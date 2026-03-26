-- EVENT MANAGEMENT DATABASE 


-- CREATE DATABASE

CREATE DATABASE Event_System_db;
USE Event_System_db;

-- CREATE TABLES

CREATE TABLE Organizers(
OrganizerID INT PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR(50),
City VARCHAR(50)
);

INSERT INTO Organizers VALUES
(1,'Ravi','Bangalore'),
(2,'Sneha','Hyderabad'),
(3,'Amit','Mumbai'),
(4,'Divya','Delhi'),
(5,'Rahul','Chennai'),
(6,'Meena','Pune'),
(7,'Arjun','Kolkata'),
(8,'Kiran','Noida'),
(9,'Pooja','Ahmedabad'),
(10,'Nikhil','Surat');


CREATE TABLE Events(
EventID INT PRIMARY KEY AUTO_INCREMENT,
EventName VARCHAR(50),
OrganizerID INT,
EventDate DATE,
Location VARCHAR(50),
FOREIGN KEY (OrganizerID) REFERENCES Organizers(OrganizerID)
);

INSERT INTO Events VALUES
(1,'Tech Fest',1,'2024-06-10','Bangalore'),
(2,'Music Night',2,'2024-07-12','Hyderabad'),
(3,'Startup Meet',3,'2024-08-15','Mumbai'),
(4,'Food Expo',4,'2024-09-20','Delhi'),
(5,'Art Show',5,'2024-10-11','Chennai'),
(6,'Dance Fest',6,'2024-11-07','Pune'),
(7,'Coding Hackathon',7,'2024-12-09','Kolkata'),
(8,'Business Summit',8,'2025-01-25','Noida'),
(9,'Fashion Show',9,'2025-02-14','Ahmedabad'),
(10,'Gaming Expo',10,'2025-03-05','Surat');


CREATE TABLE Attendees(
AttendeeID INT PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR(50),
EventID INT,
FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

INSERT INTO Attendees VALUES
(1,'Asha',1),
(2,'Rahul',2),
(3,'Sneha',3),
(4,'Arjun',4),
(5,'Divya',5),
(6,'Kiran',6),
(7,'Meena',7),
(8,'Ravi',8),
(9,'Pooja',9),
(10,'Nikhil',10);


CREATE TABLE Payments(
PaymentID INT PRIMARY KEY AUTO_INCREMENT,
EventID INT,
Amount INT,
PaymentDate DATE,
FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

INSERT INTO Payments VALUES
(1,1,10000,'2024-06-01'),
(2,2,15000,'2024-07-01'),
(3,3,12000,'2024-08-01'),
(4,4,18000,'2024-09-01'),
(5,5,9000,'2024-10-01'),
(6,6,11000,'2024-11-01'),
(7,7,20000,'2024-12-01'),
(8,8,25000,'2025-01-01'),
(9,9,17000,'2025-02-01'),
(10,10,22000,'2025-03-01');


-- INDEX

CREATE INDEX idx_event_org ON Events(OrganizerID);


-- VIEW → Revenue Report

CREATE VIEW EventRevenue AS
SELECT e.EventName, SUM(p.Amount) AS TotalRevenue
FROM Events e
JOIN Payments p ON e.EventID = p.EventID
GROUP BY e.EventName;

-- STORED PROCEDURE → Total Revenue


DELIMITER //
CREATE PROCEDURE TotalRevenue()
BEGIN
SELECT SUM(Amount) AS TotalEventRevenue FROM Payments;
END //
DELIMITER ;


-- TRIGGER 1 → Prevent Past Event Creation

DELIMITER //
CREATE TRIGGER event_date_check
BEFORE INSERT ON Events
FOR EACH ROW
BEGIN
IF NEW.EventDate < CURDATE() THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Event date cannot be in past';
END IF;
END //
DELIMITER ;


-- TRIGGER 2 → Auto delete attendees if event deleted

DELIMITER //
CREATE TRIGGER delete_attendees
AFTER DELETE ON Events
FOR EACH ROW
BEGIN
DELETE FROM Attendees WHERE EventID = OLD.EventID;
END //
DELIMITER ;
