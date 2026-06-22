-- Week 1 · Query 3: Compare the physical stores
-- Question: How do UrbanStyle's store locations compare on sales volume?

-- Number of transactions and total revenue per store location
SELECT
  store_location,
  COUNT(*)        AS transactions,
  SUM(total_price) AS revenue
FROM sales
WHERE store_location IS NOT NULL   -- ignore online / missing-location rows
GROUP BY store_location
ORDER BY revenue DESC;

-- Just the Tallinn store, most recent transactions
SELECT sale_id, sale_date, total_price, payment_method
FROM sales
WHERE store_location = 'Tallinn'
ORDER BY sale_date DESC
LIMIT 15;
