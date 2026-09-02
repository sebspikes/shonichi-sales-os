# Build queue: September 2026

**Machine status: BUILD PHASE** (change this line to `LIVE` at Phase 10 sign-off; "run my session" switches behaviour on it.)

Deadline: machine live by **Friday night 18 September**, signed off at Seb's pre-departure review **Sunday 20 September**. Sotirios drives the pipeline solo during Seb's holiday (22 Sept - 3 Oct). Full firing from **Monday 5 October**: every morning session is queue-driven outreach, 5+ quality touches.

Each session is ONE phase doc (or a named part of one). Open the next unchecked item, read its doc in `build/phases/`, execute. Sessions are 60 minutes (Seb's golden hour); Friday-night sessions are longer and marked FN.

## The queue

- [ ] **S0 — Scaffold** (done in the planning session that created this repo; tick after both founders have read CLAUDE.md)
- [x] **S1 — Phase 01: Offer & case study** — `phases/01-offer.md` (Tue 2 Sept) — drafted, awaiting Sotirios ratification
- [ ] **S2 — Phase 02: ICP & channel map** — `phases/02-icp-channels.md` (Wed 3 Sept)
- [ ] **S3 — Phase 03: Airtable CRM** — `phases/03-airtable-crm.md` (Thu 4 Sept)
- [ ] **S4 — Phase 04: Message engine** — `phases/04-message-engine.md` (Fri 5 Sept)
- [ ] **S5 — Phase 05: Pulse integration** — `phases/05-pulse-integration.md` (Sun 7 Sept; bring the n8n webhook URL)
- [ ] **S6a — Phase 06: Lead sourcing, actor bake-off** — `phases/06-lead-sourcing.md` (Mon 8 Sept)
- [ ] **S6b — Phase 06: Lead sourcing, first 100 leads** (Tue 9 - Wed 10 Sept)
- [ ] **S7a — Phase 07: Enrichment & qualification** — `phases/07-enrichment.md` (Thu 11 Sept)
- [ ] **S7b — Phase 07: wave one ranked** (Fri 12 Sept)
- [ ] **FN 12 Sept — Sotirios onboarding evening**: environment set up, joint dry-run of a build session, core rules locked together
- [ ] **S8 — Phase 08: End-to-end dry run** — `phases/08-dry-run.md` (Sun 14 Sept)
- [ ] **S9 — Phase 09: Scoreboard & notifications** — `phases/09-scoreboard.md` (Mon 15 Sept)
- [ ] **S10a — Phase 10: Soft launch, first real sends** — `phases/10-soft-launch.md` (Tue 16 - Wed 17 Sept)
- [ ] **S10b — Phase 10: iterate on friction** (Thu 18 Sept)
- [ ] **FN 18 Sept — Launch review + Sardinia handover** (in `phases/10-soft-launch.md`)
- [ ] **Sun 20 Sept — machine signed off at pre-departure review; flip status line to LIVE**

Dates are the default mapping; slide them if a day gets eaten, but the ORDER is fixed — each phase's output feeds the next. If a session finishes its task early, pull the next phase forward; never split an hour across two phases.

## Backlog (not a session; pick up when a session finishes early)

- Pull Altoluxo review scores from Hostaway, March to September 2026, and put a number on "review scores improved" in `core/offer.md`.
- Phase 05: correct the pulse footer ("62%+ resolved autonomously") to match `core/offer.md`, and retire the HostMind name from all report templates.
- Claude Code environment: add `reports.shonichi.ai` to allowed domains so sessions can open the interactive reports (blocked 2 Sept).

## Operating mode (after LIVE)

"run my session" = pull today's queue from Airtable (follow-ups due first, then fresh leads owned by this founder), draft from `messages/`, founder personalises and sends, states updated, session logged. 5+ quality touches per session. Weekly review of scoreboard + funnel rates every Sunday.
