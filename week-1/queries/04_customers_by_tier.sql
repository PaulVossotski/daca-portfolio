-- Week 1 · Query 4: Customer loyalty mix
-- Question: How is the customer base split across loyalty tiers?

-- Customers per loyalty tier
SELECT loyalty_tier, COUNT(*) AS customers
FROM customers
GROUP BY loyalty_tier
ORDER BY customers DESC;

-- Gold-tier customers in Tallinn
SELECT first_name, last_name, city, registration_date
FROM customers
WHERE loyalty_tier = 'gold'
  AND city = 'Tallinn'
ORDER BY registration_date;

-- Data-quality peek: how many customers are missing an email?
-- (foreshadows the Week 2 cleaning work)
SELECT COUNT(*) AS missing_email
FROM customers
WHERE email IS NULL OR email = '';
