-- Hospital Database 

-- CREATE DATABASE

CREATE DATABASE Hospital_db;
USE Hospital_db;

-- CREATE TABLES


CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Disease VARCHAR(100),
    AdmissionDate DATE
);

CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(50),
    Specialization VARCHAR(50),
    Experience INT,
    Phone VARCHAR(15),
    City VARCHAR(50)
);

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATE,
    Status VARCHAR(20),
    Fees DECIMAL(8,2),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Appointment Log for Trigger
CREATE TABLE AppointmentLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID INT,
    OldStatus VARCHAR(20),
    NewStatus VARCHAR(20),
    ChangedOn DATETIME
);




INSERT INTO Patients VALUES
(1,'Asha',25,'Female','90001','Bangalore','Fever','2024-01-01'),
(2,'Rahul',30,'Male','90002','Mysore','Cold','2024-01-02'),
(3,'Kiran',28,'Male','90003','Hubli','Diabetes','2024-01-03'),
(4,'Sneha',27,'Female','90004','Mangalore','Asthma','2024-01-04'),
(5,'Vijay',35,'Male','90005','Bangalore','BP','2024-01-05'),
(6,'Divya',26,'Female','90006','Mysore','Migraine','2024-01-06'),
(7,'Arjun',32,'Male','90007','Shimoga','Fracture','2024-01-07'),
(8,'Meena',29,'Female','90008','Hubli','Fever','2024-01-08'),
(9,'Ravi',40,'Male','90009','Bangalore','Heart','2024-01-09'),
(10,'Pooja',31,'Female','90010','Udupi','Skin','2024-01-10');

INSERT INTO Doctors VALUES
(101,'Dr. Anand','Cardiology',10,'80001','Bangalore'),
(102,'Dr. Mehta','General',8,'80002','Mysore'),
(103,'Dr. Khan','Orthopedic',12,'80003','Hubli'),
(104,'Dr. Sharma','Pulmonology',9,'80004','Mangalore'),
(105,'Dr. Reddy','Neurology',15,'80005','Bangalore'),
(106,'Dr. Iyer','Dermatology',7,'80006','Mysore'),
(107,'Dr. Verma','General',6,'80007','Shimoga'),
(108,'Dr. Patel','Cardiology',11,'80008','Hubli'),
(109,'Dr. Rao','Orthopedic',13,'80009','Bangalore'),
(110,'Dr. Singh','General',5,'80010','Delhi');

INSERT INTO Appointments VALUES
(1,1,102,'2024-01-11','Booked',500),
(2,2,107,'2024-01-12','Completed',400),
(3,3,101,'2024-01-13','Booked',600),
(4,4,104,'2024-01-14','Cancelled',450),
(5,5,105,'2024-01-15','Completed',700),
(6,6,106,'2024-01-16','Booked',350),
(7,7,103,'2024-01-17','Completed',650),
(8,8,102,'2024-01-18','Booked',500),
(9,9,101,'2024-01-19','Completed',800),
(10,10,106,'2024-01-20','Booked',300);

-- INDEXES


CREATE INDEX idx_patient_name ON Patients(Name);
CREATE INDEX idx_doctor_special ON Doctors(Specialization);
CREATE INDEX idx_appointment_patient ON Appointments(PatientID);


-- VIEW (DOCTOR PATIENT REPORT)


CREATE VIEW DoctorPatientReport AS
SELECT 
    p.Name AS PatientName,
    d.Name AS DoctorName,
    d.Specialization,
    a.AppointmentDate,
    a.Status,
    a.Fees
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID;


-- STORED PROCEDURE


DELIMITER //

CREATE PROCEDURE GetTopDoctor()
BEGIN
    SELECT 
        d.Name,
        COUNT(a.AppointmentID) AS TotalAppointments
    FROM Doctors d
    JOIN Appointments a ON d.DoctorID = a.DoctorID
    GROUP BY d.Name
    ORDER BY TotalAppointments DESC
    LIMIT 1;
END //

DELIMITER ;


-- TRIGGERS


-- Trigger 1: Prevent Appointment if Doctor not Available
DELIMITER //

CREATE TRIGGER trg_check_fees
BEFORE INSERT ON Appointments
FOR EACH ROW
BEGIN
    IF NEW.Fees < 300 THEN
        SET NEW.Fees = 300;
    END IF;
END //

DELIMITER ;

-- Trigger 2: Log Status Change
DELIMITER //

CREATE TRIGGER trg_appointment_log
AFTER UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF OLD.Status <> NEW.Status THEN
        INSERT INTO AppointmentLog(AppointmentID, OldStatus, NewStatus, ChangedOn)
        VALUES (OLD.AppointmentID, OLD.Status, NEW.Status, NOW());
    END IF;
END //

DELIMITER ;

SELECT * FROM DoctorPatientReport;

CALL GetTopDoctor();

-- Test Trigger
UPDATE Appointments
SET Status = 'Completed'
WHERE AppointmentID = 1;

SELECT * FROM AppointmentLog;
