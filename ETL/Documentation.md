ETL Process Overview
The ETL (Extract, Transform, Load) process for the InventoryDB and InventoryDataWarehouse is composed of four main pipelines that manage data extraction, transformation, and loading operations. These pipelines are essential in moving data from the operational database (InventoryDB) to the data warehouse (InventoryDataWarehouse) for reporting and analysis purposes.

1. Customer Data Pipeline
The Customer_Data_Pipeline is responsible for handling the customer data transfer, consisting of two main processes:

Step 1: Extraction
Extracts customer data from the Customers table in the operational database (InventoryDB) and stores it temporarily in the StagingCustomers table. The extraction only includes records from the last 24 hours to avoid redundant data transfers.

Step 2: Transformation and Loading
The transformation process involves cleaning up the CustomerName by removing any leading or trailing spaces using the trim(CustomerName) function. The cleaned data is then loaded into the DimCustomer table in the data warehouse (InventoryDataWarehouse) for analysis.

2. Product Data Pipeline
The Product_Data_Pipeline is simpler and consists of a single extraction process:

Step 1: Extraction
Data from the Products table in the operational database (InventoryDB) is extracted and loaded into the DimProducts table in the data warehouse. This pipeline does not involve any complex transformations, as it primarily transfers the product data for reporting purposes.
3. Supplier Data Pipeline
The Supplier_Data_Pipeline also follows a similar flow as the product data pipeline:

Step 1: Extraction
Data from the Suppliers table in the operational database is extracted and transferred into the DimSuppliers table in the data warehouse. Like the product data pipeline, no major transformations occur during this process.
4. Fact Sales Data Pipeline
The FactSales_Data_Pipeline is more complex and involves multiple extraction, transformation, and joining steps. It is responsible for building the FactSales table in the data warehouse.

This pipeline is divided into four key processes:

Step 1: Extraction of Orders
Data from the Orders table in the operational database is extracted and loaded into the StagingOrders table.

Step 2: Extraction of Order Line Items
The OrderLine table data is extracted and placed into the StagingOrderLine table, which contains information about each product in every order.

Step 3: Extraction of Sales Data
Sales data is extracted from the Sales table and placed in the StagingSales table. This data represents actual sales transactions.

Step 4: Building the FactSales Table
This process involves joining data from seven tables:

StagingOrders is joined with StagingOrderLine on OrderID.
The result is joined with the DimProducts table on ProductID.
The joined result is further joined with the DimSuppliers table on SupplierID.
It is then joined with StagingSales on ProductID.
The derived column transformation calculates QuantitySold and SaleAmount:
QuantitySold is derived from the Quantity field in StagingOrderLine.
SaleAmount is calculated as QuantitySold * Price from the Products table.
Finally, the table is joined with DimDate based on SaleDate.
The fully constructed data is then mapped to the FactSales table in the data warehouse.

Dimensional Model
The dimensional model is composed of the following tables:

DimCustomer – Contains customer details (ID, name, contact information).
DimProduct – Contains product details (ID, name, supplier, category, price).
DimSupplier – Contains supplier details (ID, name, contact information).
DimDate – Contains date information (key, full date, day, month, year, quarter).
FactSales – Stores sales transaction data with references to customer, product, and supplier dimensions.
Key Transformations
Trim Customer Name: The transformation step in the Customer_Data_Pipeline uses the trim() function to clean customer names by removing unwanted spaces.
Derived Columns in FactSales: The FactSales table uses derived columns to calculate QuantitySold and SaleAmount, ensuring accurate sales records are stored for analysis.
