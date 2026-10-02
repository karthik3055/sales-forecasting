/* Sales Forecasting with Time Series Analysis */

CREATE DATABASE SalesForecastDB;
USE SalesForecastDB;

CREATE TABLE Customers(
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(50),
    State VARCHAR(50),
    Gender VARCHAR(10)
);

INSERT INTO Customers(CustomerName,City,State,Gender) VALUES
('Amit','Mumbai','Maharashtra','Male'),
('Priya','Pune','Maharashtra','Female'),
('Rahul','Delhi','Delhi','Male'),
('Sneha','Bangalore','Karnataka','Female'),
('Arjun','Chennai','Tamil Nadu','Male');

CREATE TABLE Categories(
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL
);

INSERT INTO Categories(CategoryName) VALUES
('Electronics'),
('Furniture'),
('Clothing'),
('Books');

CREATE TABLE Products(
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    CategoryID INT,
    Price DECIMAL(10,2),
    FOREIGN KEY(CategoryID) REFERENCES Categories(CategoryID)
);

INSERT INTO Products(ProductName,CategoryID,Price) VALUES
('Laptop',1,65000),
('Mobile',1,25000),
('Chair',2,3500),
('Table',2,7000),
('Shirt',3,1200),
('Novel',4,550);

CREATE TABLE Sales(
    SaleID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY(ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Sales(CustomerID,ProductID,Quantity,SaleDate,TotalAmount) VALUES
(1,1,1,'2025-01-10',65000),
(2,2,2,'2025-01-15',50000),
(3,3,3,'2025-02-08',10500),
(4,5,5,'2025-02-20',6000),
(5,6,4,'2025-03-11',2200),
(1,2,1,'2025-03-22',25000),
(2,1,1,'2025-04-05',65000),
(3,4,2,'2025-04-16',14000),
(4,5,3,'2025-05-09',3600),
(5,3,2,'2025-06-12',7000);

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Sales;

SELECT CustomerName,City FROM Customers;
SELECT ProductName,Price FROM Products;

SELECT * FROM Customers WHERE City='Mumbai';
SELECT * FROM Products WHERE Price>10000;

SELECT * FROM Customers
WHERE State='Maharashtra' AND Gender='Female';

SELECT * FROM Customers
WHERE City='Mumbai' OR City='Delhi';

SELECT * FROM Customers
WHERE CustomerName LIKE 'A%';

SELECT * FROM Customers
WHERE City IN('Mumbai','Pune','Delhi');

SELECT * FROM Products
WHERE Price BETWEEN 1000 AND 30000;

SELECT * FROM Products ORDER BY Price ASC;
SELECT * FROM Products ORDER BY Price DESC;

SELECT DISTINCT City FROM Customers;

SELECT CustomerName AS Name,City AS Location
FROM Customers;

SELECT COUNT(*) AS TotalCustomers FROM Customers;

SELECT SUM(TotalAmount) AS TotalRevenue
FROM Sales;

SELECT AVG(TotalAmount) AS AverageSale
FROM Sales;

SELECT MAX(TotalAmount) AS HighestSale
FROM Sales;

SELECT MIN(TotalAmount) AS LowestSale
FROM Sales;

SELECT SUM(Quantity) AS TotalQuantitySold
FROM Sales;

SELECT CustomerID,SUM(TotalAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID;

SELECT ProductID,SUM(Quantity) AS QuantitySold
FROM Sales
GROUP BY ProductID;

SELECT MONTH(SaleDate) AS MonthNo,
SUM(TotalAmount) AS MonthlySales
FROM Sales
GROUP BY MONTH(SaleDate);

SELECT CustomerID,SUM(TotalAmount) AS TotalSales
FROM Sales
GROUP BY CustomerID
HAVING SUM(TotalAmount)>50000;

SELECT s.SaleID,c.CustomerName,
p.ProductName,s.Quantity,
s.TotalAmount,s.SaleDate
FROM Sales s
INNER JOIN Customers c
ON s.CustomerID=c.CustomerID
INNER JOIN Products p
ON s.ProductID=p.ProductID;

SELECT c.CustomerName,
s.SaleID,s.TotalAmount
FROM Customers c
LEFT JOIN Sales s
ON c.CustomerID=s.CustomerID;

SELECT SaleDate,
SUM(TotalAmount) AS DailySales
FROM Sales
GROUP BY SaleDate
ORDER BY SaleDate;

SELECT YEAR(SaleDate) AS YearNo,
MONTH(SaleDate) AS MonthNo,
SUM(TotalAmount) AS MonthlySales
FROM Sales
GROUP BY YEAR(SaleDate),MONTH(SaleDate)
ORDER BY YearNo,MonthNo;

SELECT YEAR(SaleDate) AS YearNo,
QUARTER(SaleDate) AS QuarterNo,
SUM(TotalAmount) AS QuarterlySales
FROM Sales
GROUP BY YEAR(SaleDate),QUARTER(SaleDate)
ORDER BY YearNo,QuarterNo;

SELECT YEAR(SaleDate) AS YearNo,
SUM(TotalAmount) AS YearlySales
FROM Sales
GROUP BY YEAR(SaleDate);

SELECT SaleDate,
SUM(TotalAmount) OVER(ORDER BY SaleDate) AS CumulativeSales
FROM Sales;

SELECT SaleDate,
AVG(TotalAmount) OVER(
ORDER BY SaleDate
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) AS MovingAverage
FROM Sales;

SELECT ProductName,Price
FROM Products
WHERE Price>(
SELECT AVG(Price)
FROM Products);

SELECT *
FROM Sales
WHERE TotalAmount=(
SELECT MAX(TotalAmount)
FROM Sales);

SELECT *
FROM Products
WHERE ProductID IN(
SELECT ProductID
FROM Sales);

SELECT SaleID,SaleDate,TotalAmount,
ROW_NUMBER() OVER(
ORDER BY TotalAmount DESC
) AS RowNo
FROM Sales;

SELECT SaleDate,TotalAmount,
LAG(TotalAmount) OVER(
ORDER BY SaleDate
) AS PreviousSale
FROM Sales;

SELECT SaleDate,TotalAmount,
SUM(TotalAmount) OVER(
ORDER BY SaleDate
) AS RunningTotal
FROM Sales;

CREATE VIEW CustomerSalesView AS
SELECT c.CustomerID,c.CustomerName,
SUM(s.TotalAmount) AS TotalSales
FROM Customers c
JOIN Sales s
ON c.CustomerID=s.CustomerID
GROUP BY c.CustomerID,c.CustomerName;

SELECT * FROM CustomerSalesView;

CREATE VIEW MonthlySalesView AS
SELECT YEAR(SaleDate) AS YearNo,
MONTH(SaleDate) AS MonthNo,
SUM(TotalAmount) AS MonthlySales
FROM Sales
GROUP BY YEAR(SaleDate),MONTH(SaleDate);

SELECT * FROM MonthlySalesView;

DELIMITER $$

CREATE PROCEDURE GetMonthlySales()
BEGIN
SELECT YEAR(SaleDate) AS YearNo,
MONTH(SaleDate) AS MonthNo,
SUM(TotalAmount) AS Sales
FROM Sales
GROUP BY YEAR(SaleDate),MONTH(SaleDate);
END$$

DELIMITER ;

CALL GetMonthlySales();

CREATE TABLE SalesLog(
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    SaleID INT,
    Message VARCHAR(100),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER trg_AfterSaleInsert
AFTER INSERT ON Sales
FOR EACH ROW
BEGIN
INSERT INTO SalesLog(SaleID,Message)
VALUES(NEW.SaleID,'New Sale Added');
END$$

DELIMITER ;

INSERT INTO Sales(
CustomerID,ProductID,Quantity,SaleDate,TotalAmount)
VALUES(1,2,1,'2025-07-15',25000);

SELECT * FROM SalesLog;

CREATE INDEX idx_sale_date
ON Sales(SaleDate);

SHOW INDEX FROM Sales;

SELECT YearNo,MonthNo,MonthlySales,
AVG(MonthlySales) OVER(
ORDER BY YearNo,MonthNo
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) AS ForecastSales
FROM(
SELECT YEAR(SaleDate) AS YearNo,
MONTH(SaleDate) AS MonthNo,
SUM(TotalAmount) AS MonthlySales
FROM Sales
GROUP BY YEAR(SaleDate),MONTH(SaleDate)
) AS MonthlyData;

SELECT YearNo,MonthNo,MonthlySales,
MonthlySales-
LAG(MonthlySales) OVER(
ORDER BY YearNo,MonthNo
) AS SalesGrowth
FROM(
SELECT YEAR(SaleDate) AS YearNo,
MONTH(SaleDate) AS MonthNo,
SUM(TotalAmount) AS MonthlySales
FROM Sales
GROUP BY YEAR(SaleDate),MONTH(SaleDate)
) AS MonthlyData;