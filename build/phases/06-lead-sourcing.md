# Phase 06 — Lead sourcing (the pipeline)

## Context
Decided by generate-and-attack (26 Aug): the primary pipeline is **Airbnb-first**, because every lead then enters with listings attached (pulse guaranteed generatable) and qualification comes free from the same scrape. Person-first LinkedIn chains do the work before knowing the pulse input exists; manual listing-hunting poisons the golden hour. Apify (paid account: Seb's) provides the actors; Companies House provides UK directors for free.

**The pipeline:** Airbnb city search → group by host profile → filter hosts with 5+ listings (the professional-operator filter) → host/brand name → Google → company website → decision-maker via Companies House + public LinkedIn search → lead lands in Airtable with all identifiers.

## Objective
100 ICP-checked leads in Airtable, each with Airbnb host profile + company + a contact route (LinkedIn preferred; email/Instagram fallback).

## Definition of done
100 leads loaded, each ICP-checked, ≥60% with the full triple-match (Airbnb + company + LinkedIn person). Sourcing method documented in `tools/sourcing.md` so either founder can rerun it.

## Candidate actors (verified to exist 28 Aug 2026 — bake-off in session S6a picks winners on output quality, not marketing copy)
- **Airbnb:** `simpleapi/airbnb-scraper` (location search, host attached, "expand host portfolio" mode); `cirkit/airbnb-host-scraper` (host URL/ID → full profile + every listing, public GraphQL, no login); `automation-lab/airbnb-listing` (40+ field listing detail).
- **LinkedIn (no-cookie only — founders' own accounts are never used for scraping):** `harvestapi/linkedin-profile-search` (search with filters), `harvestapi/linkedin-company-employees` (company → people), `harvestapi/linkedin-profile-scraper` (+email), `supreme_coder/linkedin-profile-scraper`.
- **Google SERP:** `apify/google-search-scraper` (official; brand → website matching, `site:linkedin.com/in` queries).
- **Companies House public data API:** free with registered key, 600 req/5min; company search + officers endpoints for UK director names.
- **Intent signals (secondary):** Indeed actors (`misceres/indeed-scraper` pay-per-result) for operators hiring guest-comms VAs → priority flag on matching leads.

## Rules
- Orchestration v1: actors fired via Apify API from the session (or n8n if quicker); raw results land in `leads/` staging or straight to Airtable inbox views; **the fuzzy matching and judgement calls are Claude's job in-session** — that is what a model beats a script at.
- £0 beyond the existing Apify subscription. Paid enrichment (Apollo/Clay) is a Phase 10 review decision, taken on reply-rate evidence.
- Compliance: public business data, professional B2B context, outreach leads with value and takes no for an answer; delete on request. Nothing creepy, nothing consumer.
- The ruthless test applies to every additional actor: more quality conversations per week, or skip it.

## Decisions to make (S6a)
1. Actor winners per step (bake-off: run 2-3 candidates on one target city, compare output quality and cost).
2. Staging format: straight to Airtable vs a `leads/inbox` CSV pass first. Recommendation: straight to Airtable with `state=new`, Claude qualifies in Phase 07.
3. City order (from Phase 02's list).

## Inputs required
Apify API token available to the session (env/secret, not committed). Companies House API key (free registration — do before the session). Phase 02's city list and ICP.

## Session plan
**S6a (60 min):** actor bake-off on one city; pick winners; write `tools/sourcing.md` with the exact run recipe. 
**S6b (1-2 × 60 min):** run the pipeline across the city list until 100 leads sit in Airtable; log counts per city/channel.

## Feeds into
Phase 07 (qualification works this inventory), Phase 05's mechanism notes (reuse the pulse workflow's Airbnb ingestion where possible).
