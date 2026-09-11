# Build queue: September 2026

**Machine status: BUILD PHASE** (change this line to `LIVE` at Phase 10 sign-off; "run my session" switches behaviour on it.)

Deadline: machine live by **Friday night 18 September**, signed off at Seb's pre-departure review **Sunday 20 September**. Sotirios drives the pipeline solo during Seb's holiday (22 Sept - 3 Oct). Full firing from **Monday 5 October**: every morning session is queue-driven outreach, 5+ quality touches.

Each session is ONE phase doc (or a named part of one). Open the next unchecked item, read its doc in `build/phases/`, execute. Sessions are 60 minutes (Seb's golden hour); Friday-night sessions are longer and marked FN.

## The queue

- [x] **S0 — Scaffold** (both founders set up and read in, 4 Sept)
- [x] **S1 — Phase 01: Offer & case study** — `phases/01-offer.md` (Tue 2 Sept) — drafted, awaiting Sotirios ratification
- [x] **S2 — Phase 02: ICP & channel map** — `phases/02-icp-channels.md` (Wed 3 Sept) — drafted, awaiting Sotirios ratification
- [x] **S3 — Phase 03: Airtable CRM** — `phases/03-airtable-crm.md` (Thu 4 Sept) — base built, awaiting Sotirios ratification
- [x] **Thu 4 Sept — Sotirios onboarding** — GitHub, Claude Code and Airtable set up, dry run done
- [x] **S4 — Phase 04: Message engine** — `phases/04-message-engine.md` (Sun 6 Sept)
- [x] **S5 — Phase 05: Pulse integration** — `phases/05-pulse-integration.md` (Mon 8 Sept) — outbound workflow QxVdCclxcIipCccv live, tested end to end
- [x] **S6a — Phase 06: Lead sourcing, actor bake-off** — `phases/06-lead-sourcing.md` (done Wed 10 Sept) — tri_angle/airbnb-scraper won (host block + portfolio size in one pass, ~1p per qualified lead); recipe in `tools/sourcing.md`; 44 enriched Manchester leads already in Airtable; 7 sourcing fields added to the CRM (ratified)
- [ ] **S6b — Phase 06: Lead sourcing, first 100 leads** (Tue 9 - Wed 10 Sept) — Manchester done (44); remaining wave 1: Liverpool, Bristol, Cardiff, Newport, Brighton; plus CH + LinkedIn contact routes for the triple-match
- [x] **S7a — Phase 07: Enrichment & qualification** — `phases/07-enrichment.md` (done Thu 11 Sept) — all 44 verdicts written (7 Qualified with named directors + LinkedIn, 1 Parked on Guesty, 10 Borderline, 26 DQ); holidayfuture seam found + baked into the city run (`tools/sourcing.md`); 5 Hostaway-confirmed seam leads added (Torr + Vista meet the 15-unit floor); handover in `build/HANDOVER.md`
- [x] **S7b — Phase 07: wave one ranked** (done Thu 11 Sept, a day early) — 22 leads ranked by pain × contactability with Hostaway-billable pinned top, owners split 11/11 (Ciaran + Sophie's + Supercity → Seb), all moved to researched; harvestapi LinkedIn pass found 5 routes (George Torr, Marc Walters, Ozzy Cinalp = Book My Place director, Emma O'Rourke = Kaver founder, Austin Mbawa); under-floor Hostaway operators ride as a light tier per Seb (core write-up pending, see backlog)
- [ ] **FN 12 Sept — Checkpoint**: Sotirios has run one solo session this week; review what broke, warm-start leads worked, core amendments if any
- [ ] **S8 — Phase 08: End-to-end dry run** — `phases/08-dry-run.md` (Sun 14 Sept)
- [ ] **S9 — Phase 09: Scoreboard & notifications** — `phases/09-scoreboard.md` (Mon 15 Sept)
- [ ] **S10a — Phase 10: Soft launch, first real sends** — `phases/10-soft-launch.md` (Tue 16 - Wed 17 Sept)
- [ ] **S10b — Phase 10: iterate on friction** (Thu 18 Sept)
- [ ] **FN 18 Sept — Launch review + Sardinia handover** (in `phases/10-soft-launch.md`)
- [ ] **Sun 20 Sept — machine signed off at pre-departure review; flip status line to LIVE**

Dates are the default mapping; slide them if a day gets eaten, but the ORDER is fixed — each phase's output feeds the next. If a session finishes its task early, pull the next phase forward; never split an hour across two phases.

## Backlog (not a session; pick up when a session finishes early)

- Seb, `core/`: write up the "Shonichi Light" tier from the S7b floor decision (11 Sept) — under-15-unit Hostaway operators priced per unit (~£30/unit) for comms automation + listing reports, growth path to 25 units (VA-replacement angle, VA sourcing pipelines). Touches `core/offer.md` and `core/icp.md`; the Hostaway-relevant pool is small (~40-80 UK operators), so the light tier changes the pool maths.
- Pull Altoluxo review scores from Hostaway, March to September 2026, and put a number on "review scores improved" in `core/offer.md`.
- Phase 05: correct the pulse footer ("62%+ resolved autonomously") to match `core/offer.md`, and retire the HostMind name from all report templates.
- Both founders: set `PULSE_WEBHOOK_URL` and `PULSE_FOUNDER_EMAIL` in a Claude Code environment and allow `shonichi.app.n8n.cloud` (see `tools/pulse.md`). The Default environment would not accept variables for Seb on 8 Sept; create a new environment.
- Seb, in the n8n editor: in both pulse workflows' Render Reports node, find the two remaining "62%+ resolved autonomously" strings in the onboarding copy and replace with "around half of guest messages resolved autonomously".
- Seb: rotate the Cloudflare R2 access key that sits in the R2 upload code nodes of both pulse workflows, and reference it from n8n environment variables instead.
- Seb: decide whether the test lead "Phase 05 pulse test" (a real Clifton listing) stays as an example row or is deleted.
- Seb: publish a redacted Higgihaus June 2026 Operational Intelligence page on reports.shonichi.ai for template 02e (`{higgihaus_sample_url}`). The source HTML carries guest names and property names; strip both before it goes public.
- Both founders: create a Calendly link each and put the URLs in `messages/sequences.md` (placeholders now).
- Seb, this week: buy one Sales Navigator seat; chase Asaad on the Hostaway Marketplace contract; ask Joel for two named intros once the case study is ratified.
- Thu 4 Sept, before Friday: Sotirios needs a GitHub account (add as collaborator), a Claude account with Claude Code, and an Airtable invite. Checklist in `phases/00-sotirios-onboarding.md`.
- Claude Code environment: add `reports.shonichi.ai` to allowed domains so sessions can open the interactive reports (blocked 2 Sept).

## Operating mode (after LIVE)

"run my session" = pull today's queue from Airtable (follow-ups due first, then fresh leads owned by this founder), draft from `messages/`, founder personalises and sends, states updated, session logged. 5+ quality touches per session. Weekly review of scoreboard + funnel rates every Sunday.
