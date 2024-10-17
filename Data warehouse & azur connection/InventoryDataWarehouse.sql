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


