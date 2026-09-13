# Property Pulse: the outbound wiring

> Built Phase 05 (Seb, 8 Sept 2026). The original inbound workflow "Property Pulse v3" is untouched. Outbound runs go through a separate copy.

## The two workflows

| | Property Pulse v3 (inbound, untouched) | Property Pulse - Outbound (Sales OS) |
|---|---|---|
| n8n workflow ID | 2Ntw5XxiKpFd2my8 | QxVdCclxcIipCccv |
| Trigger | POST /webhook/shonichi-pulse, open | POST https://shonichi.app.n8n.cloud/webhook/pulse-outbound-<secret>. The full path is in n8n and in each founder's `PULSE_WEBHOOK_URL`, never here |
| Payload | name, email, listing_url, listing_count, pms, mobile | listing_url, lead_id, founder, founder_email, listing_count (optional), company, source. pms is always Hostaway |
| Writes to | Hostchella "Property Pulse" base | Shonichi Sales OS base: Pulses row created; Lead set to pulse_ready with Pain signals and Next action, or kept at researched when the pulse is not sendable |
| Emails | The prospect (Gmail) and Seb | The founder who fired it, never the prospect |
| Headline findings | None | Three operational findings plus a CRM note, written by a third model call, then gated: fewer than 10 reviews or any listing-page wording blanks them and the lead stays researched |
| Everything else | | Identical: same two Apify actors (75 reviews cap), same two analysis calls, same scoring, same render, same R2 upload to reports.shonichi.ai |

Four edits inside the copied code, nothing else changed:
1. Slim Data and Assemble & Score read the form fields from Normalise Input instead of a form node that no longer exists.
2. Render Reports: the "62%+ autonomous resolution" line in the onboarding block became "around half of guest messages resolved autonomously and rising monthly". The two further "62%+ resolved autonomously" strings in that node's one-pager and full-report onboarding copy were fixed and published on 13 Sept (S8); the outbound workflow now carries zero occurrences. The v3 website workflow still has its copies (Seb, n8n editor — backlog).
3. Prep Final Data: source Outbound, event Sales OS outbound.
4. Assemble & Score: the Hostchella event bonus on lead temperature removed.

## How "generate me a property pulse <link>" runs

1. Claude finds or creates the lead in Airtable (Leads) and takes its record ID.
2. Claude counts today's Pulses rows for this founder in Airtable; at 10 or more it stops and says so. Then it runs `tools/pulse.sh <link> <lead record id> <founder> <listing count> <company>` from the repo root. The script extracts the listing ID, posts the payload, and returns at once. Its own 10-a-day counter is advisory only: it lives in the session's temp directory, so it resets per session and per machine.
3. n8n runs for 2 to 4 minutes (inbound average 3 min 35 s over 12 runs; the outbound test on 8 Sept took 2 min 7 s; cost about £0.75 to £1 per run, mostly the 75-review scrape and the model calls).
4. The workflow creates the Pulses row (URLs, score, headline, second, third finding, status generated) and emails the founder. If the listing has at least 10 reviews and the headline passed the positioning guard, the lead's State becomes pulse_ready with Pain signals and Next action "Send the pulse message". Otherwise the findings are blank, the lead stays at researched, and Next action says why (too few reviews: pick another listing from this host; guard tripped: write the headline by hand from the report). The email subject says "Pulse ready" or "Pulse generated, NOT sendable".
5. Claude polls the Pulses table for a row with this Listing ID whose Date generated is today and which did not exist before firing (count the matching rows first, wait for one more). Reports the headline and whether the lead is sendable. Timeout 8 minutes, then check the n8n executions list.

Claude never needs to reach reports.shonichi.ai or n8n directly. Both founders only need the Airtable connection plus one environment variable.

## Setup, once per founder

In the Claude Code environment (claude.ai, Code, Environments, edit or create one; the Default environment may not allow variables, so create "Shonichi" and start sessions in it):
- Environment variable `PULSE_WEBHOOK_URL` = the production URL of the outbound webhook. Seb copies it from the Webhook node of workflow QxVdCclxcIipCccv in n8n and hands it to Sotirios privately.
- Environment variable `PULSE_FOUNDER` = `seb` or `sotirios`, so the script knows who is firing without an argument.
- Environment variable `PULSE_FOUNDER_EMAIL` = the founder's own address (where the "Pulse ready" email lands). Required for Sotirios: the script refuses to fire without it, so his email never lands with Seb.
- Allowed network domain: `shonichi.app.n8n.cloud`, so the script can reach it. reports.shonichi.ai is not required.
- On a laptop install of Claude Code, the same three variables go in the shell profile or in `.claude/settings.json` under `env`.
- Sotirios gets the URL from Seb privately (message, not the repo). It is not in git and must not be.

