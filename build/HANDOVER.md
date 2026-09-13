# Session handover — 11 Sept 2026, evening (Seb, S7b)

For the next Claude session: this is the live state. Read this, `build/QUEUE.md`, and `tools/sourcing.md` before doing anything. `git pull` first, always.

## S8 pre-flight (Sun 13 Sept, Seb) — READ THIS FIRST

State verified Sun 13 Sept: main clean at df6b0f9 (both S7b PRs merged), no pulses fired since the Phase 05 test row, all 22 wave-one leads untouched at `researched`. Sotirios has still not run a solo session — chase, and review it when it exists.

**The dry-run five (locked by Seb, replaces the CEFAS-led list):** Sophie's Homes, Evolve Stays, Torr Property Group, plus two deliberate edge-testers — My-Places (guard stress from the ugly end: 4.34 across 21, rooms product, no verified person) and MCR Hospitality (guard stress from the top end: 4.88 high performer — does a no-pain portfolio produce a sendable headline at all?). Torr CANNOT reach `pulse_ready` (no Airbnb account) — deliberate: it tests the site-data draft path. Coverage across the five: warm route, cold re-approach, no-pulse draft, guard-low, guard-high.

**Blocker, fix FIRST in the S8 session:** four "62%+ resolved autonomously" strings are still live in the outbound pulse workflow (`Property Pulse - Outbound (Sales OS)`, QxVdCclxcIipCccv) render nodes. Approved replacement wording: "around half of guest messages resolved autonomously" (two spots in the same nodes already use it). Fixable through the n8n connection. The old v3 website workflow (2Ntw5XxiKpFd2my8) is not MCP-accessible — Seb fixes that copy in the n8n editor; not launch-gating.

Calendar correction (13 Sept): 11 Sept was a FRIDAY. Queue weekday labels for 12-17 Sept were off by one and are now fixed; the Fri 18 and Sun 20 anchors were always right. Corrected run-in: S8 Sun 13, S9 Mon 14, S10a Tue 15 - Wed 16, S10b Thu 17, FN launch review Fri 18, sign-off Sun 20.

Mid-session decisions for Seb when the moment comes: Sleepezee fit verdict (Zeevou evidence in the record) and the Shonichi Light `core/` write-up (backlog).

## Where the build is

- **Phase 07 COMPLETE** (S7a + S7b, both done Fri 11 Sept). Next up: **S8 dry run** (Sun 13 Sept, `build/phases/08-dry-run.md`), checkpoint items folded in — see the pre-flight block above.
- Machine status: still BUILD PHASE. Deadline unchanged: live by Fri 18 Sept, signed off Sun 20 Sept.

## Airtable state (base appitDnbs9KM3DpQR, Leads tblPKi621zaYsyNiw)

49 leads. **Wave one = 22 leads, all at `researched`, ranked, owner-assigned** (11 Seb / 11 Sotirios). Rank, priority and route status live in each record's Notes ("S7b 11 Sept" line) and the Priority field. The ranked order:

