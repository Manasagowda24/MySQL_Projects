-- Online Exam System


-- DATABASE

CREATE DATABASE OnlineExam_db;
USE OnlineExam_db;


-- CREATE TABLES

CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Email VARCHAR(100)
);


CREATE TABLE Exams (
    ExamID INT PRIMARY KEY AUTO_INCREMENT,
    ExamName VARCHAR(100),
    TotalMarks INT
);


CREATE TABLE Questions (
    QuestionID INT PRIMARY KEY AUTO_INCREMENT,
    ExamID INT,
    QuestionText VARCHAR(255),
    Marks INT,
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
);


CREATE TABLE Results (
    ResultID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    ExamID INT,
    MarksObtained INT,
    Grade VARCHAR(5),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
);


INSERT INTO Students (Name, Email) VALUES
('Asha','asha@gmail.com'),
('Rahul','rahul@gmail.com'),
('Sneha','sneha@gmail.com'),
('Arjun','arjun@gmail.com'),
('Divya','divya@gmail.com'),
('Kiran','kiran@gmail.com'),
('Meena','meena@gmail.com'),
('Ravi','ravi@gmail.com'),
('Pooja','pooja@gmail.com'),
('Nikhil','nikhil@gmail.com');

INSERT INTO Exams (ExamName, TotalMarks) VALUES
('Math Test',100),
('Science Test',100);

INSERT INTO Questions (ExamID, QuestionText, Marks) VALUES
(1,'Q1',10),(1,'Q2',10),(1,'Q3',10),(1,'Q4',10),(1,'Q5',10),
(2,'Q1',20),(2,'Q2',20),(2,'Q3',20),(2,'Q4',20),(2,'Q5',20);

INSERT INTO Results (StudentID, ExamID, MarksObtained, Grade) VALUES
(1,1,85,NULL),
(2,1,70,NULL),
(3,1,92,NULL),
(4,1,60,NULL),
(5,1,88,NULL),
(6,2,75,NULL),
(7,2,95,NULL),
(8,2,65,NULL),
(9,2,80,NULL),
(10,2,90,NULL);


-- INDEX

CREATE INDEX idx_exam_name ON Exams(ExamName);


-- VIEW

CREATE VIEW StudentResults AS
SELECT s.Name, e.ExamName, r.MarksObtained, r.Grade
FROM Results r
JOIN Students s ON r.StudentID = s.StudentID
JOIN Exams e ON r.ExamID = e.ExamID;


-- STORED PROCEDURE

DELIMITER //

CREATE PROCEDURE TopStudents()
BEGIN
SELECT * FROM StudentResults
WHERE MarksObtained > 80;
END //

DELIMITER ;


-- TRIGGER (AUTO GRADE)

DELIMITER //

CREATE TRIGGER before_result_insert
BEFORE INSERT ON Results
FOR EACH ROW
BEGIN
    IF NEW.MarksObtained >= 90 THEN
        SET NEW.Grade = 'A+';
    ELSEIF NEW.MarksObtained >= 75 THEN
        SET NEW.Grade = 'A';
    ELSEIF NEW.MarksObtained >= 60 THEN
        SET NEW.Grade = 'B';
    ELSE
        SET NEW.Grade = 'C';
    END IF;
END //

DELIMITER ;


-- View Results
SELECT * FROM StudentResults;

-- Top Students
CALL TopStudents();
