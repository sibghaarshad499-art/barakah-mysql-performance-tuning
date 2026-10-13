# MySQL Performance Tuning: EXPLAIN & Indexing

**Intern:** Sibgha Arshad
**Program:** Barakah TechLabs Internship (Cloud & Database Architecture)
**Role:** MySQL Performance Tuning Expert
**Tasks completed:** Task 2 (The EXPLAIN Command) and Task 3 (Indexing Strategies, B-Tree)

## Overview
I created a table with 1,000,000 rows (`orders`) in MySQL 8.0 and ran three queries without any index. I used `EXPLAIN` and `EXPLAIN ANALYZE` to see why they were slow. Then I added a single-column, a composite and a covering index, and ran the same queries again to measure the improvement.

## Results

| Query | Before | After | Speed-up |
|---|---|---|---|
| A: `customer_id = 4521` | 1,000,000 rows scanned, ~926 ms | 123 rows scanned, ~0.7 ms | ~1,300x faster |
| B: `region` + `status` + sort | 1,000,000 rows scanned + filesort, ~1,080 ms | 100 rows scanned, no filesort, ~4.2 ms | ~250x faster |
| C: `customer_id` range | 1,000,000 rows scanned, ~908 ms | 5,063 rows scanned, ~2.6 ms | ~350x faster |

| Query | Index type | Index name |
|---|---|---|
| A | Single-column | `idx_orders_customer_id` |
| B | Composite | `idx_orders_region_status_date` |
| C | Covering | `idx_orders_covering` |

## What I learned
- **Full table scan (before):** without an index, MySQL read all 1,000,000 rows even when only a few rows were needed.
- **Single-column index:** MySQL jumps straight to the matching rows instead of reading the whole table.
- **Composite index:** because `order_date` is the last column in the index, rows are already sorted, so the separate sort step (filesort) disappeared.
- **Covering index:** all columns the query needed were inside the index, so MySQL never had to open the table itself.

## Files in this repository
- `01_schema_and_data.sql`: creates the database and 1,000,000 rows
- `02_baseline_explain.sql`: queries before indexing
- `03_create_indexes.sql`: creates the three indexes
- `04_optimized_explain.sql`: same queries after indexing
- `before_*.png` and `After_*.png`: EXPLAIN ANALYZE screenshots before and after indexing

## How to run
1. Open MySQL Workbench and run the SQL files in order (01 to 04).
2. Compare the `EXPLAIN ANALYZE` output of file 02 (before) with file 04 (after).

**Tools:** MySQL 8.0, InnoDB, MySQL Workbench, EXPLAIN / EXPLAIN ANALYZE
