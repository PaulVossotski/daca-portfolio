--Number of products per category
--Quick overview: what does UrbanStyle actually sell

SELECT
  category,
  COUNT(*) AS product_count
FROM products
GROUP BY category
ORDER BY product_count DESC;
