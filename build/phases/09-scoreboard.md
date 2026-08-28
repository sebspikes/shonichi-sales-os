# Phase 09 — Scoreboard, leaderboard & notifications

## Context
The competition is a feature, not decoration: public scoreboards demonstrably move outreach volume, and the numbers scored (touches, replies) are exactly the funnel's input numbers. XP lands on touches because that is the number under a founder's command; revenue is the lagging statistic. This layer also feeds Seb's life-os game layer (his private repo reads these logs read-only; this repo never references life-os).

## Objective
"scoreboard" in any session prints live state; every logged session pings the shared Slack channel automatically; each founder can run a daily competitive brief in their own Claude account.

## Definition of done
Scoreboard renders from real logs + Airtable; Slack ping fires on "log my session"; the routine recipe is documented for both founders.

## Deliverables
- `tools/scoreboard` (script): reads `logs/*/` + Airtable Touches, renders `scoreboard/README.md` (or HTML): week-to-date touches per founder vs the 25 target, replies, demos, pulses, current streaks, head-to-head record, all-time totals.
- Slack notification: incoming webhook for the shared channel; "log my session" posts: `"<Founder>: N touches, N replies, N pulses today. Week: Seb X vs Sotirios Y (target 25)."` Webhook URL stored as a secret/env, not committed.
- `tools/routines.md`: recipe for each founder's optional daily routine in their OWN Claude account (cloud scheduled task: pull this repo + read Airtable each evening, push a phone notification — "Seb sent 22 this morning, you're 14 behind, catch up"). Accounts are sealed from each other; each founder sets up their own.
- Weekly review spec: every Sunday, whoever reviews reads reply-rate per template and per channel from Airtable; the worst performer gets tuned or cut. **This feedback loop is the machine's compounding engine — it is not optional.**

## Decisions to make in this session
1. What wins the week (recommendation: quality touches, with replies as tiebreak) and the stakes (recommendation: loser buys coffee at the Sotirios touchpoint; keep it fun, keep it real).
2. Streak rules (consecutive weeks ≥25? consecutive session days?).
3. Slack channel name and webhook creation (do live in-session).

## Inputs required
Slack workspace admin access to create the incoming webhook. Both founders' agreement on stakes (it goes in `core/` spirit even if the file lives in tools).

## Session plan (60 min)
1. (10) Decisions 1-3.
2. (25) Build and test the scoreboard render against existing logs.
3. (15) Wire the Slack ping into "log my session"; test.
4. (5) Write `tools/routines.md`.
5. (5) Log, commit, push — and enjoy the first automated ping announcing it.

## Feeds into
Operating mode (the ambient competition), the Sunday review loop, Seb's life-os evening shutdown (reads the numbers read-only).
