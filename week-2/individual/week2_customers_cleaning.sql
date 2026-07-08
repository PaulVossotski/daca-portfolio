--============================================================
--Week 2 · SQL Cleaning · Role B — Customer data
--Domain: customers | Data-quality analysis (detection only — no rows modified)
--============================================================


--------------------------------------------------------------
-- 1. DUPLICATE DETECTION
--------------------------------------------------------------

--Find duplicate emails (same email used by more than one row)
SELECT
    email,
    COUNT(*) AS copy_count
FROM customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY copy_count DESC;


--Flag the extra copies: number each row within its email group,
--rows with rn > 1 are the duplicates to remove
SELECT
    customer_id,
    email,
    rn
FROM (
    SELECT
        customer_id,
        email,
        ROW_NUMBER() OVER (
            PARTITION BY email
            ORDER BY customer_id
        ) AS rn
    FROM customers
) AS numbered_customers
WHERE rn > 1
  AND email IS NOT NULL;


--Find duplicate phone numbers
--NOTE: must GROUP BY phone (grouping by the unique customer_id would return nothing)
SELECT
    phone,
    COUNT(*) AS copy_count
FROM customers
WHERE phone IS NOT NULL
GROUP BY phone
HAVING COUNT(*) > 1
ORDER BY copy_count DESC;


--------------------------------------------------------------
-- 2. NULL / MISSING VALUES
--------------------------------------------------------------

--Overview of missing values across key customer columns
SELECT
    COUNT(*)                        AS customers_total,
    COUNT(first_name)               AS first_name_present,
    COUNT(*) - COUNT(first_name)    AS first_name_missing,
    COUNT(email)                    AS email_present,
    COUNT(*) - COUNT(email)         AS email_missing,
    COUNT(phone)                    AS phone_present,
    COUNT(*) - COUNT(phone)         AS phone_missing
FROM customers;


--------------------------------------------------------------
-- 3. CITY FORMAT — STANDARDIZATION CHECK (preview only, no UPDATE)
--------------------------------------------------------------

--See every distinct raw spelling of city (reveals the mess)
SELECT DISTINCT city
FROM customers
ORDER BY city;


--Compare cleaning options side by side (trim spaces, fix casing)
SELECT DISTINCT
    city                     AS original,
    TRIM(city)               AS trimmed,
    UPPER(TRIM(city))        AS uppercased,
    INITCAP(TRIM(city))      AS proper_case
FROM customers
WHERE city IS NOT NULL
ORDER BY city;


--Per raw spelling: how the cleaned version maps back, with customer counts
--(grouped by the ORIGINAL city, so you see every messy variant separately)
SELECT
    city                     AS original,
    TRIM(city)               AS trimmed,
    INITCAP(TRIM(city))      AS cleaned,
    COUNT(*)                 AS customers
FROM customers
GROUP BY city
ORDER BY city;


--Cleaned city statistics: group by the cleaned city, and show
--how many different original spellings collapsed into each one
SELECT
    INITCAP(TRIM(city))     AS cleaned_city,
    COUNT(*)                AS total_customers,
    COUNT(DISTINCT city)    AS original_spellings
FROM customers
GROUP BY INITCAP(TRIM(city))
ORDER BY total_customers DESC;
