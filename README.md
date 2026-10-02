# Sales Forecasting with Time Series Analysis

A MySQL project focused on sales analysis, time-based reporting, and SQL forecasting techniques.

## About

This project uses a relational sales database to analyze customers, products, categories, and sales transactions. It progresses from fundamental SQL queries to joins, aggregations, window functions, database objects, and time series forecasting.

The project is designed to demonstrate practical SQL analysis using a single MySQL workflow.

## What the Project Covers

- Database and table creation
- Customer, category, product, and sales data
- Filtering and sorting
- Pattern matching with `LIKE`
- `IN` and `BETWEEN`
- Aggregations with `COUNT`, `SUM`, `AVG`, `MAX`, and `MIN`
- `GROUP BY` and `HAVING`
- `INNER JOIN` and `LEFT JOIN`
- Daily, monthly, quarterly, and yearly sales analysis
- Cumulative sales
- Moving averages
- Subqueries
- `ROW_NUMBER()`
- `LAG()`
- Running totals
- Views
- Stored procedures
- Triggers
- Indexes
- Three-month moving average forecasting
- Monthly sales growth analysis

## Database

**Database:** `SalesForecastDB`

### Tables

- `Customers`
- `Categories`
- `Products`
- `Sales`
- `SalesLog`

## Project Structure

```text
sales-forecasting/
├── data/
│   └── sales_data.csv
├── sql/
│   ├── schema.sql
│   ├── analysis.sql
│   └── sales_forecasting.sql
└── README.md
```

## SQL Files

### `schema.sql`

Contains the database table definitions.

### `analysis.sql`

Contains focused SQL analysis queries for the sales dataset.

### `sales_forecasting.sql`

Contains the complete SQL workflow, including database setup, sample data, analysis, time series queries, views, stored procedures, triggers, indexes, and forecasting queries.

## Forecasting Approach

The project uses SQL-based time series techniques rather than a separate machine-learning application.

The main forecasting approach is a **three-month moving average**, using recent monthly sales values to calculate the next forecast value.

Monthly sales growth is also calculated to examine changes between consecutive months.

## How to Run

1. Install MySQL.
2. Open MySQL Workbench or another MySQL client.
3. Open `sql/sales_forecasting.sql`.
4. Run the script.
5. Execute the analysis and forecasting queries to inspect the results.

## Project Focus

**SQL · MySQL · Data Analysis · Time Series Analysis · Forecasting · Window Functions**
