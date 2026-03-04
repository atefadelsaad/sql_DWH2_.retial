
DROP TABLE IF EXISTS silver.fac_supplier_item_branch_stock
CREATE TABLE silver.fac_supplier_item_branch_stock(
	supplier_no int  NOT NULL,
	branch int  NOT NULL,
	order_date  date  NOT NULL,
	doctype  int  NOT NULL,
	iteamean  char(13)  NOT NULL,
	stock_total_value decimal(18, 5) NOT NULL,
	total_actual_qty decimal(18, 2) NOT NULL,
	total_free_qty decimal(18, 2) NOT NULL
PRIMARY KEY CLUSTERED 
(
	[supplier_no] ASC,
	[branch] ASC,
	[order_date] DESC,
	[doctype] ASC,
	[iteamean] ASC
))
