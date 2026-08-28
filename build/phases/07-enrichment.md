# Phase 07 — Enrichment & qualification

## Context
Raw sourced leads become personalisation-ready leads. This is judgement work — exactly what Claude in-session is for — not more scraping. The pain signals that qualify a lead are the same ones the pulse will weaponise: review response gaps, declining ratings, fee complaints, slow-response indicators.

## Objective
The 100 leads qualified against the ICP, enriched with pain signals, and **wave one (the best 25) ranked and owner-assigned**.

## Definition of done
Every lead is ICP yes/no/borderline with a reason; wave one flagged, ranked, split between founders; each wave-one record contains enough specific truth to personalise a first touch without further research.

## Deliverables
- Enrichment pass in Airtable: pain signals field filled from the sourcing data (review gaps, rating trends, portfolio size/quality), missing contact routes chased via Google/Companies House where cheap.
- ICP verdicts + disqualification reasons (feeds ICP tuning — if a disqualifier fires constantly, Phase 02's ICP gets sharpened, locked-core rule applies).
- Wave one: 25 leads, ranked by (pain signal strength × contactability), owner assigned (alternating unless a founder knows the prospect), states moved to `researched`.
- Intent-signal cross-check: any lead matching a VA-hiring signal gets the priority flag and jumps the ranking.

## Decisions to make in this session
1. The ranking heuristic (recommendation above — keep it crude and honest, refine with reply data later).
2. What "enough to personalise" means as a checklist (e.g. host name + one specific finding + city + portfolio size).

## Inputs required
Phase 06's inventory. No new tools.

## Session plan
**S7a (60 min):** qualification sweep — Claude proposes verdicts in batches, founder confirms/overrides; pain signals filled.
**S7b (60 min):** wave one ranked, owners assigned, spot-check five records against the personalisation checklist.
Log, commit, push each session.

## Feeds into
Phase 08 (dry run picks from wave one), Phase 10 (soft launch sends to wave one).
