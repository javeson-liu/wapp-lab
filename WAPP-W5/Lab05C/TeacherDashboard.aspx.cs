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
    public partial class TeacherDashboard : Page
    {
        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Session guard — only Teachers allowed
            if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "Teacher")
            {
                Response.Redirect("~/Lab05C/Login");
                return;
            }

            if (!IsPostBack)
            {
                LoadTeacherInfo();
                LoadStudents();
                LoadEnrollments();
            }
        }

        private void LoadTeacherInfo()
        {
            int teacherId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = "SELECT Name FROM Teachers WHERE TeacherID = @TeacherID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        lblWelcome.Text = "Welcome, " + result.ToString();
                    }
                }
            }
        }

        private void LoadStudents()
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();

                // Bind GridView
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

                // Bind DropDownList for grade assignment
                string sqlDdl = "SELECT StudentID, FirstName + ' ' + LastName AS FullName FROM Students ORDER BY FirstName";
                using (SqlCommand cmd = new SqlCommand(sqlDdl, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        ddlStudent.DataSource = dt;
                        ddlStudent.DataTextField = "FullName";
                        ddlStudent.DataValueField = "StudentID";
                        ddlStudent.DataBind();
                        ddlStudent.Items.Insert(0, new ListItem("-- Select Student --", ""));
                    }
                }
            }
        }

        private void LoadEnrollments()
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = @"SELECT s.FirstName + ' ' + s.LastName AS StudentName,
                                      g.CourseName, g.Grade, g.DateAssigned
                               FROM Grades g
                               INNER JOIN Students s ON g.StudentID = s.StudentID
                               ORDER BY g.DateAssigned DESC";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvEnrollments.DataSource = dt;
                        gvEnrollments.DataBind();
                    }
                }
            }
        }

        protected void btnAddStudent_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = @"INSERT INTO Students (FirstName, LastName, Email, Password, Role)
                               VALUES (@FirstName, @LastName, @Email, @Password, 'Student')";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@FirstName", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@LastName", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Email", txtStudentEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Password", HashPassword(txtStudentPassword.Text));
                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = "<div class='alert alert-success'>Student added successfully.</div>";
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtStudentEmail.Text = "";
            txtStudentPassword.Text = "";
            LoadStudents();
        }

        protected void gvStudents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteStudent")
            {
                int studentId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();

                    // Delete grades first (foreign key constraint)
                    string sqlGrades = "DELETE FROM Grades WHERE StudentID = @StudentID";
                    using (SqlCommand cmd = new SqlCommand(sqlGrades, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        cmd.ExecuteNonQuery();
                    }

                    // Delete the student
                    string sqlStudent = "DELETE FROM Students WHERE StudentID = @StudentID";
                    using (SqlCommand cmd = new SqlCommand(sqlStudent, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        cmd.ExecuteNonQuery();
                    }
                }

                lblMessage.Text = "<div class='alert alert-warning'>Student deleted.</div>";
                LoadStudents();
                LoadEnrollments();
            }
        }

        protected void btnAddGrade_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                string sql = @"INSERT INTO Grades (StudentID, CourseName, Grade)
                               VALUES (@StudentID, @CourseName, @Grade)";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", Convert.ToInt32(ddlStudent.SelectedValue));
                    cmd.Parameters.AddWithValue("@CourseName", txtCourseName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Grade", txtGrade.Text.Trim());
                    cmd.ExecuteNonQuery();
                }
            }

            lblMessage.Text = "<div class='alert alert-success'>Grade added successfully.</div>";
            txtCourseName.Text = "";
            txtGrade.Text = "";
            LoadEnrollments();
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
