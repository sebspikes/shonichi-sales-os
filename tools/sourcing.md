# Lead sourcing — the Phase 06 pipeline

How to source ICP-qualified STR operator leads from Airbnb into Airtable. Either founder can run this; every step goes through n8n so no API keys are needed on your machine.

**Status: S6a complete, ratified by Seb 10 Sept 2026. Winner: tri_angle. Manchester's 44 leads loaded. S6b in progress: Bristol (17 Sept, 21 rows) and Cardiff (21 Sept, 35 rows) done with their Phase 07 passes, see City run results below. Base: 105 leads.**

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
| **City sweep (the standard run)** | `S6 City Sweep — tri_angle` (workflow `lLkaM2BPXAmCYT6E`) | Built 17 Sept. Edit `locationQueries` in the tri_angle node per city, execute the `Run city sweep` trigger. A `Group by host` Code node applies load rules 1 and 3 in the workflow and emits one slim item per host (plus a summary item first). The `Reprocess last run` trigger re-reads the actor's last SUCCEEDED dataset for free, so a run is never paid for twice. Always read the `Group by host` output in a session, never the raw actor output: raw rows are ~15KB each |
| LinkedIn schema fetch | `S7 LinkedIn Actor Schema Fetch` | harvestapi actor internal IDs + input schemas |
| LinkedIn route pass | `S7 LinkedIn Route Pass` | harvestapi no-cookie person/employee search for route-dead leads. Edit the `Search targets` Code node per batch, execute, judge the `Route candidates` output. Short mode, pay-per-result (~$0.05 per 10-query batch) |
| Contact sweep | `S7 Contact Sweep` | Fetches direct-booking sites and extracts emails, phones, Instagram, WhatsApp, LinkedIn, contact and booking links. From 17 Sept it also reports `pmsTells`: counts of PMS and booking-engine names in the page HTML (`mews.com`, `bookingenginecdn.hostaway.com`, `checkout.lodgify.com`, `guestybookings.com`, eviivo, Boostly and the rest). Domain and script hits are hard gate-4 evidence; bare names on a Boostly or Lodgify template are noise. Edit the `Site list` Code node per city cohort. Sessions cannot fetch these sites directly (egress proxy); n8n can |
| Site scan | `S7 Holidayfuture Site Scan` | Counts listing IDs on a Hostaway direct site. Works on custom-domain Hostaway sites too (stay.airserviced.com, smartcorporatestays.com, koyahomes.co.uk): the `/listings/<id>` pattern is the engine's, not the domain's. The all-listings page shows 18 per page and `?page=` does not paginate, so 18 means 18+. Zeevou sites return 500 to it |
| Officer search | `S7 CH Officer Search` (workflow `8qxG0su8BPHt1Oaj`) | Built 17 Sept. Person name to Companies House officer search to their appointments. For trading-name brands where the company search stalls: it resolved BCE's group from the two directors on the site's email domain. Edit the `Officer queries` Code node per batch. Judge candidates by address and birth month: common names return several people |

Claude runs these through the n8n connection in a session. Ask in plain English: "run the sourcing search for Liverpool".

The n8n connector must be authorised in the founder's claude.ai connector settings before a session can fire any of these. Sessions cannot reach Apify, Companies House, Airbnb or holidayfuture sites directly: the Claude Code environment's network allowlist carries only `shonichi.app.n8n.cloud` (and `hooks.slack.com`) by design, so web search from a session is the only non-n8n route and it is near useless for the seam (17 Sept lesson).

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

Post-processing rules. From 17 Sept rules 1 and 3 run inside `S6 City Sweep — tri_angle` (the `Group by host` node); rules 2, 4, 5 and the verification sweep stay with Claude in-session:

1. Drop rows with a null host (delisted or hotel-inventory rows; 7 of 150 in Manchester).
2. Dedupe by `host.id`, then by brand name (one lead per brand; note the second host account in Notes, e.g. City SuperHost runs two).
3. Keep `managedListingsCount` 5 to 150. Above 150 mirrors the ICP upper gate and cuts the OTA aggregator accounts (Travelnest, holidaycottages.co.uk, Finest Retreats) at sourcing.
4. Create leads with `state=new`, Source channel `Airbnb pipeline`, Country/Wave set, and the sourcing enrichment fields filled: Airbnb host ID, Host rating, Host review count, Years hosting, Superhost, Host about (full text), Portfolio preview (10 listings with ratings, review counts and listing IDs — pulse targets come straight from here).
5. Re-runs upsert on **Airbnb host ID** (`fldBVAmRBSm7fo8is`) so the same host never creates a duplicate lead.
6. Gate judgements (Professional host, ICP fit, Owner) are NOT set at sourcing. `new` means gates unchecked; Phase 07 runs the one-minute test.

Manchester result: 44 leads loaded 10 Sept from the bake-off dataset, fully enriched.

## City run results

### Bristol (Seb, Thu 17 Sept 2026)

