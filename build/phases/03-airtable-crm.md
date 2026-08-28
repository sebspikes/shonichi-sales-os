# Phase 03 — Airtable CRM

## Context
Airtable is the source of truth for lead data; git never holds prospect PII. Claude sessions read/write the base through the Airtable connection so neither founder needs to open Airtable day to day. This phase builds the base in-session and documents it in git so the schema is versioned and agreed.

## Objective
A working base where a test lead can travel every pipeline state, and the daily queue query returns correctly per founder.

## Definition of done
Base exists, schema documented in `core/crm-schema.md`, one test lead pushed through new → won and deleted, queue query verified for both founders.

## Deliverables
Airtable base **"Shonichi Sales OS"** with three tables (starting design — refine in-session):

**Leads**
- Operator/company name, contact person, role
- Airbnb host profile URL, listing count, LinkedIn URL, website, email, Instagram
- City/geography, PMS (if known)
- ICP fit (yes/no/borderline), priority flag (e.g. intent signal), pain signals (text)
- State: `new → researched → pulse_ready → contacted → replied → demo_booked → proposal → won | lost | dormant`
- Owner (seb | sotirios) — leads have ONE owner so both founders never message the same person
- Next action date, source channel, notes

**Touches**
- Link to lead, founder, date, channel, template/sequence step used, reply received (y/n), reply summary

**Pulses**
- Link to lead, listing ID(s), date generated, report link/location, headline finding (one line used for personalisation)

Plus `core/crm-schema.md` documenting tables, fields, states, and the queue definition: *follow-ups where next-action date ≤ today and owner = me, then `pulse_ready` leads owned by me ordered by priority, then `new` ICP-yes leads.*

## Decisions to make in this session
1. Exact field list (above is the starting design; add, do not bloat).
2. Lead ownership assignment rule. Recommendation: assigned at qualification, alternating by default, overridable when a founder knows the prospect.
3. Where pulse reports themselves live (Airtable attachment vs link to wherever n8n outputs them). Decide with Phase 05 in mind.

## Inputs required
Airtable account access confirmed in the session (the Airtable connection must be authorised for whoever runs this session).

## Session plan (60 min)
1. (10) Confirm field list against ICP fields from Phase 02.
2. (25) Build the base and tables in-session via the Airtable connection.
3. (10) Write `core/crm-schema.md`.
4. (10) Push a test lead through every state; run the queue query for each founder.
5. (5) Log, commit, push.

## Feeds into
Phase 05 (Pulses table), Phase 06 (leads land here), Phase 08 (dry run exercises the states), operating mode (the daily queue).
