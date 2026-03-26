-- Employee Database 

-- CREATE DATABASE

CREATE DATABASE EmployeeDB;
USE EmployeeDB;

-- CREATE TABLES


CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50),
    Location VARCHAR(50),
    ManagerName VARCHAR(50)
);

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    HireDate DATE,
    JobRole VARCHAR(50),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY,
    EmpID INT,
    BaseSalary DECIMAL(10,2),
    Bonus DECIMAL(10,2),
    Deduction DECIMAL(10,2),
    NetSalary DECIMAL(10,2),
    SalaryDate DATE,
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

-- Salary Log Table (for trigger)
CREATE TABLE SalaryLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    EmpID INT,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    ChangedOn DATETIME
);


-- INSERT DATA


INSERT INTO Departments VALUES
(1,'HR','Bangalore','Anita'),
(2,'IT','Hyderabad','Ramesh'),
(3,'Finance','Mumbai','Karan'),
(4,'Marketing','Delhi','Neha'),
(5,'Sales','Chennai','Raj'),
(6,'Support','Pune','Divya'),
(7,'Admin','Bangalore','Vijay'),
(8,'R&D','Hyderabad','Arjun'),
(9,'Legal','Mumbai','Sneha'),
(10,'Operations','Delhi','Rahul');

INSERT INTO Employees VALUES
(101,'Asha','Female',25,'asha@gmail.com','90001','Bangalore','2022-01-10','Analyst',1),
(102,'Rahul','Male',28,'rahul@gmail.com','90002','Mysore','2021-02-12','Developer',2),
(103,'Kiran','Male',30,'kiran@gmail.com','90003','Hubli','2020-03-15','Accountant',3),
(104,'Sneha','Female',27,'sneha@gmail.com','90004','Mangalore','2022-04-01','Executive',4),
(105,'Vijay','Male',32,'vijay@gmail.com','90005','Bangalore','2019-05-18','Sales Rep',5),
(106,'Divya','Female',26,'divya@gmail.com','90006','Mysore','2023-06-10','Support Eng',6),
(107,'Arjun','Male',29,'arjun@gmail.com','90007','Shimoga','2021-07-22','Admin',7),
(108,'Meena','Female',24,'meena@gmail.com','90008','Hubli','2022-08-30','Researcher',8),
(109,'Ravi','Male',35,'ravi@gmail.com','90009','Bangalore','2018-09-14','Lawyer',9),
(110,'Pooja','Female',31,'pooja@gmail.com','90010','Udupi','2020-10-05','Manager',10);

INSERT INTO Salaries VALUES
(1,101,30000,2000,1000,31000,'2024-01-01'),
(2,102,40000,3000,1500,41500,'2024-01-01'),
(3,103,35000,2500,1200,36300,'2024-01-01'),
(4,104,32000,1800,900,32900,'2024-01-01'),
(5,105,45000,4000,2000,47000,'2024-01-01'),
(6,106,28000,1500,700,28800,'2024-01-01'),
(7,107,30000,1700,800,30900,'2024-01-01'),
(8,108,33000,2200,1000,34200,'2024-01-01'),
(9,109,50000,5000,2500,52500,'2024-01-01'),
(10,110,60000,6000,3000,63000,'2024-01-01');

-- INDEXES


CREATE INDEX idx_emp_name ON Employees(Name);
CREATE INDEX idx_dept_name ON Departments(DeptName);
CREATE INDEX idx_salary_emp ON Salaries(EmpID);


-- VIEW


CREATE VIEW EmployeeSalaryReport AS
SELECT 
    e.Name,
    d.DeptName,
    e.JobRole,
    s.BaseSalary,
    s.Bonus,
    s.Deduction,
    s.NetSalary
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID
JOIN Salaries s ON e.EmpID = s.EmpID;


-- STORED PROCEDURE


DELIMITER //

CREATE PROCEDURE GetHighestSalary()
BEGIN
    SELECT Name, NetSalary
    FROM Employees e
    JOIN Salaries s ON e.EmpID = s.EmpID
    ORDER BY NetSalary DESC
    LIMIT 1;
END //

DELIMITER ;


-- TRIGGERS


-- Trigger 1: Auto Calculate Net Salary
DELIMITER //

CREATE TRIGGER trg_calculate_salary
BEFORE INSERT ON Salaries
FOR EACH ROW
BEGIN
    SET NEW.NetSalary = NEW.BaseSalary + NEW.Bonus - NEW.Deduction;
END //

DELIMITER ;

-- Trigger 2: Log Salary Updates
DELIMITER //

CREATE TRIGGER trg_salary_update_log
AFTER UPDATE ON Salaries
FOR EACH ROW
BEGIN
    INSERT INTO SalaryLog(EmpID, OldSalary, NewSalary, ChangedOn)
    VALUES (OLD.EmpID, OLD.NetSalary, NEW.NetSalary, NOW());
END //

DELIMITER ;


-- TEST


SELECT * FROM EmployeeSalaryReport;

CALL GetHighestSalary();

-- Test Trigger
UPDATE Salaries
SET Bonus = 5000
WHERE EmpID = 101;

SELECT * FROM SalaryLog;