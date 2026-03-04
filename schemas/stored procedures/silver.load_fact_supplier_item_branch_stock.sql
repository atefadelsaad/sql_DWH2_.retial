
CREATE OR ALTER PROCEDURE silver.fact_supplier_item_branch_stock_import
AS
DECLARE @from_date  DATE = (SELECT DATEADD(DAY,-365,GETDATE()));
DECLARE @to_date DATE =  (SELECT GETDATE());
BEGIN
    INSERT INTO silver.fac_supplier_item_branch_stock(
		supplier_no ,
		branch ,
		order_date ,
		doctype ,
		iteamean  ,
		stock_total_value ,
		total_actual_qty ,
		total_free_qty 
	
	 )
	SELECT 
		o.sites,
		o.branch,
		CAST(o.orderdate AS DATE) AS orderdate,
		o.doctype,
		oi.itemean,
		SUM(ISNULL(oi.costprice,0) *  oi.actual_qty * (CASE WHEN o.doctype = 2010 THEN 1 ELSE -1 END)) AS total_value,
		SUM(oi.actual_qty * (CASE WHEN o.doctype = 2010 THEN 1 ELSE -1 END)) AS actual_qty,
		SUM(oi.free_qty * (CASE WHEN o.doctype = 2010 THEN 1 ELSE -1 END)) AS free_qty
	FROM bronze.erp_stk_order o
	INNER JOIN
	bronze.erp_stk_order_items	oi
	ON
	o.company=	oi.company	AND
	o.sector =	oi.sector	AND
	o.region =	oi.region	AND
	o.branch = oi.branch	AND
	o.section =oi.section	AND
	o.transtype	=oi.transtype AND
	o.doctype =	oi.doctype	AND
	o.orderno =	oi.orderno	AND
	o.orderdate	=oi.orderdate
	INNER JOIN
	bronze.erp_sys_item	i
	ON
		i.itemean =	oi.itemean
	WHERE
		o.posting =	1 AND
		i.active =	1 AND
		o.doctype	IN(2010,2050) AND 
		o.orderdate BETWEEN @from_date AND @to_date

	GROUP BY
		o.sites,
		o.branch,
		o.orderdate,
		o.doctype,
		oi.itemean

END
