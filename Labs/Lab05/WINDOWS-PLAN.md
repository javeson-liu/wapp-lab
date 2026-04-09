# Lab 05 -- Windows Machine Task Plan

> **Purpose:** This plan tells Claude Code on the Windows machine what to build, test, screenshot, and submit for the remaining Lab 05 exercises.
>
> **Repo:** `javeson-liu/wapp-lab` (branch: `main`)
>
> **Existing project:** `WAPP-W5/` -- ASP.NET Web Forms (.NET Framework) with `Registration.aspx` already working

---

## Status Overview

| Exercise | Status | What's Left |
|----------|--------|-------------|
| Lab 05A -- SQL Statements | DONE + SUBMITTED | No action needed |
| Lab 05B -- ASP.NET ADO.NET CRUD | DONE (code) | Run project, take screenshots of CRUD operations |
| Lab 05C -- ASP.NET RBAC | NOT STARTED | Build all code, run, screenshot |

---

## Exercise 1: Lab 05A -- SQL Statements (Screenshots Only)

The `.sql` file is at `Labs/Lab05/Lab05-SQL-Statements.sql`. The Word template is at `outputs/Lab05-SQL-Submission/Lab05-SQL-Submission.docx`.

### Steps

1. Open SSMS, connect to `(LocalDB)\MSSQLLocalDB`
2. Create a new database (e.g., `Lab05DB`)
3. Run the DDL section (CREATE TABLE statements) from the `.sql` file
4. Run the DML section (INSERT statements) to seed sample data
5. Run each of the 20 queries (Q1-Q20) one at a time
6. For each query, screenshot showing: the SQL query + the result grid
7. Open `Lab05-SQL-Submission.docx`, fill in student info, paste screenshots into each placeholder
8. Save as PDF: `Lab05A-SQL-Statements.pdf`

---

## Exercise 2: Lab 05B -- ASP.NET ADO.NET CRUD (Screenshots Only)

The code already exists in `WAPP-W5/`. It has `Registration.aspx` with full CRUD.

### Steps

1. Open `WAPP-W5.slnx` in Visual Studio
2. Build and run the project
3. Take screenshots of each CRUD operation:
   - **CREATE:** Fill in the form, click Save, show new record in GridView
   - **READ:** Show the GridView displaying all student records
   - **UPDATE:** Select a row, modify a field, click Update, show updated GridView
   - **DELETE:** Select a row, click Delete, show record removed from GridView
4. Also screenshot the database in SSMS showing the Students table data
5. Create a Word document `Lab05B-CRUD-Submission.docx` with:
   - Cover page (name, TP number, date)
   - Section for each CRUD operation with code snippet + screenshot
   - Brief explanation of what each operation does
6. Save as PDF: `Lab05B-CRUD-Submission.pdf`

---

## Exercise 3: Lab 05C -- ASP.NET RBAC (Build + Screenshots)

This is the only exercise that needs code written. Build it inside the existing `WAPP-W5/` project.

### Task 1 -- Database Enhancement

Run these SQL scripts in SSMS against the same database:

```sql
-- Create Teachers table
CREATE TABLE Teachers (
    TeacherID INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Password VARCHAR(50) NOT NULL,
    PRIMARY KEY CLUSTERED ([TeacherID] ASC)
);

-- Add Role column to Students table
ALTER TABLE Students
    ADD Role VARCHAR(20) NOT NULL DEFAULT 'student';

-- Insert sample teacher
INSERT INTO Teachers (Name, Email, Password)
VALUES ('Dr. Smith', 'smith@apu.edu.my', 'teacher123');
```

**Screenshot needed:** SSMS showing both tables exist with data.

### Task 2 -- Implement Authentication (Login.aspx)

Create `Login.aspx` in the project root with:
- Email TextBox (`txtEmail`)
- Password TextBox (`txtPassword`, TextMode="Password")
- Login Button (`btnLogin`)
- Error Label (`lblMessage`)

Create `Login.aspx.cs` code-behind:
- Check Students table first: `SELECT StudentID, 'student' AS Role FROM Students WHERE Email=@Email AND Password=@Password`
- If no match, check Teachers table: `SELECT TeacherID, 'teacher' AS Role FROM Teachers WHERE Email=@Email AND Password=@Password`
- On success: store `Session["UserID"]` and `Session["Role"]`, redirect to appropriate dashboard
- On failure: show "Invalid email or password."
- Use parameterized queries (never concatenate user input)
- Use `using` blocks for SqlConnection

