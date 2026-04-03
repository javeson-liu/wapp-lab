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
