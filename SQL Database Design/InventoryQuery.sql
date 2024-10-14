use InventoryDB;

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    TotalAmount DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Customer_Order FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName NVARCHAR(100) NOT NULL,
    ContactEmail NVARCHAR(100),
    ContactPhone NVARCHAR(20),
    Address NVARCHAR(255),
    CreationDate DATETIME DEFAULT GETDATE(),
    LastUpdated DATETIME DEFAULT GETDATE()
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName NVARCHAR(100) NOT NULL,
    ContactEmail NVARCHAR(100),
    ContactPhone NVARCHAR(20),
    Address NVARCHAR(255),
    CreationDate DATETIME DEFAULT GETDATE(),
    LastUpdated DATETIME DEFAULT GETDATE()
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    SupplierID INT NOT NULL,
    Category NVARCHAR(50),
    Price DECIMAL(10, 2) NOT NULL,
    CreationDate DATETIME DEFAULT GETDATE(),
    LastUpdated DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Supplier_Product FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE OrderLine (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT CHECK (Quantity > 0),
    LineTotal DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (OrderID, ProductID),  -- Composite Key
    CONSTRAINT FK_OrderLine_Order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderLine_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    SaleDate DATETIME NOT NULL,
    QuantitySold INT CHECK (QuantitySold > 0),
    SaleAmount DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Product_Sale FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    StockQuantity INT NOT NULL CHECK (StockQuantity >= 0),
    LastRestocked DATETIME NOT NULL,
    LastChecked DATETIME NOT NULL,
    ReorderPoint INT NOT NULL,     -- min stock level before reordering
    LeadTimeDays INT NOT NULL,     -- number of days to restock the product
    CONSTRAINT FK_Inventory_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


--Inserting


-- Suppliers
INSERT INTO Suppliers (SupplierName, ContactEmail, ContactPhone, Address)
VALUES 
('Oreal', 'contact@loreal.com', '555-3000', 'Oreal Ave Paris France'),
('Estée Lauder', 'info@esteelauder.com', '555-3100', '200 Estée St, New York, USA'),
('Maybelline', 'support@maybelline.com', '555-3200', '300 Maybelline Blvd, New York, USA'),
('MAC Cosmetics', 'service@maccosmetics.com', '555-3300', '400 MAC Rd, Toronto, Canada'),
('Sephora', 'contact@sephora.com', '555-3400', '500 Sephora St, San Francisco, USA'),
('NARS Cosmetics', 'info@nars.com', '555-3500', '600 NARS Ln, New York, USA'),
('Clinique', 'support@clinique.com', '555-3600', '700 Clinique Ave, New York, USA'),
('Urban Decay', 'sales@urbandecay.com', '555-3700', '800 Urban Dr, Los Angeles, USA'),
('Fenty Beauty', 'info@fentybeauty.com', '555-3800', '900 Fenty Blvd, Los Angeles, USA'),
('Charlotte Tilbury', 'service@charlottetilbury.com', '555-3900', '1000 Tilbury Ln, London, UK'),
('Acme Corp', 'contact@acmecorp.com', '555-0101', '123 Acme St, Springfield, IL'),
('Beta LLC', 'info@betallc.com', '555-0202', '456 Beta Rd, Springfield, IL'),
('Gamma Inc', 'support@gammainc.com', '555-0303', '789 Gamma Ave, Springfield, IL'),
('SOUTHERN WINE & SPIRITS NE', 'info@southernwine.com', '555-1100', '100 Wine St, Springfield, IL'),
('JIM BEAM BRANDS COMPANY', 'support@jimbeam.com', '555-1200', '200 Whiskey Ave, Louisville, KY'),
('PERFECTA WINES', 'contact@perfectawines.com', '555-1300', '300 Perfecta Ln, Napa Valley, CA'),
('PERNOD RICARD USA', 'service@pernodricard.com', '555-1400', '400 Spirit Dr, New York, NY');


-- Customers
INSERT INTO Customers (CustomerName, ContactEmail, ContactPhone, Address)
VALUES
('Jane Smith', 'jane.smith@example.com', '555-1002', '202 Second St, Springfield, IL'),
('Alice Johnson', 'alice.johnson@example.com', '555-1003', '303 Third St, Springfield, IL'),
('Emma Johnson', 'emma.johnson@email.com', '555-4100', '123 Maple St, Springfield, IL'),
('Olivia Williams', 'olivia.williams@email.com', '555-4200', '456 Oak Ave, Chicago, IL'),
('Ava Brown', 'ava.brown@email.com', '555-4300', '789 Pine Dr, New York, NY'),
('Isabella Davis', 'isabella.davis@email.com', '555-4400', '321 Cedar Ln, Los Angeles, CA'),
('Sophia Miller', 'sophia.miller@email.com', '555-4500', '654 Birch Blvd, Miami, FL'),
('Mia Wilson', 'mia.wilson@email.com', '555-4600', '987 Willow Rd, San Francisco, CA'),
('Amelia Moore', 'amelia.moore@email.com', '555-4700', '159 Aspen St, Boston, MA'),
('Charlotte Taylor', 'charlotte.taylor@email.com', '555-4800', '753 Redwood Ave, Denver, CO'),
('Harper Anderson', 'harper.anderson@email.com', '555-4900', '246 Elm St, Seattle, WA'),
('Evelyn Thomas', 'evelyn.thomas@email.com', '555-5000', '135 Spruce Dr, Houston, TX');


-- Products
INSERT INTO Products (ProductName, SupplierID, Category, Price)
VALUES 
('Oreal True Match Foundation', 1, 'Foundation', 12.99),
('Estée Lauder Double Wear Foundation', 2, 'Foundation', 42.00),
('Maybelline Fit Me Concealer', 3, 'Concealer', 7.99),
('MAC Studio Fix Powder', 4, 'Powder', 29.00),
('Sephora Collection Lip Stain', 5, 'Lipstick', 14.00),
('NARS Radiant Creamy Concealer', 6, 'Concealer', 30.00),
('Clinique Moisture Surge 72-Hour Hydrator', 7, 'Moisturizer', 39.00),
('Urban Decay All Nighter Setting Spray', 8, 'Setting Spray', 33.00),
('Fenty Beauty Gloss Bomb', 9, 'Lip Gloss', 19.00),
('Charlotte Tilbury Airbrush Flawless Foundation', 10, 'Foundation', 44.00),
('Estée Lauder Pure Color Envy Lipstick', 2, 'Lipstick', 32.00),
('Maybelline Lash Sensational Mascara', 3, 'Mascara', 8.99),
('MAC Prep + Prime Fix+', 4, 'Setting Spray', 30.00),
('Sephora Collection Microsmooth Powder', 5, 'Powder', 22.00),
('NARS Sheer Glow Foundation', 6, 'Foundation', 47.00),
('Clinique Even Better Makeup SPF 15', 7, 'Foundation', 31.00),
('Urban Decay Naked3 Eyeshadow Palette', 8, 'Eyeshadow', 54.00),
('Fenty Beauty Pro Soft Matte Foundation', 9, 'Foundation', 36.00),
('Charlotte Tilbury Pillow Talk Lipstick', 10, 'Lipstick', 34.00),
('Oreal Voluminous Lash Paradise Mascara', 1, 'Mascara', 10.99),
('Estée Lauder Advanced Night Repair Serum', 2, 'Serum', 75.00),
('Maybelline SuperStay Matte Ink', 3, 'Lipstick', 9.49),
('MAC Pro Longwear Concealer', 4, 'Concealer', 26.00),
('Sephora Collection Cream Lip Stain', 5, 'Lipstick', 14.00),
('NARS Velvet Matte Lip Pencil', 6, 'Lipstick', 27.00),
('Clinique Take The Day Off Cleansing Balm', 7, 'Cleanser', 36.00),
('Urban Decay Vice Lipstick', 8, 'Lipstick', 19.00),
('Fenty Beauty Killawatt Freestyle Highlighter', 9, 'Highlighter', 36.00),
('Charlotte Tilbury Magic Cream', 10, 'Moisturizer', 100.00);




-- Orders
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount)
VALUES
(1, '2024-09-28', 120.50),
(2, '2024-09-29', 75.99),
(3, '2024-09-30', 45.25),
(4, '2024-10-01', 89.00),
(5, '2024-10-02', 135.75),
(6, '2024-10-02', 49.99),
(7, '2024-10-03', 60.00),
(8, '2024-10-04', 110.30),
(9, '2024-10-05', 95.80),
(10, '2024-10-06', 150.25);


