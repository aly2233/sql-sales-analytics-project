WITH monthly_revenue AS (
	SELECT
		DATE_TRUNC('month', order_date) AS month,
		SUM(amount) AS revenue
	FROM amazon_sales_clean
	WHERE status NOT ILIKE '%cancel%'
		AND qty > 0
		AND amount > 0
	GROUP BY DATE_TRUNC('month', order_date)
)

SELECT
	month,
	revenue,
	LAG(revenue) OVER (ORDER BY month) AS previous_revenue,
	revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_change,
	ROUND(
		100.0 * (revenue - LAG(revenue) OVER (ORDER BY month)) 
		/ NULLIF(LAG(revenue) OVER (ORDER BY month), 0),
		2
	) AS percentage_change,
	LAG(revenue, 2) OVER (ORDER BY month) AS two_months_previous,
	revenue - LAG(revenue, 2) OVER (ORDER BY month) AS two_month_change,
	ROUND(
		100.0 * (revenue - LAG(revenue, 2) OVER (Order by month))
		/ NULLIF(LAG(revenue, 2) OVER (ORDER by month), 0),
		2
	) AS two_month_percentage
FROM monthly_revenue
ORDER BY month;