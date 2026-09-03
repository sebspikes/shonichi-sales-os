# Shonichi Sales OS

One machine, two founders, one number: **quality conversations started with qualified STR operators.**

Founders: **Seb** (Sebastian Spikes) and **Sotirios**. Co-founders of Shonichi. Weekly target: **25 quality touches per founder**, tracked on the scoreboard.

Shonichi handles guest communications 24/7 for short-term rental operators and turns every message into operational intelligence. The free Property Pulse report (generated from public Airbnb data) is the value-led opener of the sales motion. Reference economics: one client at Altoluxo shape pays ~£493/month for 5-8 hours of service. Target: £5k MRR (~10 clients). First new customer by November 2026.

## Session protocol (both founders, every session)

1. `git pull` FIRST, always. This repo syncs between two people and multiple machines.
2. One singular task per session. The unit of deep work is the session, not the project.
3. Before any commit, Claude shows the founder every decision and file change in plain English and waits for a yes.
4. Every session ends with: a log entry (see Log format), a commit, and a push. No exceptions.
5. If you do not know which founder you are talking to, ask once and remember for the session.

## The four commands

### "run my session"
- Read `build/QUEUE.md`. If the build phase is not complete: open the next unfinished phase doc in `build/phases/` and execute it with the founder. Each phase doc is a complete brief: context, objective, decisions, step plan.
- If the machine is live (QUEUE.md says so): generate today's queue from Airtable — follow-ups due first, then fresh leads owned by this founder, ordered by priority. Draft messages from `messages/` templates personalised with the lead record and pulse findings. The founder edits and sends. Update Airtable states as you go.

### "I am working with Sotirios this evening, let's start"
- Open `build/phases/00-sotirios-onboarding.md`. Run Part A with Sotirios at the keyboard, then Part B (the scheduled phase) with both founders. Seb drives the session; Claude walks him through what to do with Sotirios step by step.

### "log my session"
Write `logs/<founder>/YYYY-MM-DD.md` from `logs/TEMPLATE.md`, update the scoreboard, fire the notification webhook (see Notifications), commit, push.

### "generate me a property pulse <airbnb link or listing id>"
Fire the pulse workflow (see `tools/pulse.md` once Phase 05 is built), attach the resulting report to the lead's record in Airtable (Pulses table), report the headline finding back.

### "scoreboard" / "what has Seb|Sotirios done this week"
Read `logs/` and Airtable, answer with numbers: touches, replies, demos, pulses, week vs the 25 target, current streak, head-to-head.

## The rules

- **Quality touch definition:** personalised, aimed at an ICP-qualified operator, referencing something true and specific about their business (ideally their own pulse findings). Bulk or templated-without-personalisation sends score ZERO. This is what keeps the leaderboard honest.
- **The ruthless test:** any proposed component, tool, or automation must increase quality conversations started per week, or it does not get built. A database of 5,000 scraped leads is worth £0. Ten well-aimed conversations might each be worth £493/month, forever.
- **Locked core:** files under `core/` change only with BOTH founders' agreement, recorded in the commit message ("agreed with Sotirios/Seb"). Everything outside `core/` is open build space.
- **Sending rule:** LinkedIn (and all outreach) sends are ALWAYS a human action. The machine finds, matches, generates pulses, and drafts. Founders send. No automated sending, ever — it is a ToS/account risk and it breaks the quality-touch rule.
- **Data boundaries:** lead data lives in Airtable, not in git. No prospect personal data committed to this repo beyond what a log note needs. Seb's `life-os` repo is private and is never referenced, read, or linked from here.
- **Infrastructure follows evidence:** v1 proves the manual loop converts before any automation of it is built (see Phase 10 review gates).

## Airtable

The CRM and source of truth for leads, touches, and pulses. Base: **Shonichi Sales OS** (created in Phase 03; schema documented in `core/crm-schema.md`). Claude sessions read and write it through the Airtable connection — founders should rarely need to open Airtable directly. If the Airtable connection is unavailable in a session, say so and fall back to reading `core/crm-schema.md` for context; do not invent lead data.

## Notifications (built in Phase 09)

At the end of "log my session", post a one-line summary to the shared Slack channel via the incoming webhook (URL stored per Phase 09): "<Founder>: N touches, N replies, N pulses today. Week: Seb X vs Sotirios Y (target 25)." Each founder may additionally run a daily routine in their own Claude account that reads this repo + Airtable and pushes them a competitive brief.

## First time here? (Sotirios, start here)

Welcome. This is Claude Code: you type in plain English, Claude does the technical work (git, Airtable, scrapers, drafting). You do not need to know git or any of the tooling.

1. Type exactly: **run my session** — Claude will detect where the build is up to, or generate your outreach queue, and walk you through everything one step at a time.
2. When you finish working, type: **log my session** — your numbers go on the scoreboard automatically.
3. Any question, just ask in normal English: "what has Seb done this week", "show me the scoreboard", "explain how this repo works".

The only rules you must know: pull happens at the start (Claude does it), your session ends with a log (Claude does it), quality beats volume (you do that part), and files in `core/` only change when you and Seb both agree.

## Log format

`logs/<founder>/YYYY-MM-DD.md`, from `logs/TEMPLATE.md`:

```
date: YYYY-MM-DD
founder: seb | sotirios
type: build | outreach
touches: 0
replies: 0
demos: 0
pulses: 0
note: one line on what happened
```

Machine-countable. The scoreboard, the Slack ping, and Seb's life-os evening review all read these numbers, so the format is fixed (locked-core rule applies to this section).
