--============================================================
--Week 3 · Group Work · Role C — Products (dead stock)
--Goal: find products that have never sold, using LEFT JOIN + IS NULL,
--and size the problem for UrbanStyle's catalog decisions.
--============================================================


--------------------------------------------------------------
-- 1. Unsold products — the full dead-stock list
--------------------------------------------------------------
SELECT
    p.product_name,
    p.category,
    p.subcategory,
    p.retail_price
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
ORDER BY p.retail_price DESC;


--------------------------------------------------------------
-- 2. How many unsold products in total?
--------------------------------------------------------------
SELECT
    COUNT(DISTINCT p.product_id) AS unsold_products
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;


--------------------------------------------------------------
-- 3. Unsold products by category (where is the dead stock?)
--------------------------------------------------------------
SELECT
    p.category,
    COUNT(*) AS unsold_products
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
GROUP BY p.category
ORDER BY unsold_products DESC;


--------------------------------------------------------------
-- 4. Combined retail value tied up in unsold products
--------------------------------------------------------------
SELECT
    COUNT(*)             AS unsold_products,
    SUM(p.retail_price)  AS unsold_retail_value,
    MIN(p.retail_price)  AS cheapest,
    MAX(p.retail_price)  AS most_expensive
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;


--------------------------------------------------------------
-- 5. ADVANCED — unsold products as a share of the whole catalog
--    (subquery: puts the 12 into business context)
--------------------------------------------------------------
SELECT
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(DISTINCT p.product_id)
     FROM products p
     LEFT JOIN sales s ON p.product_id = s.product_id
     WHERE s.sale_id IS NULL) AS unsold_products,
    ROUND(
        (SELECT COUNT(DISTINCT p.product_id)
         FROM products p
         LEFT JOIN sales s ON p.product_id = s.product_id
         WHERE s.sale_id IS NULL) * 100.0
        / (SELECT COUNT(*) FROM products),
        1
    ) AS unsold_pct;
