--  E-Commerce Database

-- CREATE DATABASE

CREATE DATABASE Ecommerce_db;
USE Ecommerce_db;

-- CREATE TABLES

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    SignupDate DATE
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT,
    Brand VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    OrderStatus VARCHAR(20),
    ShippingAddress VARCHAR(200),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    OrderID INT,
    PaymentDate DATE,
    PaymentMethod VARCHAR(50),
    PaymentStatus VARCHAR(20),
    Amount DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Payment Log for Trigger
CREATE TABLE PaymentLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    PaymentID INT,
    OldStatus VARCHAR(20),
    NewStatus VARCHAR(20),
    ChangedOn DATETIME
);


-- INSERT DATA


INSERT INTO Customers VALUES
(1,'Asha','asha@gmail.com','90001','Bangalore','2023-01-01'),
(2,'Rahul','rahul@gmail.com','90002','Mysore','2023-02-02'),
(3,'Kiran','kiran@gmail.com','90003','Hubli','2023-03-03'),
(4,'Sneha','sneha@gmail.com','90004','Mangalore','2023-04-04'),
(5,'Vijay','vijay@gmail.com','90005','Bangalore','2023-05-05'),
(6,'Divya','divya@gmail.com','90006','Mysore','2023-06-06'),
(7,'Arjun','arjun@gmail.com','90007','Shimoga','2023-07-07'),
(8,'Meena','meena@gmail.com','90008','Hubli','2023-08-08'),
(9,'Ravi','ravi@gmail.com','90009','Bangalore','2023-09-09'),
(10,'Pooja','pooja@gmail.com','90010','Udupi','2023-10-10');

INSERT INTO Products VALUES
(101,'Laptop','Electronics',50000,10,'Dell'),
(102,'Mobile','Electronics',20000,15,'Samsung'),
(103,'Headphones','Accessories',2000,20,'Sony'),
(104,'Shoes','Fashion',3000,25,'Nike'),
(105,'Watch','Fashion',4000,18,'Fossil'),
(106,'Keyboard','Accessories',1500,30,'Logitech'),
(107,'Mouse','Accessories',800,40,'HP'),
(108,'Backpack','Fashion',1200,22,'Wildcraft'),
(109,'Tablet','Electronics',25000,12,'Apple'),
(110,'Charger','Accessories',500,50,'Anker');

INSERT INTO Orders VALUES
(1,1,101,1,'2024-01-01',50000,'Placed','Bangalore'),
(2,2,102,2,'2024-01-02',40000,'Shipped','Mysore'),
(3,3,103,3,'2024-01-03',6000,'Delivered','Hubli'),
(4,4,104,1,'2024-01-04',3000,'Cancelled','Mangalore'),
(5,5,105,2,'2024-01-05',8000,'Delivered','Bangalore'),
(6,6,106,1,'2024-01-06',1500,'Placed','Mysore'),
(7,7,107,2,'2024-01-07',1600,'Shipped','Shimoga'),
(8,8,108,1,'2024-01-08',1200,'Delivered','Hubli'),
(9,9,109,1,'2024-01-09',25000,'Delivered','Bangalore'),
(10,10,110,4,'2024-01-10',2000,'Placed','Udupi');

INSERT INTO Payments VALUES
(1,1,'2024-01-01','UPI','Completed',50000),
(2,2,'2024-01-02','Card','Completed',40000),
(3,3,'2024-01-03','Cash','Completed',6000),
(4,4,'2024-01-04','UPI','Refunded',3000),
(5,5,'2024-01-05','Card','Completed',8000),
(6,6,'2024-01-06','UPI','Pending',1500),
(7,7,'2024-01-07','Card','Completed',1600),
(8,8,'2024-01-08','Cash','Completed',1200),
(9,9,'2024-01-09','UPI','Completed',25000),
(10,10,'2024-01-10','Card','Pending',2000);


-- INDEXES


CREATE INDEX idx_customer ON Customers(Name);
CREATE INDEX idx_product ON Products(ProductName);
CREATE INDEX idx_order ON Orders(CustomerID);


-- VIEW (SALES REPORT)


CREATE VIEW SalesReport AS
SELECT 
    c.Name,
    p.ProductName,
    o.Quantity,
    o.TotalAmount,
    pay.PaymentMethod,
    pay.PaymentStatus
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID
JOIN Payments pay ON o.OrderID = pay.OrderID;


-- STORED PROCEDURE


DELIMITER //

CREATE PROCEDURE GetTopCustomer()
BEGIN
    SELECT 
        c.Name,
        SUM(o.TotalAmount) AS TotalSpent
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.Name
    ORDER BY TotalSpent DESC
    LIMIT 1;
END //

DELIMITER ;


-- TRIGGERS


-- Trigger 1: Auto Calculate Total
DELIMITER //

CREATE TRIGGER trg_order_total
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE price DECIMAL(10,2);
    SELECT Price INTO price FROM Products WHERE ProductID = NEW.ProductID;
    SET NEW.TotalAmount = price * NEW.Quantity;
END //

DELIMITER ;

-- Trigger 2: Log Payment Status Change
DELIMITER //

CREATE TRIGGER trg_payment_log
AFTER UPDATE ON Payments
FOR EACH ROW
BEGIN
    IF OLD.PaymentStatus <> NEW.PaymentStatus THEN
        INSERT INTO PaymentLog(PaymentID, OldStatus, NewStatus, ChangedOn)
        VALUES (OLD.PaymentID, OLD.PaymentStatus, NEW.PaymentStatus, NOW());
    END IF;
END //

DELIMITER ;


SELECT * FROM SalesReport;

CALL GetTopCustomer();

UPDATE Payments
SET PaymentStatus = 'Completed'
WHERE PaymentID = 6;

SELECT * FROM PaymentLog;