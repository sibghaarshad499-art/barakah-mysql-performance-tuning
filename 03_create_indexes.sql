USE perf_lab;

CREATE INDEX idx_orders_customer_id ON orders (customer_id);

CREATE INDEX idx_orders_region_status_date ON orders (region, status, order_date);

CREATE INDEX idx_orders_covering ON orders (customer_id, order_date, amount);

SHOW INDEX FROM orders;