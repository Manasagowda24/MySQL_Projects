-- Banking System Database

-- DATABASE

CREATE DATABASE Banking_db;
USE Banking_db;

-- CUSTOMERS

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50)
);


-- ACCOUNTS

CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    AccountType VARCHAR(50),
    Balance DECIMAL(10,2) DEFAULT 0,
    OpenDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);



-- TRANSACTIONS

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT,
    TransactionType VARCHAR(20), 
    Amount DECIMAL(10,2),
    TransactionDate DATE,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- SAMPLE DATA

INSERT INTO Customers (Name, Phone, City) VALUES
('Anita','9000011111','Bangalore'),
('Raj','9000011112','Mysore'),
('Vikram','9000011113','Hubli'),
('Priya','9000011114','Udupi'),
('Suresh','9000011115','Belgaum'),
('Nisha','9000011116','Tumkur'),
('Karthik','9000011117','Shimoga'),
('Deepa','9000011118','Davangere'),
('Manoj','9000011119','Bijapur'),
('Lakshmi','9000011120','Mangalore');

INSERT INTO Accounts (CustomerID, AccountType, Balance, OpenDate) VALUES
(1,'Savings',5000,'2024-01-01'),
(2,'Current',8000,'2024-01-01'),
(3,'Savings',7000,'2024-01-01'),
(4,'Savings',6000,'2024-01-01'),
(5,'Current',9000,'2024-01-01'),
(6,'Savings',4000,'2024-01-01'),
(7,'Savings',7500,'2024-01-01'),
(8,'Current',6500,'2024-01-01'),
(9,'Savings',5500,'2024-01-01'),
(10,'Current',8500,'2024-01-01');

INSERT INTO Transactions (AccountID, TransactionType, Amount, TransactionDate) VALUES
(1,'Deposit',1000,'2024-02-01'),
(2,'Withdraw',500,'2024-02-02'),
(3,'Deposit',700,'2024-02-03'),
(4,'Withdraw',600,'2024-02-04'),
(5,'Deposit',900,'2024-02-05'),
(6,'Withdraw',400,'2024-02-06'),
(7,'Deposit',750,'2024-02-07'),
(8,'Withdraw',650,'2024-02-08'),
(9,'Deposit',550,'2024-02-09'),
(10,'Withdraw',850,'2024-02-10');

-- INDEX

CREATE INDEX idx_transaction_type 
ON Transactions(TransactionType);


-- VIEW (LIVE BALANCE)

CREATE VIEW AccountBalanceView AS
SELECT 
    a.AccountID,
    c.Name,
    a.Balance +
    IFNULL(SUM(CASE 
        WHEN t.TransactionType = 'Deposit' THEN t.Amount
        WHEN t.TransactionType = 'Withdraw' THEN -t.Amount
    END),0) AS CurrentBalance
FROM Accounts a
JOIN Customers c ON a.CustomerID = c.CustomerID
LEFT JOIN Transactions t ON a.AccountID = t.AccountID
GROUP BY a.AccountID;


-- STORED PROCEDURE
DELIMITER //

CREATE PROCEDURE GetAccountBalance(IN acc_id INT)
BEGIN
    SELECT * 
    FROM AccountBalanceView
    WHERE AccountID = acc_id;
END //

DELIMITER ;


-- TRIGGER (AUTO BALANCE UPDATE)

DELIMITER //

CREATE TRIGGER after_transaction_insert
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    IF NEW.TransactionType = 'Deposit' THEN
        UPDATE Accounts
        SET Balance = Balance + NEW.Amount
        WHERE AccountID = NEW.AccountID;
    ELSEIF NEW.TransactionType = 'Withdraw' THEN
        UPDATE Accounts
        SET Balance = Balance - NEW.Amount
        WHERE AccountID = NEW.AccountID;
    END IF;
END //

DELIMITER ;


-- PRACTICE QUERIES


-- Check Single Account Balance
CALL GetAccountBalance(1);

-- View All Account Balances
SELECT * FROM AccountBalanceView;

-- Total Deposits
SELECT AccountID, SUM(Amount) AS TotalDeposits
FROM Transactions
WHERE TransactionType = 'Deposit'
GROUP BY AccountID;
