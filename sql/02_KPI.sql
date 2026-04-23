SELECT 
	SUM(qty) AS total_units,
	COUNT(DISTINCT order_id) AS total_orders,
	SUM(amount) AS total_revenue,
	ROUND(SUM(amount)/NULLIF(COUNT(DISTINCT order_id), 0), 2) AS average_order_value
FROM amazon_sales_clean
WHERE status NOT ILIKE '%cancel%'
	AND qty > 0
	AND amount > 0