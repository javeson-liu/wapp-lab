# Registration CRUD Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a single-page registration form with full CRUD operations connected to SQL Server LocalDB.

**Architecture:** ASP.NET Web Forms page with ADO.NET data access. Registration.aspx contains the form and GridView. Code-behind handles all four CRUD operations using parameterized SqlCommand queries against a LocalDB database. Database and table are auto-created on first page load.

**Tech Stack:** ASP.NET Web Forms (.NET Framework 4.7.2), ADO.NET (System.Data.SqlClient), SQL Server LocalDB, Bootstrap 5

---

## File Structure

| File | Action | Responsibility |
|---|---|---|
| `WAPP-W5/Web.config` | Modify | Add connection string for LocalDB |
| `WAPP-W5/Registration.aspx` | Create | Form UI + GridView markup |
| `WAPP-W5/Registration.aspx.cs` | Create | CRUD code-behind logic |
| `WAPP-W5/Registration.aspx.designer.cs` | Create | Auto-generated control field declarations |
| `WAPP-W5/Site.Master` | Modify | Add Registration nav link |
| `WAPP-W5/WAPP-W5.csproj` | Modify | Include new Registration files |

---

### Task 1: Add Connection String to Web.config

**Files:**
- Modify: `WAPP-W5/Web.config:6` (insert before `<system.web>`)

- [ ] **Step 1: Add connectionStrings section to Web.config**

Open `WAPP-W5/Web.config` and insert the following block immediately after `<configuration>` (line 6) and before `<system.web>`:

```xml
  <connectionStrings>
    <add name="WAPP_W5_DB"
         connectionString="Data Source=(LocalDb)\MSSQLLocalDB;Initial Catalog=WAPP_W5_DB;Integrated Security=True"
         providerName="System.Data.SqlClient" />
  </connectionStrings>
```

- [ ] **Step 2: Verify Web.config is valid XML**

Open the file in Visual Studio or run a quick check — the file should have no red squiggles. The `<connectionStrings>` block should sit between `<configuration>` and `<system.web>`.

---

### Task 2: Create Registration.aspx Page

**Files:**
- Create: `WAPP-W5/Registration.aspx`

- [ ] **Step 1: Create Registration.aspx with form and GridView**

Create `WAPP-W5/Registration.aspx` with the following content:

```aspx
<%@ Page Title="Registration" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="WAPP_W5.Registration" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <h2 class="mt-3 mb-4">Registration Form</h2>

        <%-- Status Message --%>
        <asp:Label ID="lblMessage" runat="server" CssClass="mb-3 d-block" />

        <%-- Registration Form --%>
        <div class="card mb-4">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="<%= txtName.ClientID %>" class="form-label">Name <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="100" />
                        <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                            ErrorMessage="Name is required." CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    <div class="col-md-6">
                        <label for="<%= txtEmail.ClientID %>" class="form-label">Email <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" MaxLength="200" />
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                            ErrorMessage="Email is required." CssClass="text-danger small" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                            ValidationExpression="^[\w\.-]+@[\w\.-]+\.\w{2,}$"
                            ErrorMessage="Invalid email format." CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    <div class="col-md-6">
                        <label for="<%= txtPassword.ClientID %>" class="form-label">Password <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" MaxLength="100" />
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                            ErrorMessage="Password is required." CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    <div class="col-md-6">
                        <label for="<%= txtPhone.ClientID %>" class="form-label">Phone</label>
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" MaxLength="20" />
                    </div>
                    <div class="col-12">
                        <label for="<%= txtAddress.ClientID %>" class="form-label">Address</label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" MaxLength="500" />
                    </div>
                    <div class="col-12">
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary me-2" OnClick="btnSubmit_Click" />
                        <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnClear_Click" CausesValidation="false" />
                    </div>
                </div>
            </div>
        </div>

        <%-- Registration Records Grid --%>
        <h4>Registration Records</h4>
        <asp:GridView ID="gvRegistrations" runat="server" AutoGenerateColumns="false"
            CssClass="table table-striped table-bordered" DataKeyNames="Id"
            OnRowCommand="gvRegistrations_RowCommand">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="ID" ReadOnly="true" />
                <asp:BoundField DataField="Name" HeaderText="Name" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="Phone" HeaderText="Phone" />
                <asp:BoundField DataField="Address" HeaderText="Address" />
                <asp:BoundField DataField="CreatedDate" HeaderText="Created Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditRecord"
                            CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-warning me-1" CausesValidation="false">
                            Edit
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteRecord"
                            CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-danger"
                            CausesValidation="false"
                            OnClientClick="return confirm('Are you sure you want to delete this record?');">
                            Delete
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <p class="text-muted p-3">No registration records found.</p>
            </EmptyDataTemplate>
        </asp:GridView>
    </main>
</asp:Content>
```

