# Sprint 4.1 — Mapping Finalization & Deterministic Identity Strategy

Project: Enterprise CRM Data Migration to Microsoft Dynamics 365
Sprint: 4.1
Objective: Finalize source-to-target mappings and enforce deterministic identity to support repeatable, idempotent migration into Dynamics 365.

## Context

Sprint 4 begins the production-grade execution phase of the CRM migration program. Sprint 4.1 establishes the contract between source CRM data and Dynamics 365 entities, including identity rules to prevent duplicates and enable safe re-runs.

## Scope

### In Scope

* Final source-to-target mapping for core CRM entities:

  * Account, Contact, Lead, Opportunity
  * Supporting/reference entities as applicable (e.g., Industry, Territory, Owner/Users, Status/State)
* Deterministic identity approach for Dynamics 365 primary keys
* Field-level transformation rules (standardization, normalization, defaults)
* Data constraints and validation rules required for D365 compatibility

### Out of Scope

* Production cutover execution (Sprint 4.4)
* Ongoing hypercare monitoring operations (Sprint 4.4/4.5+)
* Net-new feature development in Dynamics 365

## Approach

* Consolidated mapping workbook/spec into a version-controlled artifact
* Defined deterministic GUID strategy per entity:

  * Stable key inputs (e.g., BusinessEntityID / natural keys / composite keys)
  * Consistent hashing/namespace rules to generate reproducible GUIDs
* Documented required transforms:

  * Datetime normalization (UTC standard)
  * Picklist/state mapping
  * Owner mapping rules
  * Address formatting rules (if applicable)
* Established data quality gates aligned to Dynamics 365 constraints:

  * Required fields, max lengths, datatype compatibility
  * Referential integrity expectations (parent-child relationships)

## Execution Steps Completed

1. Reviewed entity inventory and confirmed authoritative source fields.
2. Completed field-by-field mapping for each target entity.
3. Defined deterministic identity rule set for each entity.
4. Confirmed relationship mapping (Account → Contact, Account → Opportunity, etc.).
5. Documented data quality gates required before load.

## Deliverables

* Mapping specification (version-controlled)
* Deterministic identity specification (entity-by-entity)
* Transformation and data quality rules documentation

## Evidence Produced

* Mapping table snapshots (before/after)
* Sample key derivation examples (inputs → deterministic GUID outputs)
* D365 constraint checklist completion notes

## Risks & Mitigations

* Risk: Duplicate records due to inconsistent identity.

  * Mitigation: Deterministic GUIDs + idempotent upsert approach.
* Risk: Relationship breakage due to missing parents.

  * Mitigation: Load ordering rules + referential checks pre-load.

## Exit Criteria

* All core entity mappings reviewed and signed off.
* Deterministic identity strategy approved.
* Data quality gates defined and testable.

## Status

- Completed