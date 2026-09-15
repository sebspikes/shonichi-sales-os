# Session handover — 15 Sept 2026 (Seb, S9)

For the next Claude session: this is the live state. Read this, `build/QUEUE.md`, and `build/friction-log.md` before doing anything. `git pull` first, always.

## S10a pre-flight (Wed 16 Sept — soft launch, first real sends, `build/phases/10-soft-launch.md`)

1. **Schedule state:** Mon 14 was missed; everything slid one day, order held. S10a is now ONE day (Wed 16), S10b Thu 17, FN review + Shonichi Light write-up Fri 18, sign-off Sun 20. No slack left — a lost day now eats the launch.
2. **Sotirios is ON HOLIDAY.** Do not wait on him for anything this week. His 11 wave-one leads: S10a decides whether Seb covers any (MCR's draft is ready and the connect sits on Seb's account anyway) or they hold for his return. His full setup bundle (solo session, `PULSE_*` env vars, allowlists, routine) must land between his return and Sun 21 — he drives solo from Mon 22.
3. **Before the first send, Seb checks LinkedIn accepts** on the 11 Sept connects (Torr, MCR, Staycasa, CEFAS, CasaCity, Supercity, Mbawa, Tommy Gan — the last now parked, reply-exception only). Accepts start the step-2 clock; three drafts are waiting on exactly that.
4. **First live Slack ping fires at S10a log time** IF Seb has added `SLACK_WEBHOOK_URL` (#sales-os incoming webhook) to the Shonichi environment and allowed `hooks.slack.com`. Not done → the ping prints a dry-run payload and says so; add the var and re-run `tools/scoreboard --ping seb --date <date>`.
5. Send-ready now, all drafted 13 Sept in Airtable Touches (`Sent` empty): Sophie's 02a warm + Evolve 02c (both Seb's, sendable the moment he chooses), MCR 02b teaser (Sotirios-owned, Seb-held connect — see 2), Torr 02d site-data (waits on accept), My-Places 02d observation (WhatsApp/site form, no name). At send time: paste what was actually sent into the Touch's `Sent` field, tick `Quality touch`, set the lead's state/next action — that is what makes it count on the scoreboard.

## "log my session" now does (Phase 09, built 15 Sept)

1. Write `logs/<founder>/YYYY-MM-DD.md` from the template.
2. Run `tools/scoreboard` — regenerates `scoreboard/README.md`; commit it with the log.
3. Run `tools/scoreboard --ping <founder>` — posts the one-liner to #sales-os (dry-run print if `SLACK_WEBHOOK_URL` unset).
4. Commit, push, PR, squash-merge (standing authorisation).

Scoreboard rules (Seb, provisional until Sotirios ratifies on return): quality touches win the week, replies tiebreak, loser buys coffee; streak = consecutive weekdays with a logged session (weekends extend, never break); counts come from logs only, drafts never count.

## Where the build is

- Phases 01–09 COMPLETE. Machine status: BUILD PHASE until Phase 10 sign-off (Sun 20), then LIVE.
- Outbound pulse workflow: version c39d6edd live since 13 Sept (copy fix + full guard package), first four production runs clean. Publish-after-clean-test rule stands.
- Pulse caps: 0 fired since 13 Sept (Seb used 4/10 that day; daily reset).

## Airtable state (base appitDnbs9KM3DpQR) — unchanged since S8

- pulse_ready + draft (3): Sophie's (51), Evolve/Ciaran (63), MCR (74). researched + draft (2): Torr (no-pulse by design), My-Places (gated at 9 reviews). parked: Sleepezee (Zeevou, Seb verdict 13 Sept), City Superhost (Guesty).
- Touches: 5 draft rows of 13 Sept, `Sent` empty, `Quality touch` unchecked. Pulses: 5 rows (4 of 13 Sept + Phase 05 test).
- Evolve's Pain signals hold a flooding-with-injury finding deliberately left out of the draft opener — Seb judges if it is ever used. My-Places: address nobody by name.

## Phase 10 iterate list (S10b, Thu 17)

1. Workflow: gated path must stop blanking the lead's existing `Pain signals` (data loss; My-Places restored by hand 13 Sept).
2. Workflow: gate's "pick another listing" advice should consult the portfolio preview first.
3. Templates: 02c vs the 80-word rule — Sunday review decision.
4. CLAUDE.md amendment (joint, needs Sotirios): pulses fire as one parallel batch; 10/founder/day cap unchanged.
5. From S9: first live Slack ping + Seb's own daily routine (`tools/routines.md`) once the env var exists.

## Ratified decisions — additions this session (Seb, 15 Sept)

16. Scoreboard: touches win / replies tiebreak / coffee stakes — provisional, Sotirios ratifies on return.
17. Streak: session-day rule (weekdays required, weekends extend).
18. Shared ping lives in Slack #sales-os (the only surface both founders see); the personal daily brief lives in each founder's own Claude account per `tools/routines.md`.

Decisions 1–15 stand (see git history of this file).
