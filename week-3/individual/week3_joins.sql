--============================================================
--Week 3 · SQL JOINs — Anna's marketing campaign
--Connecting the cleaned tables (sales, customers, products)
--to answer real business questions.
--============================================================


--------------------------------------------------------------
-- 1. INNER JOIN — only matched rows (customers who DID buy)
--------------------------------------------------------------

--Top sales with the customer behind each one
SELECT
    c.first_name,
    c.last_name,
    c.city,
    s.sale_id,
    s.sale_date,
    s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
ORDER BY s.total_price DESC
LIMIT 20;


--Best-selling products by quantity
SELECT
    p.product_name,
    p.category,
    s.quantity,
    s.unit_price
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY s.quantity DESC
LIMIT 15;


--Top products by units sold, with unit profit (retail - cost)
SELECT
    p.product_name,
    SUM(s.quantity)                  AS total_sold,
    (p.retail_price - p.cost_price)  AS unit_profit
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 10;


--Anna Q1 — TOP customers by spend (recent window)
SELECT
    c.first_name,
    c.last_name,
    c.customer_id,
    SUM(s.quantity)      AS total_quantity,
    SUM(s.total_price)   AS total_spent
FROM sales s
INNER JOIN customers c ON c.customer_id = s.customer_id
WHERE s.sale_date >= '2026-05-01'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;


--------------------------------------------------------------
-- 2. LEFT JOIN — keep everything on the left (find the gaps)
--------------------------------------------------------------

--All customers, including those with no sales (NULL where no purchase)
SELECT
    c.first_name,
    c.last_name,
    c.city,
    s.sale_id,
    s.total_price
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
ORDER BY s.total_price DESC NULLS LAST;


--Anna Q2 — LOST customers: registered but never bought anything
SELECT
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.registration_date
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;


--Lost customers grouped by city (where is the wasted potential?)
SELECT
    c.city,
    COUNT(*) AS lost_customers
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY c.city
ORDER BY lost_customers DESC;


--How many customers are actually active (have at least one sale)?
SELECT
    COUNT(DISTINCT c.customer_id) AS active_customers
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id;


--Dead stock: products that have never been sold
SELECT
    p.product_name,
    p.category,
    p.retail_price
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;


--Unsold products grouped by category
SELECT
    p.category,
    COUNT(*) AS unsold_products
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
GROUP BY p.category
ORDER BY unsold_products DESC;


--------------------------------------------------------------
-- 3. THREE-TABLE JOIN — customer + sale + product together
--------------------------------------------------------------

--Anna Q3 — who bought what: the full picture in one view
SELECT
    c.first_name || ' ' || c.last_name  AS customer,
    c.city,
    s.sale_date,
    p.product_name,
    p.category,
    s.quantity,
    s.unit_price,
    s.total_price                       AS line_total
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p  ON s.product_id  = p.product_id
ORDER BY line_total DESC
LIMIT 20;


--Anna Q4 — revenue by city and category (find the best segment)
SELECT
    c.city,
    p.category,
    SUM(s.total_price) AS total_revenue
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p  ON s.product_id  = p.product_id
GROUP BY c.city, p.category
ORDER BY total_revenue DESC;


--Same breakdown, narrowed to the two biggest cities
SELECT
    c.city,
    p.category,
    SUM(s.total_price) AS total_revenue,
    SUM(s.quantity)    AS total_quantity
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p  ON s.product_id  = p.product_id
WHERE c.city IN ('Tallinn', 'Tartu')
GROUP BY c.city, p.category
ORDER BY c.city, total_revenue DESC;
