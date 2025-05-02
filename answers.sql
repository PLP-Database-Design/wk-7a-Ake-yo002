-- =============================================
-- QUESTION 1: Converting to First Normal Form (1NF)
-- =============================================
-- Problem: Products column contains multiple values (violates atomicity rule of 1NF)
-- Solution: Split into rows with one product per order line

-- Create normalized table structure
CREATE TABLE NormalizedOrders_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(50)  -- Single product per row
);

-- Insert data in 1NF format 
INSERT INTO NormalizedOrders_1NF (OrderID, CustomerName, Product)
VALUES 
    (101, 'John Doe', 'Laptop'),
    (101, 'John Doe', 'Mouse'),
    (102, 'Jane Smith', 'Tablet'),
    (102, 'Jane Smith', 'Keyboard'),
    (102, 'Jane Smith', 'Mouse'),
    (103, 'Emily Clark', 'Phone');

-- Verification query
SELECT * FROM NormalizedOrders_1NF ORDER BY OrderID, Product;


-- =============================================
-- CORRECTED QUESTION 2: Converting to Second Normal Form (2NF)
-- =============================================
-- Problem: CustomerName depends only on OrderID (partial dependency)
-- Solution: Split into two tables to remove partial dependencies

-- Step 1: Create Orders table 
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Create OrderItems table (contains order line items with quantities)
CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 3: Populate Orders table with distinct order headers
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName 
FROM OrderDetails;

-- Step 4: Populate OrderItems table with all products and their quantities
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Verification queries
SELECT * FROM Orders ORDER BY OrderID;
SELECT * FROM OrderItems ORDER BY OrderID, Product;
