using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace WAPP_W5
{
    public partial class Login : Page
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
            }
        }

        private void EnsureDatabaseExists()
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();

                // Ensure Students table exists (may already be created by Lab 05B)
                string sqlStudents = @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Students')
                    CREATE TABLE Students (
                        StudentID INT PRIMARY KEY IDENTITY(1,1),
                        FirstName NVARCHAR(50) NOT NULL,
                        LastName NVARCHAR(50) NOT NULL,
                        Email NVARCHAR(200) NOT NULL,
                        Password NVARCHAR(100) NOT NULL,
                        EnrollmentDate DATE DEFAULT GETDATE()
                    )";
                using (SqlCommand cmd = new SqlCommand(sqlStudents, conn))
                {
                    cmd.ExecuteNonQuery();
                }

                // Add Role column to Students if it doesn't exist
                string sqlRole = @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_NAME = 'Students' AND COLUMN_NAME = 'Role')
                    ALTER TABLE Students ADD Role NVARCHAR(20) DEFAULT 'Student'";
                using (SqlCommand cmd = new SqlCommand(sqlRole, conn))
                {
                    cmd.ExecuteNonQuery();
                }

                // Create Teachers table
                string sqlTeachers = @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Teachers')
                    CREATE TABLE Teachers (
                        TeacherID INT PRIMARY KEY IDENTITY(1,1),
                        Name NVARCHAR(100) NOT NULL,
                        Email NVARCHAR(200) NOT NULL,
                        Password NVARCHAR(100) NOT NULL
                    )";
                using (SqlCommand cmd = new SqlCommand(sqlTeachers, conn))
                {
                    cmd.ExecuteNonQuery();
                }

                // Create Grades table
                string sqlGrades = @"IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Grades')
                    CREATE TABLE Grades (
                        GradeID INT PRIMARY KEY IDENTITY(1,1),
                        StudentID INT NOT NULL FOREIGN KEY REFERENCES Students(StudentID),
                        CourseName NVARCHAR(100) NOT NULL,
                        Grade NVARCHAR(2) NOT NULL,
                        DateAssigned DATETIME DEFAULT GETDATE()
                    )";
                using (SqlCommand cmd = new SqlCommand(sqlGrades, conn))
                {
                    cmd.ExecuteNonQuery();
                }

                // Seed default teacher account
                string sqlSeed = @"IF NOT EXISTS (SELECT 1 FROM Teachers WHERE Email = 'admin@school.com')
                    INSERT INTO Teachers (Name, Email, Password)
                    VALUES ('Admin Teacher', 'admin@school.com', @Password)";
                using (SqlCommand cmd = new SqlCommand(sqlSeed, conn))
                {
                    cmd.Parameters.AddWithValue("@Password", HashPassword("password123"));
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string email = txtEmail.Text.Trim();
            string hashedPassword = HashPassword(txtPassword.Text);

            // Try Student login first
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = "SELECT StudentID, FirstName FROM Students WHERE Email = @Email AND Password = @Password";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            Session["UserID"] = reader["StudentID"].ToString();
                            Session["Role"] = "Student";
                            Session["UserName"] = reader["FirstName"].ToString();
                            Response.Redirect("~/Lab05C/StudentDashboard");
                            return;
                        }
                    }
                }
            }

            // Try Teacher login
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = "SELECT TeacherID, Name FROM Teachers WHERE Email = @Email AND Password = @Password";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            Session["UserID"] = reader["TeacherID"].ToString();
                            Session["Role"] = "Teacher";
                            Session["UserName"] = reader["Name"].ToString();
                            Response.Redirect("~/Lab05C/TeacherDashboard");
                            return;
                        }
                    }
                }
            }

            lblMessage.Text = "<div class='alert alert-danger'>Invalid email or password.</div>";
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
    }
}
