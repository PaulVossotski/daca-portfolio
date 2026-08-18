--============================================================
--Week 4 · SQL Aggregation — personal practice
--Kristi needs board-level summary numbers: trends, categories, segments.
--Covers GROUP BY + aggregates, WHERE vs HAVING, CTE, window functions.
--============================================================


--------------------------------------------------------------
-- 1. GROUP BY + aggregate functions
--------------------------------------------------------------

--Monthly sales summary: order count, revenue, average order value
SELECT
    DATE_TRUNC('month', sale_date)  AS month,
    COUNT(sale_id)                  AS orders,
    SUM(total_price)                AS revenue,
    ROUND(AVG(total_price), 2)      AS avg_order_value
FROM sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month;


--Sales by product category (joins products), largest categories first
SELECT
    p.category,
    COUNT(DISTINCT p.product_id)    AS products,
    SUM(s.total_price)              AS revenue,
    ROUND(AVG(s.total_price), 2)    AS avg_sale
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;


--Revenue and customer count by loyalty tier
SELECT
    c.loyalty_tier,
    COUNT(DISTINCT c.customer_id)   AS customers,
    SUM(s.total_price)              AS revenue,
    ROUND(AVG(s.total_price), 2)    AS avg_sale
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.loyalty_tier
ORDER BY revenue DESC;


--------------------------------------------------------------
-- 2. WHERE vs HAVING
--    WHERE filters rows BEFORE grouping; HAVING filters groups AFTER
--------------------------------------------------------------

--Categories by average retail price, counting only products over €20,
--and keeping only categories whose average price ends up above €50.
--WHERE removes cheap products first; HAVING then filters on the aggregate
--(the average) — something WHERE cannot do.
SELECT
    category,
    COUNT(*)                     AS products,
    ROUND(AVG(retail_price), 2)  AS avg_price
FROM products
WHERE retail_price > 20        -- row filter, before grouping
GROUP BY category
HAVING AVG(retail_price) > 50  -- group filter, after grouping (on an aggregate)
ORDER BY avg_price DESC;


--------------------------------------------------------------
-- 3. CTE (WITH) — month-over-month revenue change
--------------------------------------------------------------

WITH monthly AS (
    SELECT
        DATE_TRUNC('month', sale_date) AS month,
        SUM(total_price)               AS revenue
    FROM sales
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month)             AS prev_month,
    revenue - LAG(revenue) OVER (ORDER BY month)   AS change
FROM monthly
ORDER BY month;


--------------------------------------------------------------
-- 4. Window function — rank top products within each category
--------------------------------------------------------------

SELECT
    p.category,
    p.product_name,
    SUM(s.total_price) AS revenue,
    RANK() OVER (
        PARTITION BY p.category
        ORDER BY SUM(s.total_price) DESC
    ) AS rank_in_category
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY p.category, p.product_name
ORDER BY p.category, rank_in_category;