The webhook URL is a secret: whoever has it can spend about £1 per call. It lives in environment variables and in n8n only, never in this repo.

## Payload contract

```json
{"listing_url": "https://www.airbnb.co.uk/rooms/1739176700405931399",
 "lead_id": "recXXXXXXXXXXXXXX",
 "founder": "seb",
 "founder_email": "sebastian.spikes@higgihaus.com",
 "listing_count": 40,
 "pms": "Hostaway",
 "company": "Example Stays Ltd",
 "source": "outbound"}
```
Only listing_url is required. listing_count is omitted when not given, so the lead's own Listing count is never overwritten. Without lead_id the Pulses row is created unlinked and the lead-update node fails softly (it is set to continue on error); the email then reads "(no lead id)".

## Headline findings rule (enforced in the model prompt)

Findings are operational only: recurring complaint patterns, declining trend, unanswered negatives, access, cleanliness or maintenance clusters, slow response. Never title, photos, SEO or description. Each under 25 words with a number and a count or time span. This is the positioning guard from `messages/templates/README.md`, applied twice: in the prompt (which is no longer given the title, listing scores or host portfolio data) and deterministically in Parse Headline, which blanks any finding over 25 words or containing title, photo, description, SEO, keyword, amenities, pricing, nightly rate, Superhost, ranking, search or portfolio. Fewer than 10 reviews blanks everything: a one-review listing is not a sendable lead, whatever the model says.

## How it was built, and the record of the test

Generated from the original's JSON export by a generator script kept in Seb's session scratchpad, not in git, because the R2 key sits inside the copied code nodes. Imported into n8n on 8 Sept, "Available in MCP" switched on. One post-import fix: n8n refreshed the Airtable field list and dropped the Status option list on Create Pulse Row, restored with the three options requested, generated, sent.

Test run 8 Sept 06:04 UTC, execution 62711, listing 1739176700405931399: success in 2 min 7 s. Pulses row created, score 62, three findings and a four-line CRM note written, lead recW59NgvUSaEUEye set to pulse_ready, founder email sent. The listing has one review, and the findings were honest statements of missing data, which is exactly not a sendable opener. That run is why the minimum-reviews gate and the positioning guard were added the same morning, along with a tighter prompt that no longer sees the title, listing scores or portfolio figures.

Second test run 8 Sept 06:48 UTC, execution 62714, same listing, after those changes: success in 2 min 5 s. Findings blanked by the gate, lead kept at researched with Next action "Pulsed listing has 1 reviews, under the 10 minimum. Pick another listing from this host before messaging.", email subject "Pulse generated, NOT sendable". The first run's Pulses row was deleted so the lead links to one row.

The sendable path was exercised in the Phase 08 dry run (13 Sept, first four production-webhook runs): three sendable pulses (scores 51, 63, 74), one correct gate-trip at 9 reviews, all nine findings operational on the one-time eyeball check — positioning rule held. Note from the same session: the 8 Sept review fixes had never been published (the active version was a pre-guard autosave), so S8 published them; after any n8n edit that tests clean, publish immediately.

Seb can also fire and watch runs through the n8n connection in a Claude session (execute_workflow on QxVdCclxcIipCccv with the same payload under webhookData.body). That path needs no environment variable and is the fallback if the script route is unavailable.

## Known limits and follow-ups

- The Airtable credential on the two Sales OS nodes is the same token the inbound workflow uses. If it lacks access to the Sales OS base, the run fails at Create Pulse Row: add the base to that token in Airtable (Account, Developer hub, the token, Access).
- The R2 upload code in both workflows holds the R2 access key in the node code. Rotate that key and move it to n8n environment variables when convenient. It is not in this repo.
- Same listing pulsed by both workflows overwrites the same report file name on R2. Same content, so harmless.
- Firing through the n8n connection in Claude (execute_workflow) also works for Seb and is the fallback if the webhook route is unavailable.
