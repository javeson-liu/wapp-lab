-- ============================================
-- Lab 05A: SQL Statements Tutorial
-- Student Management Database
-- ============================================
-- Run each section sequentially in SSMS
-- connected to (LocalDB)\MSSQLLocalDB
-- ============================================


-- ============================================
-- SECTION 1: DDL — CREATE TABLES
-- ============================================

CREATE TABLE Students (
    StudentID    INT PRIMARY KEY IDENTITY(1,1),
    FirstName    NVARCHAR(50)  NOT NULL,
    LastName     NVARCHAR(50)  NOT NULL,
    Email        NVARCHAR(100) NOT NULL,
    DateOfBirth  DATE          NULL,
    EnrollmentDate DATE        DEFAULT GETDATE()
);

CREATE TABLE Courses (
    CourseID     INT PRIMARY KEY IDENTITY(1,1),
    CourseName   NVARCHAR(100) NOT NULL,
    Credits      INT           NOT NULL CHECK (Credits > 0 AND Credits <= 6),
    Department   NVARCHAR(50)  NULL
);

CREATE TABLE Enrollments (
    EnrollmentID   INT PRIMARY KEY IDENTITY(1,1),
    StudentID      INT NOT NULL FOREIGN KEY REFERENCES Students(StudentID),
    CourseID       INT NOT NULL FOREIGN KEY REFERENCES Courses(CourseID),
    EnrollmentDate DATE DEFAULT GETDATE(),
    Grade          NVARCHAR(2) NULL
);


-- ============================================
-- SECTION 2: DML — INSERT SEED DATA
-- ============================================

-- Students
INSERT INTO Students (FirstName, LastName, Email, DateOfBirth, EnrollmentDate)
VALUES
    ('Alice',   'Tan',      'alice.tan@gmail.com',    '2002-03-15', '2024-09-01'),
    ('Bob',     'Lee',      'bob.lee@yahoo.com',      '2001-07-22', '2024-09-01'),
    ('Charlie', 'Wong',     'charlie.w@outlook.com',  '2003-01-10', '2024-09-01'),
    ('Diana',   'Kumar',    'diana.k@gmail.com',      NULL,         '2025-01-15'),
    ('Edward',  'Lim',      'edward.lim@hotmail.com', '2002-11-05', '2025-01-15');

-- Courses
INSERT INTO Courses (CourseName, Credits, Department)
VALUES
    ('Web Applications',       3, 'Computing'),
    ('Database Systems',       4, 'Computing'),
    ('Data Structures',        3, 'Computing'),
    ('Business Communication', 2, 'Business'),
    ('Linear Algebra',         3, 'Mathematics');

-- Enrollments
INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate, Grade)
VALUES
    (1, 1, '2024-09-01', 'A'),
    (1, 2, '2024-09-01', 'B+'),
    (2, 1, '2024-09-01', 'B'),
    (2, 3, '2024-09-01', NULL),
    (3, 2, '2024-09-01', 'A-'),
    (3, 4, '2024-09-01', 'A'),
    (4, 1, '2025-01-15', NULL),
    (4, 5, '2025-01-15', 'B'),
    (5, 3, '2025-01-15', 'C+'),
    (5, 1, '2025-01-15', NULL);


-- ============================================
-- SECTION 3: SELECT — 10 PRACTICE PROBLEMS
-- ============================================

-- 1. Select all students
SELECT * FROM Students;

-- 2. Select specific columns only
SELECT FirstName, Email FROM Students;

-- 3. WHERE with equality — students in a specific enrollment year
SELECT * FROM Students
WHERE EnrollmentDate >= '2025-01-01';

-- 4. COUNT — total number of students
SELECT COUNT(*) AS TotalStudents FROM Students;

-- 5. ORDER BY — students sorted by last name ascending
SELECT * FROM Students
ORDER BY LastName ASC;

-- 6. Comparison operator — courses with 3 or more credits
SELECT * FROM Courses
WHERE Credits >= 3;

-- 7. LIKE — students with Gmail addresses
SELECT * FROM Students
WHERE Email LIKE '%gmail.com';

-- 8. JOIN — show student name with enrolled course name and grade
SELECT s.FirstName, s.LastName, c.CourseName, e.Grade
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID
ORDER BY s.LastName, c.CourseName;

-- 9. DISTINCT — all unique departments from Courses
SELECT DISTINCT Department FROM Courses;

-- 10. NULL check — students with no date of birth recorded
SELECT * FROM Students
WHERE DateOfBirth IS NULL;


-- ============================================
-- SECTION 4: INSERT VARIATIONS
-- ============================================

-- Single-row insert
INSERT INTO Students (FirstName, LastName, Email, DateOfBirth, EnrollmentDate)
VALUES ('Fiona', 'Chen', 'fiona.chen@gmail.com', '2002-06-20', '2025-03-01');

-- Specific-column insert (omit nullable/default columns)
INSERT INTO Students (FirstName, LastName, Email)
VALUES ('George', 'Ng', 'george.ng@outlook.com');

-- Bulk insert (multiple rows in one statement)
INSERT INTO Courses (CourseName, Credits, Department)
VALUES
    ('Operating Systems',    3, 'Computing'),
    ('Intro to Marketing',  2, 'Business');


-- ============================================
-- SECTION 5: UPDATE
-- ============================================

-- Simple update — change one student's email
UPDATE Students
SET Email = 'alice.updated@gmail.com'
WHERE StudentID = 1;

-- Conditional update — set grade for a specific enrollment
UPDATE Enrollments
SET Grade = 'B+'
WHERE StudentID = 2 AND CourseID = 3;

-- Bulk update — add 1 credit to all Computing courses
UPDATE Courses
SET Credits = Credits + 1
WHERE Department = 'Computing';


-- ============================================
-- SECTION 6: DELETE
-- ============================================

-- Targeted delete by ID
DELETE FROM Enrollments
WHERE EnrollmentID = 10;

-- Conditional delete — remove enrollments with no grade assigned
DELETE FROM Enrollments
WHERE Grade IS NULL;

-- Full table clear (removes all rows, keeps table structure)
DELETE FROM Enrollments;
