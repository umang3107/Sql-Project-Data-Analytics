-- =========================================================
-- PROJECT: E-Commerce Sales Analysis using PostgreSQL
-- DATASET: Superstore Dataset
-- =========================================================


-- =========================================================
-- 1. VIEW SAMPLE DATA
-- =========================================================

SELECT *
FROM orders
LIMIT 5;


-- =========================================================
-- 2. TOTAL NUMBER OF ORDERS
-- =========================================================

SELECT COUNT(*) AS total_orders
FROM orders;


-- =========================================================
-- 3. TOTAL REVENUE
-- =========================================================

SELECT ROUND(SUM(sales),2) AS total_revenue
FROM orders;


-- =========================================================
-- 4. TOTAL PROFIT
-- =========================================================

SELECT ROUND(SUM(profit),2) AS total_profit
FROM orders;


-- =========================================================
-- 5. UNIQUE PRODUCT CATEGORIES
-- =========================================================

SELECT DISTINCT category
FROM orders;


-- =========================================================
-- 6. TOTAL UNIQUE CUSTOMERS
-- =========================================================

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM orders;


-- =========================================================
-- 7. SALES BY CATEGORY
-- =========================================================

SELECT category,
       ROUND(SUM(sales),2) AS revenue
FROM orders
GROUP BY category
ORDER BY revenue DESC;


-- =========================================================
-- 8. PROFIT BY CATEGORY
-- =========================================================

SELECT category,
       ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY category
ORDER BY total_profit DESC;


-- =========================================================
-- 9. TOP 10 PRODUCTS BY SALES
-- =========================================================

SELECT product_name,
       ROUND(SUM(sales),2) AS revenue
FROM orders
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;


-- =========================================================
-- 10. TOP 10 PRODUCTS BY PROFIT
-- =========================================================

SELECT product_name,
       ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;


-- =========================================================
-- 11. SALES BY REGION
-- =========================================================

SELECT region,
       ROUND(SUM(sales),2) AS total_sales
FROM orders
GROUP BY region
ORDER BY total_sales DESC;


-- =========================================================
-- 12. TOP 10 STATES BY PROFIT
-- =========================================================

SELECT state,
       ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY state
ORDER BY total_profit DESC
LIMIT 10;


-- =========================================================
-- 13. TOP 10 CUSTOMERS BY PURCHASE
-- =========================================================

SELECT customer_name,
       ROUND(SUM(sales),2) AS total_purchase
FROM orders
GROUP BY customer_name
ORDER BY total_purchase DESC
LIMIT 10;


-- =========================================================
-- 14. CUSTOMER SEGMENTATION USING CASE
-- =========================================================

SELECT customer_name,
       ROUND(SUM(sales),2) AS total_purchase,

       CASE
           WHEN SUM(sales) >= 10000 THEN 'Premium'
           WHEN SUM(sales) >= 5000 THEN 'Gold'
           ELSE 'Regular'
       END AS customer_type

FROM orders
GROUP BY customer_name
ORDER BY total_purchase DESC;


-- =========================================================
-- 15. MONTHLY SALES TREND
-- =========================================================

SELECT 
    EXTRACT(MONTH FROM TO_DATE(order_date, 'MM/DD/YYYY')) AS month,
    ROUND(SUM(sales),2) AS monthly_sales
FROM orders
GROUP BY month
ORDER BY month;


-- =========================================================
-- 16. PRODUCT RANKING WITHIN CATEGORY
-- WINDOW FUNCTION
-- =========================================================

SELECT category,
       product_name,
       ROUND(sales,2) AS sales,

       RANK() OVER(
           PARTITION BY category
           ORDER BY sales DESC
       ) AS product_rank

FROM orders;


-- =========================================================
-- 17. RUNNING TOTAL OF SALES
-- WINDOW FUNCTION
-- =========================================================

SELECT order_date,
       sales,

       SUM(sales) OVER(
           ORDER BY TO_DATE(order_date, 'MM/DD/YYYY')
       ) AS running_total

FROM orders;


-- =========================================================
-- 18. REGIONS WITH SALES GREATER THAN AVERAGE
-- CTE EXAMPLE
-- =========================================================

WITH regional_sales AS (

    SELECT region,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY region
)

SELECT *
FROM regional_sales
WHERE total_sales >
(
    SELECT AVG(total_sales)
    FROM regional_sales
);


-- =========================================================
-- 19. PRODUCTS WITH NEGATIVE PROFIT
-- =========================================================

SELECT product_name,
       ROUND(SUM(profit),2) AS total_loss
FROM orders
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_loss;


-- =========================================================
-- 20. AVERAGE DISCOUNT BY CATEGORY
-- =========================================================

SELECT category,
       ROUND(AVG(discount),2) AS avg_discount
FROM orders
GROUP BY category
ORDER BY avg_discount DESC;


-- =========================================================
-- 21. TOP CUSTOMERS IN EACH REGION
-- WINDOW FUNCTION + SUBQUERY
-- =========================================================

SELECT *
FROM (

    SELECT region,
           customer_name,
           ROUND(SUM(sales),2) AS total_sales,

           RANK() OVER(
               PARTITION BY region
               ORDER BY SUM(sales) DESC
           ) AS rank_num

    FROM orders
    GROUP BY region, customer_name

) ranked_customers

WHERE rank_num <= 3;


-- =========================================================
-- 22. AVERAGE ORDER VALUE
-- =========================================================

SELECT ROUND(SUM(sales) / COUNT(DISTINCT order_id),2)
       AS avg_order_value
FROM orders;


-- =========================================================
-- 23. SALES VS PROFIT ANALYSIS
-- =========================================================

SELECT category,
       ROUND(SUM(sales),2) AS total_sales,
       ROUND(SUM(profit),2) AS total_profit
FROM orders
GROUP BY category
ORDER BY total_sales DESC;