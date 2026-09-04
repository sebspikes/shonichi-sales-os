# Airtable CRM schema

> STATUS: BUILT Phase 03 (Seb, 4 Sept 2026). Awaiting Sotirios ratification. LOCKED CORE: changes need both founders.
> Base: **Shonichi Sales OS** (`appitDnbs9KM3DpQR`) in Seb's workspace. Source of truth for all lead data. Lead PII never lives in git.

Three tables. Claude reads and writes them through the Airtable connection; founders rarely open Airtable. Table and field IDs are listed so sessions can address them without guessing.

## Leads (`tblPKi621zaYsyNiw`)

One row per operator. Fields grouped by what they are for.

**Identity**
| Field | Type | ID |
|---|---|---|
| Company (primary) | text | fldmXXyoRxiZAYpMc |
| Contact name | text | flduAPDmT3CsaSQSM |
| Role | text | fldNpOVabpKyt4tnR |
| LinkedIn URL | url | fldG3FM1rUHEiO2xg |
| Airbnb host URL | url | fld1NAJOngO6FM4kS |
| Website | url | fld1Hvnwzr6L4mBK0 |
| Email | email | fldeHMesJSUKsIsac |
| Instagram | url | fldWq6OwxoYEPN71e |
| City | text | fldgppJMXeWtLdAY3 |
| Country | select: UK, Ireland, US, Other | fld1AuXQpCAVztjVi |
| Wave | select: 1, 2, 3, 4 (see `core/icp.md`) | fldh7jDlV534Md7EG |

**ICP gates** (one field per gate of the one-minute test in `core/icp.md`)
| Field | Type | ID |
|---|---|---|
| Professional host | select: Yes, No, Unsure | fld6CLlnrkrJXzttj |
| Listing count | number | fldJS78umXfrNahrq |
| Property type | select: Urban SA, Coastal / rural, Hotel PMS aparthotel, Other | fld65gisC14PsM1bZ |
| PMS | select: Hostaway, Guesty, Other, Unknown | fld4xruK7gzdpzGQH |
| Hostaway evidence | text (how we know) | fldoWxIVARdtwCp99 |
| Decision maker found | checkbox | fld8dQvOjGo5MNWMP |
| ICP fit | select: Qualified, Borderline, Parked, Disqualified. Set by a founder at qualification, never by formula | fldr2ew7eh3GIIJ8I |

**Sales**
| Field | Type | ID |
|---|---|---|
| State | select, see state machine below | fldRLWWi3WqevMsQD |
| Owner | select: seb, sotirios | fldgEtsZ8ucZQOwWm |
| Source channel | select: LinkedIn + pulse, Airbnb pipeline, Altoluxo referral, Upwork, Job post signal, Hostaway marketplace, Fiverr, Reddit, Directory, Paid ads, Warm intro | fldFJX08yzGjaP9qX |
| Competing comms tool | select: None, Conduit, Besty, Enso Connect, Other, Unknown | fldNOzMYLUogBmLGy |
| Product fit | select: Bundle, OpIntel only, Comms only | fldy5vYY0UmoZaUxm |
| Priority | select: 1, 2, 3 (1 highest) | fldeojZgkeXsMMvOU |
| Intent signal | text | fldboxnSdMb64Hupz |
| Pain signals | long text, from the pulse | flda9nQIzVBQrH9DP |
| Next action date | date (ISO) | fld5VdlFE4qmV1aCv |
| Next action | text | fldDnT5DberIhrchN |
| Notes | long text | fldx3O1ANwrK0T4tl |

**Computed** (do not write to these)
| Field | Type | ID |
|---|---|---|
| Touches | link to Touches (reverse) | fldfXik6PjWMrHROC |
| Pulses | link to Pulses (reverse) | fldSfPRTfTjac8QW0 |
| Touch count | count of Touches | fldEp1wgVjM6DLLXP |
| Last touch date | rollup MAX(Touches.Date) | fldv0usCcqyTYfwS2 |
| Headline finding | lookup from Pulses | fldYOiN6XDBzjyhWv |

