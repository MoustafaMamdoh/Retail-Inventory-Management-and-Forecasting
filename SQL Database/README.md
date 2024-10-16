# SQL Database Design and Implementation Documentation



<h3> 🧵 Contains Main Three Points: </h3>
<b>
I- Quick Peak on Database<br>
II- SQL Queries for Bussiness Information Questions<br>
III- Filling Database with dump data
</b>

<h2> I- Quick Peak on Database </h2>


``` sql
SELECT TOP 3 * FROM Inventory
```
![alt text](https://github.com/shahdHesham13/Retail-Inventory-Management-and-Forecasting/blob/main/images/inventory.png)
``` sql
SELECT TOP 3 * FROM Customers
```
![alt text](https://github.com/shahdHesham13/Retail-Inventory-Management-and-Forecasting/blob/main/images/customers.png)
``` sql
SELECT TOP 3 * FROM Suppliers
```
![alt text](https://github.com/shahdHesham13/Retail-Inventory-Management-and-Forecasting/blob/main/images/suppliers.png)
``` sql
SELECT TOP 3 * FROM Products
```
![alt text](https://github.com/shahdHesham13/Retail-Inventory-Management-and-Forecasting/blob/main/images/product.png)
``` sql
SELECT TOP 3 * FROM Sales
```
![alt text](https://github.com/shahdHesham13/Retail-Inventory-Management-and-Forecasting/blob/main/images/sales.png)
``` sql
SELECT TOP 3 * FROM Orders
```
![alt text](https://github.com/shahdHesham13/Retail-Inventory-Management-and-Forecasting/blob/main/images/order.png)
``` sql
SELECT TOP 3 * FROM OrderLine
```
![alt text](https://github.com/shahdHesham13/Retail-Inventory-Management-and-Forecasting/blob/main/images/orderline.png)




#

<h2> II- SQL Queries for Bussiness Information Questions </h2>
<h5>Some Standard Essential Reports to monitor the overall health of sales, inventory, orders, and supplier relationships.
<br> These queries can be Executed Regularly to generate up-to-date reports for Management Review.
</h5>

1. This query calculates Monthly Total Sales for each year to help track sales Trends over time.

``` sql
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
```

2. This query monitor changes in customer spending habits by calculating the Average Order Value over time for Month.

``` sql
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
```
 3. This query Identifies popular products by Listing of the 10 most sold products by quantity and total sales.

``` sql
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
```
4. This query display Stock Levels and Reorder points to show how much inventory is above or below the reorder threshold.

``` sql
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

```
5. This query Lists the products with Stock Levels at or below the reorder point to prevent stockouts.

``` sql
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
```
6. This query show the Orders placed in the last 30 days.


``` sql
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
```

7. This query gives a quick view of Sales Performance for the day.

``` sql
SELECT s.SaleDate, p.ProductName, s.QuantitySold, s.SaleAmount
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE s.SaleDate = CAST(GETDATE() AS DATE);
```

8. This query Lists each customer's orders by date to get into the customer purchasing behavior.


``` sql
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
```

9. This query shows What products supplied by each Supplier.

``` sql
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
```

10. This query lists the top 5 most valuable customers based on total spend.


``` sql
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
```

11. This query tells which Product Categories perform best.

``` sql
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
```

12. This query measures Suppliers by the total stock supplied and Sales generated. Evaluates supplier contributions to business.


``` sql
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
```

13. This query shows How long products have been in stock since the last restock.

``` sql
SELECT p.ProductName, i.StockQuantity, DATEDIFF(DAY, i.LastRestocked, GETDATE()) AS DaysSinceLastRestock
FROM Inventory i
JOIN Products p ON i.ProductID = p.ProductID
ORDER BY DaysSinceLastRestock DESC;
```

14. This query Identifies customers who haven't made a purchase in the last 30 days.

``` sql
SELECT c.CustomerName, MAX(o.OrderDate) AS LastOrderDate,
       DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) AS DaysSinceLastOrder
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.CustomerName
HAVING DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) > 30;
```

<h2> III- Filling Database with dump data </h2>

### Data Population Script for Database

The script in ```invData.py``` file generates dummy data to populate three tables: **Suppliers**, **Customers**, and **Products** in the **InventoryManagement** database.
<br>
by using Python Library `Faker`For generating the fake data,
<br>
and `pyodbc` For connecting to the SQL Server database.


### Code Breakdown

1. **Import Libraries**:
   ```python
   import random
   from faker import Faker
   import pyodbc
   ```

2. **Initialize Faker**:
   ```python
   faker = Faker()
   ```

3. **Database Connection**:
   Set up the connection to the SQL Server database.
   ```python
   conn = pyodbc.connect(
       'DRIVER={SQL Server};'
       'SERVER=DESKTOP-MCCKTCD;'
       'DATABASE=InventoryManagment;'
   )
   cursor = conn.cursor()
   ```

4. **Configuration**:
   Define the number of records you want to generate for each table.
   ```python
   num_suppliers = 10
   num_products = 50
   num_customers = 20
   ```

5. **Functions to Populate each Table**:

   - **Populate Suppliers Table**:
     ```python
     def populate_suppliers():
         suppliers_data = []
         for _ in range(num_suppliers):
             suppliers_data.append((
                 faker.company(),
                 faker.email(),
                 faker.phone_number()[:15],
                 faker.address(),
             ))
         
         cursor.executemany("""
             INSERT INTO Suppliers (SupplierName, ContactEmail, ContactPhone, Address) 
             VALUES (?, ?, ?, ?)
         """, suppliers_data)
         conn.commit()
         print("Suppliers data inserted successfully.")
     ```

   - **Populate Customers Table**:
     ```python
     def populate_customers():
         customers_data = []
         for _ in range(num_customers):
             customers_data.append((
                 faker.name(),
                 faker.email(),
                 faker.phone_number()[:15],
                 faker.address(),
             ))
         
         cursor.executemany("""
             INSERT INTO Customers (CustomerName, ContactEmail, ContactPhone, Address) 
             VALUES (?, ?, ?, ?)
         """, customers_data)
         conn.commit()
         print("Customers data inserted successfully.")
     ```

   - **Populate Products Table**:
     ```python
     def populate_products():
         cursor.execute("SELECT SupplierID FROM Suppliers")
         existing_supplier_ids = [row[0] for row in cursor.fetchall()]
         
         products_data = []
         for _ in range(num_products):
             products_data.append((
                 faker.word(),
                 random.choice(existing_supplier_ids),
                 faker.word(),
                 round(random.uniform(5, 100), 2)
             ))
         
         cursor.executemany("""
             INSERT INTO Products (ProductName, SupplierID, Category, Price) 
             VALUES (?, ?, ?, ?)
         """, products_data)
         conn.commit()
         print("Products data inserted successfully.")
     ```

6. **Execute the functions to populate the tables.**:
   ```python
   populate_suppliers()
   populate_customers()
   populate_products()
   ```

7. **Close Connection**:
   Ensure to close the cursor and connection after data insertion.
   ```python
   cursor.close()
   conn.close()
   ```
