# Sprint 4 — Order Financials & Invoice Domain Integration

## Sprint Goal
Extend the migration model from Orders into financial document representation (Invoice and Invoice Line), including target schema, extraction, loads, reconciliation, and DQ rules.

## Sprint 4.1 Completed
- Invoice target model designed and documented as the sprint contract:
  - `tgt.invoice`
  - `tgt.invoice_line`
- Deterministic keying strategy defined
- Relationships to Orders established
- DQ readiness planned for Sprint 4.3