# Enterprise CRM Data Migration to Microsoft Dynamics 365

## Overview
This project implements an enterprise-grade CRM data migration from a legacy Microsoft SQL Server
system to Microsoft Dynamics 365 / Dataverse.

The focus of this initiative is data migration engineering, including source analysis, data mapping,
cleansing, transformation, validation, reconciliation, and cutover readiness. The project follows
Agile Scrum delivery and enterprise governance standards.

This repository represents the migration layer of a real-world CRM modernization program and is
designed to mirror how large organizations execute Dynamics 365 migrations.

---

## Business Problem
Legacy CRM data platforms often suffer from inconsistent data quality, fragmented customer views,
and limited auditability. Migrating to Microsoft Dynamics 365 requires more than data movement; it
requires controlled transformation, traceability, and reconciliation to ensure business continuity
and regulatory compliance.

This project addresses these challenges by implementing a structured, auditable, and repeatable
migration framework.

---

## Source Systems
- Microsoft SQL Server 2022
- AdventureWorks2022 (OLTP system of record)
- AdventureWorksDW2022 (validation and reconciliation reference only)

AdventureWorks2022 is treated as the authoritative source for customer and transactional data.
The data warehouse is used exclusively for cross-checks and validation.

---

## Target Platform
- Microsoft Dynamics 365
- Dataverse logical data model

Direct access to a live Dynamics 365 environment is not required for this project. The migration
is engineered against a Dataverse-aligned logical target model implemented locally in SQL Server.
This approach reflects common enterprise practice where migration engineers build, validate, and
rehearse migrations prior to final loads into secured SaaS environments.

---

## Migration Scope

### In Scope
- Accounts
- Contacts
- Addresses
- Sales Orders
- Sales Order Line Items

### Out of Scope
- Product catalog and pricing
- Inventory and fulfillment
- Manufacturing data
- HR and employee data

---

## Delivery Approach
- Agile Scrum with defined sprint goals and acceptance criteria
- SQL-driven extraction, transformation, and load processes
- Batch-controlled, idempotent migration execution
- Built-in data quality validation and reconciliation
- Governance-focused documentation and audit artifacts

---

## Repository Structure
- `docs/` – Migration strategy, governance, and design documentation
- `sql/` – Migration implementation scripts
- `sprint_logs/` – Sprint execution records and acceptance evidence
- `control/` – Batch control and watermark tracking
- `evidence/` – Validation outputs and reconciliation proof

---

## Intended Audience
- Data Migration Engineers
- Data Engineers
- Solution Architects
- CRM and Dynamics 365 stakeholders