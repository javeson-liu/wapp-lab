-- ============================================
-- Lab 05: SQL Statements Tutorial
-- Web Applications
-- ============================================

-- ============================================
-- 1. Table Schemas (DDL)
-- ============================================

CREATE TABLE Students (
    StudentID INT IDENTITY(1,1) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    EnrollmentDate DATE,
    PRIMARY KEY CLUSTERED ([StudentID] ASC)
);

CREATE TABLE Courses (
    CourseID INT IDENTITY(1,1) NOT NULL,
    CourseName VARCHAR(100) NOT NULL,
    Credits INT CHECK (Credits > 0),
    PRIMARY KEY CLUSTERED ([CourseID] ASC)
);

CREATE TABLE Enrollments (
    EnrollmentID INT IDENTITY(1,1) NOT NULL,
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    Grade CHAR(2) NOT NULL,
    PRIMARY KEY CLUSTERED ([EnrollmentID] ASC),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- ============================================
-- 2. Populating Sample Data (DML)
-- ============================================

INSERT INTO Students (FirstName, LastName, Email, Password, EnrollmentDate)
VALUES
('Alice', 'Johnson', 'alice@apu.edu.my', 'alice', '2026-02-01'),
('Bob', 'Smith', 'bob@apu.edu.my', 'bob', '2026-02-03'),
('Charlie', 'Brown', 'charlie@apu.edu.my', 'charlie', '2026-02-05');

SET IDENTITY_INSERT Courses ON;
INSERT INTO Courses (CourseID, CourseName, Credits) VALUES
(101, 'Web Applications', 3),
(102, 'Data Science', 4),
(103, 'Introduction to SQL', 3);
SET IDENTITY_INSERT Courses OFF;

INSERT INTO Enrollments (StudentID, CourseID, Grade) VALUES
(1, 101, 'A'),
(1, 102, 'B'),
(2, 101, 'B');

-- ============================================
-- SELECT Category (Read Operations)
-- ============================================

-- Q1: Basic Retrieval - Show all columns for all students
SELECT * FROM Students;

-- Q2: Specific Columns - FirstName and LastName only
SELECT FirstName, LastName FROM Students;

-- Q3: Filtering - Student with LastName 'Smith'
SELECT * FROM Students WHERE LastName = 'Smith';

-- Q4: Counting - Total number of students
SELECT COUNT(*) AS TotalStudents FROM Students;

-- Q5: Ordering - Courses alphabetically by CourseName
SELECT * FROM Courses ORDER BY CourseName ASC;

-- Q6: Comparison - Courses with more than 3 credits
SELECT * FROM Courses WHERE Credits > 3;

-- Q7: Pattern Matching - Emails ending with 'uni.edu'
SELECT * FROM Students WHERE Email LIKE '%uni.edu';

-- Q8: Joins - Student names with enrolled CourseID
SELECT s.FirstName, s.LastName, e.CourseID
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID;

-- Q9: Distinct Values - Unique grades
SELECT DISTINCT Grade FROM Enrollments;

-- Q10: Null Checks - Students with no email
SELECT * FROM Students WHERE Email IS NULL;

-- ============================================
-- INSERT Category (Create Operations)
-- ============================================

-- Q11: Single Row - Add Diana Prince
INSERT INTO Students (FirstName, LastName, Email, Password)
VALUES ('Diana', 'Prince', 'diana@apu.edu.my', 'diana');

-- Q12: Specific Columns - Add Art History course
INSERT INTO Courses (CourseName, Credits)
VALUES ('Art History', 2);

-- Q13: Bulk Insert - Add two students at once
INSERT INTO Students (FirstName, LastName, Email, Password)
VALUES
('John', 'Doe', 'john@apu.edu.my', 'john'),
('Jane', 'Doe', 'jane@apu.edu.my', 'jane');

-- ============================================
-- UPDATE Category (Edit Operations)
-- ============================================

-- Q14: Simple Update - Change Bob's last name to Jones
UPDATE Students SET LastName = 'Jones' WHERE FirstName = 'Bob' AND LastName = 'Smith';

-- Q15: Conditional Update - Change Intro to SQL credits to 4
UPDATE Courses SET Credits = 4 WHERE CourseName = 'Introduction to SQL';

-- Q16: Bulk Update - Increase all credits by 1
UPDATE Courses SET Credits = Credits + 1;

-- Q17: Grade Change - Update Alice's Data Science grade to A
UPDATE Enrollments SET Grade = 'A' WHERE StudentID = 1 AND CourseID = 102;

-- ============================================
-- DELETE Category (Remove Operations)
-- ============================================

-- Q18: Targeted Delete - Remove StudentID 3
DELETE FROM Students WHERE StudentID = 3;

-- Q19: Conditional Delete - Delete enrollments with grade C
DELETE FROM Enrollments WHERE Grade = 'C';

-- Q20: Clear Table - Delete all records from Enrollments
DELETE FROM Enrollments;
