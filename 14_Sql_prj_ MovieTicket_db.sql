-- Movie Ticket Booking System

-- DATABASE

CREATE DATABASE MovieTicket_db;
USE MovieTicket_db;


-- CREATE TABLES

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Phone VARCHAR(15)
);




CREATE TABLE Movies (
    MovieID INT PRIMARY KEY AUTO_INCREMENT,
    MovieName VARCHAR(100),
    Language VARCHAR(50),
    TicketPrice DECIMAL(10,2)
);


CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    MovieID INT,
    Seats INT,
    TotalAmount DECIMAL(10,2),
    BookingDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID)
);


CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    BookingID INT,
    PaymentMode VARCHAR(50),
    PaymentDate DATE,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

INSERT INTO Customers (Name, Phone) VALUES
('Amit','9000000001'),
('Neha','9000000002'),
('Rahul','9000000003'),
('Sneha','9000000004'),
('Arjun','9000000005'),
('Divya','9000000006'),
('Kiran','9000000007'),
('Meena','9000000008'),
('Ravi','9000000009'),
('Pooja','9000000010');

INSERT INTO Movies (MovieName, Language, TicketPrice) VALUES
('Leo','Tamil',200),
('KGF','Kannada',180),
('RRR','Telugu',150),
('Jawan','Hindi',220),
('Avatar','English',250),
('Pushpa','Telugu',170),
('Master','Tamil',160),
('Dune','English',210),
('Pathaan','Hindi',190),
('Salaar','Kannada',230);

INSERT INTO Bookings (CustomerID, MovieID, Seats, TotalAmount, BookingDate) VALUES
(1,1,2,0,'2024-02-01'),
(2,2,3,0,'2024-02-02'),
(3,3,4,0,'2024-02-03'),
(4,4,2,0,'2024-02-04'),
(5,5,1,0,'2024-02-05'),
(6,6,5,0,'2024-02-06'),
(7,7,2,0,'2024-02-07'),
(8,8,3,0,'2024-02-08'),
(9,9,4,0,'2024-02-09'),
(10,10,2,0,'2024-02-10');

INSERT INTO Payments (BookingID, PaymentMode, PaymentDate) VALUES
(1,'UPI','2024-02-01'),
(2,'Card','2024-02-02'),
(3,'Cash','2024-02-03'),
(4,'UPI','2024-02-04'),
(5,'Card','2024-02-05'),
(6,'UPI','2024-02-06'),
(7,'Cash','2024-02-07'),
(8,'Card','2024-02-08'),
(9,'UPI','2024-02-09'),
(10,'Card','2024-02-10');

-- INDEX

CREATE INDEX idx_movie_name ON Movies(MovieName);

-- VIEW

CREATE VIEW BookingSummary AS
SELECT c.Name, m.MovieName, b.Seats, b.TotalAmount
FROM Bookings b
JOIN Customers c ON b.CustomerID = c.CustomerID
JOIN Movies m ON b.MovieID = m.MovieID;


-- STORED PROCEDURE

DELIMITER //

CREATE PROCEDURE HighBookings()
BEGIN
SELECT * FROM BookingSummary
WHERE TotalAmount > 400;
END //

DELIMITER ;


-- TRIGGER (AUTO TOTAL)

DELIMITER //

CREATE TRIGGER before_booking_insert
BEFORE INSERT ON Bookings
FOR EACH ROW
BEGIN
    DECLARE price DECIMAL(10,2);
    
    SELECT TicketPrice INTO price
    FROM Movies
    WHERE MovieID = NEW.MovieID;
    
    SET NEW.TotalAmount = NEW.Seats * price;
END //

DELIMITER ;



-- View Bookings
SELECT * FROM BookingSummary;

-- High Bookings
CALL HighBookings();
