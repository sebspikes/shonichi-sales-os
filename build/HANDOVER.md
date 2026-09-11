# Session handover — 11 Sept 2026 (Seb)

For the next Claude session: this is the live state. Read this, `build/QUEUE.md`, and `tools/sourcing.md` before doing anything. `git pull` first, always.

## Where the build is

- **S6a + S6b (Manchester) done, S7a done.** Next up: **S7b — wave one ranking and owner assignment** (see below).
- Machine status: still BUILD PHASE. Deadline unchanged: live by Fri 18 Sept, signed off Sun 20 Sept.

## Airtable state (base appitDnbs9KM3DpQR, Leads tblPKi621zaYsyNiw)

49 leads, all Manchester-cohort. Every row has an ICP verdict:

- **7 Qualified** (contact-ready, PMS unknown unless stated): Staycasa (Gin Fung Yong), Evolve Stays (Ciaran Thornley — Seb has him on LinkedIn already, prior outreach no reply, owner must be Seb), MCR Hospitality (Michelle Cooper, sole director), CEFAS (Peter Ajayi, Founder/CEO), Sleepezee (Tommy Gan), CasaCity (Max Scully), Sophie's Homes (Sophie Tierney — Seb knows her personally, warm route; on Hospitable, qualified on Seb's override).
- **1 Parked**: City Superhost (Matt Smith CEO, Stephanie Hakim) — confirmed on Guesty. First call when the Guesty pilot opens.
- **Priority-1 seam cohort (Hostaway CONFIRMED via holidayfuture.com)**: Torr Property Group (15 units, George Torr) and Vista Stays (15 units, Kevin Lowry) both meet the billing floor — arguably the two best leads in the base. Mbawa & Sons (8), MOVR (4 visible), Stay Manchester City Centre (3) are under the 15-unit floor — Seb to decide if Hostaway overrides it. These 5 have NO Airbnb host ID yet; the brand dedupe sweep connects them when city sweeps run.
- **10 Borderline** riding into S7b, including Elan Residences (Hostaway confirmed, 7 units, site half-disabled) and Supercity Aparthotels (Walters family, most Higgihaus-shaped, PMS question outstanding).
- **26 Disqualified** (22 size, 2 coastal agencies, 3 chains) + 2 rows marked DUPLICATE (Michelle = MCR Hospitality's director; Tee = CEFAS second account).

Conventions: Airbnb host ID field = upsert key for re-runs. Duplicate accounts get ICP fit=Disqualified + a DUPLICATE note, kept for the upsert key. Notes carry the audit trail (sourcing line, LINKED evidence, S7a chase results). Full host about-text lives in the Host about field; portfolio previews carry listing IDs that feed `generate me a property pulse <id>` directly.

## n8n workflows built (all in Seb's personal project, all reusable)

| Workflow | Use |
|---|---|
| `S6 Companies House Credential Test` | Fire to re-verify the CH key |
| `S6 Actor Schema Fetch` | Any Apify actor's input schema + internal ID (the Apify node needs internal IDs, not slugs) |
| `S6 Bake-off Round 1` | The three search actors + a `Run costs` branch for per-run USD |
| `S7 Companies House Sweep` | Brand→company→officers batch. Edit the `Brand queries` Code node, execute, read `Pick best` + `Attach officers`. WATCH FOR FALSE POSITIVES — judge the candidates list, the scorer has been fooled twice (Awaken Drinks, Coffee Kavern) |
| `S7 Holidayfuture Site Scan` | Unit counts from Hostaway direct sites. Edit the `Site URLs` Code node |

Credentials in n8n: `Apify account` (SbLZK9VOgzJ7ihHZ), `Companies House` (LQDMhMOkmsYzHquI, Basic Auth). Never paste keys into sessions; the container blocks api.apify.com, apify.com, and the CH API directly — everything goes through n8n. WebSearch works from the session.

## Ratified decisions (Seb)

1. tri_angle/airbnb-scraper is the sourcing actor (recipe in `tools/sourcing.md`); simpleapi parked (rental), expansion actors skipped.
2. Leads go straight to Airtable `state=new`; Phase 07 qualifies.
3. City order: wave 1 — Manchester done, then Liverpool, Bristol, Cardiff, Newport, Brighton.
4. Cast wide, 20+ listings = clearly a business; borderlines ride the flow.
5. **THE CITY RUN is two steps**: holidayfuture seam search FIRST (free, gate-4 confirmed), then the Airbnb sweep. See `tools/sourcing.md`.
6. Hold at the current cohort until the downstream pipeline is proven; remaining cities are one command each.
7. Every session ends with log, commit, push, PR, squash merge to main (standing authorisation, in CLAUDE.md).
8. Paid contact enrichment (Apollo/Clay) deferred to Phase 10 on reply-rate evidence; websites + LinkedIn + harvestapi actors cover the current motion.

## S7b — the next session's task

1. Rank wave one (best ~25) by **pain signal strength × contactability**; VA-hiring intent jumps the queue. Pain signals are filled on every qualified/borderline row.
2. Assign owners: alternate by default; **Ciaran/Evolve and Sophie's Homes go to Seb** (personal connections). Move wave one to `researched`.
3. LinkedIn actor pass (harvestapi no-cookie actors, pay-per-result) for the route-dead leads: Emma/Kaver, Britannia, Pendrose, Book My Place person, Andrew/Aaron/James, seam directors without URLs (George Torr, Kevin Lowry, Austin Mbawa, Zabir Hussain).
4. Spot-check five wave-one records against the personalisation checklist: decision-maker first name + one specific true finding + portfolio size + city.
5. Volume context: UK-wide model says ~100-150 qualified operators total, 40-80 Hostaway-relevant; send capacity (25 touches/founder/week) is the constraint, not inventory. Pace sourcing to the scoreboard.

## Numbers this week (for the scoreboard)

Seb: build sessions 10 + 11 Sept (S6a, S7a). Touches 0, pulses 0 — build phase. Sotirios: no logs yet this week.
