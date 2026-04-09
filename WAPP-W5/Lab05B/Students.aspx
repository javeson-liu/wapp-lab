<%@ Page Title="Student Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Students.aspx.cs" Inherits="WAPP_W5.Students" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <h2 class="mt-3 mb-4">Student Management Form</h2>

        <%-- Status Message --%>
        <asp:Label ID="lblMessage" runat="server" CssClass="mb-3 d-block" />

        <%-- Hidden field to store selected StudentID --%>
        <asp:HiddenField ID="hfStudentID" runat="server" />

        <%-- Student Form --%>
        <div class="card mb-4">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="<%= txtFirstName.ClientID %>" class="form-label">First Name <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" MaxLength="50" />
                        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ControlToValidate="txtFirstName"
                            ErrorMessage="First name is required." CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    <div class="col-md-6">
                        <label for="<%= txtLastName.ClientID %>" class="form-label">Last Name <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" MaxLength="50" />
                        <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName"
                            ErrorMessage="Last name is required." CssClass="text-danger small" Display="Dynamic" />
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
                        <label for="<%= txtEnrollmentDate.ClientID %>" class="form-label">Enrollment Date</label>
                        <asp:TextBox ID="txtEnrollmentDate" runat="server" CssClass="form-control" TextMode="Date" />
                    </div>
                    <div class="col-12">
                        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary me-2" OnClick="btnSave_Click" />
                        <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-warning me-2" OnClick="btnUpdate_Click" />
                        <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-danger me-2" OnClick="btnDelete_Click"
                            CausesValidation="false" OnClientClick="return confirm('Are you sure you want to delete this student?');" />
                        <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-secondary" OnClick="btnClear_Click" CausesValidation="false" />
                    </div>
                </div>
            </div>
        </div>

        <%-- Student Records Grid --%>
        <h4>Student Records</h4>
        <asp:GridView ID="gvStudents" runat="server" AutoGenerateColumns="false"
            CssClass="table table-striped table-bordered" DataKeyNames="StudentID"
            OnSelectedIndexChanged="gvStudents_SelectedIndexChanged">
            <Columns>
                <asp:CommandField ShowSelectButton="True" SelectText="Select" />
                <asp:BoundField DataField="StudentID" HeaderText="ID" ReadOnly="true" />
                <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="EnrollmentDate" HeaderText="Enrollment Date" DataFormatString="{0:yyyy-MM-dd}" />
            </Columns>
            <EmptyDataTemplate>
                <p class="text-muted p-3">No student records found.</p>
            </EmptyDataTemplate>
        </asp:GridView>
    </main>
</asp:Content>
