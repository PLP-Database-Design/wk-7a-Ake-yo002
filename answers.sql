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
-- QUESTION 2: Converting to Second Normal Form (2NF)
-- =============================================
-- Problem: CustomerName depends only on OrderID (partial dependency)
-- Solution: Split into two tables to remove partial dependencies

-- Step 1: Create Orders table
CREATE TABLE Orders_2NF (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Create OrderItems table 
CREATE TABLE OrderItems_2NF (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders_2NF(OrderID)
);

-- Step 3: Populate Orders table 
INSERT INTO Orders_2NF (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName 
FROM NormalizedOrders_1NF;

-- Step 4: Populate OrderItems table (all products with quantities)
-- I am assuming quantity=1 for all items
-- since original table didn't have quantity information
INSERT INTO OrderItems_2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, 1 AS Quantity
FROM NormalizedOrders_1NF;

-- Verification queries
SELECT * FROM Orders_2NF ORDER BY OrderID;
SELECT * FROM OrderItems_2NF ORDER BY OrderID, Product;
