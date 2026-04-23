-- =========================================
-- PROJECT: Sales Analytics (Amazon Dataset)
-- FILE: 01_cleaning.sql
-- PURPOSE: Clean raw sales data and create analysis-ready table
-- =========================================
-- =========================================
-- STEP 1: UNDERSTAND RAW DATA
-- =========================================
-- Raw table: amazon_sales_raw
-- Notes:
-- - Columns imported as col1, col2, ..., col23
-- - Data contains text fields, numeric fields stored as text, and inconsistent formatting
-- =========================================
-- STEP 2: CREATE CLEAN TABLE
-- =========================================
-- Goal:
-- - Rename columns
-- - Convert data types
-- - Handle NULLs
-- - Standardize text fields
-- - Prepare for analysis
CREATE TABLE amazon_sales_clean AS
SELECT
-- IDENTIFIERS
TRIM(col2) AS order_id,
-- DATE CLEANING
-- Format: MM-DD-YY → convert to DATE
TO_DATE(col3, 'MM-DD-YY') AS order_date,

-- ORDER DETAILS
TRIM(col4) AS status,
TRIM(col5) AS fulfillment,
TRIM(col6) AS sales_channel,
TRIM(col7) AS ship_service_level,

-- PRODUCT DETAILS
TRIM(col8) AS style,
TRIM(col9) AS sku,
TRIM(col10) AS category,
TRIM(col11) AS size,
TRIM(col12) AS asin,

-- SHIPPING STATUS
TRIM(col13) AS courier_status,

-- NUMERIC CLEANING
-- Convert text → numeric safely
COALESCE(NULLIF(col14, ''), '0')::INT AS qty,
COALESCE(NULLIF(col16, ''), '0')::NUMERIC AS amount,

-- CURRENCY
TRIM(col15) AS currency,

-- LOCATION
TRIM(col17) AS ship_city,
TRIM(col18) AS ship_state,
TRIM(col19) AS ship_postal_code,
TRIM(col20) AS ship_country,

-- PROMOTIONS
TRIM(col21) AS promotion_ids,

-- BOOLEAN CONVERSION
CASE 
    WHEN col22 ILIKE 'true' THEN TRUE
    ELSE FALSE
END AS is_b2b,

-- FULFILLMENT SOURCE
TRIM(col23) AS fulfilled_by
FROM amazon_sales_raw;
-- =========================================
-- STEP 3: VALIDATION CHECKS
-- =========================================
-- Row count check
SELECT COUNT(*) AS total_rows
FROM amazon_sales_clean;
-- Date validation
SELECT
MIN(order_date) AS min_date,
MAX(order_date) AS max_date
FROM amazon_sales_clean;
-- NULL checks
SELECT
COUNT() FILTER (WHERE order_date IS NULL) AS null_dates,
COUNT() FILTER (WHERE qty IS NULL) AS null_qty,
COUNT(*) FILTER (WHERE amount IS NULL) AS null_amount
FROM amazon_sales_clean;
-- Status distribution (to understand business logic)
SELECT
status,
COUNT(*) AS count
FROM amazon_sales_clean
GROUP BY status
ORDER BY count DESC;
-- =========================================
-- STEP 4: NOTES / ASSUMPTIONS
-- =========================================
-- - Blank qty/amount treated as 0
-- - Dates parsed using MM-DD-YY format
-- - Status will be used later to filter valid revenue (exclude cancelled)
-- - TRIM applied to prevent grouping/filtering issues