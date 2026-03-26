-- Online Food Order System 


-- CREATE DATABASE

CREATE DATABASE FoodOrderSystem_db;
USE FoodOrderSystem_db;

-- CREATE TABLES


CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    City VARCHAR(50),
    SignupDate DATE
);

CREATE TABLE Menu (
    ItemID INT PRIMARY KEY,
    ItemName VARCHAR(50),
    Category VARCHAR(50),
    Price DECIMAL(8,2),
    Availability VARCHAR(20)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ItemID INT,
    Quantity INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    OrderStatus VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ItemID) REFERENCES Menu(ItemID)
);

-- Order Log Table for Trigger
CREATE TABLE OrderLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    OldStatus VARCHAR(20),
    NewStatus VARCHAR(20),
    ChangedOn DATETIME
);

-- INSERT DATA


INSERT INTO Customers VALUES
(1,'Asha','90001','asha@gmail.com','Bangalore','2023-01-01'),
(2,'Rahul','90002','rahul@gmail.com','Mysore','2023-02-02'),
(3,'Kiran','90003','kiran@gmail.com','Hubli','2023-03-03'),
(4,'Sneha','90004','sneha@gmail.com','Mangalore','2023-04-04'),
(5,'Vijay','90005','vijay@gmail.com','Bangalore','2023-05-05'),
(6,'Divya','90006','divya@gmail.com','Mysore','2023-06-06'),
(7,'Arjun','90007','arjun@gmail.com','Shimoga','2023-07-07'),
(8,'Meena','90008','meena@gmail.com','Hubli','2023-08-08'),
(9,'Ravi','90009','ravi@gmail.com','Bangalore','2023-09-09'),
(10,'Pooja','90010','pooja@gmail.com','Udupi','2023-10-10');

INSERT INTO Menu VALUES
(101,'Pizza','Fast Food',250,'Available'),
(102,'Burger','Fast Food',150,'Available'),
(103,'Pasta','Italian',200,'Available'),
(104,'Sandwich','Snacks',120,'Available'),
(105,'Fried Rice','Chinese',180,'Available'),
(106,'Noodles','Chinese',170,'Available'),
(107,'Coffee','Beverage',80,'Available'),
(108,'Tea','Beverage',40,'Available'),
(109,'Ice Cream','Dessert',90,'Available'),
(110,'Juice','Beverage',100,'Available');

INSERT INTO Orders VALUES
(1,1,101,2,'2024-01-01',500,'Placed'),
(2,2,102,1,'2024-01-02',150,'Delivered'),
(3,3,103,3,'2024-01-03',600,'Placed'),
(4,4,104,2,'2024-01-04',240,'Cancelled'),
(5,5,105,1,'2024-01-05',180,'Delivered'),
(6,6,106,2,'2024-01-06',340,'Placed'),
(7,7,107,3,'2024-01-07',240,'Delivered'),
(8,8,108,4,'2024-01-08',160,'Placed'),
(9,9,109,2,'2024-01-09',180,'Delivered'),
(10,10,110,1,'2024-01-10',100,'Placed');


-- INDEXES


CREATE INDEX idx_customer_name ON Customers(Name);
CREATE INDEX idx_menu_item ON Menu(ItemName);
CREATE INDEX idx_order_customer ON Orders(CustomerID);

-- VIEW (TOP ORDERS)


CREATE VIEW OrderSummary AS
SELECT 
    c.Name,
    m.ItemName,
    o.Quantity,
    o.TotalAmount,
    o.OrderStatus
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Menu m ON o.ItemID = m.ItemID;

-- STORED PROCEDURE


DELIMITER //

CREATE PROCEDURE GetTopSpendingCustomer()
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


-- Trigger 1: Auto Calculate Total Amount
DELIMITER //

CREATE TRIGGER trg_calculate_total
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    DECLARE price DECIMAL(8,2);
    SELECT Price INTO price FROM Menu WHERE ItemID = NEW.ItemID;
    SET NEW.TotalAmount = price * NEW.Quantity;
END //

DELIMITER ;

-- Trigger 2: Log Order Status Change
DELIMITER //

CREATE TRIGGER trg_order_status_log
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF OLD.OrderStatus <> NEW.OrderStatus THEN
        INSERT INTO OrderLog(OrderID, OldStatus, NewStatus, ChangedOn)
        VALUES (OLD.OrderID, OLD.OrderStatus, NEW.OrderStatus, NOW());
    END IF;
END //

DELIMITER ;


-- TEST


SELECT * FROM OrderSummary;

CALL GetTopSpendingCustomer();

-- Test Trigger
UPDATE Orders
SET OrderStatus = 'Delivered'
WHERE OrderID = 1;

SELECT * FROM OrderLog;
