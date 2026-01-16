# Sprint 4.2 — Invoice Source-to-Target Mapping

## Source System
AdventureWorks2022

## Design Note
AdventureWorks does not provide a standalone Invoice entity. For this portfolio migration, Invoice is represented using Sales Order financials:
- Invoice Header = Sales.SalesOrderHeader
- Invoice Line = Sales.SalesOrderDetail

## Source to Target Mapping

### Invoice Header (tgt.invoice)
- SourceInvoiceKey: Sales.SalesOrderHeader.SalesOrderID (surrogate invoice key)
- invoice_number: CAST(SalesOrderID AS nvarchar(50))
- invoice_date: OrderDate
- invoice_status:
  - If Status = 5 then 'Invoiced'
  - Else 'Open'
- currency_code: NULL (not provided by AdventureWorks)
- subtotal_amount: SubTotal
- tax_amount: TaxAmt
- freight_amount: Freight
- total_amount: TotalDue
- order join key: SalesOrderID

### Invoice Line (tgt.invoice_line)
- SourceInvoiceLineKey: SalesOrderID + '-' + SalesOrderDetailID
- line_number: SalesOrderDetailID
- product reference: ProductID
- quantity: OrderQty
- unit_price: UnitPrice
- line_amount: LineTotal
- invoice join key: SalesOrderID
- order line join key: SalesOrderDetailID (mapped via SalesOrderID + SalesOrderDetailID strategy in target)

## Keys
- invoice_id deterministic key: fn_deterministic_guid('invoice', SalesOrderID)
- invoice_line_id deterministic key: fn_deterministic_guid('invoice_line', SalesOrderID + '-' + SalesOrderDetailID)

## Notes
- Invoice model supports later extension to true invoice sources if introduced.
- Reconciliation rules will validate:
  - invoice.total_amount equals source TotalDue
  - sum(invoice_line.line_amount) equals source SubTotal (tolerance optional)