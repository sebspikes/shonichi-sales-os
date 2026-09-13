# Session handover — 13 Sept 2026, morning (Seb, S8)

For the next Claude session: this is the live state. Read this, `build/QUEUE.md`, and `build/friction-log.md` before doing anything. `git pull` first, always.

## S9 pre-flight (Mon 14 Sept — scoreboard & notifications, `build/phases/09-scoreboard.md`)

1. **Scoreboard counting rule (from S8, non-negotiable):** five dry-run drafts sit in Touches with `Sent` EMPTY and `Quality touch` unchecked. The scoreboard counts a touch ONLY when `Sent` is non-empty. Drafts must never inflate the leaderboard.
2. **Slack webhook does not exist yet** — Phase 09 builds it. Until then "log my session" skips the ping (S8 did).
3. **Chase Sotirios**: still no solo session (nothing in `logs/sotirios/` since onboarding). His `PULSE_WEBHOOK_URL` / `PULSE_FOUNDER_EMAIL` environment is also still unset — he cannot fire pulses until that's done (`tools/pulse.md`, setup section).
4. Week numbers for the scoreboard build: Seb — build sessions 10, 11, 13 Sept; touches 0, pulses 4 (all 13 Sept, dry run). Sotirios — nothing logged.

## Where the build is

- **Phase 08 COMPLETE** (Sun 13 Sept). Five locked leads send-ready in 24 min (~7.5 min pure loop). Full timings and the bug list: `build/friction-log.md`.
- Next: **S9** (Mon 14), **S10a first real sends** (Tue 15 – Wed 16), S10b iterate (Thu 17), FN launch review (Fri 18, + Shonichi Light core write-up, Seb), sign-off Sun 20.
- Machine status: still BUILD PHASE.

## The outbound pulse workflow is now truly live

- S8 published version **c39d6edd** of `Property Pulse - Outbound (Sales OS)` (QxVdCclxcIipCccv): the 62% copy fix PLUS the entire Phase 05 guard package (min-reviews gate, positioning guard, dynamic lead state, sendable email subject), which had sat unpublished since 8 Sept — the active version was a pre-guard autosave and the production webhook had never fired.
- First four production runs, 13 Sept: all success, ~3m15s average, guard passed both edge tests (gate-trip at 9 reviews; 4.88 high performer still sendable at score 74). All 9 findings operational — the one-time positioning eyeball in `tools/pulse.md` is done.
- **Rule adopted (S8): after any n8n edit that tests clean, publish immediately.** The draft is not the machine.
- Batch firing is the live pattern: 4 parallel webhook fires, 1 second, no strain. Proposed CLAUDE.md amendment (needs joint agreement): "multiple pulses fire as one parallel batch; the 10/founder/day cap still applies."

## Airtable state (base appitDnbs9KM3DpQR)

- **pulse_ready + draft attached (3):** Sophie's Homes (pulse 51, 02a warm draft), Evolve/Ciaran (63, 02c re-approach), MCR Hospitality (74, 02b teaser — headline swapped to "65 of last 75 unanswered", shower-pressure finding held for follow-up).
- **researched + draft attached (2):** Torr (02d site-data variant, no pulse by design), My-Places (02d-style observation; pulse correctly gated at 9 reviews — no listing in its preview reaches 10, so the gate's "pick another listing" advice is impossible; S10 sends the observation or enriches the other 11 listings).
- **parked (new):** Sleepezee — Seb verdict 13 Sept on the Zeevou evidence, same treatment as City Superhost/Guesty. Exception noted on the record if Tommy accepts the 11 Sept connect.
- Touches: 5 draft rows dated 13 Sept, `Sent` empty, `Quality touch` unchecked. Pulses: 5 rows total (4 of 13 Sept + the Phase 05 test).
- Pulse cap: Seb fired 4/10 on 13 Sept; resets daily.

## Send-readiness for S10 (Tue 15)

- Sophie's and Evolve drafts are Seb-sendable as-is (his leads, his routes). Sophie: warm channel of Seb's choice. Evolve: LinkedIn, already connected.
- **Open S10 decision:** Torr and MCR are Sotirios-owned but the pending connects sit on Seb's LinkedIn. Drafts are in Seb voice. Both founders decide who sends before anything goes out.
- Evolve's Pain signals hold a flooding-with-guest-injury finding deliberately left OUT of the draft opener — Seb judges whether it ever gets used.
- My-Places: address nobody by name (director unverified).

## Phase 10 iterate list (from the dry run)

1. Workflow: gated path must stop blanking the lead's existing `Pain signals` (data loss; My-Places was restored by hand).
2. Workflow: gate's Next action should consult the portfolio preview before advising "pick another listing".
3. Templates: 02c three findings cannot fit the 80-word rule untrimmed — drafting note added to the template file; decide the real rule at the Sunday review.
4. CLAUDE.md: batch-firing amendment above (joint agreement).

## Ratified decisions (Seb) — additions this session

12. Sleepezee parked on the zeevou.direct tell — Zeevou operators are not Hostaway-billable; park, revisit if a Zeevou route opens (City Superhost precedent).
13. Shonichi Light core write-up scheduled FN 18 Sept.
14. Publish-after-clean-test rule for n8n (above).
15. Pulse batches fire in parallel, never sequentially (Seb, mid-session, applied and proven at 4x).

Decisions 1–11 stand (see git history of this file).
