# Phase 04 — Message engine

## Context
The pulse is the gift; the message delivers it. This is what makes 5-10 quality touches fit in one hour: Claude drafts from the lead record + pulse findings + `core/offer.md`, the founder applies judgement and sends. Personalisation depth is the conversion lever — "your Value score is being dragged by fee complaints in 8 reviews" beats any generic opener ever written.

## Objective
Given a lead with a pulse, Claude drafts the full sequence needing only light edits.

## Definition of done
Sequences written for the primary channel, templates in `messages/templates/` with named personalisation slots, objection library started, demo booking mechanism decided. Test: draft against 2-3 real example listings (use the Heim-style pulse output) and both founders would send the result.

## Deliverables
- `messages/sequences.md`: **LinkedIn primary sequence** — connect note (short, credible, no pitch) → pulse delivery message (the gift, one headline finding quoted) → value follow-up (a second finding + soft demo offer) → breakup (graceful, door open). Variants: email (where an address is findable) and Fiverr gig response. Timing rules between steps (recommendation: 3-4 working days).
- `messages/templates/` one file per template with slots: `{first_name}`, `{company}`, `{headline_finding}`, `{second_finding}`, `{listing_name}`, `{city}` etc.
- Objection library started in `messages/objections.md`: "we have a VA", "we use [PMS] automations", "how much", "is this AI slop", "where did you get my data" (answer: public listing data, happy to delete, here's the free report regardless).
- Demo booking mechanism decided and linked in templates.

## Decisions to make in this session
1. **Tone.** Recommendation: peer-to-peer operator tone — "we run an STR operation in Manchester ourselves" is the credibility unlock and belongs in the first touch. Not corporate, not salesy.
2. Demo booking: calendar link vs "reply and we'll sort a time". Recommendation: both — link for the willing, reply for the conversational.
3. How much of the pulse goes in the message vs held for the full report. Recommendation: one sharp finding in the message, full report as the deliverable, second finding held for follow-up.

## Inputs required
`core/offer.md` (Phase 01) and the Heim example pulse for realistic drafting.

## Session plan (60 min)
1. (10) Tone + sequence shape decisions.
2. (25) Draft the LinkedIn sequence + templates against real pulse examples.
3. (10) Objection library first pass.
4. (10) Both-founders test read (or flag for Sotirios).
5. (5) Log, commit, push.

## Feeds into
Phase 08 (dry run uses these), operating mode (every morning drafts from here). Reply-rate data per template feeds the weekly review loop — tag every touch with its template in Airtable.
