# Sprint 4.2 — Migration Pipeline Build & Rehearsal Runs

Project: Enterprise CRM Data Migration to Microsoft Dynamics 365
Sprint: 4.2
Objective: Build and validate repeatable migration pipelines (full + incremental), including load ordering, idempotent upserts, and rehearsal runs with measurable outcomes.

## Context

With mappings and identity strategy finalized in Sprint 4.1, Sprint 4.2 implements the migration mechanics: extraction, transform, load, ordering, and repeatable execution.

## Scope

### In Scope

* Build migration pipelines for:

  * Full loads (initial bulk migration)
  * Incremental loads (delta/CDC via watermark strategy)
* Load sequencing for relationships:

  * Account before Contact/Opportunity, etc.
* Error handling and retry strategy
* Rehearsal runs in non-production environment(s)
* Performance and throughput measurement (records/sec, runtime)

### Out of Scope

* Production cutover execution and go-live (Sprint 4.4)
* Post-migration hypercare monitoring (Sprint 4.4.3)

## Pipeline Design

* Extraction:

  * Source query definitions per entity
  * Watermark field selection (e.g., ModifiedOn/LastUpdated)
* Transform:

  * Apply mapping and normalization rules from Sprint 4.1
  * Deterministic GUID generation
* Load:

  * Idempotent upsert to Dynamics 365
  * Dependency-aware ordering
  * Batch sizing strategy

## Execution Steps Completed

1. Implemented entity pipelines for Account, Contact, Lead, Opportunity.
2. Implemented deterministic GUID generation in load process.
3. Defined and tested ordering constraints and dependency rules.
4. Executed full-load rehearsal and captured baseline runtime.
5. Executed incremental-load rehearsal using watermark approach.
6. Captured errors, categorized root causes, and applied fixes.

## Deliverables

* Migration pipeline definitions (full + incremental)
* Run logs from rehearsal executions
* Load ordering and dependency documentation
* Error handling and retry model documentation

## Evidence Produced

* Rehearsal run results:

  * Start/end timestamps
  * Record counts processed
  * Failures and retry outcomes
* Throughput/runtime notes and tuning decisions

## Risks & Mitigations

* Risk: API throttling / rate limits during load.

  * Mitigation: Batch sizing, backoff/retry, staged execution.
* Risk: Partial loads creating referential gaps.

  * Mitigation: Enforced ordering + post-load referential checks.

## Exit Criteria

* Pipelines execute end-to-end successfully in rehearsal.
* Full + incremental loads are repeatable and idempotent.
* Load ordering validated for core entity relationships.

## Status

- Completed