**Seam:** `site:holidayfuture.com Bristol` and eight query variants returned only Higgihaus and Altoluxo (our own companies), one Cape Town operator and Bath/Cheltenham noise. Bristol has no free Hostaway-confirmed operators from the seam. Negative tells found instead: Hopewell Short Lets Ltd, Market My Property Ltd and Green Acorn Holiday Homes Ltd all run `guestybookings.com` direct sites (Guesty). Hopewell (independent Bristol agency, Prince Street Studios alone is 15 serviced apartments, CH 10096294, co-founders Adam Kershaw and Maxwell Hope) loaded as `parked` on the City Superhost precedent; the other two noted only.

**Sweep** (`S6 City Sweep — tri_angle`, execution 63706, Apify run wd3maBxOoiSAbJFX6): 156 rows in 102 s, **$0.52** (156 enriched listings at $0.00335 each). 5 null-host rows, 124 unique hosts, 24 with 5+ managed listings, 15 with 10+, 12 with 15+. Cut above 150: Travelnest (1,224), Toad Hall Cottages (357), Birch Stays (189), Pass The Property (165). **20 hosts loaded as `new`** with the full sourcing block.

Bristol is thinner than Manchester at the top: 24 hosts at 5+ against 51, and the 15+ band is 12 hosts, five of them branded operators (Your Apartment 127, Host360 73, Cohost Partners 70, Bespoke Cultural Escapes 61, Brunel Stays 23), plus Short Stay Uk (32, host rating 3.59) and three personal-name hosts (Dave 19, Albert 17). Below the floor sit the light-tier shapes (Donny 11, CCP Stays 11, Roost 10) and single-building room operators (CoalShed, 3 Berkeley Square, BOHO Rooms). Pulse angles by host rating: Short Stay Uk 3.59, Host360 4.28, Roost 4.32, Cohost Partners 4.35, Your Apartment 4.53.

**Verification sweep:** no host-ID or listing-ID overlap with the Manchester base. Two name-only collisions (a second Michelle and a second Peter, both suffixed in Company to keep the primary field unambiguous). One Bristol web: Tina and Peter (Berkeley Square) share five listing IDs, one Georgian townhouse in Clifton, LINKED on both rows. Cohost Partners is multi-city (Swansea, Cardiff, Warrington, Bristol) and is the first Cardiff-area operator in the base.