-- OrderLine
INSERT INTO OrderLine (OrderID, ProductID, Quantity, LineTotal)
VALUES
(1, 1, 2, 27.98),
(1, 4, 1, 30.00),
(2, 2, 1, 32.00),
(2, 3, 3, 26.97),
(3, 5, 1, 22.00),
(4, 6, 1, 47.00),
(5, 7, 2, 62.00),
(6, 8, 1, 54.00),
(7, 9, 1, 36.00),
(8, 10, 2, 68.00);

-- Sales
INSERT INTO Sales (ProductID, SaleDate, QuantitySold, SaleAmount)
VALUES
(1, '2024-09-28', 2, 27.98),
(2, '2024-09-29', 1, 32.00),
(3, '2024-09-29', 3, 26.97),
(4, '2024-09-30', 1, 30.00),
(5, '2024-09-30', 1, 22.00),
(6, '2024-10-01', 1, 47.00),
(7, '2024-10-02', 2, 62.00),
(8, '2024-10-02', 1, 54.00),
(9, '2024-10-03', 1, 36.00),
(10, '2024-10-04', 2, 68.00);


INSERT INTO Sales (ProductID, SaleDate, QuantitySold, SaleAmount)
VALUES
(11,'2024-10-01',2,20000),
(12,'2024-10-01',1,600);



-- Inventory
INSERT INTO Inventory (ProductID, StockQuantity, LastRestocked, LastChecked, ReorderPoint, LeadTimeDays)
VALUES
(1, 50, '2024-09-25', '2024-09-28', 10, 5),
(2, 40, '2024-09-26', '2024-09-29', 8, 6),
(3, 100, '2024-09-24', '2024-09-29', 15, 4),
(4, 25, '2024-09-27', '2024-09-30', 5, 7),
(5, 60, '2024-09-23', '2024-09-30', 12, 3),
(6, 20, '2024-09-28', '2024-10-01', 5, 7),
(7, 80, '2024-09-29', '2024-10-02', 20, 6),
(8, 30, '2024-09-25', '2024-10-02', 10, 5),
(9, 55, '2024-09-24', '2024-10-03', 12, 6),
(10, 45, '2024-09-28', '2024-10-04', 10, 5);



SELECT TOP 3 * FROM Inventory
SELECT TOP 3 * FROM Sales
SELECT TOP 3 * FROM OrderLine
SELECT TOP 3 * FROM Orders

SELECT TOP 3 * FROM Customers
SELECT TOP 3 * FROM Products
SELECT TOP 3 * FROM Suppliers

