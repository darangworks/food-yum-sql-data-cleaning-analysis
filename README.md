# FoodYum Grocery Sales Data Cleaning & Analysis

A PostgreSQL SQL project based on the **DataCamp Data Analyst Associate practical exam**. The task is to clean a grocery-product dataset without modifying the original table, then answer questions about missing values, category price ranges, and higher-volume Meat and Dairy products.

## Business context

FoodYum is a US-based grocery store chain. The exercise focuses on preparing product inventory data for reliable analysis and understanding price ranges across product categories.

## Dataset schema

The source table is named `products` and contains:
- `product_id`: unique product identifier
- `product_type`: category (Produce, Meat, Dairy, Bakery, Snacks)
- `brand`: product brand
- `weight`: product weight in grams
- `price`: product price in US dollars
- `average_units_sold`: average monthly units sold
- `year_added`: year the product entered stock
- `stock_location`: warehouse location (A–D)

## Tasks and approach

### Task 1 — Missing year values
Count records where `year_added IS NULL`. The supplied result reports **170** missing values.

### Task 2 — Data cleaning
Build a cleaned result with a CTE instead of updating the source table. The query:
- Replaces missing or placeholder brand values with `Unknown`
- Removes non-numeric characters from numeric text fields before casting
- Calculates overall medians with `PERCENTILE_CONT(0.5)` to fill missing weight and price
- Replaces missing average monthly sales with `0`
- Replaces missing years with `2022`
- Normalizes warehouse codes to uppercase and maps invalid values to `Unknown`
- Handles missing or blank product categories as `Unknown`

### Task 3 — Price range by category
Uses `MIN` and `MAX` grouped by `product_type`. In the supplied result, Meat has the highest maximum price at **$16.98**.

### Task 4 — Meat and Dairy sales filter
Returns `product_id`, `price`, and `average_units_sold` for Meat and Dairy products with average monthly sales greater than 10.

## Repository layout

- `queries/food_yum_analysis.sql` — commented PostgreSQL queries for the four tasks.
- `outputs/task1_missing_year.csv` — Task 1 result.
- `outputs/task2_clean_data.csv` — cleaned product data.
- `outputs/task3_price_ranges.csv` — price range by product category.
- `outputs/task4_meat_dairy_high_sales.csv` — filtered Meat and Dairy products.

The CSVs are exported result snapshots from the local project folder. The extra dataframe index column is retained where present in the original exports. The local folder also contained an alternate `task2 (2).csv`; it is not included because it appears to be a different intermediate version (including lowercase warehouse codes), rather than the standardized result selected for this repository.

## Reproducibility and scope

The SQL is written for PostgreSQL and assumes the source table `products` is available in the database. The CSV files show saved outputs; they do not include the original source dataset or credentials.

## Author

**Mohammad Darang**  
Quantitative Researcher | Crypto Markets | Python & SQL  
[LinkedIn](https://www.linkedin.com/in/mohammad-darang-36b002130)