**Screenshots needed:**
- Login page UI
- Successful student login (redirects to StudentDashboard.aspx)
- Successful teacher login (redirects to TeacherDashboard.aspx)
- Failed login attempt showing error message

### Task 3 -- Implement Role-Based Access Control

#### StudentDashboard.aspx

Create with these features:
- **Session guard** in `Page_Load`: if `Session["Role"]` is not "student", redirect to `Login.aspx`
- **View own grades:** GridView showing enrollments for the logged-in student only
- **Modify own info:** Form to update own FirstName, LastName, Email
- **No access to:** adding/deleting students, adding grades, viewing other students

#### TeacherDashboard.aspx

Create with these features:
- **Session guard** in `Page_Load`: if `Session["Role"]` is not "teacher", redirect to `Login.aspx`
- **Add new students:** Form with Save button to INSERT into Students
- **Delete students:** GridView with Delete button
- **Add grades:** Form to insert into Enrollments (StudentID, CourseID, Grade)
- **View enrollment details:** GridView with JOIN showing student names + courses + grades
- **No access to:** modifying student personal data

#### Access Matrix (must be enforced)

| Action | Student | Teacher |
|--------|---------|---------|
| Login | Allowed | Allowed |
| View own grades | Allowed | Allowed |
| Modify own personal info | Allowed | Not Allowed |
| Add new students | Not Allowed | Allowed |
| Delete students | Not Allowed | Allowed |
| Add grades | Not Allowed | Allowed |
| View student enrollment details | Not Allowed | Allowed |
| Modify student personal data | Not Allowed | Not Allowed |

**Screenshots needed:**
- StudentDashboard showing own grades
- StudentDashboard showing edit own info
- Student trying to access TeacherDashboard (should redirect to Login)
- TeacherDashboard showing student list with add/delete
- TeacherDashboard showing grade entry
- TeacherDashboard showing enrollment details
- Teacher trying to access StudentDashboard (should redirect to Login)

#### Create submission document `Lab05C-RBAC-Submission.docx`:
- Cover page (name, TP number, date)
- Task 1: SQL scripts + SSMS screenshot of tables
- Task 2: Login.aspx code + screenshots of login flows
- Task 3: Dashboard code + screenshots proving each access rule

Save as PDF: `Lab05C-RBAC-Submission.pdf`

---

## Final Submission Checklist

### Files to include in ZIP: `Lab05-Submission.zip`

```
Lab05-Submission/
|
|-- Lab05A-SQL/
|   |-- Lab05-SQL-Statements.sql          (the 20 queries)
|   |-- Lab05A-SQL-Statements.pdf         (queries + SSMS screenshots)
|
|-- Lab05B-CRUD/
|   |-- WAPP-W5/                          (full project folder)
|   |   |-- Registration.aspx
|   |   |-- Registration.aspx.cs
|   |   |-- Web.config
|   |   |-- (other project files)
|   |-- Lab05B-CRUD-Submission.pdf        (code + screenshots)
|
|-- Lab05C-RBAC/
|   |-- WAPP-W5/                          (full project folder with RBAC added)
|   |   |-- Login.aspx
|   |   |-- Login.aspx.cs
|   |   |-- StudentDashboard.aspx
|   |   |-- StudentDashboard.aspx.cs
|   |   |-- TeacherDashboard.aspx
|   |   |-- TeacherDashboard.aspx.cs
|   |   |-- Web.config
|   |   |-- (other project files)
|   |-- Lab05C-RBAC-Setup.sql             (Teachers DDL + ALTER + seed data)
|   |-- Lab05C-RBAC-Submission.pdf        (code + screenshots per task)
```

### Alternative: If lecturer accepts repo link instead of ZIP

Push all code to `javeson-liu/wapp-lab` and submit:
- GitHub repo link: `https://github.com/javeson-liu/wapp-lab`
- Three PDF documents (one per exercise)

---

## Important Reminders

- All database operations must use **parameterized queries** (never string concatenation)
- All pages with restricted access must check `Session["Role"]` in `Page_Load`
- Use `using` blocks for all `SqlConnection` and `SqlCommand` objects
- Connection string name is `"StudentDB"` in `Web.config`
- After building RBAC, commit and push to `javeson-liu/wapp-lab` using SSH remote
- Git config on Windows should use `javeson-liu` as the user
