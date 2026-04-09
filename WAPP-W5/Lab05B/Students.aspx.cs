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
    public partial class Students : Page
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
                LoadStudents();
            }
        }

        private void EnsureDatabaseExists()
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Students')
                    CREATE TABLE Students (
                        StudentID INT PRIMARY KEY IDENTITY(1,1),
                        FirstName NVARCHAR(50) NOT NULL,
                        LastName NVARCHAR(50) NOT NULL,
                        Email NVARCHAR(200) NOT NULL,
                        Password NVARCHAR(100) NOT NULL,
                        EnrollmentDate DATE DEFAULT GETDATE()
                    )";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void LoadStudents()
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = "SELECT StudentID, FirstName, LastName, Email, EnrollmentDate FROM Students ORDER BY StudentID DESC";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvStudents.DataSource = dt;
                        gvStudents.DataBind();
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = @"INSERT INTO Students (FirstName, LastName, Email, Password, EnrollmentDate)
                               VALUES (@FirstName, @LastName, @Email, @Password, @EnrollmentDate)";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Password", HashPassword(txtPassword.Text));
                    cmd.Parameters.AddWithValue("@EnrollmentDate",
                        string.IsNullOrEmpty(txtEnrollmentDate.Text) ? (object)DBNull.Value : DateTime.Parse(txtEnrollmentDate.Text));
                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = "<div class='alert alert-success'>Student saved successfully.</div>";
            ClearForm();
            LoadStudents();
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            if (string.IsNullOrEmpty(hfStudentID.Value))
            {
                lblMessage.Text = "<div class='alert alert-danger'>Please select a student to update.</div>";
                return;
            }

            int id = Convert.ToInt32(hfStudentID.Value);

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = @"UPDATE Students
                               SET FirstName = @FirstName, LastName = @LastName, Email = @Email,
                                   Password = @Password, EnrollmentDate = @EnrollmentDate
                               WHERE StudentID = @StudentID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", id);
                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Password", HashPassword(txtPassword.Text));
                    cmd.Parameters.AddWithValue("@EnrollmentDate",
                        string.IsNullOrEmpty(txtEnrollmentDate.Text) ? (object)DBNull.Value : DateTime.Parse(txtEnrollmentDate.Text));
                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = "<div class='alert alert-info'>Student updated successfully.</div>";
            ClearForm();
            LoadStudents();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hfStudentID.Value))
            {
                lblMessage.Text = "<div class='alert alert-danger'>Please select a student to delete.</div>";
                return;
            }

            int id = Convert.ToInt32(hfStudentID.Value);

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = "DELETE FROM Students WHERE StudentID = @StudentID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", id);
                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = "<div class='alert alert-warning'>Student deleted.</div>";
            ClearForm();
            LoadStudents();
        }

        protected void gvStudents_SelectedIndexChanged(object sender, EventArgs e)
        {
            GridViewRow row = gvStudents.SelectedRow;
            hfStudentID.Value = gvStudents.DataKeys[gvStudents.SelectedIndex].Value.ToString();
            txtFirstName.Text = row.Cells[2].Text;
            txtLastName.Text = row.Cells[3].Text;
            txtEmail.Text = row.Cells[4].Text;
            txtEnrollmentDate.Text = row.Cells[5].Text;
            lblMessage.Text = "<div class='alert alert-info'>Student #" + hfStudentID.Value + " selected. Modify the fields and click Update.</div>";
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
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            txtEnrollmentDate.Text = "";
            hfStudentID.Value = "";
            lblMessage.Text = "";
        }
    }
}
