# Sprint 3 Closure Summary

## Sprint Title
Data Quality Framework & BusinessEntity Account Model

---

## Sprint Goal (Met)

Establish a production-grade Data Quality (DQ) framework and resolve referential integrity between Orders and Accounts using a deterministic, enterprise-safe account model.

---

## What Was Delivered (Authoritative)

### Data Quality Framework

- Implemented a dedicated `dq` schema
- Created rule catalog, exception, and exception detail tables
- Enforced rule uniqueness with deduplication and a unique index
- Seeded idempotent DQ rules across Account, Contact, Address, Order, and Order Line domains
- Built a repeatable DQ execution pipeline tied to migration batches

---

### BusinessEntity-Based Account Model

- Identified root cause: zero overlap between `tgt.sales_order.account_id` and `tgt.account.account_id`
- Designed a unified BusinessEntity account source covering Person and Store entities
- Implemented deterministic GUID strategy for account keying using  
  `account_id = fn_deterministic_guid('account', BusinessEntityID)`
- Upserted 20,673 BusinessEntity accounts into the target account model
- Verified full referential integrity restoration:
  - Orders resolved to accounts: 31,465 / 31,465
  - Orphan orders: 0

---

### Governance and Auditability

- Archived deprecated remediation scripts under `sql/_archive`
- Produced a renderer-safe execution runbook (`.txt`) for Sprint 3
- Maintained idempotent, rerunnable scripts suitable for CI/CD pipelines and controlled reruns

---

## Sprint 3 Closure Metrics

- Orders processed: 31,465  
- Accounts loaded: 20,673  
- Order to Account integrity: 100%  
- Orphan Orders: 0  
- DQ Rule Catalog: Stable and Unique  
- DQ Execution: Deterministic  

---

## Risks Closed

- Ambiguous account keying across Person versus Store entities
- Non-deterministic Data Quality rule evaluation
- Referential integrity failures masking downstream data issues

---

## Artifacts Committed

- `sql/dq/*` — Final Data Quality framework
- `sql/transform/275_create_src_business_entity_accounts.sql`
- `sql/load/316_upsert_business_entity_accounts.sql`
- `sql/validation_reconciliation/*`
- Archived legacy scripts under `sql/_archive`

---

## Sprint Status

Sprint 3 is formally closed.
