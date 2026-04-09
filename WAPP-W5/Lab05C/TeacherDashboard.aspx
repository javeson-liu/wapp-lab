<%@ Page Title="Teacher Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TeacherDashboard.aspx.cs" Inherits="WAPP_W5.TeacherDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <div class="d-flex justify-content-between align-items-center mt-3 mb-4">
            <h2>Teacher Dashboard</h2>
            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-outline-dark" OnClick="btnLogout_Click" CausesValidation="false" />
        </div>

        <asp:Label ID="lblWelcome" runat="server" CssClass="h5 d-block mb-4" />

        <%-- Status Message --%>
        <asp:Label ID="lblMessage" runat="server" CssClass="mb-3 d-block" />

        <%-- Add Student Section --%>
        <div class="card mb-4">
            <div class="card-header"><strong>Add Student</strong></div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label for="<%= txtFirstName.ClientID %>" class="form-label">First Name <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" MaxLength="50" ValidationGroup="AddStudent" />
                        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName"
                            ErrorMessage="Required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="AddStudent" />
                    </div>
                    <div class="col-md-3">
                        <label for="<%= txtLastName.ClientID %>" class="form-label">Last Name <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" MaxLength="50" ValidationGroup="AddStudent" />
                        <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName"
                            ErrorMessage="Required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="AddStudent" />
                    </div>
                    <div class="col-md-3">
                        <label for="<%= txtStudentEmail.ClientID %>" class="form-label">Email <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtStudentEmail" runat="server" CssClass="form-control" TextMode="Email" MaxLength="200" ValidationGroup="AddStudent" />
                        <asp:RequiredFieldValidator ID="rfvStudentEmail" runat="server" ControlToValidate="txtStudentEmail"
                            ErrorMessage="Required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="AddStudent" />
                    </div>
                    <div class="col-md-3">
                        <label for="<%= txtStudentPassword.ClientID %>" class="form-label">Password <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtStudentPassword" runat="server" CssClass="form-control" TextMode="Password" MaxLength="100" ValidationGroup="AddStudent" />
                        <asp:RequiredFieldValidator ID="rfvStudentPassword" runat="server" ControlToValidate="txtStudentPassword"
                            ErrorMessage="Required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="AddStudent" />
                    </div>
                    <div class="col-12">
                        <asp:Button ID="btnAddStudent" runat="server" Text="Add Student" CssClass="btn btn-primary" OnClick="btnAddStudent_Click" ValidationGroup="AddStudent" />
                    </div>
                </div>
            </div>
        </div>

        <%-- Student List Section --%>
        <div class="card mb-4">
            <div class="card-header"><strong>Student List</strong></div>
            <div class="card-body">
                <asp:GridView ID="gvStudents" runat="server" AutoGenerateColumns="false"
                    CssClass="table table-striped table-bordered" DataKeyNames="StudentID"
                    OnRowCommand="gvStudents_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="StudentID" HeaderText="ID" ReadOnly="true" />
                        <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                        <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="EnrollmentDate" HeaderText="Enrollment Date" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnDeleteStudent" runat="server" CommandName="DeleteStudent"
                                    CommandArgument='<%# Eval("StudentID") %>' CssClass="btn btn-sm btn-danger"
                                    CausesValidation="false"
                                    OnClientClick="return confirm('Are you sure you want to delete this student?');">
                                    Delete
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <p class="text-muted p-3">No students found.</p>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

        <%-- Add Grade Section --%>
        <div class="card mb-4">
            <div class="card-header"><strong>Add Grade</strong></div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label for="<%= ddlStudent.ClientID %>" class="form-label">Student <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlStudent" runat="server" CssClass="form-select" />
                        <asp:RequiredFieldValidator ID="rfvStudent" runat="server" ControlToValidate="ddlStudent"
                            InitialValue="" ErrorMessage="Select a student." CssClass="text-danger small" Display="Dynamic" ValidationGroup="AddGrade" />
                    </div>
                    <div class="col-md-4">
                        <label for="<%= txtCourseName.ClientID %>" class="form-label">Course Name <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtCourseName" runat="server" CssClass="form-control" MaxLength="100" ValidationGroup="AddGrade" />
                        <asp:RequiredFieldValidator ID="rfvCourseName" runat="server" ControlToValidate="txtCourseName"
                            ErrorMessage="Required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="AddGrade" />
                    </div>
                    <div class="col-md-2">
                        <label for="<%= txtGrade.ClientID %>" class="form-label">Grade <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtGrade" runat="server" CssClass="form-control" MaxLength="2" ValidationGroup="AddGrade" />
                        <asp:RequiredFieldValidator ID="rfvGrade" runat="server" ControlToValidate="txtGrade"
                            ErrorMessage="Required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="AddGrade" />
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <asp:Button ID="btnAddGrade" runat="server" Text="Add Grade" CssClass="btn btn-success" OnClick="btnAddGrade_Click" ValidationGroup="AddGrade" />
                    </div>
                </div>
            </div>
        </div>

        <%-- View Enrollment Details Section --%>
        <div class="card mb-4">
            <div class="card-header"><strong>Student Enrollment Details</strong></div>
            <div class="card-body">
                <asp:GridView ID="gvEnrollments" runat="server" AutoGenerateColumns="false"
                    CssClass="table table-striped table-bordered">
                    <Columns>
                        <asp:BoundField DataField="StudentName" HeaderText="Student" />
                        <asp:BoundField DataField="CourseName" HeaderText="Course" />
                        <asp:BoundField DataField="Grade" HeaderText="Grade" />
                        <asp:BoundField DataField="DateAssigned" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                    </Columns>
                    <EmptyDataTemplate>
                        <p class="text-muted p-3">No enrollment details found.</p>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </main>
</asp:Content>
