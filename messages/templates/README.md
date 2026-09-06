# Templates

One file per step. Each has a Seb voice and a Sotirios voice; pick by sender, never mix. Slots in `{braces}` are filled from the Airtable lead and pulse record. Every send is logged in Touches with the file name in the Template field, so reply rates per template are comparable on the Sunday review.

Rules, non-negotiable:
- Under 200 characters for a connect note, under 80 words for everything else.
- One true, specific finding from their own pulse in every message after the connect. Generic sends score zero.
- No "hope you're well", no exclamation marks, no emoji, no pitch before the pulse.
- Pricing never appears. It is given on the call.
- Founder edits before sending. Claude drafts, humans send.

Slots: `{first_name}` `{company}` `{city}` `{listing_name}` `{headline_finding}` `{second_finding}` `{third_finding}` `{report_url}` `{calendly_url}` `{score}` `{units}` `{comms_tool}` `{higgihaus_sample_url}`

Pulse-delivery variants for the September test (pick one per lead, rotate evenly, log the file name):
- `02a` full pulse: one finding, link to the full report.
- `02b` teaser: one finding, no link, ask if they want the report.
- `02c` half pulse: three findings, link to the full report.
- `02d` no pulse: one finding stated as an observation, no report offered.
- `02e` OpIntel ask: no pulse at all, the live product's findings from Higgihaus as proof, straight to a 15-minute ask.

**Headline finding rule.** `{headline_finding}` is always an operational finding: a recurring complaint pattern, a declining trend, unanswered negative reviews, an access or cleanliness cluster. Never a title, photo, SEO or description finding. Those exist in the pulse but they are not what Shonichi does, and leading with them makes us sound like a listing optimiser. Frame the pulse as "the same analysis we run on guest messages, applied to your public reviews".

**Draft versus sent.** Every logged touch stores Claude's draft and what was actually sent. The Sunday review compares them per founder so tone drift and heavy editing are visible, and the templates get rewritten from what really goes out.
