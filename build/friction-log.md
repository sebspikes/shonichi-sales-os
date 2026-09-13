# Friction log — S8 end-to-end dry run (Seb, Sun 13 Sept 2026)

Five locked leads: Sophie's Homes, Evolve Stays, Torr Property Group (no-pulse variant), My-Places (guard-low), MCR Hospitality (guard-high). All times UTC. Session start 05:48.

## Where the hour went

| Stage | Time | Elapsed |
|---|---|---|
| Pull, branch reset, read-in (handover, phase doc, queue) | 05:48–05:53 | 5 min |
| Pre-flight: find + fix the 62% strings, discover the missed publish, verify, publish | 05:49–06:04 | 16 min |
| Mid-session decisions (Sleepezee, Light tier) — taken INSIDE the n8n wait | 06:02 | 0 min marginal |
| Fire 4 pulses in parallel (Seb call: batch, not sequential) | 06:04:42 | 1 second |
| Cook time — used for Torr draft + Touch row | 06:05–06:08 | 3.5 min |
| All four pulses back (3m06s–3m24s each) | 06:08:07 | |
| Verify states, restore Pain signals (bug), fill + save 4 drafts | 06:08–06:12 | 4 min |
| **Loop complete: 5 send-ready drafts in Airtable** | **06:12** | **24 min** |
| Fixes, docs, log, commit | 06:12– | remainder |

Pure loop (fire → all drafts saved): **~7.5 minutes for 5 leads**, because pulses ran as one parallel batch and drafting happened during cook time. The pre-flight 16 minutes was one-off debt from 8 Sept, not loop cost.

## What broke or dragged, timed

1. **(16 min, one-off) The missed publish.** The "four 62% strings" turned out to be 2 in the draft + 2 in the active version of the outbound workflow — because the active version was an 8 Sept 05:57 autosave, published BEFORE the Phase 05 review fixes. The minimum-reviews gate, positioning guard, dynamic lead state and sendable email subject had never been live: both 8 Sept end-to-end tests ran the draft manually, and the production webhook had never fired at all. Today's first four production runs would have marked every lead pulse_ready unconditionally, edge-testers included. Fixed: copy edit + publish (version c39d6edd), verified byte-level, 0 old strings live. **Rule adopted: after any n8n edit that tests clean, publish immediately — the draft is not the machine.**
2. **(2 min to patch, workflow fix queued) Gated path blanks Pain signals.** My-Places' gate-trip overwrote the S7b research note in Pain signals with the gate's empty output. Restored by hand. Workflow must only write Pain signals when non-blank → Phase 10 iterate list.
3. **(1 min) Gate advice can be impossible.** Gate's Next action said "pick another listing from this host" but no My-Places listing in the portfolio preview has 10+ reviews (max 9). Human override recorded on the record. Future: gate message could consult the preview counts → Phase 10 iterate list.
4. **(~2 min while drafting) 02c cannot fit 80 words untrimmed.** Three machine findings at up to 25 words each + the template skeleton overflows the 80-word rule. Findings needed hand-trimming to clause form. One-line guidance added to the 02c template today; decide at Sunday review whether 02c keeps the 80-word cap or gets its own limit.
5. **(0 min today, S10 decision) Owner/connect mismatch.** Torr and MCR are Sotirios-owned but the accepted-or-pending connects sit on Seb's LinkedIn. Draft voice follows the account that holds the connect (Seb). Who sends step 2 on these two → S10 with both founders.
6. **(10 min, hidden inside pre-flight) 94KB node edits via MCP are slow.** The Render Reports copy fix took ~10 minutes to write + byte-verify through the connection. Fine for one-offs; not a loop operation.
7. **(0 min) Draft rows vs the scoreboard.** Dry-run drafts live as Touches rows with Sent empty and Quality touch unchecked. S9 scoreboard must count only touches with Sent filled — spec input for tomorrow, otherwise drafts inflate the leaderboard.

## What worked without friction

- Parallel batch firing: 4 webhooks accepted in 1 second, 4 concurrent n8n runs, no strain, all back inside 3.5 minutes. This is the live-mode pattern.
- The guard, both ends, first production runs: My-Places (4.34, 9 reviews) correctly held at researched with the right Next action; MCR (4.88 high performer) correctly produced a sendable score-74 pulse. All 9 findings across 3 sendable pulses were operational — zero title/photo/SEO leakage (pulse.md's one-time eyeball check: done, passed).
- Airtable chain: Pulses rows linked, states flipped, Pain signals rich and structured (on the sendable path), founder emails fired.
- Mid-session founder decisions cost zero marginal time when taken during machine waits.

## Measured numbers (phase decisions)

- **Touches-per-hour:** 5 prepared, send-ready quality touches in 24 minutes including one-off pre-flight; ~7.5 min pure loop. Preparation comfortably beats the 5/hour floor — call it **10+ prepared touches/hour** at batch cadence. The unmeasured half is the human edit-and-send; keep **5+ SENT touches/session** as the October target until S10 measures real sends.
- **Pulse cost/time:** 4 pulses, ~3m15s average, ~£3–4 total. Daily cap untouched (4/10).
- **"run my session" spec:** held up. One amendment proposed (batch pulse firing) — see session log; CLAUDE.md change needs joint agreement.
