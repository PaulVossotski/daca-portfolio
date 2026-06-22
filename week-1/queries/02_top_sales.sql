-- Week 1 · Query 2: Highest-value sales
-- Question: What were the largest individual transactions?

-- Top 10 sales by total price
SELECT sale_id, sale_date, total_price, quantity, channel, store_location
FROM sales
ORDER BY total_price DESC
LIMIT 10;

-- Only online sales above 100 EUR, most recent first
SELECT sale_id, sale_date, total_price, channel
FROM sales
WHERE channel = 'online'
  AND total_price > 100
ORDER BY sale_date DESC
LIMIT 20;
