--============================================================
--Week 3 · Step 0 — Apply Week 2 cleaning to the ORIGINAL tables
--In Week 2 the issues were analyzed on a test copy; here the fixes
--are applied for real (DELETE / UPDATE) so the JOINs run on clean data.
--============================================================


--Remove duplicate sales, keeping the earliest row per sale_id
--(uses the internal surrogate `id`; sale_id is the business key that repeats)
DELETE FROM sales
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales
    GROUP BY sale_id
);


--Fix impossible future sale dates (clamp them to today)
UPDATE sales
SET sale_date = CURRENT_DATE
WHERE sale_date > CURRENT_DATE;


--Standardize customer city names
--(otherwise GROUP BY city shows 50+ variants instead of ~12)
UPDATE customers
SET city = INITCAP(TRIM(city))
WHERE city IS NOT NULL;


--Verify the results
SELECT COUNT(*) AS sales_rows FROM sales;              
SELECT COUNT(DISTINCT city) AS cities FROM customers;