| # | Lead | Owner | P | Route |
|---|---|---|---|---|
| 1 | Torr Property Group (George Torr) | sotirios | 1 | LinkedIn FOUND (S7b) |
| 2 | Vista Stays (Kevin Lowry) | seb | 1 | email + phone + WhatsApp (sweep); no LinkedIn. Main site vistastays.co.uk claims 3 cities |
| 3 | CEFAS (Peter Ajayi) | sotirios | 1 | LinkedIn ✓ — strongest pain in batch, S8 dry-run candidate |
| 4 | Evolve Stays (Ciaran) | seb | 1 | Seb already connected |
| 5 | Staycasa (Gin Fung Yong) | sotirios | 1 | LinkedIn ✓ |
| 6 | Sophie's Homes | seb | 1 | warm personal route |
| 7 | Sleepezee (Tommy Gan) | sotirios | 2 | LinkedIn ✓ — PMS FLAG: booking runs on Zeevou (zeevou.direct tell), PMS set to Other; fit verdict is Seb's call at the checkpoint |
| 8 | CasaCity (Max Scully) | seb | 2 | LinkedIn ✓ |
| 9 | Kaver Property Group (Emma O'Rourke) | sotirios | 2 | FOUND (S7b): founder + email, in Airtable |
| 10 | My-Places | seb | 2 | site form; director name unverified |
| 11 | Supercity Aparthotels (Marc Walters) | seb | 2 | LinkedIn FOUND (S7b); PMS question is the gate |
| 12 | Book My Place (Ozzy Cinalp) | sotirios | 2 | FOUND (S7b): Director 6y, Manchester |
| 13 | MCR Hospitality (Michelle Cooper) | sotirios | 2 | brand LinkedIn profile |
| 14 | Mbawa & Sons (Austin Mbawa) | seb | 2 | LinkedIn FOUND (S7b) — light tier |
| 15 | MOVR | sotirios | 3 | verify unit count first |
| 16 | Elan Residences | seb | 2 | site only — light tier |
| 17 | Stay Manchester City Centre | sotirios | 3 | verify company first |
| 18-22 | Britannia, Aaron, Andrew, Pendrose, James | mixed | 3 | route-dead (Pendrose has an unverified PM profile in Notes) |

- **Light tier (Seb, 11 Sept):** under-floor Hostaway-confirmed operators (Mbawa 8, Elan 7, MOVR 4, Stay MCC 3) are NOT discarded — they ride as a lighter product shape: per-unit pricing (~£30/unit), comms automation + listing reports, growth path towards 25 units. Mbawa + Elan stay in wave one at P2; MOVR + Stay MCC at P3 until unit counts / company are verified. Core write-up is a backlog item (Seb owns it).
- **City Superhost** stays `parked` (Guesty) — untouched, first call when the Guesty pilot opens.
- 24 rows Disqualified/DUPLICATE, unchanged. Airbnb host ID remains the upsert key; Torr/Vista/Mbawa/MOVR/Stay MCC still have NO host ID (seam-sourced) — the brand dedupe sweep connects them when city sweeps run.

## n8n workflows (all in Seb's personal project, all reusable)

| Workflow | Use |
|---|---|
| `S6 Companies House Credential Test` | Fire to re-verify the CH key |
| `S6 Actor Schema Fetch` | Any Apify actor's input schema + internal ID |
| `S6 Bake-off Round 1` | The three search actors + `Run costs` branch |
| `S7 Companies House Sweep` | Brand→company→officers batch. WATCH FOR FALSE POSITIVES |
| `S7 Holidayfuture Site Scan` | Unit counts from Hostaway direct sites |
| `S7 LinkedIn Actor Schema Fetch` | harvestapi actor IDs + input schemas (NEW, S7b) |
| `S7 LinkedIn Route Pass` | harvestapi no-cookie LinkedIn search for route-dead leads. Edit the `Search targets` Code node per batch; Short mode, pay-per-result (~$0.05 per 10-query batch). JUDGE every candidate — the Pendrose result needed a verification probe (NEW, S7b) |
| `S7 Contact Sweep` | Fetches direct-booking sites and regexes out emails/phones/IG/WA/contact links (the container cannot reach these sites; n8n can). Edit the `Site list` Code node per batch. HTML comes back under `data`, not `body` (NEW, S7b) |

Credentials in n8n: `Apify account` (SbLZK9VOgzJ7ihHZ), `Companies House` (LQDMhMOkmsYzHquI). Never paste keys into sessions; api.apify.com and the CH API are blocked from the container — everything goes through n8n. WebSearch works from the session.

## Ratified decisions (Seb) — additions this session

Decisions 1-8 from S7a stand (tri_angle actor, city order, two-step city run, hold at current cohort, etc. — see git history of this file if needed). New:

9. **Light tier**: Hostaway-confirmed operators under the 15-unit floor get a lighter shape (per-unit ~£30, comms automation + listing reports, scale-to-25 growth path) instead of parking. Rationale: the UK Hostaway pool is small (~40-80 relevant operators); either branch PMSs later or service small operators cheaply and grow them. Formal `core/` write-up pending (backlog).
10. Ranking heuristic confirmed: pain × contactability, Hostaway-billable pinned top, VA-hiring intent jumps the queue (none present in this cohort yet).
11. Personal-name hosts with no surname and no brand (Andrew/Aaron/James) are not actor-searchable — a fuzzy match risks messaging the wrong person. They stay route-dead until they surface on another channel.

## Contact sweep (S7b, late evening — after the first merge)

`S7 Contact Sweep` (new n8n workflow) fetched every wave-one direct site and pulled emails, phones, Instagram, WhatsApp into Airtable. Result: **19 of 22 wave-one leads now have at least one working channel** (LinkedIn, email, phone, IG or WhatsApp); details per record in Airtable.

- Solved outright: Vista Stays (email + phone + WA + main site vistastays.co.uk), Stay Manchester (brand email lets@), MOVR (hello@ + Sheffield phone), Mbawa (Austin's own email on their site), Torr (email + phone on top of LinkedIn), Book My Place (hello@), My-Places (phone/WA/IG).
- Still dark (3): Elan Residences (no site, no IG, no email anywhere — only their listing pages), Britannia, and the three no-surname hosts Andrew/Aaron/James (Pendrose keeps its unverified PM profile).
- New tell for the city run: `<brand>.zeevou.direct` = Zeevou customer, same logic as holidayfuture = Hostaway. It caught Sleepezee (PMS moved to Other, evidence in the record; fit verdict for Seb).
- Seb sent LinkedIn connection requests to the wave-one profiles on 11 Sept evening (noted per record). When accepts come in, first messages ride the S10 sequences.
- Measured cost of the whole Manchester cohort to date: about £0.70 of Apify plan credits (sweep $0.50 + bake-off reject $0.27 + ~$0.15 of LinkedIn actor results; CH, holidayfuture, site fetches free). Roughly 1.5p per lead in the base, ~4p per researched wave-one lead.

## For the S8 dry run + checkpoint items

- Personalisation spot-check passed on the top five (Torr, Vista, CEFAS, Evolve, Staycasa): decision-maker first name + one specific true finding + portfolio size + city all present in each record.
- S8 dry run picks from wave one. **CEFAS is the flagged candidate** (strongest pain, LinkedIn route, pulse targets sitting in its Portfolio preview). Torr/Vista cannot take a pulse yet — no Airbnb host ID — their pitch runs off their own Hostaway direct sites instead.
- Sotirios has not run a solo session yet this week (no logs). The checkpoint should cover that plus his 11 wave-one leads.
- Pulse cap reminder: max 10 pulses per founder per day; none fired yet.

## Numbers this week (for the scoreboard)

Seb: build sessions 10 + 11 Sept (S6a, S7a + S7b). Touches 0, pulses 0 — build phase. Sotirios: no logs yet this week.
