# Lead sourcing — the Phase 06 pipeline

How to source ICP-qualified STR operator leads from Airbnb into Airtable. Either founder can run this; every step goes through n8n so no API keys are needed on your machine.

**Status: S6a complete, ratified by Seb 10 Sept 2026. Winner: tri_angle. Manchester's 44 leads loaded to Airtable.**

## The pipeline (as proven in the bake-off)

```
tri_angle Airbnb city search (host profiles enriched)
      →  one actor returns: listing + full host block per row
      →  filter hosts with managedListingsCount >= 5   ← the 5+ filter comes free
      →  host name + about text = brand                ← Companies House + Google from here
      →  Companies House officers = decision-maker names
      →  LinkedIn person (public search, no-cookie actors)
      →  Airtable lead (state=new), Claude qualifies in Phase 07
```

The original design assumed a separate host-portfolio-expansion step. The bake-off showed it is not needed for lead generation: the search actor already attaches each host's total managed listings count and a 10-listing portfolio preview.

## Infrastructure

All scraping runs through n8n (`shonichi.app.n8n.cloud`) using credentials stored there. Nothing is pasted into sessions, no API keys on founder machines.

| Piece | Where | Notes |
|---|---|---|
| Apify credential | n8n `Apify account` | Seb's paid Apify account ($30/month plan) |
| Companies House credential | n8n `Companies House` | Basic Auth, key as username. Verified 10 Sept (live search returned the Higgihaus companies) |
| CH test workflow | `S6 Companies House Credential Test` | Fire any time to re-verify the key |
| Actor schema fetch | `S6 Actor Schema Fetch` | Pulls any actor's input schema + internal ID via the Apify API. Reuse before wiring any new actor |
| Bake-off workflow | `S6 Bake-off Round 1 — Airbnb search actors` | Also carries the `Run costs` branch for per-run USD figures |
| LinkedIn schema fetch | `S7 LinkedIn Actor Schema Fetch` | harvestapi actor internal IDs + input schemas |
| LinkedIn route pass | `S7 LinkedIn Route Pass` | harvestapi no-cookie person/employee search for route-dead leads. Edit the `Search targets` Code node per batch, execute, judge the `Route candidates` output. Short mode, pay-per-result (~$0.05 per 10-query batch) |
| Contact sweep | `S7 Contact Sweep` | Fetches direct-booking sites and extracts emails, phones, Instagram, WhatsApp, contact links. Edit the `Site list` Code node per city cohort. Sessions cannot fetch these sites directly (egress proxy); n8n can |

Claude runs these through the n8n connection in a session. Ask in plain English: "run the sourcing search for Liverpool".

## Bake-off results (S6a, 10 Sept 2026, test city Manchester)

Criteria: host attached to every listing, portfolio-size signal (the 5+ filter), field quality for personalisation, cost, run time.

| Actor | Result |
|---|---|
| `tri_angle/airbnb-scraper` | **WINNER.** 150/150 rows with full host block on 143 (7 delisted/hotel rows). Host block: id, name, url, location, about text, managedListingsCount (present 143/143), 10-listing portfolio preview with review counts, years hosting, review count, rating, review responses (often signed with real first names). 85s, $0.50 per 150-listing city sweep |
| `automation-lab/airbnb-listing` | Rejected. 60/60 rows had NO host identifier of any kind. Rich amenity/price detail but cannot feed a group-by-host pipeline. $0.27/60 rows |
| `simpleapi/airbnb-scraper` | Parked, not tested. Rental-model actor; free trial expired, needs a monthly rent before it will run. Revisit with costed options only if the winner underperforms in production |
| `cirkit/airbnb-host-scraper` | Not run. Host-expansion is unnecessary: the winner returns portfolio size directly. Fallback candidate if `managedListingsCount` proves unreliable |
| `automation-lab/airbnb-host-portfolio-scraper` | Not run. Same reason |

### Measured yield (the number that matters)

One 150-listing Manchester search, 85 seconds, $0.50:

- 122 unique hosts
- **51 unique hosts with 5+ managed listings**
- 34 with 10+ listings
- Portfolio sizes up to 1,268 (the biggest are OTA/agency host accounts — Travelnest, holidaycottages.co.uk, Finest Retreats — which Phase 07 filters out using the about text; genuine operators in the sample include Staycasa 85, City SuperHost 67, MCR Hospitality 42, Book My Place 26, Sleepezee 17)
- Cost per qualified 5+ host: about 1p
- 100-lead target ≈ 2-3 city searches ≈ $1-2 total

## THE CITY RUN (standard, ratified by Seb 11 Sept)

Every city is worked with BOTH steps, in this order:

