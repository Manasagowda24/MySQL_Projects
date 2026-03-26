
-- Payroll Management System


-- DATABASE

CREATE DATABASE Payroll_db;
USE Payroll_db;


-- CREATE TABLE

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    DepartmentID INT,
    JoinDate DATE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);


CREATE TABLE Salary (
    SalaryID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    Basic DECIMAL(10,2),
    HRA DECIMAL(10,2),
    Bonus DECIMAL(10,2),
    Deductions DECIMAL(10,2),
    NetSalary DECIMAL(10,2),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    PresentDays INT,
    AbsentDays INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


INSERT INTO Departments (DepartmentName) VALUES
('HR'),('IT'),('Finance'),('Sales'),('Marketing');

INSERT INTO Employees (Name, DepartmentID, JoinDate) VALUES
('Amit',1,'2022-01-01'),
('Neha',2,'2022-02-01'),
('Rahul',3,'2022-03-01'),
('Sneha',4,'2022-04-01'),
('Arjun',5,'2022-05-01'),
('Pooja',1,'2022-06-01'),
('Ravi',2,'2022-07-01'),
('Meena',3,'2022-08-01'),
('Kiran',4,'2022-09-01'),
('Divya',5,'2022-10-01');

INSERT INTO Salary (EmployeeID, Basic, HRA, Bonus, Deductions, NetSalary) VALUES
(1,30000,5000,2000,1000,0),
(2,35000,6000,3000,1500,0),
(3,40000,7000,2500,1200,0),
(4,32000,5500,2200,1100,0),
(5,45000,8000,3500,1800,0),
(6,28000,4000,1500,900,0),
(7,36000,6200,2700,1400,0),
(8,39000,6800,2600,1300,0),
(9,31000,5200,2100,1000,0),
(10,47000,8500,3700,2000,0);

INSERT INTO Attendance (EmployeeID, PresentDays, AbsentDays) VALUES
(1,26,2),(2,25,3),(3,27,1),(4,24,4),(5,26,2),
(6,23,5),(7,25,3),(8,27,1),(9,26,2),(10,24,4);


-- INDEX

CREATE INDEX idx_department ON Employees(DepartmentID);


-- VIEW (NET SALARY)

CREATE VIEW SalaryDetails AS
SELECT e.Name,
       s.Basic,
       s.HRA,
       s.Bonus,
       s.Deductions,
       (s.Basic + s.HRA + s.Bonus - s.Deductions) AS NetSalary
FROM Salary s
JOIN Employees e ON s.EmployeeID = e.EmployeeID;



DELIMITER //

CREATE PROCEDURE HighSalary()
BEGIN
SELECT * FROM SalaryDetails
WHERE NetSalary > 40000;
END //

DELIMITER ;


-- TRIGGER (AUTO NET SALARY)

DELIMITER //

CREATE TRIGGER before_salary_insert
BEFORE INSERT ON Salary
FOR EACH ROW
BEGIN
    SET NEW.NetSalary = NEW.Basic + NEW.HRA + NEW.Bonus - NEW.Deductions;
END //

DELIMITER ;



-- View Salary Details
SELECT * FROM SalaryDetails;

-- High Salary Employees
CALL HighSalary();

