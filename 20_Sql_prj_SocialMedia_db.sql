-- SOCIAL MEDIA DATABASE


-- CREATE DATABASE

CREATE DATABASE SocialMedia_db;
USE SocialMedia_db;


-- CREATE TABLES


CREATE TABLE Users(
UserID INT PRIMARY KEY AUTO_INCREMENT,
UserName VARCHAR(50),
City VARCHAR(50)
);

INSERT INTO Users VALUES
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




CREATE TABLE Posts(
PostID INT PRIMARY KEY AUTO_INCREMENT,
UserID INT,
Content VARCHAR(255),
PostDate DATE,
FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

INSERT INTO Posts VALUES
(1,1,'Hello World','2024-01-01'),
(2,2,'SQL is fun','2024-01-02'),
(3,3,'Learning DB','2024-01-03'),
(4,4,'Coding time','2024-01-04'),
(5,5,'Analytics','2024-01-05'),
(6,6,'Triggers','2024-01-06'),
(7,7,'Views','2024-01-07'),
(8,8,'Indexes','2024-01-08'),
(9,9,'Procedures','2024-01-09'),
(10,10,'Databases','2024-01-10');


CREATE TABLE Likes(
LikeID INT PRIMARY KEY AUTO_INCREMENT,
PostID INT,
UserID INT,
FOREIGN KEY (PostID) REFERENCES Posts(PostID),
FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

INSERT INTO Likes VALUES
(1,1,2),
(2,2,3),
(3,3,4),
(4,4,5),
(5,5,6),
(6,6,7),
(7,7,8),
(8,8,9),
(9,9,10),
(10,10,1);


CREATE TABLE Followers(
FollowID INT PRIMARY KEY AUTO_INCREMENT,
UserID INT,
FollowerID INT,
FOREIGN KEY (UserID) REFERENCES Users(UserID),
FOREIGN KEY (FollowerID) REFERENCES Users(UserID)
);

INSERT INTO Followers VALUES
(1,1,2),
(2,2,3),
(3,3,4),
(4,4,5),
(5,5,6),
(6,6,7),
(7,7,8),
(8,8,9),
(9,9,10),
(10,10,1);


-- INDEX

CREATE INDEX idx_post_user ON Posts(UserID);

-- VIEW → Post Popularity

CREATE VIEW PostPopularity AS
SELECT p.PostID, COUNT(l.LikeID) AS TotalLikes
FROM Posts p
LEFT JOIN Likes l ON p.PostID = l.PostID
GROUP BY p.PostID;


-- STORED PROCEDURE → Total Followers

DELIMITER //
CREATE PROCEDURE TotalFollowers()
BEGIN
SELECT UserID, COUNT(FollowerID) AS Followers
FROM Followers
GROUP BY UserID;
END //
DELIMITER ;

-- TRIGGER 1 → Prevent Self Follow


DELIMITER //
CREATE TRIGGER prevent_self_follow
BEFORE INSERT ON Followers
FOR EACH ROW
BEGIN
IF NEW.UserID = NEW.FollowerID THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='User cannot follow themselves';
END IF;
END //
DELIMITER ;


-- TRIGGER 2 → Prevent Empty Post
DELIMITER //
CREATE TRIGGER prevent_empty_post
BEFORE INSERT ON Posts
FOR EACH ROW
BEGIN
IF NEW.Content IS NULL OR NEW.Content = '' THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Post content cannot be empty';
END IF;
END //
DELIMITER ;