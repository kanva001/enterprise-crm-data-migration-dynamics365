# Sprint 4.1 — Invoice Target Model Design

## Objective
Define the target schema for Invoice and Invoice Line entities to extend the migration model from Orders into financial documents, aligned to enterprise CRM/ERP patterns and ready for deterministic keying, batch loads, and DQ enforcement.

## Scope
In scope:
- Invoice header (`tgt.invoice`)
- Invoice line (`tgt.invoice_line`)
- Relationships to existing Order tables
- Deterministic key strategy (consistent with Sprint 3)

Out of scope:
- Source views and extraction
- Transform/load scripts
- Reconciliation logic implementation
- DQ rule implementation (planned in Sprint 4.3)

## Target Tables

### 1) `tgt.invoice` (Header)
Purpose: Represents the financial document derived from an order.

Primary key:
- `invoice_id` (uniqueidentifier, deterministic)

Foreign keys:
- `sales_order_id` → `tgt.sales_order.sales_order_id`

Columns (minimum baseline):
- `invoice_id` uniqueidentifier NOT NULL
- `sales_order_id` uniqueidentifier NOT NULL
- `invoice_number` nvarchar(50) NOT NULL
- `invoice_date` date NOT NULL
- `invoice_status` nvarchar(30) NOT NULL
- `currency_code` nvarchar(10) NULL
- `subtotal_amount` decimal(19,4) NOT NULL
- `tax_amount` decimal(19,4) NOT NULL
- `freight_amount` decimal(19,4) NOT NULL
- `total_amount` decimal(19,4) NOT NULL
- `source_system` nvarchar(50) NOT NULL
- `source_primary_key` nvarchar(100) NOT NULL
- `migration_batch_id` int NOT NULL
- `created_utc` datetime2 NOT NULL
- `updated_utc` datetime2 NOT NULL
- `dq_status` nvarchar(20) NOT NULL

Deterministic key strategy:
- `invoice_id = fn_deterministic_guid('invoice', SourceInvoiceKey)`

SourceInvoiceKey selection rule:
- If a true invoice number exists in the source: use invoice number.
- If the source does not provide invoices: use SalesOrderID as the invoice surrogate key for this portfolio implementation.

### 2) `tgt.invoice_line` (Line)
Purpose: Line-level invoice detail aligned to order lines.

Primary key:
- `invoice_line_id` (uniqueidentifier, deterministic)

Foreign keys:
- `invoice_id` → `tgt.invoice.invoice_id`
- `sales_order_line_id` → `tgt.sales_order_line.sales_order_line_id`

Columns (minimum baseline):
- `invoice_line_id` uniqueidentifier NOT NULL
- `invoice_id` uniqueidentifier NOT NULL
- `sales_order_line_id` uniqueidentifier NULL
- `line_number` int NOT NULL
- `product_id` uniqueidentifier NULL
- `quantity` decimal(19,4) NOT NULL
- `unit_price` decimal(19,4) NOT NULL
- `line_amount` decimal(19,4) NOT NULL
- `source_system` nvarchar(50) NOT NULL
- `source_primary_key` nvarchar(100) NOT NULL
- `migration_batch_id` int NOT NULL
- `created_utc` datetime2 NOT NULL
- `updated_utc` datetime2 NOT NULL
- `dq_status` nvarchar(20) NOT NULL

Deterministic key strategy:
- `invoice_line_id = fn_deterministic_guid('invoice_line', SourceInvoiceLineKey)`

SourceInvoiceLineKey selection rule:
- If source invoice line id exists: use it.
- Otherwise: concatenate (InvoiceKey + '-' + LineNumber).

## Relationships
- One Sales Order maps to one Invoice (portfolio assumption; enterprise migration may support many-to-one)
- One Invoice maps to many Invoice Lines
- Each Invoice Line may map to one Sales Order Line (if traceable)

## DQ Readiness (Planned Rules)
Planned DQ rules to be implemented in Sprint 4.3:
- INVOICE_ORDER_REQUIRED
- INVOICE_TOTAL_MATCH
- INVOICE_LINE_SUM_MATCH
- INVOICE_LINE_ORDERLINE_REQUIRED

## Approval
This document is the target model contract for Sprint 4.2 and beyond.