1. **The seam first** (free, 2 minutes): web-search `site:holidayfuture.com <city>`. Every hit is a Hostaway customer's direct-booking site — gate 4 pre-passed. For each operator found, work backwards: `S7 Holidayfuture Site Scan` counts their units from their own site (the 15-unit floor decides billability), `S7 Companies House Sweep` finds the company + directors, web search finds LinkedIn. Their Airbnb host account connects later via step 2's brand dedupe.
2. **The Airbnb sweep** (~$0.50, 90 seconds): the tri_angle recipe below. Catches the professional operators NOT on Hostaway yet (pulse still works on them; PMS is chased at qualification).

The seam finds certainty, the sweep finds volume. Manchester proof: the seam alone produced Torr Property Group and Vista Stays — both Hostaway-confirmed, both at the 15-unit floor, both with named directors — in under half an hour.

## The run recipe (Airbnb sweep)

Actor: `tri_angle/airbnb-scraper` (internal ID `GsNzxEKzE2vQ5d9HN`), via the n8n Apify node, operation "Run actor and get dataset", credential `Apify account`. Input:

```json
{
  "locationQueries": ["<City>, United Kingdom"],
  "maxResults": 150,
  "enrichUserProfiles": true,
  "currency": "GBP",
  "locale": "en-GB"
}
```

Notes:
- `enrichUserProfiles: true` is what attaches the host block. Never run without it.
- The Apify n8n node rejects `username~actor` slugs; use the internal actor ID. `S6 Actor Schema Fetch` resolves ID + input schema for any new actor.

## Loading to Airtable (ratified 10 Sept, done for Manchester)

Post-processing rules, applied by Claude in-session (S6b may move them into the workflow):

1. Drop rows with a null host (delisted or hotel-inventory rows; 7 of 150 in Manchester).
2. Dedupe by `host.id`, then by brand name (one lead per brand; note the second host account in Notes, e.g. City SuperHost runs two).
3. Keep `managedListingsCount` 5 to 150. Above 150 mirrors the ICP upper gate and cuts the OTA aggregator accounts (Travelnest, holidaycottages.co.uk, Finest Retreats) at sourcing.
4. Create leads with `state=new`, Source channel `Airbnb pipeline`, Country/Wave set, and the sourcing enrichment fields filled: Airbnb host ID, Host rating, Host review count, Years hosting, Superhost, Host about (full text), Portfolio preview (10 listings with ratings, review counts and listing IDs — pulse targets come straight from here).
5. Re-runs upsert on **Airbnb host ID** (`fldBVAmRBSm7fo8is`) so the same host never creates a duplicate lead.
6. Gate judgements (Professional host, ICP fit, Owner) are NOT set at sourcing. `new` means gates unchecked; Phase 07 runs the one-minute test.

Manchester result: 44 leads loaded 10 Sept from the bake-off dataset, fully enriched.

## Duplicates, multi-city hosts and linked businesses

Multi-city operators WILL surface again in other city searches (Staycasa, Sleepezee and STK all say "across the UK"). Three layers keep the base clean:

1. **Mechanical dedupe (same host account):** every load upserts on **Airbnb host ID** (`fldBVAmRBSm7fo8is`). A host already in the base gets its row updated, never duplicated. This is why that field exists.
2. **Post-load verification sweep (Claude, after every city load):** compare new rows against the whole base for (a) case-insensitive brand-name matches and (b) shared listing IDs across Portfolio previews. Shared listing IDs are hard proof two accounts run one portfolio. Mark every find with a `LINKED:` line in Notes on BOTH rows, naming the evidence, and treat the web as one prospect (one owner, one sequence).
3. **Know what the fields mean:** a lead's City is the operator's base, not the search city; the Portfolio preview is profile-wide, not city-filtered. A host with no visible units in the searched city is normal for multi-city operators (e.g. STK/Staykeepers matched Manchester via one student room while their preview shows London).

Webs marked 10 Sept: City SuperHost (2 accounts, pre-merged), MCR Hospitality + Michelle/Awakend Stays (3 shared listing IDs), The Church (Amar + Hayder, same brand), CEFAS (Tee + Peter, identical profile text). 11 Sept: CH officers resolved two webs — Michelle Cooper is MCR Hospitality's sole director; Peter Ajayi is CEFAS's founder.

## The holidayfuture.com seam (found 11 Sept, S7a)

`site:holidayfuture.com <city>` on a web search returns operators whose DIRECT BOOKING SITE runs on Hostaway — gate 4 pre-passed, the hardest evidence in the funnel, free. The same logic works for competitor PMSs: `<brand>.zeevou.direct` = Zeevou customer (caught Sleepezee in S7b, PMS moved to Other), `<brand>.guestybookings.com` = Guesty (caught City Superhost in S7a). Negative tells matter as much as positive ones — they stop us pitching Hostaway-native OpIntel at the wrong stack. The Manchester query surfaced Elan Residences (already a lead, promoted on the spot) plus MOVR, Torr Property Group, Vista Stays, Stay Manchester City Centre, Mbawa & Sons, and Lushpads/Satori — none of which the Airbnb search had caught. Run this query for every city alongside the tri_angle search; any operator found here starts with PMS=Hostaway confirmed.

