/*
Project: FoodYum Grocery Sales Data Cleaning & Analysis
Author: Mohammad Darang
Environment: PostgreSQL
Source: DataCamp Data Analyst Associate practical exam
*/

-- TASK 1: Count products with a missing year_added value.
SELECT COUNT(*) AS missing_year
FROM products
WHERE year_added IS NULL;


-- TASK 2: Clean the data in a query without modifying the source table.
WITH cleaned_data AS (
    SELECT
        product_id,
        product_type,
        CASE
            WHEN brand IS NULL OR TRIM(brand) IN ('', '-') THEN 'Unknown'
            ELSE TRIM(brand)
        END AS brand,
        CAST(NULLIF(REGEXP_REPLACE(weight::text, '[^0-9.]', '', 'g'), '') AS numeric) AS clean_weight,
        CAST(NULLIF(REGEXP_REPLACE(price::text, '[^0-9.]', '', 'g'), '') AS numeric) AS clean_price,
        CAST(NULLIF(REGEXP_REPLACE(average_units_sold::text, '[^0-9]', '', 'g'), '') AS integer) AS clean_units,
        CAST(NULLIF(REGEXP_REPLACE(year_added::text, '[^0-9]', '', 'g'), '') AS integer) AS clean_year,
        CASE
            WHEN UPPER(TRIM(stock_location)) IN ('A', 'B', 'C', 'D')
                THEN UPPER(TRIM(stock_location))
            ELSE 'Unknown'
        END AS stock_location
    FROM products
),
medians AS (
    SELECT
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY clean_weight)::numeric AS median_weight,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY clean_price)::numeric AS median_price
    FROM cleaned_data
)
SELECT
    product_id,
    COALESCE(NULLIF(TRIM(product_type), ''), 'Unknown') AS product_type,
    brand,
    ROUND(COALESCE(clean_weight, m.median_weight), 2) AS weight,
    ROUND(COALESCE(clean_price, m.median_price), 2) AS price,
    COALESCE(clean_units, 0) AS average_units_sold,
    COALESCE(clean_year, 2022) AS year_added,
    stock_location
FROM cleaned_data
CROSS JOIN medians AS m;


-- TASK 3: Minimum and maximum price by product type.
SELECT
    product_type,
    MIN(CAST(NULLIF(REGEXP_REPLACE(price::text, '[^0-9.]', '', 'g'), '') AS numeric)) AS min_price,
    MAX(CAST(NULLIF(REGEXP_REPLACE(price::text, '[^0-9.]', '', 'g'), '') AS numeric)) AS max_price
FROM products
GROUP BY product_type
ORDER BY product_type;


-- TASK 4: Meat and dairy products with average monthly sales above 10.
SELECT
    product_id,
    price,
    average_units_sold
FROM products
WHERE product_type IN ('Meat', 'Dairy')
  AND average_units_sold > 10
ORDER BY product_id;
