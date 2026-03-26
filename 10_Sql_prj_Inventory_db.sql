-- Inventory Management System

-- DATABASE

CREATE DATABASE Inventory_db;
USE Inventory_db;


-- CREATE TABLE

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);


CREATE TABLE Stock (
    ProductID INT PRIMARY KEY,
    Quantity INT,
    LastUpdated DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    OrderType VARCHAR(20), -- Purchase / Sale
    Quantity INT,
    OrderDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


INSERT INTO Suppliers (SupplierName, Phone, City) VALUES
('ABC Traders','9000000001','Bangalore'),
('XYZ Supplies','9000000002','Mysore'),
('Global Goods','9000000003','Hubli'),
('Prime Traders','9000000004','Udupi'),
('Star Suppliers','9000000005','Belgaum'),
('Elite Traders','9000000006','Tumkur'),
('Metro Supplies','9000000007','Shimoga'),
('Super Traders','9000000008','Davangere'),
('Speed Suppliers','9000000009','Bijapur'),
('Max Traders','9000000010','Mangalore');

INSERT INTO Products (ProductName, Category, Price, SupplierID) VALUES
('Laptop','Electronics',50000,1),
('Mouse','Electronics',500,2),
('Keyboard','Electronics',1000,3),
('Monitor','Electronics',8000,4),
('Printer','Electronics',12000,5),
('Table','Furniture',7000,6),
('Chair','Furniture',3000,7),
('Fan','Appliance',2000,8),
('AC','Appliance',35000,9),
('Fridge','Appliance',25000,10);

INSERT INTO Stock VALUES
(1,50,'2024-01-01'),
(2,100,'2024-01-01'),
(3,80,'2024-01-01'),
(4,40,'2024-01-01'),
(5,30,'2024-01-01'),
(6,20,'2024-01-01'),
(7,60,'2024-01-01'),
(8,70,'2024-01-01'),
(9,15,'2024-01-01'),
(10,25,'2024-01-01');

INSERT INTO Orders (ProductID, OrderType, Quantity, OrderDate) VALUES
(1,'Sale',2,'2024-02-01'),
(2,'Purchase',10,'2024-02-02'),
(3,'Sale',5,'2024-02-03'),
(4,'Purchase',8,'2024-02-04'),
(5,'Sale',3,'2024-02-05'),
(6,'Purchase',6,'2024-02-06'),
(7,'Sale',4,'2024-02-07'),
(8,'Purchase',12,'2024-02-08'),
(9,'Sale',1,'2024-02-09'),
(10,'Purchase',7,'2024-02-10');


-- INDEX

CREATE INDEX idx_product_category ON Products(Category);


-- VIEW

CREATE VIEW StockDetails AS
SELECT p.ProductName, s.Quantity, p.Price
FROM Stock s
JOIN Products p ON s.ProductID = p.ProductID;


-- STORED PROCEDURE

DELIMITER //

CREATE PROCEDURE LowStock()
BEGIN
SELECT * FROM StockDetails
WHERE Quantity < 30;
END //

DELIMITER ;

-- TRIGGER (AUTO STOCK UPDATE)

DELIMITER //

CREATE TRIGGER after_order_insert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NEW.OrderType = 'Purchase' THEN
        UPDATE Stock
        SET Quantity = Quantity + NEW.Quantity,
            LastUpdated = CURDATE()
        WHERE ProductID = NEW.ProductID;
    ELSEIF NEW.OrderType = 'Sale' THEN
        UPDATE Stock
        SET Quantity = Quantity - NEW.Quantity,
            LastUpdated = CURDATE()
        WHERE ProductID = NEW.ProductID;
    END IF;
END //

DELIMITER ;



-- View Stock
SELECT * FROM StockDetails;

-- Low Stock
CALL LowStock();
