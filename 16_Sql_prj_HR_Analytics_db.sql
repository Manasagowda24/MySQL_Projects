
--  HR ANALYTICS DATABASE


-- CREATE DATABASE

CREATE DATABASE HR_Analytics_db;
USE HR_Analytics_db;

-- CREATE TABLES

CREATE TABLE Departments(
DeptID INT PRIMARY KEY AUTO_INCREMENT,
DeptName VARCHAR(50),
Location VARCHAR(50)
);

INSERT INTO Departments VALUES
(1,'HR','Bangalore'),
(2,'IT','Hyderabad'),
(3,'Finance','Mumbai'),
(4,'Sales','Delhi'),
(5,'Marketing','Chennai'),
(6,'Support','Pune'),
(7,'Admin','Kolkata'),
(8,'Legal','Noida'),
(9,'R&D','Coimbatore'),
(10,'Operations','Ahmedabad');


CREATE TABLE Employees(
EmpID INT PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR(50),
Gender VARCHAR(10),
HireDate DATE,
DeptID INT,
JobRole VARCHAR(50),
Status VARCHAR(20),
FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

INSERT INTO Employees VALUES
(1,'Asha','Female','2020-01-10',1,'HR Manager','Active'),
(2,'Rahul','Male','2019-03-12',2,'Developer','Active'),
(3,'Sneha','Female','2018-05-14',3,'Accountant','Left'),
(4,'Arjun','Male','2021-06-20',4,'Sales Exec','Active'),
(5,'Divya','Female','2022-02-11',5,'SEO Analyst','Active'),
(6,'Kiran','Male','2017-07-07',2,'Team Lead','Left'),
(7,'Meena','Female','2020-08-09',3,'Analyst','Active'),
(8,'Ravi','Male','2016-11-25',4,'Manager','Active'),
(9,'Pooja','Female','2023-01-01',5,'Executive','Active'),
(10,'Nikhil','Male','2015-12-15',2,'Architect','Left');


CREATE TABLE Salaries(
SalaryID INT PRIMARY KEY AUTO_INCREMENT,
EmpID INT,
SalaryAmount INT,
EffectiveDate DATE,
FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

INSERT INTO Salaries VALUES
(1,1,60000,'2024-01-01'),
(2,2,90000,'2024-01-01'),
(3,3,55000,'2024-01-01'),
(4,4,70000,'2024-01-01'),
(5,5,50000,'2024-01-01'),
(6,6,95000,'2024-01-01'),
(7,7,65000,'2024-01-01'),
(8,8,80000,'2024-01-01'),
(9,9,48000,'2024-01-01'),
(10,10,100000,'2024-01-01');


CREATE TABLE Hiring(
HireID INT PRIMARY KEY AUTO_INCREMENT,
EmpID INT,
Recruiter VARCHAR(50),
HireSource VARCHAR(50),
HiringDate DATE,
FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

INSERT INTO Hiring VALUES
(1,1,'Riya','LinkedIn','2020-01-10'),
(2,2,'John','Naukri','2019-03-12'),
(3,3,'Sara','Referral','2018-05-14'),
(4,4,'Ramesh','LinkedIn','2021-06-20'),
(5,5,'Anita','Walk-in','2022-02-11'),
(6,6,'Karan','Naukri','2017-07-07'),
(7,7,'Megha','Referral','2020-08-09'),
(8,8,'Vikram','Consultancy','2016-11-25'),
(9,9,'Priya','Walk-in','2023-01-01'),
(10,10,'Raj','LinkedIn','2015-12-15');


CREATE TABLE Attrition(
AttritionID INT PRIMARY KEY AUTO_INCREMENT,
EmpID INT,
ExitDate DATE,
Reason VARCHAR(100),
FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

INSERT INTO Attrition VALUES
(1,3,'2023-11-01','Higher Studies'),
(2,6,'2022-10-15','Better Offer'),
(3,10,'2023-08-20','Retirement');


-- INDEX

CREATE INDEX idx_emp_dept ON Employees(DeptID);
CREATE INDEX idx_salary_emp ON Salaries(EmpID);

-- VIEW → Salary Trend

CREATE VIEW SalaryTrend AS
SELECT e.Name, d.DeptName, s.SalaryAmount
FROM Employees e
JOIN Salaries s ON e.EmpID = s.EmpID
JOIN Departments d ON e.DeptID = d.DeptID;


-- STORED PROCEDURE → Attrition Count

DELIMITER //
CREATE PROCEDURE GetAttrition()
BEGIN
SELECT COUNT(*) AS TotalAttrition FROM Attrition;
END //
DELIMITER ;

-- TRIGGER 1 → Auto mark employee as LEFT

DELIMITER //
CREATE TRIGGER mark_left
AFTER INSERT ON Attrition
FOR EACH ROW
BEGIN
UPDATE Employees
SET Status='Left'
WHERE EmpID = NEW.EmpID;
END //
DELIMITER ;

-- TRIGGER 2 → Prevent Negative Salary

DELIMITER //
CREATE TRIGGER salary_check
BEFORE INSERT ON Salaries
FOR EACH ROW
BEGIN
IF NEW.SalaryAmount < 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Salary cannot be negative';
END IF;
END //
DELIMITER ;