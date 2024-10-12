-- standard reports and analytical queries to derive valuable insights for the Retail Inventory Management and Forecasting system.

use InventoryDB;

-- 1. Total Sales by Month
SELECT
    YEAR(SaleDate) AS SaleYear,
    MONTH(SaleDate) AS SaleMonth,
    SUM(SaleAmount) AS TotalSales
FROM
    Sales
GROUP BY
    YEAR(SaleDate),
    MONTH(SaleDate)
ORDER BY
    SaleYear,
    SaleMonth;

-- 2. Average Order Value Over Time for Month
SELECT
    YEAR(OrderDate) AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    AVG(TotalAmount) AS AverageOrderValue
FROM
    Orders
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;


-- 3. Top 10 Best-Selling Products
SELECT TOP 10
    P.ProductID,
    P.ProductName,
    SUM(S.QuantitySold) AS TotalQuantitySold,
    SUM(S.SaleAmount) AS TotalSalesAmount
FROM
    Sales S
    JOIN Products P ON S.ProductID = P.ProductID
GROUP BY
    P.ProductID,
    P.ProductName
ORDER BY
    TotalQuantitySold DESC;

-- 4. Current Inventory Levels
SELECT
    P.ProductID,
    P.ProductName,
    I.StockQuantity,
    I.ReorderPoint,
    (I.StockQuantity - I.ReorderPoint) AS StockDifference
FROM
    Inventory I
    JOIN Products P ON I.ProductID = P.ProductID
ORDER BY
    StockDifference ASC;

-- 5. Products Below Reorder Point
SELECT
    P.ProductID,
    P.ProductName,
    I.StockQuantity,
    I.ReorderPoint
FROM
    Inventory I
    JOIN Products P ON I.ProductID = P.ProductID
WHERE
    I.StockQuantity <= I.ReorderPoint
ORDER BY
    I.StockQuantity ASC;

-- 6. Recent Orders (Last 30 Days)
SELECT
    O.OrderID,
    O.OrderDate,
    C.CustomerName,
    O.TotalAmount
FROM
    Orders O
    JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE
    O.OrderDate >= DATEADD(DAY, -30, GETDATE())
ORDER BY
    O.OrderDate DESC;


-- 7. Daily Sales Report
SELECT s.SaleDate, p.ProductName, s.QuantitySold, s.SaleAmount
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE s.SaleDate = CAST(GETDATE() AS DATE);


-- 8. Customer Order History
SELECT
    C.CustomerID,
    C.CustomerName,
    O.OrderID,
    O.OrderDate,
    O.TotalAmount
FROM
    Customers C
    JOIN Orders O ON C.CustomerID = O.CustomerID
ORDER BY
    C.CustomerID,
    O.OrderDate DESC;

-- 9. Supplier Product List
SELECT
    S.SupplierID,
    S.SupplierName,
    P.ProductID,
    P.ProductName,
    P.Category,
    P.Price
FROM
    Suppliers S
    JOIN Products P ON S.SupplierID = P.SupplierID
ORDER BY
    S.SupplierName,
    P.ProductName;

-- 10. Top 5 Customers by Total Spend
SELECT TOP 5
    C.CustomerID,
    C.CustomerName,
    SUM(O.TotalAmount) AS TotalSpent
FROM
    Orders O
    JOIN Customers C ON O.CustomerID = C.CustomerID
GROUP BY
    C.CustomerID,
    C.CustomerName
ORDER BY
    TotalSpent DESC;

-- 11. Product Category Performance
SELECT
    P.Category,
    COUNT(DISTINCT P.ProductID) AS NumberOfProducts,
    SUM(S.QuantitySold) AS TotalQuantitySold,
    SUM(S.SaleAmount) AS TotalSalesAmount,
    AVG(P.Price) AS AveragePrice
FROM
    Products P
    JOIN Sales S ON P.ProductID = S.ProductID
GROUP BY
    P.Category
ORDER BY
    TotalSalesAmount DESC;

-- 12. Supplier Performance Metrics (Total Supply and Sales)
SELECT
    S.SupplierID,
    S.SupplierName,
    COUNT(DISTINCT P.ProductID) AS NumberOfProductsSupplied,
    SUM(I.StockQuantity) AS TotalStockSupplied,
    SUM(SA.QuantitySold) AS TotalQuantitySold,
    SUM(SA.SaleAmount) AS TotalSalesFromSupplier
FROM
    Suppliers S
    JOIN Products P ON S.SupplierID = P.SupplierID
    JOIN Inventory I ON P.ProductID = I.ProductID
    JOIN Sales SA ON P.ProductID = SA.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalSalesFromSupplier DESC;

-- 13. how long products have been in stock since the last restock
SELECT p.ProductName, i.StockQuantity, DATEDIFF(DAY, i.LastRestocked, GETDATE()) AS DaysSinceLastRestock
FROM Inventory i
JOIN Products p ON i.ProductID = p.ProductID
ORDER BY DaysSinceLastRestock DESC;

-- 14. Identifies customers who haven't made a purchase in the last 30 days (or any threshold).
SELECT c.CustomerName, MAX(o.OrderDate) AS LastOrderDate,
       DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) AS DaysSinceLastOrder
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerName
HAVING DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) > 30;
