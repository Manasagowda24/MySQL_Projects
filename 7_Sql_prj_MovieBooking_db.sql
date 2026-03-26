-- Movie Ticket Booking 


-- CREATE DATABASE

CREATE DATABASE MovieBooking_db;
USE MovieBooking_db;
  
  
-- CREATE TABLES


CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    Title VARCHAR(100),
    Genre VARCHAR(50),
    Language VARCHAR(50),
    Duration INT,
    Rating DECIMAL(2,1)
);

CREATE TABLE Theaters (
    TheaterID INT PRIMARY KEY,
    TheaterName VARCHAR(100),
    City VARCHAR(50),
    TotalSeats INT
);

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    MovieID INT,
    TheaterID INT,
    ShowDate DATE,
    SeatCount INT,
    TicketPrice DECIMAL(8,2),
    TotalAmount DECIMAL(10,2),
    BookingStatus VARCHAR(20),
    FOREIGN KEY (MovieID) REFERENCES Movies(MovieID),
    FOREIGN KEY (TheaterID) REFERENCES Theaters(TheaterID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    BookingID INT,
    PaymentMethod VARCHAR(50),
    PaymentStatus VARCHAR(20),
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID)
);

-- Booking Log
CREATE TABLE BookingLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT,
    OldStatus VARCHAR(20),
    NewStatus VARCHAR(20),
    ChangedOn DATETIME
);


-- INSERT DATA


INSERT INTO Movies VALUES
(1,'Leo','Action','Tamil',150,8.5),
(2,'KGF','Action','Kannada',160,9.0),
(3,'RRR','Drama','Telugu',170,8.8),
(4,'Jawan','Action','Hindi',145,8.2),
(5,'Avatar','Sci-Fi','English',180,9.1),
(6,'Pushpa','Action','Telugu',155,8.4),
(7,'Master','Drama','Tamil',140,8.0),
(8,'Dune','Sci-Fi','English',165,8.6),
(9,'Pathaan','Action','Hindi',150,7.9),
(10,'Salaar','Action','Kannada',175,8.9);

INSERT INTO Theaters VALUES
(101,'PVR','Bangalore',200),
(102,'INOX','Mysore',150),
(103,'Cinepolis','Hubli',180),
(104,'IMAX','Bangalore',220),
(105,'Fun Cinemas','Mangalore',160),
(106,'Asian','Hyderabad',210),
(107,'Carnival','Shimoga',140),
(108,'Miraj','Udupi',130),
(109,'SRS','Delhi',190),
(110,'Gold','Mumbai',250);

INSERT INTO Bookings VALUES
(1,1,101,'2024-02-01',2,200,400,'Confirmed'),
(2,2,102,'2024-02-02',3,180,540,'Confirmed'),
(3,3,103,'2024-02-03',4,150,600,'Cancelled'),
(4,4,104,'2024-02-04',2,220,440,'Confirmed'),
(5,5,105,'2024-02-05',1,250,250,'Confirmed'),
(6,6,106,'2024-02-06',5,170,850,'Confirmed'),
(7,7,107,'2024-02-07',2,160,320,'Cancelled'),
(8,8,108,'2024-02-08',3,210,630,'Confirmed'),
(9,9,109,'2024-02-09',4,190,760,'Confirmed'),
(10,10,110,'2024-02-10',2,230,460,'Confirmed');

INSERT INTO Payments VALUES
(1,1,'UPI','Completed',400,'2024-02-01'),
(2,2,'Card','Completed',540,'2024-02-02'),
(3,3,'Cash','Refunded',600,'2024-02-03'),
(4,4,'UPI','Completed',440,'2024-02-04'),
(5,5,'Card','Completed',250,'2024-02-05'),
(6,6,'UPI','Completed',850,'2024-02-06'),
(7,7,'Cash','Refunded',320,'2024-02-07'),
(8,8,'Card','Completed',630,'2024-02-08'),
(9,9,'UPI','Completed',760,'2024-02-09'),
(10,10,'Card','Completed',460,'2024-02-10');


-- INDEXES


CREATE INDEX idx_movie ON Movies(Title);
CREATE INDEX idx_theater ON Theaters(TheaterName);
CREATE INDEX idx_booking ON Bookings(MovieID);

-- VIEW (BOOKING REPORT)


CREATE VIEW BookingReport AS
SELECT 
    m.Title,
    t.TheaterName,
    b.ShowDate,
    b.SeatCount,
    b.TotalAmount,
    b.BookingStatus
FROM Bookings b
JOIN Movies m ON b.MovieID = m.MovieID
JOIN Theaters t ON b.TheaterID = t.TheaterID;

-- STORED PROCEDURE


DELIMITER //

CREATE PROCEDURE GetTopMovie()
BEGIN
    SELECT 
        m.Title,
        COUNT(b.BookingID) AS TotalBookings
    FROM Movies m
    JOIN Bookings b ON m.MovieID = b.MovieID
    GROUP BY m.Title
    ORDER BY TotalBookings DESC
    LIMIT 1;
END //

DELIMITER ;


-- TRIGGERS


-- Auto Calculate Total Amount
DELIMITER //

CREATE TRIGGER trg_ticket_total
BEFORE INSERT ON Bookings
FOR EACH ROW
BEGIN
    SET NEW.TotalAmount = NEW.SeatCount * NEW.TicketPrice;
END //

DELIMITER ;

-- Log Booking Status Change
DELIMITER //

CREATE TRIGGER trg_booking_log
AFTER UPDATE ON Bookings
FOR EACH ROW
BEGIN
    IF OLD.BookingStatus <> NEW.BookingStatus THEN
        INSERT INTO BookingLog(BookingID, OldStatus, NewStatus, ChangedOn)
        VALUES (OLD.BookingID, OLD.BookingStatus, NEW.BookingStatus, NOW());
    END IF;
END //

DELIMITER ;

-- TEST


SELECT * FROM BookingReport;

CALL GetTopMovie();

UPDATE Bookings
SET BookingStatus = 'Confirmed'
WHERE BookingID = 3;

SELECT * FROM BookingLog;
