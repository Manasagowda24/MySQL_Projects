-- Student Management System 



-- CREATE DATABASE

CREATE DATABASE StudentManagement_db;
USE StudentManagement_db;

-- CREATE TABLES


CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    City VARCHAR(50)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    DurationMonths INT
);

CREATE TABLE Marks (
    MarkID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Marks INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    AttendancePercentage INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);


-- INSERT DATA (10 EACH)


INSERT INTO Students VALUES
(1,'Asha',20,'Female','Bangalore'),
(2,'Rahul',21,'Male','Mysore'),
(3,'Kiran',22,'Male','Hubli'),
(4,'Sneha',20,'Female','Mangalore'),
(5,'Vijay',23,'Male','Bangalore'),
(6,'Divya',21,'Female','Mysore'),
(7,'Arjun',22,'Male','Shimoga'),
(8,'Meena',20,'Female','Hubli'),
(9,'Ravi',24,'Male','Bangalore'),
(10,'Pooja',21,'Female','Udupi');

INSERT INTO Courses VALUES
(101,'SQL',3),
(102,'Python',4),
(103,'Power BI',2),
(104,'Excel',1),
(105,'Tableau',2),
(106,'Data Science',6),
(107,'Java',5),
(108,'Web Dev',4),
(109,'AI Basics',3),
(110,'Cloud',5);

INSERT INTO Marks VALUES
(1,1,101,85),
(2,2,102,78),
(3,3,103,90),
(4,4,104,88),
(5,5,105,76),
(6,6,106,92),
(7,7,107,81),
(8,8,108,74),
(9,9,109,89),
(10,10,110,95);

INSERT INTO Attendance VALUES
(1,1,101,90),
(2,2,102,85),
(3,3,103,88),
(4,4,104,92),
(5,5,105,80),
(6,6,106,95),
(7,7,107,87),
(8,8,108,82),
(9,9,109,91),
(10,10,110,89);

-- INDEXES

CREATE INDEX idx_student_name ON Students(Name);
CREATE INDEX idx_course_name ON Courses(CourseName);
CREATE INDEX idx_marks ON Marks(StudentID, CourseID);
CREATE INDEX idx_attendance ON Attendance(StudentID, CourseID);

-- VIEW


CREATE VIEW Student_Performance AS
SELECT 
    s.StudentID,
    s.Name,
    c.CourseName,
    m.Marks,
    a.AttendancePercentage
FROM Students s
JOIN Marks m ON s.StudentID = m.StudentID
JOIN Courses c ON m.CourseID = c.CourseID
JOIN Attendance a 
     ON s.StudentID = a.StudentID 
     AND c.CourseID = a.CourseID;


-- STORED PROCEDURE


DELIMITER //

CREATE PROCEDURE GetStudentReport(IN sid INT)
BEGIN
    SELECT 
        s.Name,
        c.CourseName,
        m.Marks,
        a.AttendancePercentage
    FROM Students s
    JOIN Marks m ON s.StudentID = m.StudentID
    JOIN Courses c ON m.CourseID = c.CourseID
    JOIN Attendance a 
         ON s.StudentID = a.StudentID 
         AND c.CourseID = a.CourseID
    WHERE s.StudentID = sid;
END //

DELIMITER ;

-- TEST

SELECT * FROM Student_Performance;

CALL GetStudentReport(1);

