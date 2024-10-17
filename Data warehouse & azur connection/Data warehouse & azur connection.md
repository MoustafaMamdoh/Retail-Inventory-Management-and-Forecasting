## Data Warehouse Implementation and Azure Connection

### i. Objectives
- Design and implement a data warehouse for managing inventory and sales data.
- Structure the database using dimension and fact tables to support complex reporting and analysis.
- Establish a connection with Azure for enhanced data management and scalability.

### ii. Database Schema Design

The data warehouse is designed using a star schema, with a fact table storing transactional data (sales) and dimension tables providing context (date, product, customer, supplier). This schema ensures ease of querying for business intelligence and analytics.

#### 1. Entities
- **DimDate**
- **DimProduct**
- **DimCustomer**
- **DimSupplier**
- **FactSales**

#### 2. Attributes

- **DimDate**
  - `DateKey` (Primary Key): Unique identifier for each date entry.
  - `FullDate`: The full calendar date.
  - `Day`: The day of the month.
  - `Month`: The month number.
  - `Year`: The calendar year.
  - `Weekday`: The name of the day.
  - `Quarter`: The quarter of the year.

- **DimProduct**
  - `ProductID` (Primary Key): Unique identifier for each product.
  - `ProductName`: The name of the product.
  - `SupplierID` (Foreign Key): The supplier who provides the product.
  - `Category`: The category to which the product belongs.
  - `Price`: The price of the product.

- **DimCustomer**
  - `CustomerID` (Primary Key): Unique identifier for each customer.
  - `CustomerName`: The name of the customer.
  - `ContactEmail`: Customer’s email address.
  - `ContactPhone`: Customer’s phone number.
  - `Address`: Customer’s delivery address.

- **DimSupplier**
  - `SupplierID` (Primary Key): Unique identifier for each supplier.
  - `SupplierName`: The name of the supplier.
  - `ContactEmail`: Supplier’s email address.
  - `ContactPhone`: Supplier’s phone number.
  - `Address`: Supplier’s location.

- **FactSales**
  - `SaleID` (Primary Key): Unique identifier for each sale.
  - `OrderID`: Identifier for the related order.
  - `ProductID` (Foreign Key): The ID of the product being sold.
  - `CustomerID` (Foreign Key): The ID of the customer.
  - `SupplierID` (Foreign Key): The supplier of the product.
  - `QuantitySold`: The quantity of the product sold.
  - `SaleAmount`: The total sale amount.
  - `SaleDateKey` (Foreign Key): The key to the sale date.

#### 3. Database Relationships

- **Products and Sales**:
  - One-to-Many: Each product can appear in multiple sales records, but each sale is linked to only one product.

- **Customers and Sales**:
  - One-to-Many: A customer can make multiple purchases, but each sale is linked to only one customer.

- **Suppliers and Products**:
  - Many-to-One: Each product is supplied by one supplier, but a supplier can supply many products.

- **Date and Sales**:
  - One-to-Many: Each sales transaction occurs on a specific date, and multiple sales can happen on the same day.

#### 4. Database and data warehouse diagrams :
- **(1)	Database diagram**:

  
![Screenshot 2024-10-17 104409](https://github.com/user-attachments/assets/35e41dc7-b633-4bb7-a912-b3bf18e826fc)

- **(2) Data warehouse diagram**:

  
![Screenshot 2024-10-17 102953](https://github.com/user-attachments/assets/87cea9a4-7993-45ed-be0e-5939df02e3bc)


### iii. SQL Scripts for Creating the Data Warehouse

```sql
CREATE DATABASE InventoryDataWarehouse;

USE InventoryDataWarehouse;

CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,  
    FullDate DATE NOT NULL,
    Day INT NOT NULL,
    Month INT NOT NULL,
    Year INT NOT NULL,
    Weekday NVARCHAR(20),
    Quarter NVARCHAR(5)
);

CREATE TABLE DimProduct (
    ProductID INT PRIMARY KEY,  
    ProductName NVARCHAR(100) NOT NULL,
    SupplierID INT,       
    Category NVARCHAR(50),
    Price DECIMAL(10, 2)
);

CREATE TABLE DimCustomer (
    CustomerID INT PRIMARY KEY,  
    CustomerName NVARCHAR(100) NOT NULL,
    ContactEmail NVARCHAR(100),
    ContactPhone NVARCHAR(20),
    Address NVARCHAR(255)
);

CREATE TABLE DimSupplier (
    SupplierID INT PRIMARY KEY,
    SupplierName NVARCHAR(100) NOT NULL,
    ContactEmail NVARCHAR(100),
    ContactPhone NVARCHAR(20),
    Address NVARCHAR(255)
);

CREATE TABLE FactSales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),  
    OrderID INT,                           
    ProductID INT,                         
    CustomerID INT,                   
    SupplierID INT,                        
    QuantitySold INT CHECK (QuantitySold > 0),  
    SaleAmount DECIMAL(10, 2) NOT NULL,    
    SaleDateKey INT,                       
    
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    FOREIGN KEY (SupplierID) REFERENCES DimSupplier(SupplierID),
    FOREIGN KEY (SaleDateKey) REFERENCES DimDate(DateKey)
);
```
### iv. Azure Connection
To implement the data warehouse and establish a secure connection between SSMS and Azure, the following steps were taken:

#### 1. Creating the Azure Resource Group and SQL Server

- **Login to Azure Portal**:
  - Navigate to Azure Portal.
  - Access the “Create a resource” section.

- **Configure SQL Server**:
  - Server name: `retail-inventory-management-and-forecasting.database.windows.net`
  - Region: `South Africa North`
  - Administrator credentials:
    - Username: `*****`
    - Password: `***********`

- **Create the SQL Database and Data Warehouse**:
  - Database name: `InventoryDB`
  - Data warehouse name: `InventoryDataWarehouse`
  - Server: `retail-inventory-management-and-forecasting`

#### 2. Connection to SQL Server Management Studio (SSMS)

SSMS was used to manage and interact with the Azure SQL Server. The following connection string was used within SSMS:

- **Server**: `retail-inventory-management-and-forecasting.database.windows.net`
- **Authentication**: SQL Server Authentication
- **Username**: `*****`
- **Password**: `***********`

This secure connection enabled full access to the data warehouse for development and query execution.

---

### iv. Tools Used

1. **SQL Server Management Studio (SSMS)**:
   - A powerful tool for managing SQL Server instances and databases, used for executing queries and managing the database schema.

2. **Microsoft Azure**:
   - **Azure SQL Database**: For creating and hosting the SQL server and database in the cloud.
   - **Azure Portal**: To manage Azure resources, configure settings, and monitor services.
   - **Azure Resource Manager**: For organizing and managing resources within the Azure cloud.

---

### v. Deliverables

1. **Data Warehouse Schema**:
   - A well-defined star schema comprising multiple tables:
     - Dimension Tables:
       - `DimDate`
       - `DimProduct`
       - `DimCustomer`
       - `DimSupplier`
     - Fact Table:
       - `FactSales`

2. **SQL Scripts**:
   - Creating the data warehouse with its fact and dimension tables.

3. **Azure SQL Server and Database**:
   - Creation of an Azure SQL Server configured with security settings and firewall rules.
   - Establishment of a database and data warehouse for storing inventory and sales data.

4. **Connection Setup**:
   - Configuration of SSMS to connect to the Azure SQL Server, ensuring secure and efficient database management.
