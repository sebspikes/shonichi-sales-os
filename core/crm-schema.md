# Airtable CRM schema

> STATUS: SHELL — filled by Phase 03 when the base is built. LOCKED CORE.
> Base: "Shonichi Sales OS". Source of truth for all lead data. Lead PII never lives in git.

Proposed tables: Leads (with state machine + owner), Touches, Pulses.
States: new → researched → pulse_ready → contacted → replied → demo_booked → proposal → won | lost | dormant.
Queue definition: follow-ups due today (owner = me) → pulse_ready (owner = me, by priority) → new ICP-yes.
