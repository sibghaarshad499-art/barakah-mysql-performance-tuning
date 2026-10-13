USE perf_lab;

EXPLAIN ANALYZE
SELECT * FROM orders WHERE customer_id = 4521;

EXPLAIN ANALYZE
SELECT order_id, customer_id, amount, order_date
FROM orders
WHERE region = 'Punjab' AND status = 'DELIVERED'
ORDER BY order_date DESC
LIMIT 100;

EXPLAIN ANALYZE
SELECT customer_id, order_date, amount
FROM orders
WHERE customer_id BETWEEN 1000 AND 1050;