---

### Task 3: Create Registration.aspx.cs Code-Behind

**Files:**
- Create: `WAPP-W5/Registration.aspx.cs`

- [ ] **Step 1: Create the code-behind file with all CRUD operations**

Create `WAPP-W5/Registration.aspx.cs` with the following content:

```csharp
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPP_W5
{
    public partial class Registration : Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["WAPP_W5_DB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                EnsureDatabaseExists();
                BindGrid();
            }
        }

        private void EnsureDatabaseExists()
        {
            // Connect to master to create the database if it doesn't exist
            string masterConn = "Data Source=(LocalDb)\\MSSQLLocalDB;Initial Catalog=master;Integrated Security=True";
            using (SqlConnection conn = new SqlConnection(masterConn))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(
                    "IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'WAPP_W5_DB') CREATE DATABASE WAPP_W5_DB", conn))
                {
                    cmd.ExecuteNonQuery();
                }
            }

            // Create the Registration table if it doesn't exist
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Registration')
                    CREATE TABLE Registration (
                        Id INT PRIMARY KEY IDENTITY(1,1),
                        Name NVARCHAR(100) NOT NULL,
                        Email NVARCHAR(200) NOT NULL,
                        Password NVARCHAR(100) NOT NULL,
                        Phone NVARCHAR(20) NULL,
                        Address NVARCHAR(500) NULL,
                        CreatedDate DATETIME DEFAULT GETDATE()
                    )";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void BindGrid()
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = "SELECT Id, Name, Email, Phone, Address, CreatedDate FROM Registration ORDER BY Id DESC";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvRegistrations.DataSource = dt;
                        gvRegistrations.DataBind();
                    }
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            if (ViewState["EditId"] != null)
            {
                UpdateRecord(Convert.ToInt32(ViewState["EditId"]));
            }
            else
            {
                InsertRecord();
            }

            ClearForm();
            BindGrid();
        }

        private void InsertRecord()
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = @"INSERT INTO Registration (Name, Email, Password, Phone, Address)
                               VALUES (@Name, @Email, @Password, @Phone, @Address)";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text);
                    cmd.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(txtPhone.Text.Trim()) ? (object)DBNull.Value : txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@Address", string.IsNullOrEmpty(txtAddress.Text.Trim()) ? (object)DBNull.Value : txtAddress.Text.Trim());
                    cmd.ExecuteNonQuery();
                }
            }
            lblMessage.Text = "<div class='alert alert-success'>Registration added successfully.</div>";
        }

        private void UpdateRecord(int id)
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = @"UPDATE Registration
                               SET Name = @Name, Email = @Email, Password = @Password, Phone = @Phone, Address = @Address
                               WHERE Id = @Id";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text);
                    cmd.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(txtPhone.Text.Trim()) ? (object)DBNull.Value : txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@Address", string.IsNullOrEmpty(txtAddress.Text.Trim()) ? (object)DBNull.Value : txtAddress.Text.Trim());
                    cmd.ExecuteNonQuery();
                }
            }
            lblMessage.Text = "<div class='alert alert-info'>Registration updated successfully.</div>";
        }

        private void DeleteRecord(int id)
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = "DELETE FROM Registration WHERE Id = @Id";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.ExecuteNonQuery();
                }
            }
            lblMessage.Text = "<div class='alert alert-warning'>Registration deleted.</div>";
        }

        protected void gvRegistrations_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditRecord")
            {
                LoadRecordForEdit(id);
            }
            else if (e.CommandName == "DeleteRecord")
            {
                DeleteRecord(id);
                ClearForm();
                BindGrid();
            }
        }

        private void LoadRecordForEdit(int id)
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = "SELECT Name, Email, Password, Phone, Address FROM Registration WHERE Id = @Id";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtName.Text = reader["Name"].ToString();
                            txtEmail.Text = reader["Email"].ToString();
                            txtPassword.Attributes["value"] = reader["Password"].ToString();
                            txtPhone.Text = reader["Phone"] == DBNull.Value ? "" : reader["Phone"].ToString();
                            txtAddress.Text = reader["Address"] == DBNull.Value ? "" : reader["Address"].ToString();
                            ViewState["EditId"] = id;
                            btnSubmit.Text = "Update";
                            lblMessage.Text = "<div class='alert alert-info'>Editing record #" + id + ". Modify the fields and click Update.</div>";
                        }
                    }
                }
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            txtName.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            txtPhone.Text = "";
            txtAddress.Text = "";
            ViewState["EditId"] = null;
            btnSubmit.Text = "Submit";
        }
    }
}
```

