CREATE DATABASE IF NOT EXISTS sales_forecasting;

USE sales_forecasting;

CREATE TABLE IF NOT EXISTS sales (
    sale_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL
);

LOAD DATA LOCAL INFILE 'data/sales_data.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(sale_id, order_date, product_name, category, region, quantity, unit_price);
