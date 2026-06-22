-- Week 1 · Query 1: Browse the product catalog
-- Question: What product categories does UrbanStyle sell, and how many products in each?

-- All products, newest catalog view
SELECT product_id, product_name, category, retail_price, eco_certified
FROM products
ORDER BY category, retail_price DESC;

-- Count of products per category (single-table GROUP BY)
SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category
ORDER BY product_count DESC;

-- How many products carry the sustainability (eco) certificate?
SELECT eco_certified, COUNT(*) AS products
FROM products
GROUP BY eco_certified;
