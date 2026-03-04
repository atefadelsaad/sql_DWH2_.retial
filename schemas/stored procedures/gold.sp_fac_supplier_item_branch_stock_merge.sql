 CREATE OR ALTER PROCEDURE gold.fac_supplier_item_branch_stock_merge
 AS
 BEGIN
      MERGE gold.fac_supplier_item_branch_stock_purchases AS target
	  USING silver.fac_supplier_item_branch_stock AS source
	  ON target.supplier_no = source.supplier_no AND
	     target.branch = source.branch AND
	     target.order_date = source.order_date AND
	     target.doctype = source.doctype AND
	     target.iteamean = source.iteamean 
     WHEN MATCHED AND
	     target.stock_total_value <> source.stock_total_value OR
	     target.total_actual_qty <> source.total_actual_qty OR
	     target.total_free_qty <> source.total_free_qty
     THEN UPDATE SET
	     target.stock_total_value = source.stock_total_value ,
	     target.total_actual_qty = source.total_actual_qty ,
	     target.total_free_qty = source.total_free_qty	  
     WHEN NOT MATCHED BY target
	 THEN
	      INSERT(supplier_no,branch,order_date,doctype,iteamean,stock_total_value,total_actual_qty,total_free_qty,last_update)
		  VALUES(source.supplier_no,source.branch,source.order_date,source.doctype,source.iteamean,source.stock_total_value,source.total_actual_qty,source.total_free_qty,getdate())
     WHEN NOT MATCHED BY source
	 THEN DELETE;
 END
   
 