---

### Task 4: Create Registration.aspx.designer.cs

**Files:**
- Create: `WAPP-W5/Registration.aspx.designer.cs`

- [ ] **Step 1: Create the designer file with control declarations**

Create `WAPP-W5/Registration.aspx.designer.cs` with the following content:

```csharp
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WAPP_W5
{
    public partial class Registration
    {
        protected global::System.Web.UI.WebControls.Label lblMessage;
        protected global::System.Web.UI.WebControls.TextBox txtName;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator rfvName;
        protected global::System.Web.UI.WebControls.TextBox txtEmail;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator rfvEmail;
        protected global::System.Web.UI.WebControls.RegularExpressionValidator revEmail;
        protected global::System.Web.UI.WebControls.TextBox txtPassword;
        protected global::System.Web.UI.WebControls.RequiredFieldValidator rfvPassword;
        protected global::System.Web.UI.WebControls.TextBox txtPhone;
        protected global::System.Web.UI.WebControls.TextBox txtAddress;
        protected global::System.Web.UI.WebControls.Button btnSubmit;
        protected global::System.Web.UI.WebControls.Button btnClear;
        protected global::System.Web.UI.WebControls.GridView gvRegistrations;
    }
}
```

---

### Task 5: Add Navigation Link to Site.Master

**Files:**
- Modify: `WAPP-W5/Site.Master:51` (add after Contact nav item)

- [ ] **Step 1: Add Registration link to navbar**

In `WAPP-W5/Site.Master`, find line 51 (the Contact `<li>`) and add the following line immediately after it:

```html
                        <li class="nav-item"><a class="nav-link" runat="server" href="~/Registration">Registration</a></li>
```

The nav `<ul>` should now have four items: Home, About, Contact, Registration.

---

### Task 6: Add Registration Files to .csproj

**Files:**
- Modify: `WAPP-W5/WAPP-W5.csproj`

- [ ] **Step 1: Add Registration.aspx as Content item**

In `WAPP-W5/WAPP-W5.csproj`, find the `<ItemGroup>` that contains `<Content Include="Default.aspx" />` (line 121). Add the following line nearby:

```xml
    <Content Include="Registration.aspx" />
```

- [ ] **Step 2: Add Registration.aspx.cs and .designer.cs as Compile items**

In `WAPP-W5/WAPP-W5.csproj`, find the `<ItemGroup>` that contains the `<Compile>` elements (starts around line 185). Add the following block after the Default.aspx.designer.cs entry (around line 208):

```xml
    <Compile Include="Registration.aspx.cs">
      <DependentUpon>Registration.aspx</DependentUpon>
      <SubType>ASPXCodeBehind</SubType>
    </Compile>
    <Compile Include="Registration.aspx.designer.cs">
      <DependentUpon>Registration.aspx</DependentUpon>
    </Compile>
```

---

### Task 7: Build and Verify

- [ ] **Step 1: Build the solution**

Run from solution root:
```bash
msbuild WAPP-W5.slnx /p:Configuration=Debug
```

Expected: Build succeeds with 0 errors.

- [ ] **Step 2: Verify by running the app**

Press F5 in Visual Studio or run IIS Express. Navigate to `/Registration`. Expected:
- Registration form displays with Name, Email, Password, Phone, Address fields
- Empty GridView shows "No registration records found."
- Submit with empty required fields shows validation errors
- Submit with valid data creates a record and shows it in the grid
- Edit button loads record into form, Submit updates it
- Delete button shows confirm dialog, then removes the record

- [ ] **Step 3: Commit all changes**

```bash
git add WAPP-W5/Web.config WAPP-W5/Registration.aspx WAPP-W5/Registration.aspx.cs WAPP-W5/Registration.aspx.designer.cs WAPP-W5/Site.Master WAPP-W5/WAPP-W5.csproj
git commit -m "feat: add Registration CRUD form with SQL Server LocalDB"
```
