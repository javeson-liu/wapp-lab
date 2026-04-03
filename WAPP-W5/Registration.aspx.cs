using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WAPP_W5
{
    public partial class Registration : Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString; }
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
                    cmd.Parameters.AddWithValue("@Password", HashPassword(txtPassword.Text));
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
                    cmd.Parameters.AddWithValue("@Password", HashPassword(txtPassword.Text));
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
                            txtPassword.Attributes["value"] = "";
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

        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
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
