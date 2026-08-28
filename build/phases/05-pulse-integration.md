# Phase 05 — Pulse integration

## Context
The Property Pulse (existing n8n workflow: Airbnb listing ID in, full HTML report out) is the machine's warhead. This phase turns it into a one-line command available in any session, with results logged against leads automatically.

## Objective
"generate me a property pulse <airbnb link>" works end to end: listing ID extracted, workflow fired, report captured, Pulses row created in Airtable, headline finding returned in-chat.

## Definition of done
The command runs against a real listing with zero manual steps between link and logged report. `tools/pulse.md` documents the wiring for future sessions.

## Deliverables
- `tools/pulse.md`: the n8n webhook URL location (stored as an environment secret or in the founders' n8n, NOT committed in plaintext if the webhook is unauthenticated — decide in-session), payload format, response handling.
- `tools/pulse.sh` (or `.py`): wrapper script — extract listing ID from any Airbnb URL form, POST to the webhook, capture the output location.
- CLAUDE.md command already points here; verify the flow reads naturally.
- Airtable Pulses table wiring: each generation creates a row with lead link, listing ID, report location, headline finding (Claude summarises the report's top finding into one personalisation-ready line).

## Decisions to make in this session
1. **How the report reaches the prospect.** Options: hosted link (n8n output URL), PDF attachment, or re-hosted on a Shonichi domain (looks best, most work). Recommendation: whatever the workflow outputs today for v1; branded hosting is a Phase 10 review item.
2. Webhook security: if the URL alone can fire paid work, treat it as a secret (env var / n8n credentials), not a committed string.
3. Rate/cost guardrail: max pulses per day if generation has a real cost.

## Inputs required (bring to the session — hard requirement)
- The n8n webhook URL and expected payload for the pulse workflow.
- One real Airbnb listing to test against.
- How the workflow currently ingests Airbnb data (Apify actor? other?) — Phase 06 wants to reuse the same mechanism.

## Session plan (60 min)
1. (10) Walk the existing workflow: input, output, cost, timing.
2. (20) Write and test the wrapper script.
3. (15) Wire Airtable logging + headline-finding summary.
4. (10) End-to-end test on a real listing.
5. (5) Log, commit, push.

## Feeds into
Phase 06 (shared Airbnb ingestion mechanism), Phase 08 (dry run generates real pulses), every outreach session thereafter.
