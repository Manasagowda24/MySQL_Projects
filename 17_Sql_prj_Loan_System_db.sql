-- LOAN MANAGEMENT DATABASE


-- CREATE DATABASE

CREATE DATABASE Loan_System_db;
USE Loan_System_db;


-- CREATE TABLES

CREATE TABLE Customers(
CustomerID INT PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR(50),
City VARCHAR(50),
Income INT
);

INSERT INTO Customers VALUES
(1,'Asha','Bangalore',50000),
(2,'Rahul','Hyderabad',70000),
(3,'Sneha','Mumbai',40000),
(4,'Arjun','Delhi',80000),
(5,'Divya','Chennai',60000),
(6,'Kiran','Pune',45000),
(7,'Meena','Kolkata',55000),
(8,'Ravi','Noida',90000),
(9,'Pooja','Ahmedabad',30000),
(10,'Nikhil','Surat',75000);


CREATE TABLE Loans(
LoanID INT PRIMARY KEY AUTO_INCREMENT,
CustomerID INT,
LoanAmount INT,
InterestRate DECIMAL(5,2),
LoanDate DATE,
Status VARCHAR(20),
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Loans VALUES
(1,1,200000,10,'2023-01-10','Approved'),
(2,2,500000,12,'2022-06-12','Approved'),
(3,3,150000,9,'2023-03-14','Rejected'),
(4,4,800000,11,'2021-06-20','Approved'),
(5,5,300000,10,'2022-02-11','Approved'),
(6,6,250000,8,'2020-07-07','Closed'),
(7,7,400000,13,'2023-08-09','Approved'),
(8,8,900000,14,'2019-11-25','Approved'),
(9,9,100000,7,'2024-01-01','Rejected'),
(10,10,700000,12,'2018-12-15','Closed');


CREATE TABLE EMI(
EMIID INT PRIMARY KEY AUTO_INCREMENT,
LoanID INT,
MonthlyEMI INT,
DurationMonths INT,
FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

INSERT INTO EMI VALUES
(1,1,5000,60),
(2,2,12000,72),
(3,4,15000,84),
(4,5,7000,48),
(5,6,6000,36),
(6,7,9000,60),
(7,8,20000,96),
(8,10,16000,72);


CREATE TABLE Payments(
PaymentID INT PRIMARY KEY AUTO_INCREMENT,
LoanID INT,
AmountPaid INT,
PaymentDate DATE,
FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);

INSERT INTO Payments VALUES
(1,1,5000,'2024-01-01'),
(2,1,5000,'2024-02-01'),
(3,2,12000,'2024-01-05'),
(4,4,15000,'2024-01-07'),
(5,5,7000,'2024-01-10'),
(6,6,6000,'2024-01-12'),
(7,7,9000,'2024-01-15'),
(8,8,20000,'2024-01-18'),
(9,10,16000,'2024-01-20'),
(10,4,15000,'2024-02-07');

-- INDEX

CREATE INDEX idx_customer_loan ON Loans(CustomerID);


-- VIEW → EMI STATUS

CREATE VIEW EMI_Status AS
SELECT c.Name, l.LoanAmount, e.MonthlyEMI
FROM Customers c
JOIN Loans l ON c.CustomerID=l.CustomerID
JOIN EMI e ON l.LoanID=e.LoanID;


-- STORED PROCEDURE → Total Loan Given

DELIMITER //
CREATE PROCEDURE TotalLoanAmount()
BEGIN
SELECT SUM(LoanAmount) AS TotalLoan FROM Loans WHERE Status='Approved';
END //
DELIMITER ;


-- TRIGGER 1 → Auto Close Loan

DELIMITER //
CREATE TRIGGER close_loan
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
UPDATE Loans
SET Status='Closed'
WHERE LoanID = NEW.LoanID
AND LoanAmount <= (SELECT SUM(AmountPaid) FROM Payments WHERE LoanID=NEW.LoanID);
END //
DELIMITER ;


-- TRIGGER 2 → Prevent Negative Loan

DELIMITER //
CREATE TRIGGER loan_check
BEFORE INSERT ON Loans
FOR EACH ROW
BEGIN
IF NEW.LoanAmount < 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Loan cannot be negative';
END IF;
END //
DELIMITER ;

