# Outreach sequences

> STATUS: DRAFTED Phase 04 (Seb, 6 Sept 2026). Grown from reply data every Sunday.

Every touch is a human send, logged in Airtable Touches with the template file name, so reply rate per template is visible on the Sunday review. Templates live in `messages/templates/`, one file per step, Seb voice and Sotirios voice in each.

## Voice

- **Seb:** first person operator. "I run 46 serviced apartments in Bristol and Cardiff." Peer to peer, the same business struggles.
- **Sotirios:** co-founder who sells, not the operator. Borrows Seb's credibility explicitly: "my co-founder Seb runs 46 units". Curious, evidence-led, never pretends to run units.
- Both: short, data forward, lead with value, no pleasantries, no exclamation marks, no pitch before the pulse. Under 200 characters for a connect note, under 80 words otherwise. Pricing never appears in outreach.

## LinkedIn primary sequence

| Step | Template | When | State after |
|---|---|---|---|
| 1 | `linkedin-01-connect` | With the connection request. No pitch, no link | contacted |
| 2 | `linkedin-02a/b/c/d/e` (one variant per lead, rotate) or `linkedin-opintel-pulse` if a competing comms tool is set | 1 to 2 days after accept | contacted, next action +4 working days |
| 3 | `linkedin-03-followup` | 3 to 4 working days after step 2, no reply | contacted, next action +5 working days |
| 4 | `linkedin-04-breakup` | 5 working days after step 3, no reply | dormant, revisit after 90 days |

Any reply at any step moves the lead to `replied` and the sequence stops. From there Claude drafts a reply from the objection library and the lead's own report; the founder edits and sends.

If the connection request is not accepted within 7 days and an email is findable, send `email-pulse` and set next action +4 working days. If nothing after that, dormant.

## The September test: four ways to deliver the pulse

The whole motion is "here is free value, no strings", so the default is the full report. But whether people reply more to a link, a teaser, more evidence, or an observation alone is unknown. Rotate evenly across qualified leads, minimum 10 sends per variant before judging:

- **02a full pulse:** one finding, full report linked. The control.
- **02b teaser:** one finding, no link, "want me to send it?". Tests whether asking for a reply first lifts engagement.
- **02c half pulse:** three findings, full report linked. Tests whether more evidence beats one sharp line.
- **02d no pulse:** one finding as an operator observation, no report offered. Tests whether the insight alone starts the conversation.
- **02e OpIntel ask:** no pulse, no listing talk. What the live product surfaced at Higgihaus last month, a redacted report link, and a 15-minute ask. Tests whether the intelligence pitch books calls on its own and protects the positioning: Shonichi is not a listing optimiser.

**Positioning guard.** Whatever the variant, the headline finding is operational (complaint patterns, trends, unanswered negatives, access or cleanliness clusters), never title, photo or SEO. See the rule in `templates/README.md`.

Judge on reply rate to step 2 and on demo rate by step 4. Kill the losers at the Phase 10 review.

The one-pager gated behind a call is not in the test. Gating contradicts "no strings". Keep it for paid or top-of-funnel traffic later, where a pre-qualifying step is wanted.

## Other sequences

- **OpIntel-only** (lead has Conduit, Besty or Enso Connect): steps 1, `linkedin-opintel-pulse`, 3, 4. Never mentions replacing their comms.
- **Upwork:** `upwork-reply` on the platform. If they reply, move to LinkedIn or email for the report. Screen against 15 listings first.
- **Altoluxo referral:** `referral-intro` only, skips the connect note. Follow-up by reply, not by sequence.
- **Fiverr:** scoped in `core/channels.md`, no template until the Phase 10 go/no-go.

## Draft versus sent

When a touch is logged, Claude writes its draft into the Draft field and asks the founder for what was sent; "as drafted" copies it across. An Edited flag shows which touches were rewritten. Sunday review reports edit rate per founder and per template, and quotes the recurring changes, so the templates move toward what the founders actually say.

## Demo booking

Calendly link plus "or reply and we'll sort a time" in step 3 and the referral intro. Seb's and Sotirios's own links, one each; `{calendly_url}` is filled per sender. Placeholders until both links exist.

## Worked example, from the Heim pulse

Lead: The Heim, Manchester. Listing: Scandinavian | The Heim. Score 62. Headline finding: "8 negative reviews with no reply, and the same multi-code entry complaint in 11 reviews across 399 days". Second finding: "a 23-character title with no Manchester keyword, so the listing is invisible in city search". Third: "value rated 4.42, dragged by fee complaints in 8 reviews".

Step 2a, Seb: "Thanks for connecting, Ben. I ran Scandinavian | The Heim through the listing analysis we use on our own units. One thing stood out: 8 negative reviews with no reply, and the same multi-code entry complaint in 11 reviews across 399 days. Full report here, no strings: [link]. It's built from public Airbnb data only. If any of it is useful, I'd be interested to hear which bit."

Sixty-one words. That is the bar.
