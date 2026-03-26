-- AIRLINE RESERVATION DATABASE


-- CREATE DATABASE

CREATE DATABASE Airline_System_db;
USE Airline_System_db;


-- CREATE TABLES

CREATE TABLE Passengers(
PassengerID INT PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR(50),
City VARCHAR(50)
);

INSERT INTO Passengers VALUES
(1,'Asha','Bangalore'),
(2,'Rahul','Hyderabad'),
(3,'Sneha','Mumbai'),
(4,'Arjun','Delhi'),
(5,'Divya','Chennai'),
(6,'Kiran','Pune'),
(7,'Meena','Kolkata'),
(8,'Ravi','Noida'),
(9,'Pooja','Ahmedabad'),
(10,'Nikhil','Surat');


CREATE TABLE Flights(
FlightID INT PRIMARY KEY AUTO_INCREMENT,
FlightName VARCHAR(50),
Source VARCHAR(50),
Destination VARCHAR(50),
TotalSeats INT
);

INSERT INTO Flights VALUES
(1,'AI101','Bangalore','Delhi',150),
(2,'AI102','Hyderabad','Mumbai',180),
(3,'AI103','Delhi','Chennai',200),
(4,'AI104','Mumbai','Kolkata',160),
(5,'AI105','Pune','Ahmedabad',140),
(6,'AI106','Noida','Goa',120),
(7,'AI107','Chennai','Delhi',170),
(8,'AI108','Kolkata','Hyderabad',190),
(9,'AI109','Surat','Mumbai',130),
(10,'AI110','Bangalore','Goa',150);


CREATE TABLE Bookings(
BookingID INT PRIMARY KEY AUTO_INCREMENT,
PassengerID INT,
FlightID INT,
SeatsBooked INT,
FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID),
FOREIGN KEY (FlightID) REFERENCES Flights(FlightID)
);

INSERT INTO Bookings VALUES
(1,1,1,2),
(2,2,2,1),
(3,3,3,3),
(4,4,4,2),
(5,5,5,1),
(6,6,6,2),
(7,7,7,4),
(8,8,8,2),
(9,9,9,1),
(10,10,10,3);


CREATE TABLE Payments(
PaymentID INT PRIMARY KEY AUTO_INCREMENT,
BookingID INT,
Amount INT,
FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

INSERT INTO Payments VALUES
(1,1,10000),
(2,2,5000),
(3,3,15000),
(4,4,12000),
(5,5,7000),
(6,6,9000),
(7,7,20000),
(8,8,11000),
(9,9,6000),
(10,10,14000);


-- INDEX

CREATE INDEX idx_flight_booking ON Bookings(FlightID);


-- VIEW → Flight Revenue


CREATE VIEW FlightRevenue AS
SELECT f.FlightName, SUM(p.Amount) AS TotalRevenue
FROM Flights f
JOIN Bookings b ON f.FlightID = b.FlightID
JOIN Payments p ON b.BookingID = p.BookingID
GROUP BY f.FlightName;


-- STORED PROCEDURE → Total Bookings


DELIMITER //
CREATE PROCEDURE TotalBookings()
BEGIN
SELECT COUNT(*) AS TotalBookings FROM Bookings;
END //
DELIMITER ;


-- TRIGGER 1 → Prevent Overbooking


DELIMITER //
CREATE TRIGGER prevent_overbooking
BEFORE INSERT ON Bookings
FOR EACH ROW
BEGIN
IF NEW.SeatsBooked > (SELECT TotalSeats FROM Flights WHERE FlightID = NEW.FlightID)
THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Cannot book more than available seats';
END IF;
END //
DELIMITER ;


-- TRIGGER 2 → Prevent Negative Payment

DELIMITER //
CREATE TRIGGER payment_check
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
IF NEW.Amount < 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Payment cannot be negative';
END IF;
END //
DELIMITER ;