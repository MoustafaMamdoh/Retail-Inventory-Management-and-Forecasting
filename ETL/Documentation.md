# Inventory Data Warehouse ETL Process

This repository contains the ETL process for loading data from an operational database (`InventoryDB`) into a data warehouse (`InventoryDataWarehouse`) for reporting and analysis. The process is implemented using multiple Azure Data Factory pipelines that handle the extraction, transformation, and loading (ETL) of the data.

## Overview

The ETL process consists of **four main pipelines**, each responsible for different aspects of data movement and transformation from `InventoryDB` to `InventoryDataWarehouse`.![image](https://github.com/user-attachments/assets/c80b023c-c0ce-4405-9712-87d057f633e1)


---

### 1. **Customer Data Pipeline**

The `Customer_Data_Pipeline` handles customer data and consists of two main processes:

- **Step 1: Extraction**  
  Extracts customer data from the `Customers` table in `InventoryDB` and loads it into a temporary staging table called `StagingCustomers`. The extraction only includes data from the last 24 hours to avoid redundancy.

- **Step 2: Transformation and Loading**  
  The transformation process trims leading and trailing spaces from `CustomerName` using the `trim(CustomerName)` function. The cleaned data is then loaded into the `DimCustomer` table in `InventoryDataWarehouse` for further analysis.
![image](https://github.com/user-attachments/assets/b0c3a064-b0ec-42ed-948c-cfde2e452912)

---

### 2. **Product Data Pipeline**

The `Product_Data_Pipeline` is responsible for product data extraction:

- **Step 1: Extraction**  
  Extracts data from the `Products` table in `InventoryDB` and loads it into the `DimProducts` table in `InventoryDataWarehouse`. This pipeline focuses solely on data extraction and does not include complex transformations.

---

### 3. **Supplier Data Pipeline**

The `Supplier_Data_Pipeline` follows the same structure as the product data pipeline:

- **Step 1: Extraction**  
  Extracts supplier data from the `Suppliers` table in `InventoryDB` and loads it into the `DimSuppliers` table in `InventoryDataWarehouse`. Like the product data pipeline, this process focuses on extraction without transformations.

---

### 4. **Fact Sales Data Pipeline**

The `FactSales_Data_Pipeline` is the most complex and involves multiple steps to join data and build the `FactSales` table in `InventoryDataWarehouse`. The pipeline consists of the following steps:

- **Step 1: Extract Orders**  
  Extracts order data from the `Orders` table and loads it into the `StagingOrders` table.

- **Step 2: Extract Order Line Items**  
  Extracts line item data from the `OrderLine` table and loads it into the `StagingOrderLine` table.

- **Step 3: Extract Sales Data**  
  Extracts sales data from the `Sales` table and loads it into the `StagingSales` table.

- **Step 4: Build FactSales Table**  
  The final step involves joining data from **seven tables**:
  - `StagingOrders` is joined with `StagingOrderLine` on `OrderID`.
  - The resulting data is joined with `DimProducts` on `ProductID`.
  - This data is then joined with `DimSuppliers` on `SupplierID`.
  - The result is joined with `StagingSales` on `ProductID`.
  - A derived column transformation calculates:
    - `QuantitySold` from the `Quantity` field in `StagingOrderLine`.
    - `SaleAmount` as `QuantitySold * Price` from the `Products` table.
  - The final join is with `DimDate` based on `SaleDate`.
  
  The constructed data is mapped to the `FactSales` table in `InventoryDataWarehouse` for reporting.

---

## Data Warehouse Schema

The data warehouse uses a dimensional model with the following tables:

1. **DimCustomer** – Contains customer details (ID, name, contact information).
2. **DimProduct** – Contains product details (ID, name, supplier, category, price).
3. **DimSupplier** – Contains supplier details (ID, name, contact information).
4. **DimDate** – Contains date information (key, full date, day, month, year, quarter).
5. **FactSales** – Stores sales transaction data, linked to customer, product, supplier, and date dimensions.

---

## Transformations

Key transformations during the ETL process include:

- **Trim Customer Names**  
  The `Customer_Data_Pipeline` removes any leading or trailing spaces from `CustomerName` using the `trim()` function.

- **Derived Columns in FactSales**  
  The `FactSales_Data_Pipeline` uses derived columns to calculate `QuantitySold` and `SaleAmount`. These values are calculated using:
  - `QuantitySold = Quantity` from the `StagingOrderLine` table.
  - `SaleAmount = QuantitySold * Price` from the `Products` table.

---

## Technology Stack

- **Azure Data Factory**: The ETL pipelines are implemented using Azure Data Factory.
- **SQL Server**: The operational database (`InventoryDB`) and data warehouse (`InventoryDataWarehouse`) are hosted on SQL Server.
- **Azure SQL Database**: Data is stored in the Azure SQL Database for reporting and analysis.