## Contact-route chase results (S7a, Manchester cohort)

The brand → Companies House → officers → LinkedIn flow (workflow `S7 Companies House Sweep`, edit the Brand queries node per batch):
- Branded operators: 12/15 CH company matches, decision-maker names for 11, LinkedIn URLs for 6 of the top prospects. The flow works.
- Trading names with no registered company under that name (BookMyPlace, Awakend Stays, Kaver, Pendrose, Elan) stall CH matching — website/LinkedIn-company-page routes fill some gaps; the rest need the no-cookie LinkedIn actors.
- Unbranded personal-name hosts (Andrew, Aaron, James) produce nothing cheaply even at 23-30 listings. Expected; they stay Borderline as route-dead until an actor-based pass.
- CH search false positives happen (Awaken Drinks for Awakend Stays, Coffee Kavern for Kaver) — a human/Claude judgement pass on candidates is mandatory before trusting a match.

## LinkedIn actor pass results (S7b, Manchester cohort)

The harvestapi no-cookie route (`S7 LinkedIn Route Pass`, ~$0.05 for 15 queries across two batches):
- **Found (5)**: George Torr (Director, Torr Property Group — profile is a pure SA/contractor pitch), Marc Walters (Supercity), Ozzy Cinalp (Director, Book My Place, 6y — found via the company-employees actor on their LinkedIn company page), Emma O'Rourke (Founder, Kaver Property Group — solved a surname-unknown lead and surfaced her business email), Austin Mbawa (exact-name match).
- **Not found (4)**: Kevin Lowry (three query shapes), Zabir Hussain, Michelle Cooper personal profile, anything for Britannia (generic brand).
- **Judgement still mandatory**: the first Pendrose hit (Akay Raheem) had no visible tie to the brand; a verification probe found a second, stale profile listing "Property Manager, Pendrose Home" — recorded in Notes as unverified, NOT written to the LinkedIn URL field.
- Pattern: named person + brand = high hit rate; brand-only fuzzy queries = judge hard; no surname + no brand = do not search (wrong-person risk). The company-employees actor works when a LinkedIn company page URL is known.
- URLs come back in LinkedIn's member-ID form (`linkedin.com/in/ACwAA...`) — they open fine in a browser.
- **Company-page lever (batch 3-4)**: `harvestapi/linkedin-company-search` (actor taHaRcqil3scbchuI) finds company pages, then the employees actor mines them. It cracked Book My Place but false-positives at COMPANY level too: `linkedin.com/company/vista-stays` looked right (Hospitality, 22 followers) and turned out to be an Indian boutique-hotel group — its employees (Delhi/Nainital/Trinidad) exposed it. Rule: always check the employees' geography before trusting a company-page match. My-Places/Elan/Stay Manchester City Centre have no real pages.
- Coverage after S7b: 12 of 22 wave-one leads have a LinkedIn or warm route; every searchable identity has been searched. The remaining gaps are missing upstream identities (no surname or no confirmed company), not missing tooling — city sweeps + brand dedupe fix these over time, and Sales Navigator (backlog) is the next tool-level upgrade if reply data justifies it.

## Contact sweep results (S7b, Manchester cohort)

`S7 Contact Sweep` over every wave-one direct site (free, ~15 fetches): emails found for Vista Stays, Stay Manchester, MOVR, Mbawa (the director's own address on their site), Torr (x2), Book My Place, Staycasa, Evolve, Kaver, CEFAS; Instagram handles for My-Places, Staycasa, Evolve, Supercity, Kaver, Sleepezee; phones/WhatsApp throughout. After the sweep, 19 of 22 wave-one leads have at least one working channel. Still dark: Elan Residences (no web footprint at all), Britannia, and the no-surname hosts. Lesson: the direct-booking site is the richest free contact source we have — bake this sweep into every city run after qualification.

## Companies House

Free public data API, 600 requests / 5 min, through the n8n `Companies House` credential:

- `GET /search/companies?q=<brand>` — brand name to company number
- `GET /company/{number}/officers` — directors (decision-maker names)

## Compliance rules (from the phase brief)

- Public business data only, professional B2B context.
- LinkedIn scraping: no-cookie actors only. Founders' own accounts are never used for scraping.
- Outreach leads with value and takes no for an answer; delete on request.
- All sends are human. The machine only finds, matches, and drafts.

## Cost

Measured, not estimated: $0.50 per 150-listing city sweep with host enrichment, on the existing $30/month Apify plan. The full 100-lead phase costs $3-5 of plan credits. No actor rentals required. If a rental actor ever earns its way in, present the option with its monthly price and the lead value it adds before renting.