## Touches (`tbl3JhCvwoQTWqW4E`)

One row per human send. The scoreboard counts these. Nothing is ever written here by automation; the founder sent it or it does not exist.

| Field | Type | ID |
|---|---|---|
| Touch (primary) | text label: Company - date - step | fld2QbnhwcEai6sLD |
| Lead | link to Leads | fldHsK97puj15WNYU |
| Founder | select: seb, sotirios | fld3pu9AwrEdyAgSo |
| Date | date (ISO) | fldyxBJswVa36n9PM |
| Channel | select: LinkedIn, Email, Upwork, WhatsApp, Call, Other | fldKkYEUXq0XwZIxP |
| Template | text, file name from `messages/templates/` | fldVdvfnt7jjMtGAV |
| Sequence step | select: connect, pulse, follow-up, breakup, reply, other | flddh1cZxCSE1MTBU |
| Quality touch | checkbox. Ticked by default when logged from a personalised draft. Unticked means it scores zero on the board | fldd02AeNoud9wFZN |
| Reply received | checkbox | fld4714VkfQGnrXTX |
| Reply summary | long text | fldUe7AlZOcb698pq |

## Pulses (`tblxCDw3x7GDxmkQ1`)

One row per Property Pulse generated. Reports live at their reports.shonichi.ai URL; nothing is attached in Airtable.

| Field | Type | ID |
|---|---|---|
| Pulse (primary) | text label: Company - listing name | fldVqFcLk5hO3xXlf |
| Lead | link to Leads | fldFwZtb8FJ4T5Krk |
| Listing URL | url | fldmX3luO2jk89nfg |
| Listing ID | text | fld0GovOgJi7NrzaM |
| Date generated | date (ISO) | fldz4cLfSJOo2nNmK |
| Report URL | url | fldt1XgmxSZlNI1Wq |
| Score | number, 0 to 100 | fld2NC5lQQq1kdHGW |
| Headline finding | text, one line, used in the first message | fldhZdePXx4FGYdro |
| Second finding | text, held for the follow-up | fldYHIfBWKuTr1SLL |
| Status | select: requested, generated, sent | fldopd9f3JpWh0Kac |

## State machine

`new → researched → pulse_ready → contacted → replied → demo_booked → proposal → won`
Exits from any state: `lost`, `dormant`. Plus `parked` for operators that pass every gate except Hostaway (see `core/icp.md`).

- `new`: landed from the pipeline or an import, gates not yet checked.
- `researched`: gates filled, ICP fit set, Owner assigned.
- `pulse_ready`: a Pulses row exists with status generated. Ready for the first message.
- `contacted`: first touch logged. Next action date set for the follow-up.
- `replied`: any reply. Reply summary on the touch.
- `demo_booked`, `proposal`, `won`: self-explanatory. `won` triggers onboarding, outside this base.
- `dormant`: sequence exhausted with no reply. Revisit after 90 days.

## Ownership rule

Assigned at qualification (state `researched`). Alternate by default; override when a founder knows the prospect or the city. One owner per lead, always, so two founders never message the same person.

## The daily queue

"run my session" for founder F returns, in this order:
1. **Follow-ups due:** Owner = F, State in (contacted, replied, demo_booked, proposal), Next action date on or before today. Sorted by Priority then Next action date.
2. **Ready to send:** Owner = F, State = pulse_ready. Sorted by Priority.
3. **To qualify:** Owner = F or empty, State = new, ICP fit empty or Qualified.

Session cap is what the founder can personalise properly, target 5+ quality touches. Implementation note for Claude: filter and sort by field ID, not field name; sorting by name fails validation.

## Verified 4 Sept 2026

Test lead pushed new → contacted (with a pulse and a touch linked) → won, then deleted with its pulse and touch. Rollups and lookup populated correctly. Queue query returned the test lead for seb and nothing for sotirios.
