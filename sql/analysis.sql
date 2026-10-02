USE sales_forecasting;

-- 1. Total revenue
SELECT
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM sales;

-- 2. Revenue by month
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    ROUND(SUM(quantity * unit_price), 2) AS monthly_revenue
FROM sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;

-- 3. Revenue by product
SELECT
    product_name,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price), 2) AS revenue
FROM sales
GROUP BY product_name
ORDER BY revenue DESC;

-- 4. Revenue by category
SELECT
    category,
    ROUND(SUM(quantity * unit_price), 2) AS revenue
FROM sales
GROUP BY category
ORDER BY revenue DESC;

-- 5. Month-over-month growth
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        SUM(quantity * unit_price) AS revenue
    FROM sales
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY sales_month))
        / NULLIF(LAG(revenue) OVER (ORDER BY sales_month), 0) * 100,
        2
    ) AS mom_growth_percent
FROM monthly_sales
ORDER BY sales_month;

-- 6. Three-month moving average
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        SUM(quantity * unit_price) AS revenue
    FROM sales
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
    sales_month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        AVG(revenue) OVER (
            ORDER BY sales_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS three_month_average
FROM monthly_sales
ORDER BY sales_month;

-- 7. Revenue by region
SELECT
    region,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price), 2) AS revenue
FROM sales
GROUP BY region
ORDER BY revenue DESC;

-- 8. Best-performing months
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    ROUND(SUM(quantity * unit_price), 2) AS revenue
FROM sales
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY revenue DESC
LIMIT 5;
