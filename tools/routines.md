# Daily competitive brief — per-founder routine (Phase 09)

Each founder runs this in their OWN Claude account. Accounts are sealed from each
other; this is why the shared session ping lives in Slack (#sales-os) and the private
nudge lives here. Setting it up is optional but the competition works better armed.

## What it does

Every weekday evening, your Claude account opens a fresh session in your Shonichi
environment, pulls this repo, reads the scoreboard and the other founder's logs, and
pushes ONE short notification to your phone. Example:

> Seb logged 6 touches today, you're 4 behind on the week (11 vs 15, target 25). Your streak: 3 days.

## Setup (10 minutes, once)

1. You need: the Claude mobile app with notifications on, and a Claude Code
   environment with this repo (the same "Shonichi" environment used for sessions —
   it already carries your `PULSE_*` variables; `SLACK_WEBHOOK_URL` optional here,
   the routine never posts to Slack).
2. On claude.ai → Code, create a scheduled task (Routine): weekdays, 18:00 UK,
   fresh session each run, in the Shonichi environment.
3. Prompt for the Routine (paste as-is, swap the founder names for Sotirios):

   ```
   git pull, then run tools/scoreboard. Read my latest log in logs/sotirios/ and
   Seb's latest in logs/seb/. Send me one push notification, two sentences
   maximum: what Seb logged today (touches/replies/pulses), my week total vs
   his vs the 25 target, and my current session-day streak. If a log records
   replies or demos, name the company only (e.g. "1 reply (Evolve)"), never a
   person. No other prospect data in the notification. If neither of us logged
   today, say exactly that in one sentence. Do nothing else: no commits, no
   sends, no Airtable writes.
   ```

4. Test it once by firing the Routine manually; check the notification lands.

## Rules baked in

- The routine is READ-ONLY: it never commits, never sends outreach, never writes
  Airtable. The sending rule (humans send) applies to notifications too.
- Names rule (Seb, 15 Sept): pushes are numbers-only, EXCEPT replies and demos
  may name the company ("1 reply (Evolve)") — never a person. Rationale: a reply
  on the lock screen sets tomorrow's first move; people's names on lock screens
  are leakage for no gain. The shared #sales-os ping stays pure numbers always.
- Counts come from `tools/scoreboard`, which reads only the logs — a touch exists
  when the log says so and `Sent` is filled in Airtable. Drafts do not count.

## Status

- Seb: LIVE since 15 Sept — Routine `trig_019ZAgetqQXYkmzXdHzp67zB`, weekdays
  17:06 UTC (18:06 UK in summer; drifts to 17:06 UK when BST ends 25 Oct — nudge
  it then if that grates), fresh session per run, push on.
- Sotirios: queued for his return from holiday — bundle with his other setup
  (solo session walkthrough, `PULSE_WEBHOOK_URL` + `PULSE_FOUNDER_EMAIL` env vars,
  `shonichi.app.n8n.cloud` + `hooks.slack.com` allowlist, this routine). Must land
  before Sun 21 Sept if he drives the pipeline solo from Mon 22.
