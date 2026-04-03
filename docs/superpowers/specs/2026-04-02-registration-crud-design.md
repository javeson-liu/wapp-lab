# Registration CRUD Web Form — Design Spec

**Date:** 2026-04-02  
**Stack:** ASP.NET Web Forms (.NET Framework 4.7.2) + ADO.NET + SQL Server LocalDB  

## Overview

A single-page registration form with full CRUD operations. Users can create, view, edit, and delete registration records. The form sits above a data grid showing all records.

## Database

- **Instance:** `(LocalDb)\MSSQLLocalDB`
- **Database:** `WAPP_W5_DB`
- **Table:** `Registration`

| Column | Type | Constraints |
|---|---|---|
| `Id` | `INT` | Primary Key, Identity |
| `Name` | `NVARCHAR(100)` | NOT NULL |
| `Email` | `NVARCHAR(200)` | NOT NULL |
| `Password` | `NVARCHAR(100)` | NOT NULL |
| `Phone` | `NVARCHAR(20)` | NULL |
| `Address` | `NVARCHAR(500)` | NULL |
| `CreatedDate` | `DATETIME` | DEFAULT GETDATE() |

Connection string added to `Web.config`:

```xml
<connectionStrings>
  <add name="WAPP_W5_DB" 
       connectionString="Data Source=(LocalDb)\MSSQLLocalDB;Initial Catalog=WAPP_W5_DB;Integrated Security=True"
       providerName="System.Data.SqlClient" />
</connectionStrings>
```

## UI — Registration.aspx (Single Page)

### Top: Registration Form
- TextBoxes: Name, Email, Password, Phone, Address
- Validators: RequiredFieldValidator on Name, Email, Password; RegularExpressionValidator on Email
- Buttons: Submit (insert or update), Clear (reset form)
- Label for success/error messages

### Bottom: Data Grid
- ASP.NET GridView bound to all registration records
- Visible columns: Id, Name, Email, Phone, Address, CreatedDate
- Password column hidden from grid
- Edit button: loads record into form, sets ViewState["EditId"]
- Delete button: removes record with confirmation

### Styling
- Uses existing Bootstrap 5 via Site.Master
- Navigation link added to Site.Master navbar

## Data Access — Registration.aspx.cs

All operations use parameterized ADO.NET queries (SqlConnection + SqlCommand).

| Operation | Trigger | SQL |
|---|---|---|
| Create | Submit button (no EditId) | `INSERT INTO Registration (Name, Email, Password, Phone, Address) VALUES (...)` |
| Read | Page load + after every operation | `SELECT Id, Name, Email, Phone, Address, CreatedDate FROM Registration` |
| Update | Submit button (EditId set) | `UPDATE Registration SET ... WHERE Id = @Id` |
| Delete | GridView Delete button | `DELETE FROM Registration WHERE Id = @Id` |

### Key Patterns
- Parameterized queries to prevent SQL injection
- `ViewState["EditId"]` tracks insert vs. update mode
- GridView Edit button populates form fields and sets ViewState
- After each operation: clear form, reset ViewState, rebind GridView
- `using` blocks on SqlConnection/SqlCommand for disposal
- Database/table auto-created on first load if not exists

## Files

| File | Action | Purpose |
|---|---|---|
| `Web.config` | Modify | Add connection string |
| `Registration.aspx` | Create | Form + GridView page |
| `Registration.aspx.cs` | Create | CRUD code-behind |
| `Registration.aspx.designer.cs` | Create | Control declarations |
| `Site.Master` | Modify | Add Registration nav link |

No additional NuGet packages required.
