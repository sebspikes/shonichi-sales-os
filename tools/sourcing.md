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

## The run recipe (winner)

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

Webs marked 10 Sept: City SuperHost (2 accounts, pre-merged), MCR Hospitality + Michelle/Awakend Stays (3 shared listing IDs), The Church (Amar + Hayder, same brand), CEFAS (Tee + Peter, identical profile text).

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
