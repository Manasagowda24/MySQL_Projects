-- Library Management System 


-- CREATE DATABASE

CREATE DATABASE LibraryManagement_db;
USE LibraryManagement_db;


-- CREATE TABLES


CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    PublishedYear INT,
    ISBN VARCHAR(20),
    CopiesAvailable INT
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    MembershipDate DATE
);

CREATE TABLE IssuedBooks (
    IssueID INT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    IssueDate DATE,
    DueDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

CREATE TABLE ReturnBooks (
    ReturnID INT PRIMARY KEY,
    IssueID INT,
    ReturnDate DATE,
    FineAmount DECIMAL(5,2),
    FOREIGN KEY (IssueID) REFERENCES IssuedBooks(IssueID)
);


-- INSERT DATA (10 EACH)


INSERT INTO Books VALUES
(1,'SQL Basics','John Smith','Education',2018,'ISBN101',5),
(2,'Python Guide','David Lee','Programming',2020,'ISBN102',3),
(3,'AI Intro','Mark Wood','Technology',2021,'ISBN103',4),
(4,'Data Science','Anna Bell','Technology',2019,'ISBN104',6),
(5,'Excel Pro','Sara Khan','Business',2017,'ISBN105',7),
(6,'Cloud Basics','Tom Hardy','Technology',2022,'ISBN106',2),
(7,'Java Master','James Bond','Programming',2016,'ISBN107',5),
(8,'Machine Learning','Elon Ray','Technology',2021,'ISBN108',3),
(9,'Power BI','Lara Croft','Business',2019,'ISBN109',4),
(10,'Web Dev','Steve Jobs','Programming',2018,'ISBN110',6);

INSERT INTO Members VALUES
(1,'Asha','asha@gmail.com','90001','Bangalore','2023-01-10'),
(2,'Rahul','rahul@gmail.com','90002','Mysore','2023-02-12'),
(3,'Kiran','kiran@gmail.com','90003','Hubli','2023-03-15'),
(4,'Sneha','sneha@gmail.com','90004','Mangalore','2023-04-01'),
(5,'Vijay','vijay@gmail.com','90005','Bangalore','2023-05-18'),
(6,'Divya','divya@gmail.com','90006','Mysore','2023-06-10'),
(7,'Arjun','arjun@gmail.com','90007','Shimoga','2023-07-22'),
(8,'Meena','meena@gmail.com','90008','Hubli','2023-08-30'),
(9,'Ravi','ravi@gmail.com','90009','Bangalore','2023-09-14'),
(10,'Pooja','pooja@gmail.com','90010','Udupi','2023-10-05');

INSERT INTO IssuedBooks VALUES
(1,1,1,'2024-01-01','2024-01-10'),
(2,2,2,'2024-01-05','2024-01-15'),
(3,3,3,'2024-01-10','2024-01-20'),
(4,4,4,'2024-01-12','2024-01-22'),
(5,5,5,'2024-01-15','2024-01-25'),
(6,6,6,'2024-01-18','2024-01-28'),
(7,7,7,'2024-01-20','2024-01-30'),
(8,8,8,'2024-01-22','2024-02-01'),
(9,9,9,'2024-01-25','2024-02-04'),
(10,10,10,'2024-01-28','2024-02-07');

INSERT INTO ReturnBooks VALUES
(1,1,'2024-01-12',20),
(2,2,'2024-01-14',0),
(3,3,'2024-01-25',50),
(4,4,'2024-01-21',0),
(5,5,'2024-01-28',30),
(6,6,'2024-01-27',0),
(7,7,'2024-02-05',60),
(8,8,'2024-01-30',0),
(9,9,'2024-02-10',40),
(10,10,'2024-02-06',0);


-- 4. INDEXES


CREATE INDEX idx_book_title ON Books(Title);
CREATE INDEX idx_member_name ON Members(Name);
CREATE INDEX idx_issue_dates ON IssuedBooks(IssueDate, DueDate);


-- VIEW (OVERDUE TRACKING)


CREATE VIEW OverdueBooks AS
SELECT 
    m.Name,
    b.Title,
    i.IssueDate,
    i.DueDate,
    r.ReturnDate,
    DATEDIFF(r.ReturnDate, i.DueDate) AS OverdueDays
FROM IssuedBooks i
JOIN Members m ON i.MemberID = m.MemberID
JOIN Books b ON i.BookID = b.BookID
JOIN ReturnBooks r ON i.IssueID = r.IssueID
WHERE r.ReturnDate > i.DueDate;


-- STORED PROCEDURE


DELIMITER //

CREATE PROCEDURE GetOverdueBooks()
BEGIN
    SELECT 
        m.Name,
        b.Title,
        i.DueDate,
        r.ReturnDate,
        DATEDIFF(r.ReturnDate, i.DueDate) AS OverdueDays,
        r.FineAmount
    FROM IssuedBooks i
    JOIN Members m ON i.MemberID = m.MemberID
    JOIN Books b ON i.BookID = b.BookID
    JOIN ReturnBooks r ON i.IssueID = r.IssueID
    WHERE r.ReturnDate > i.DueDate;
END //

DELIMITER ;


-- TEST

SELECT * FROM OverdueBooks;

CALL GetOverdueBooks();

