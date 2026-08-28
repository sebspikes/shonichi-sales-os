# Phase 08 — End-to-end dry run

## Context
Before real sends, the whole chain runs under match conditions. The October constraint is one hour: if the loop cannot produce 5+ prepared quality touches inside a session comfortably, the machine is not done, whatever the components say.

## Objective
Prove: wave-one lead → pulse generated → sequence drafted → (dummy) send walked through → Airtable states updated → session logged, for five leads, inside the hour, with friction recorded.

## Definition of done
Five leads fully processed to send-ready. A friction list exists; everything small fixed in-session, anything larger queued with an owner. Time-per-touch measured and written down.

## Deliverables
- Five wave-one leads at state `pulse_ready` with drafted sequences attached (drafts saved against the lead in Airtable, NOT sent).
- `build/friction-log.md`: every snag, timed. (Where did the hour go? Which step dragged?)
- Fixes applied for anything under ~10 minutes of work; bigger items added to Phase 10's iterate list.

## Decisions to make in this session
1. Is "run my session" in operating mode specified correctly in CLAUDE.md, or does the dry run demand changes? Update CLAUDE.md (locked-core: agree changes jointly).
2. Realistic touches-per-hour number for October targets (5 is the floor hypothesis — replace with the measured number).

## Inputs required
Everything upstream built: offer, ICP, CRM, messages, pulse command, wave one.

## Session plan (60 min)
1. (45) Run the loop on five leads, timing each stage honestly. No polishing detours — record friction, keep moving.
2. (10) Fix the quick frictions; queue the rest.
3. (5) Log (type: build), commit, push.

## Feeds into
Phase 10 (soft launch uses the proven loop and the measured pace), CLAUDE.md operating-mode spec.
