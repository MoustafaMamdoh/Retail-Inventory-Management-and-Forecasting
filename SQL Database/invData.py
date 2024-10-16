import random
from faker import Faker
import pandas as pd
import pyodbc

# Initialize Faker
faker = Faker()

# Connection
conn = pyodbc.connect(
    'DRIVER={SQL Server};'
    'SERVER=DESKTOP-MCCKTCD;'
    'DATABASE=InventoryManagment;'
)
cursor = conn.cursor()

# Number of records to generate
num_suppliers = 10
num_products = 50
num_customers = 20

num_orderlines_per_order = 3  # Number of orderlines per order

# Generate and populate Suppliers table
def populate_suppliers():
    suppliers_data = []
    for _ in range(num_suppliers):
        suppliers_data.append((
            faker.company(),
            faker.email(),
            faker.phone_number()[:15],  # Limit phone number length to 15 characters
            faker.address(),
        ))
    
    cursor.executemany("""
        INSERT INTO Suppliers (SupplierName, ContactEmail, ContactPhone, Address) 
        VALUES (?, ?, ?, ?)
    """, suppliers_data)
    conn.commit()
    print("Suppliers data inserted successfully.")


# Generate and populate Customers table
def populate_customers():
    customers_data = []
    for _ in range(num_customers):
        customers_data.append((
            faker.name(),
            faker.email(),
            faker.phone_number()[:15],  # Limit phone number length to 15 characters
            faker.address(),
        ))
    
    cursor.executemany("""
        INSERT INTO Customers (CustomerName, ContactEmail, ContactPhone, Address) 
        VALUES (?, ?, ?, ?)
    """, customers_data)
    conn.commit()
    print("Customers data inserted successfully.")

# Generate and populate Products table
def populate_products():
    cursor.execute("SELECT SupplierID FROM Suppliers")
    existing_supplier_ids = [row[0] for row in cursor.fetchall()]
    
    products_data = []
    for _ in range(num_products):
        products_data.append((
            faker.word(),
            random.choice(existing_supplier_ids),  # Choose a valid SupplierID
            faker.word(),
            round(random.uniform(5, 100), 2)  # Price between 5 and 100
        ))
    
    cursor.executemany("""
        INSERT INTO Products (ProductName, SupplierID, Category, Price) 
        VALUES (?, ?, ?, ?)
    """, products_data)
    conn.commit()
    print("Products data inserted successfully.")

# Run all data population functions
populate_suppliers()
populate_customers()
populate_products()

# Close the cursor and connection
cursor.close()
conn.close()