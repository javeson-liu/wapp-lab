using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;

namespace WAPP_W5
{
    public partial class StudentDashboard : Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Session guard — only Students allowed
            if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "Student")
            {
                Response.Redirect("~/Lab05C/Login");
                return;
            }

            if (!IsPostBack)
            {
                LoadStudentInfo();
                LoadGrades();
            }
        }

        private void LoadStudentInfo()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = "SELECT FirstName, LastName, Email FROM Students WHERE StudentID = @StudentID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblWelcome.Text = "Welcome, " + reader["FirstName"].ToString() + " " + reader["LastName"].ToString();
                            txtFirstName.Text = reader["FirstName"].ToString();
                            txtLastName.Text = reader["LastName"].ToString();
                            txtEmail.Text = reader["Email"].ToString();
                        }
                    }
                }
            }
        }

        private void LoadGrades()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = "SELECT CourseName, Grade, DateAssigned FROM Grades WHERE StudentID = @StudentID ORDER BY DateAssigned DESC";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvGrades.DataSource = dt;
                        gvGrades.DataBind();
                    }
                }
            }
        }

        protected void btnUpdateInfo_Click(object sender, EventArgs e)
        {
            int studentId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();

                // If password field is filled, update password too
                string sql;
                if (!string.IsNullOrEmpty(txtPassword.Text))
                {
                    sql = @"UPDATE Students
                            SET FirstName = @FirstName, LastName = @LastName, Email = @Email, Password = @Password
                            WHERE StudentID = @StudentID";
                }
                else
                {
                    sql = @"UPDATE Students
                            SET FirstName = @FirstName, LastName = @LastName, Email = @Email
                            WHERE StudentID = @StudentID";
                }

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    if (!string.IsNullOrEmpty(txtPassword.Text))
                    {
                        cmd.Parameters.AddWithValue("@Password", HashPassword(txtPassword.Text));
                    }
                    cmd.ExecuteNonQuery();
                }
            }

            Session["UserName"] = txtFirstName.Text.Trim();
            lblMessage.Text = "<div class='alert alert-success'>Your information has been updated.</div>";
            lblWelcome.Text = "Welcome, " + txtFirstName.Text.Trim() + " " + txtLastName.Text.Trim();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Lab05C/Login");
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
