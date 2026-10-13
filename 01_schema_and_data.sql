-- ============================================================
-- Barakah TechLabs Internship - MySQL Performance Tuning
-- Task 2: EXPLAIN Command + Task 3: Indexing Strategies (B-Tree)
-- File 01: Schema creation + 1M+ row dataset generation
-- ============================================================

DROP DATABASE IF EXISTS perf_lab;
CREATE DATABASE perf_lab;
USE perf_lab;

-- Customers table
CREATE TABLE customers (
    customer_id   INT PRIMARY KEY AUTO_INCREMENT,
    full_name     VARCHAR(100),
    city          VARCHAR(50),
    signup_date   DATE
) ENGINE=InnoDB;

-- Orders table (no extra indexes on purpose: baseline test)
CREATE TABLE orders (
    order_id      BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id   INT NOT NULL,
    order_date    DATE NOT NULL,
    status        VARCHAR(20) NOT NULL,
    amount        DECIMAL(10,2) NOT NULL,
    region        VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

-- Populate customers (10,000 rows)
DELIMITER $$
CREATE PROCEDURE seed_customers()
BEGIN
    DECLARE i INT DEFAULT 0;
    SET autocommit = 0;
    WHILE i < 10000 DO
        INSERT INTO customers (full_name, city, signup_date)
        VALUES (
            CONCAT('Customer_', i),
            ELT(1 + FLOOR(RAND()*6), 'Lahore','Karachi','Islamabad','Multan','Faisalabad','Peshawar'),
            DATE_ADD('2020-01-01', INTERVAL FLOOR(RAND()*2000) DAY)
        );
        SET i = i + 1;
    END WHILE;
    COMMIT;
    SET autocommit = 1;
END$$
DELIMITER ;

CALL seed_customers();
DROP PROCEDURE seed_customers;

-- Populate orders (1,000,000 rows) in batches of 50,000
DELIMITER $$
CREATE PROCEDURE seed_orders(IN total_rows INT, IN batch_size INT)
BEGIN
    DECLARE inserted INT DEFAULT 0;
    WHILE inserted < total_rows DO
        INSERT INTO orders (customer_id, order_date, status, amount, region)
        SELECT
            1 + FLOOR(RAND()*10000),
            DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND()*900) DAY),
            ELT(1 + FLOOR(RAND()*4), 'PENDING','SHIPPED','DELIVERED','CANCELLED'),
            ROUND(50 + RAND()*9950, 2),
            ELT(1 + FLOOR(RAND()*5), 'Punjab','Sindh','KPK','Balochistan','GB')
        FROM
            (SELECT 1) a
            JOIN (SELECT 1 FROM information_schema.columns LIMIT 1000) b
            JOIN (SELECT 1 FROM information_schema.columns LIMIT 1000) c
        LIMIT batch_size;
        SET inserted = inserted + batch_size;
    END WHILE;
END$$
DELIMITER ;

CALL seed_orders(1000000, 50000);
DROP PROCEDURE seed_orders;

-- Sanity check
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_customers FROM customers;