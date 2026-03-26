-- Transport Management System


-- DATABASE

CREATE DATABASE Transport_db;
USE Transport_db;

-- CREATE TABLE

CREATE TABLE Drivers (
    DriverID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Phone VARCHAR(15),
    LicenseNo VARCHAR(50)
);


CREATE TABLE Vehicles (
    VehicleID INT PRIMARY KEY AUTO_INCREMENT,
    VehicleNumber VARCHAR(20),
    VehicleType VARCHAR(50),
    Capacity INT
);


CREATE TABLE Trips (
    TripID INT PRIMARY KEY AUTO_INCREMENT,
    DriverID INT,
    VehicleID INT,
    Distance INT,
    Cost DECIMAL(10,2),
    TripDate DATE,
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID),
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID)
);


CREATE TABLE Fuel (
    FuelID INT PRIMARY KEY AUTO_INCREMENT,
    VehicleID INT,
    Liters DECIMAL(10,2),
    FuelCost DECIMAL(10,2),
    FuelDate DATE,
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID)
);


INSERT INTO Drivers (Name, Phone, LicenseNo) VALUES
('Amit','9000000001','DL123'),
('Neha','9000000002','DL124'),
('Rahul','9000000003','DL125'),
('Sneha','9000000004','DL126'),
('Arjun','9000000005','DL127'),
('Pooja','9000000006','DL128'),
('Ravi','9000000007','DL129'),
('Meena','9000000008','DL130'),
('Kiran','9000000009','DL131'),
('Divya','9000000010','DL132');

INSERT INTO Vehicles (VehicleNumber, VehicleType, Capacity) VALUES
('KA01A1234','Truck',1000),
('KA02B2345','Van',500),
('KA03C3456','Truck',1200),
('KA04D4567','Van',600),
('KA05E5678','Truck',1500),
('KA06F6789','Van',550),
('KA07G7890','Truck',1300),
('KA08H8901','Van',580),
('KA09I9012','Truck',1600),
('KA10J0123','Van',620);

INSERT INTO Trips (DriverID, VehicleID, Distance, Cost, TripDate) VALUES
(1,1,100,0,'2024-02-01'),
(2,2,80,0,'2024-02-02'),
(3,3,120,0,'2024-02-03'),
(4,4,90,0,'2024-02-04'),
(5,5,150,0,'2024-02-05'),
(6,6,70,0,'2024-02-06'),
(7,7,130,0,'2024-02-07'),
(8,8,85,0,'2024-02-08'),
(9,9,160,0,'2024-02-09'),
(10,10,75,0,'2024-02-10');

INSERT INTO Fuel (VehicleID, Liters, FuelCost, FuelDate) VALUES
(1,20,2000,'2024-02-01'),
(2,15,1500,'2024-02-02'),
(3,25,2500,'2024-02-03'),
(4,18,1800,'2024-02-04'),
(5,30,3000,'2024-02-05'),
(6,12,1200,'2024-02-06'),
(7,28,2800,'2024-02-07'),
(8,16,1600,'2024-02-08'),
(9,32,3200,'2024-02-09'),
(10,14,1400,'2024-02-10');


-- INDEX

CREATE INDEX idx_vehicle_type ON Vehicles(VehicleType);


-- VIEW

CREATE VIEW TripDetails AS
SELECT d.Name, v.VehicleNumber, t.Distance, t.Cost
FROM Trips t
JOIN Drivers d ON t.DriverID = d.DriverID
JOIN Vehicles v ON t.VehicleID = v.VehicleID;


-- STORED PROCEDURE

DELIMITER //

CREATE PROCEDURE LongTrips()
BEGIN
SELECT * FROM TripDetails
WHERE Distance > 100;
END //

DELIMITER ;


-- TRIGGER (AUTO TRIP COST)

DELIMITER //

CREATE TRIGGER before_trip_insert
BEFORE INSERT ON Trips
FOR EACH ROW
BEGIN
    SET NEW.Cost = NEW.Distance * 20;
END //

DELIMITER ;


-- View Trip Details
SELECT * FROM TripDetails;

-- Long Trips
CALL LongTrips();
