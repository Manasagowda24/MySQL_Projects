-- 15. Gym Management System


-- DATABASE

CREATE DATABASE Gym_db;
USE Gym_db;

-- CREATE TABLES

CREATE TABLE Members (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Phone VARCHAR(15),
    JoinDate DATE
);


CREATE TABLE Trainers (
    TrainerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Specialization VARCHAR(50)
);


CREATE TABLE MembershipPlans (
    PlanID INT PRIMARY KEY AUTO_INCREMENT,
    PlanName VARCHAR(50),
    DurationMonths INT,
    Fee DECIMAL(10,2)
);


CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    MemberID INT,
    PlanID INT,
    TotalFee DECIMAL(10,2),
    PaymentDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (PlanID) REFERENCES MembershipPlans(PlanID)
);

INSERT INTO Members (Name, Phone, JoinDate) VALUES
('Amit','9000000001','2024-01-01'),
('Neha','9000000002','2024-01-02'),
('Rahul','9000000003','2024-01-03'),
('Sneha','9000000004','2024-01-04'),
('Arjun','9000000005','2024-01-05'),
('Divya','9000000006','2024-01-06'),
('Kiran','9000000007','2024-01-07'),
('Meena','9000000008','2024-01-08'),
('Ravi','9000000009','2024-01-09'),
('Pooja','9000000010','2024-01-10');

INSERT INTO Trainers (Name, Specialization) VALUES
('Trainer A','Cardio'),
('Trainer B','Strength'),
('Trainer C','Yoga'),
('Trainer D','Crossfit'),
('Trainer E','Zumba'),
('Trainer F','Pilates'),
('Trainer G','HIIT'),
('Trainer H','Bodybuilding'),
('Trainer I','Weight Loss'),
('Trainer J','Flexibility');

INSERT INTO MembershipPlans (PlanName, DurationMonths, Fee) VALUES
('Monthly',1,2000),
('Quarterly',3,5000),
('Half Yearly',6,9000),
('Yearly',12,16000);

INSERT INTO Payments (MemberID, PlanID, TotalFee, PaymentDate) VALUES
(1,1,0,'2024-02-01'),
(2,2,0,'2024-02-02'),
(3,3,0,'2024-02-03'),
(4,4,0,'2024-02-04'),
(5,1,0,'2024-02-05'),
(6,2,0,'2024-02-06'),
(7,3,0,'2024-02-07'),
(8,4,0,'2024-02-08'),
(9,1,0,'2024-02-09'),
(10,2,0,'2024-02-10');

-- INDEX

CREATE INDEX idx_plan_name ON MembershipPlans(PlanName);


-- VIEW

CREATE VIEW PaymentSummary AS
SELECT m.Name, mp.PlanName, p.TotalFee
FROM Payments p
JOIN Members m ON p.MemberID = m.MemberID
JOIN MembershipPlans mp ON p.PlanID = mp.PlanID;


-- STORED PROCEDURE

DELIMITER //

CREATE PROCEDURE HighPayments()
BEGIN
SELECT * FROM PaymentSummary
WHERE TotalFee > 5000;
END //

DELIMITER ;


-- TRIGGER (AUTO FEE)

DELIMITER //

CREATE TRIGGER before_payment_insert
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
    DECLARE fee DECIMAL(10,2);
    
    SELECT Fee INTO fee
    FROM MembershipPlans
    WHERE PlanID = NEW.PlanID;
    
    SET NEW.TotalFee = fee;
END //

DELIMITER ;



-- View Payments
SELECT * FROM PaymentSummary;

-- High Payments
CALL HighPayments();