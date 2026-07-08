--============================================================
--Week 2 · SQL Cleaning · Techniques (sales & products)
--Session 1 practice: duplicates, date formatting, type casting,
--price validation, cross-table quality overview
--============================================================


--------------------------------------------------------------
-- 1. DUPLICATES IN SALES
--------------------------------------------------------------

--Find duplicate sale_id values
SELECT
    sale_id,
    COUNT(*) AS copy_count
FROM sales
GROUP BY sale_id
HAVING COUNT(*) > 1
ORDER BY copy_count DESC
LIMIT 10;


--Number each row inside its sale_id group (rn > 1 = duplicate rows)
SELECT
    sale_id,
    customer_id,
    total_price,
    sale_date,
    ROW_NUMBER() OVER (
        PARTITION BY sale_id
        ORDER BY sale_date
    ) AS rn
FROM sales;


--Impact of duplicates on the revenue figure:
--compare total with duplicates vs. total counting each sale once
SELECT
    COUNT(*)                              AS rows_total,
    COUNT(DISTINCT sale_id)               AS unique_sales,
    COUNT(*) - COUNT(DISTINCT sale_id)    AS duplicates,
    SUM(total_price)                      AS revenue_with_duplicates,
    (
        SELECT SUM(total_price)
        FROM (
            SELECT DISTINCT ON (sale_id) total_price
            FROM sales
            ORDER BY sale_id, sale_date
        ) unique_rows
    )                                     AS revenue_without_duplicates
FROM sales;


--Referential check: sales with no linked customer (orphan rows)
SELECT
    sale_id,
    customer_id,
    total_price
FROM sales
WHERE customer_id IS NULL;


--------------------------------------------------------------
-- 2. DATE FORMATTING
--------------------------------------------------------------

--Format sale_date into different human/reporting formats
SELECT
    sale_id,
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY')    AS date_ee,
    TO_CHAR(sale_date, 'Day')           AS weekday,
    TO_CHAR(sale_date, 'YYYY-"Q"Q')     AS quarter,
    EXTRACT(DOW FROM sale_date)         AS weekday_number
FROM sales
ORDER BY sale_date DESC
LIMIT 10;


--Same date in several display formats side by side
SELECT
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY')      AS format_ee,
    TO_CHAR(sale_date, 'YYYY-MM-DD')      AS format_iso,
    TO_CHAR(sale_date, 'DD. Month YYYY')  AS format_long
FROM sales
LIMIT 5;


--------------------------------------------------------------
-- 3. TYPE CASTING (text -> number / date)
--------------------------------------------------------------

--Standard SQL CAST syntax
SELECT CAST('125.50' AS NUMERIC);       -- text -> number
SELECT CAST('2024-01-15' AS DATE);      -- text -> date

--PostgreSQL shorthand (:: operator) — same result
SELECT '125.50'::NUMERIC;
SELECT '2024-01-15'::DATE;


--------------------------------------------------------------
-- 4. PRICE VALIDATION IN PRODUCTS
--------------------------------------------------------------

--Flag suspicious retail prices (NULL, zero, or negative)
SELECT
    product_id,
    product_name,
    retail_price,
    CASE
        WHEN retail_price IS NULL THEN 'NULL'
        WHEN retail_price = 0     THEN 'ZERO (missing?)'
        WHEN retail_price < 0     THEN 'NEGATIVE!'
        ELSE 'OK'
    END AS price_status
FROM products
WHERE retail_price IS NULL OR retail_price <= 0
ORDER BY retail_price;


--------------------------------------------------------------
-- 5. CROSS-TABLE DUPLICATE OVERVIEW
--------------------------------------------------------------

--One glance at duplicate levels across all three core tables
SELECT
    'sales' AS table_name,
    COUNT(*)                              AS rows_total,
    COUNT(DISTINCT sale_id)               AS unique_keys,
    COUNT(*) - COUNT(DISTINCT sale_id)    AS duplicates
FROM sales
UNION ALL
SELECT
    'customers',
    COUNT(*),
    COUNT(DISTINCT email),
    COUNT(*) - COUNT(DISTINCT email)
FROM customers
UNION ALL
SELECT
    'products',
    COUNT(*),
    COUNT(DISTINCT product_id),
    COUNT(*) - COUNT(DISTINCT product_id)
FROM products;
