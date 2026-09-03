# Friday 5 September — Sotirios onboarding + Phase 04 together

Trigger: Seb says "I am working with Sotirios this evening, let's start". Claude opens this doc, runs Part A with Seb driving, then Part B (Phase 04) with both founders in the room.

## Context
Sotirios has no technical background and brings no existing network. He needs to leave the evening able to type "run my session" on his own and have the machine carry him. He also ratifies the three locked-core files, which unblocks every later "agreed with Sotirios" commit. Pulled forward from 12 September so ratification and his first solo session happen a week earlier.

## Objective
By the end of Part A: Sotirios can pull, run a session, log it, and push, entirely from plain English. Core files ratified or amended. By the end of Part B: Phase 04 done with his voice in the templates he will send.

## Definition of done
- Sotirios has run "run my session" and "log my session" on his own machine, and his log file is on `main`.
- `core/offer.md`, `core/icp.md`, `core/channels.md` carry "ratified by Sotirios 5 Sept" in their status line, or a list of amendments is committed.
- Phase 04 deliverables done (see `04-message-engine.md`).

## Seb, before Friday (15 minutes, do these Thursday)
- [ ] Sotirios has a GitHub account. Add him as a collaborator with write access on `sebspikes/shonichi-sales-os`.
- [ ] Sotirios has a Claude account with Claude Code access (Pro, Max or Team). He will use Claude Code on the web at claude.ai/code, no install.
- [ ] Airtable base exists (Phase 03, Thursday). Invite Sotirios as an editor.
- [ ] Send him `CLAUDE.md` and the three core files to read on the train. Ratification is faster if he has seen them.
- [ ] Bring: the Heim example pulse and one or two more, and the Joel testimonial quotes (already in `core/offer.md`).

## Part A: setup and dry run (40 minutes, Sotirios at the keyboard)

1. **(5) Connect GitHub.** In claude.ai: Settings, Connectors, connect GitHub, grant `shonichi-sales-os`. Open claude.ai/code, pick the repo, start a session.
2. **(5) Connect Airtable.** Same Connectors page, add Airtable, authorise the Shonichi Sales OS base. Test: he asks "how many tables are in the Airtable base" and gets an answer.
3. **(5) Read the rules.** He reads the "First time here?" section of `CLAUDE.md` aloud. Four rules only: pull happens first, one task per session, end with a log, files in `core/` change only by agreement. Then the quality-touch definition and the sending rule.
4. **(15) Ratify core.** Claude walks him through each of `core/offer.md`, `core/icp.md`, `core/channels.md` section by section. He says yes, or names the change. Amendments are made live, shown to both founders, committed with "agreed with Seb and Sotirios" in the message. Ratified files get "ratified by Sotirios 5 Sept" in the status line.
5. **(5) Dry run.** He types "run my session". Claude pulls, reads the queue, and explains where the build is. He types "log my session". Claude writes `logs/sotirios/2026-09-05.md` (type build, zero touches, note "onboarded, core ratified"), commits, pushes.
6. **(5) Capture.** Two things go to Airtable, not git: what Sotirios has already sent (pulses, to whom, replies), and Seb's warm-start list of operators and contacts. Claude creates the lead records.

If anything in steps 1 or 2 fails on Sotirios's account, do not burn the evening on it. Seb drives Part B from his own session and Sotirios repeats steps 1 and 2 on Sunday.

## Part B: Phase 04, message engine (60 minutes, both founders)

Open `04-message-engine.md` and run it as written, with two corrections carried in from Phases 01 and 02:
- The credibility line is "we run a 46-unit aparthotel business in Bristol and Cardiff ourselves", not Manchester. Phase 04's brief has the wrong city.
- Sequences needed per `core/channels.md`: LinkedIn bundle, LinkedIn OpIntel-only (for operators on Conduit, Besty or Enso Connect), Upwork first reply, Altoluxo referral intro. Email variant where an address is findable. Fiverr response is scoped only, not written.

Sotirios's job in Part B: read every template aloud as if sending it. If he would not send it, it is rewritten.

## After Friday
- 12 September becomes a checkpoint, not an onboarding: Sotirios runs a session solo that week and the checkpoint reviews what broke.
- If Part B does not finish, S4 slides to Saturday 6 September. S5 on Sunday needs the n8n webhook URL and does not move.

## Feeds into
Phase 08 dry run (both founders now able to run it), Phase 10 Sardinia handover (Sotirios drives solo 22 Sept to 3 Oct).