**Phase 07 pass (same day, Seb's call to run it straight after the sweep):** three CH batches, one officer search, two contact sweeps with PMS tells, targeted web searches for LinkedIn. Every gate, contact and owner written to the 21 rows.

| Verdict | Leads | Why |
|---|---|---|
| **Qualified** | **ShortStayUK** (32, host rating 3.59, P1, sotirios), **Cohost Partners (StayRight)** (70, Cardiff, PMS unknown, P2, sotirios) | ShortStayUK's direct site runs the Hostaway booking engine: the only gate-4 confirmation in the cohort, and the weakest host score in the base. Cohost was bought by StayRight (Cardiff) in Sept 2025; directors Zac Ratcliffe and Eve D'Arcy on LinkedIn |
| **Parked** (not Hostaway) | Host360 (73, eviivo), Bespoke Cultural Escapes (61, Lodgify), Brunel Stays (23, Lodgify), Hopewell (Guesty) | All four pass gates 1, 2, 3 and 5 with named directors and emails. They are the Bristol re-approach list for the Marketplace launch |
| **Borderline** (owner seb, P3) | CCP Stays (11, Charlie Cook, light tier), Donny (11, one building), Dave (19, co-host, route-dead), Albert (17, new, route-dead) | Under the floor or no identity to chase |
| **Qualified, OpIntel only** | **Your Apartment** (127, Mews hotel PMS, P2, seb) | Proposed DQ at gate 3; Seb override 21 Sept: kept alive for the data product only, no comms pitch. Toby Guest on LinkedIn |
| **Disqualified** | Roost (10, Guesty, Reading), Curated Property (7), Tom / Clifton Lets (5), Emma, Tina + Peter, Michelle, Ned & Hugh, Michaela, Kate | Under the floor, single buildings, rural, private landlords |

**What Bristol says about the pool:** zero Hostaway-confirmed operators inside the city. The five branded Bristol operators run Mews, eviivo, Lodgify, Lodgify and Guesty. The one Hostaway operator the sweep caught (ShortStayUK) is Milton Keynes-based and surfaced through a single Bradley Stoke unit. Bristol's sendable output from a $0.52 sweep is two leads, one of them in Cardiff. Parked is where Bristol's value sits until the Marketplace listing exists.

**Route lessons:** (1) the site's email domain is a Companies House key when the brand is a trading name (BCE). (2) Boostly-built sites name every PMS in their template, so a bare "hostaway" string is not evidence; only `bookingenginecdn.hostaway.com`, `holidayfuture.com`, `checkout.lodgify.com`, `mews.com` and `guestybookings.com` count. (3) Acquisitions make the Airbnb about text stale: check CH officer appointment dates (Cohost).

**Next:** ShortStayUK and Cohost/StayRight need a pulse each (targets in Next action); Your Apartment is Seb's OpIntel-only first touch on his return. Owner split confirmed 21 Sept: the two Hostaway-shaped Qualified leads to Sotirios for the holiday window, Your Apartment and the Borderlines to Seb.

### Cardiff (Seb, Mon 21 Sept 2026)

**Seam:** `site:holidayfuture.com Cardiff` and three variants surfaced eight Hostaway direct sites beyond Higgihaus: JRY Property Group, MySA Properties, Solace Stays (70214_1), Smart Corporate Stays (57058_1), Holm House / Airserviced, Dragon Apartments (162510_1), Qasim Din, and an empty 76142_1. Site scan: four at 18+ (page cap), Holm House 10, Dragon 5, Qasim Din 8. Negative tells: five Zeevou operators (StaySouthWales, Classy Comfort, Dyzyn, FabAccommodation, Dwell Haven) and Bloqq on Guesty.

**Sweep** (`S6 City Sweep — tri_angle`, execution 64198, 97 s): 152 rows, 8 null-host, 124 unique hosts, 30 with 5+, 21 with 10+, 12 with 15+. One account cut above 150 (Travelnest 896). 29 kept; Cohost Partners already in the base (upsert on host ID, note appended), 28 new rows. Three Cardiff webs: Starlight Stays + The Collective Club (4 shared IDs), MYGUEST + Safwan (1), Sarah & Wyn + Sarah (5). Two name collisions with the base (Adam, Eva) suffixed.

**Phase 07 pass, same session:** three CH batches (24 brands, 15 matched with judgement), two contact sweeps with PMS tells, site scans, targeted web searches. All 35 rows carry gates, PMS evidence, contacts, owner, priority, pain signals and a suggested pulse target (the assembly script picks the lowest-rated unit with 10+ reviews).

| Verdict | Leads | Why |
|---|---|---|
| **Qualified, Hostaway confirmed** | **Koya Homes** (22, rating 4.49, P1), **JRY Property Group** (18+, P1), **Solace Stays** (18+, P1), **MySA Properties** (18+, P2), **Smart Corporate Stays** (18+, Chesterfield, P2), all owner sotirios | Booking engine on the direct site in every case. Koya and JRY have named founders with direct emails; Solace has chris@ and a co-founder on LinkedIn; Smart Corporate Stays' founder is on LinkedIn and announcing a franchise |
| **Borderline P2** | StayServiced / Airserviced + Holm House (about 29, Hostaway, no named owner, sotirios), InspoHome (56, PMS unknown, seb), MYGUEST Ltd (26, seb), Jaymin / Berriman Collection (67, no identity, seb) | Gate 5 or gate 4 open |
| **Parked** | Starlight Stays (38, Smoobu), StaySouthWales (Zeevou) | Not Hostaway; Starlight's founder Aaron Baynton is on LinkedIn |
| **Borderline P3, light tier** | Brodyr Property (13), Builders Beds (11), Adam (12), The Iconic Spaces (17, new), KR Short Stays (24, Reading), Dragon Apartments (5, Hostaway), Qasim Din (8, Hostaway) | Under the floor or too new |
| **Disqualified** | Bloqq (student rooms, Guesty), Cardiff Bay Hostel, Charlie And Abi, Pete, Safwan, Kobir, Sarah & Wyn, Sarah, The Collective Club, Kash, Hayley, Jodie, Raymond, Jonathan, Lottie, Eva, Sian | Rooms in one building, duplicate webs, private hosts under the floor |

**What Cardiff says about the pool:** the opposite of Bristol. Six Hostaway-confirmed operators at or above the floor in one city, five of them Qualified today, against zero in Bristol. Cardiff plus the two StayRight and ShortStayUK leads gives Sotirios seven Hostaway-shaped Qualified leads for the holiday window. The seam is what found them: four of the five Qualified operators were not in the top-150 Airbnb sweep at all.

**Route lessons:** (1) A host's about text can carry a rebrand ('formerly Airserviced') that ties an Airbnb account to a seam site: read every about text against the seam list before creating rows. (2) Custom-domain Hostaway sites (smartcorporatestays.com, koyahomes.co.uk, stay.airserviced.com) never show in a `site:holidayfuture.com` search; the contact sweep's `bookingenginecdn.hostaway.com` tell is what catches them, so run it on every brand's own domain. (3) One brand can reference two engines at once (Solace: Guesty link on the main site, Hostaway engine live): record both and ask. (4) A shared registered office (14 Museum Place: StayRight and MySA) is an accountant, not a link.

**Next:** five pulses for Sotirios (targets in each Next action; the four seam-only rows need their Airbnb host account found first or the 02d site-data variant). LinkedIn actor pass on the six named directors with no profile found (Davenport, Ahmadi, Adetula, Adekoya, Abou Hamda, the Hawkins-Smiths).

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
