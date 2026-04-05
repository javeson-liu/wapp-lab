# wapp-lab

Source code repository for the **Web Applications** module (CT050-3-2-WAPP) at Asia Pacific University (APU), Semester 4.

Covers full-stack web development using the Microsoft .NET ecosystem with SQL Server as the database backend.

---

## Tech Stack

| Layer       | Technology                                    |
|-------------|-----------------------------------------------|
| Framework   | ASP.NET Web Forms (.NET Framework)            |
| Language    | C# (code-behind pattern)                      |
| Database    | Microsoft SQL Server / LocalDB (`.mdf`)       |
| Data Access | ADO.NET (`SqlConnection`, `SqlCommand`, etc.) |
| Frontend    | HTML5, CSS3, JavaScript (ASPX pages)          |
| IDE         | Visual Studio                                 |
| DB Tool     | SQL Server Management Studio (SSMS)           |
| Config      | `Web.config` for connection strings           |

---

## Module Topics

| Lecture | Topic                        |
|---------|------------------------------|
| 01      | HTML5                        |
| 02      | CSS                          |
| 03      | Introduction to ASP.NET      |
| 04      | Introduction to ADO.NET      |
| 05      | Website Design Method        |
| 06      | Web Accessibility            |
| 07      | Servers and Security         |
| 08      | Evaluation of Web Pages      |
| 09      | Web HCI and Usability        |

---

## ADO.NET Quick Reference

### Connection String (`Web.config`)

```xml
<connectionStrings>
  <add name="DefaultConnection"
       connectionString="Data Source=(LocalDB)\MSSQLLocalDB;
         AttachDbFilename=|DataDirectory|\AppDatabase.mdf;
         Integrated Security=True"
       providerName="System.Data.SqlClient" />
</connectionStrings>
```

### Standard ADO.NET Pattern

```csharp
using System.Data.SqlClient;
using System.Configuration;

string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

using (SqlConnection conn = new SqlConnection(connStr))
{
    conn.Open();
    string sql = "SELECT * FROM Users WHERE Username = @Username";
    using (SqlCommand cmd = new SqlCommand(sql, conn))
    {
        cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            while (reader.Read())
            {
                // reader["ColumnName"].ToString()
            }
        }
    }
}
```

### CRUD Operations

| Operation | ADO.NET Method                  |
|-----------|---------------------------------|
| INSERT    | `cmd.ExecuteNonQuery()`         |
| SELECT    | `da.Fill(dt)` → bind to GridView|
| UPDATE    | `cmd.ExecuteNonQuery()`         |
| DELETE    | `cmd.ExecuteNonQuery()`         |

### Session Authentication Pattern

```csharp
// On login success
Session["UserID"] = userId;
Session["UserRole"] = "Member"; // or "Admin"
Response.Redirect("~/Member/Dashboard.aspx");

// Auth guard in Page_Load
if (Session["UserID"] == null)
    Response.Redirect("~/Login.aspx");
```

---

## Lab 05 — Homework Exercises

