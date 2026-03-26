-- Hotel Management System


-- DATABASE

CREATE DATABASE Hotel_db;
USE Hotel_db;


-- CREATE TABLE

CREATE TABLE Guests (
    GuestID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50)
);


CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY AUTO_INCREMENT,
    RoomType VARCHAR(50),
    PricePerNight DECIMAL(10,2),
    Status VARCHAR(20) DEFAULT 'Available'
);


CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    GuestID INT,
    RoomID INT,
    CheckIn DATE,
    CheckOut DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);


CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    BookingID INT,
    PaymentAmount DECIMAL(10,2),
    PaymentDate DATE,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);


INSERT INTO Guests (Name, Phone, City) VALUES
('Amit','9000000001','Bangalore'),
('Neha','9000000002','Mysore'),
('Rahul','9000000003','Hubli'),
('Sneha','9000000004','Udupi'),
('Arjun','9000000005','Belgaum'),
('Pooja','9000000006','Tumkur'),
('Ravi','9000000007','Shimoga'),
('Meena','9000000008','Davangere'),
('Kiran','9000000009','Bijapur'),
('Divya','9000000010','Mangalore');

INSERT INTO Rooms (RoomType, PricePerNight) VALUES
('Single',1500),
('Double',2500),
('Suite',4000),
('Single',1500),
('Double',2500),
('Suite',4000),
('Single',1500),
('Double',2500),
('Suite',4000),
('Single',1500);

INSERT INTO Bookings (GuestID, RoomID, CheckIn, CheckOut, TotalAmount) VALUES
(1,1,'2024-02-01','2024-02-03',3000),
(2,2,'2024-02-02','2024-02-04',5000),
(3,3,'2024-02-03','2024-02-05',8000),
(4,4,'2024-02-04','2024-02-06',3000),
(5,5,'2024-02-05','2024-02-07',5000),
(6,6,'2024-02-06','2024-02-08',8000),
(7,7,'2024-02-07','2024-02-09',3000),
(8,8,'2024-02-08','2024-02-10',5000),
(9,9,'2024-02-09','2024-02-11',8000),
(10,10,'2024-02-10','2024-02-12',3000);

INSERT INTO Payments (BookingID, PaymentAmount, PaymentDate) VALUES
(1,3000,'2024-02-03'),
(2,5000,'2024-02-04'),
(3,8000,'2024-02-05'),
(4,3000,'2024-02-06'),
(5,5000,'2024-02-07'),
(6,8000,'2024-02-08'),
(7,3000,'2024-02-09'),
(8,5000,'2024-02-10'),
(9,8000,'2024-02-11'),
(10,3000,'2024-02-12');


-- INDEX

CREATE INDEX idx_room_type ON Rooms(RoomType);

-- VIEW

CREATE VIEW BookingDetails AS
SELECT g.Name, r.RoomType, b.CheckIn, b.CheckOut, b.TotalAmount
FROM Bookings b
JOIN Guests g ON b.GuestID = g.GuestID
JOIN Rooms r ON b.RoomID = r.RoomID;


-- STORED PROCEDURE

DELIMITER //

CREATE PROCEDURE GetHighBookings()
BEGIN
SELECT * FROM BookingDetails
WHERE TotalAmount > 4000;
END //

DELIMITER ;


-- TRIGGER

DELIMITER //

CREATE TRIGGER after_booking_insert
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Rooms
    SET Status = 'Booked'
    WHERE RoomID = NEW.RoomID;
END //

DELIMITER ;


-- High Value Bookings
CALL GetHighBookings();

-- View All Booking Details
SELECT * FROM BookingDetails;