> **Note:** All Lab 05 exercises are implemented on a separate Windows machine. ASP.NET Web Forms and SQL Server LocalDB require a Windows environment with Visual Studio installed. Code is pushed to this repository from that machine and can be reviewed here on any OS.
>
> GitHub repository: [javeson-liu/wapp-lab](https://github.com/javeson-liu/wapp-lab)

---

### Lab 05A — SQL Statements Tutorial

**Summary:**
Covers foundational SQL DDL and DML operations against a student management database consisting of three tables: `Students`, `Courses`, and `Enrollments`.

**What is covered:**
- **DDL (Schema Creation):** `CREATE TABLE` statements with primary keys, foreign keys, identity columns, and check constraints for all three tables
- **DML — Sample Data:** `INSERT` scripts to seed the database with sample students, courses, and enrollment records
- **SELECT (Read):** 10 practice problems covering basic retrieval, column filtering, `WHERE` conditions, `COUNT`, `ORDER BY`, comparison operators, `LIKE` pattern matching, `JOIN`, `DISTINCT`, and `NULL` checks
- **INSERT (Create):** Single-row inserts, specific-column inserts, and bulk inserts
- **UPDATE (Edit):** Simple updates, conditional updates, and bulk updates
- **DELETE (Remove):** Targeted deletes by ID, conditional deletes, and full table clears with `DELETE`

---

### Lab 05B — ASP.NET Web Forms CRUD Tutorial (ADO.NET)

**Summary:**
Builds a fully functional Student Management Form using ASP.NET Web Forms and ADO.NET — covering the complete Create, Read, Update, Delete cycle against a SQL Server LocalDB database.

**What is covered:**
- **Project Setup:** Creating an ASP.NET Web Application (.NET Framework) with Web Forms template in Visual Studio
- **Connection String:** Configured in `Web.config` using `(LocalDB)\MSSQLLocalDB` and `AttachDbFilename` pointing to a `.mdf` file
- **Frontend (Students.aspx):** Form with `TextBox` controls for FirstName, LastName, Email, Password, and EnrollmentDate; Save, Update, Delete buttons; and a `GridView` with bound columns and a select button
- **READ:** `LoadStudents()` uses `SqlDataAdapter` and `DataTable` to fill and bind the GridView
- **CREATE:** `btnSave_Click` uses `ExecuteNonQuery()` with parameterized `INSERT` to safely add a new student record
- **UPDATE:** `btnUpdate_Click` uses parameterized `UPDATE` with the StudentID stored in a hidden field
- **DELETE:** `btnDelete_Click` uses parameterized `DELETE` by StudentID
- **Row Selection:** `gvStudents_SelectedIndexChanged` populates the form fields from the selected GridView row for editing

---

### Lab 05C — ASP.NET Role-Based Access Control (RBAC)

**Summary:**
Extends the student management system built in Lab 05B by implementing Role-Based Access Control (RBAC), supporting two distinct user roles — **Student** and **Teacher** — each with different permitted actions.

**What is covered:**
- **Database Enhancement (Task 1):** Adds a `Teachers` table (`TeacherID`, `Name`, `Email`, `Password`) and a `Role` column (`VARCHAR(20)`) to the `Students` table to support role differentiation
- **Authentication (Task 2):** Login system (`Login.aspx`) queries both `Students` and `Teachers` tables, stores `Session["UserID"]` and `Session["Role"]` on success, and redirects to the appropriate dashboard (`StudentDashboard.aspx` or `TeacherDashboard.aspx`)
- **RBAC Rules (Task 3):** Enforces the following access matrix:

| Action | Student | Teacher |
|---|---|---|
| Login | Allowed | Allowed |
| View own grades | Allowed | Allowed |
| Modify own personal info | Allowed | Not Allowed |
| Add / Delete students | Not Allowed | Allowed |
| Add grades | Not Allowed | Allowed |
| View student enrollment details | Not Allowed | Allowed |
| Modify student personal data | Not Allowed | Not Allowed* |

*Teachers may modify academic-related data only, depending on design.

- **Session Guards:** Every protected page checks `Session["Role"]` in `Page_Load` and redirects unauthorised users

---

## Project Structure

```
wapp-lab/
├── Labs/                      # Weekly lab exercises
│   ├── Lab01/                 # HTML5 — Personal Web Page
│   ├── Lab02/                 # CSS — Portfolio & Restaurant
│   ├── Lab05/                 # SQL Statements
│   └── Lab06/                 # ASP.NET ADO.NET CRUD
│
└── Assignments/               # Group Assignment
    └── WebLearningSystem/
        ├── WebLearningSystem.sln
        └── WebLearningSystem/
            ├── Web.config
            ├── Default.aspx
            ├── Login.aspx
            ├── Register.aspx
            ├── Admin/         # Admin-only pages
            ├── Member/        # Member-only pages
            ├── App_Data/      # .mdf database files
            ├── CSS/           # External stylesheets
            ├── JS/            # JavaScript files
            └── Images/
```

---

## Security Practices

- Parameterized queries only — never string-concatenate user input into SQL
- Session-based authentication with role checks on every protected page
- Server-side and client-side form validation
- Never store plain-text passwords
- Never commit `Web.config` with real credentials

---

## Getting Started

### Prerequisites

- Visual Studio 2019 or later
- SQL Server Express with LocalDB
- SQL Server Management Studio (SSMS)

### Setup

1. Clone the repository
```
git clone https://github.com/javeson-liu/wapp-lab.git
```

2. Open the `.sln` file in Visual Studio

3. Build the solution to restore dependencies

4. Run the project — LocalDB will auto-create the `.mdf` file on first run

5. Use SSMS to connect to `(LocalDB)\MSSQLLocalDB` and run any SQL seed scripts in the `Database/` folder

---

## Module Info

- **University:** Asia Pacific University (APU)
- **Module:** Web Applications (CT050-3-2-WAPP)
- **Semester:** 4
