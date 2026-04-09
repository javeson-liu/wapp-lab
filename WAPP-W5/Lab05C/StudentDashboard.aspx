<%@ Page Title="Student Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="WAPP_W5.StudentDashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <div class="d-flex justify-content-between align-items-center mt-3 mb-4">
            <h2>Student Dashboard</h2>
            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-outline-dark" OnClick="btnLogout_Click" CausesValidation="false" />
        </div>

        <asp:Label ID="lblWelcome" runat="server" CssClass="h5 d-block mb-4" />

        <%-- Status Message --%>
        <asp:Label ID="lblMessage" runat="server" CssClass="mb-3 d-block" />

        <%-- My Grades Section --%>
        <div class="card mb-4">
            <div class="card-header"><strong>My Grades</strong></div>
            <div class="card-body">
                <asp:GridView ID="gvGrades" runat="server" AutoGenerateColumns="false"
                    CssClass="table table-striped table-bordered">
                    <Columns>
                        <asp:BoundField DataField="CourseName" HeaderText="Course" />
                        <asp:BoundField DataField="Grade" HeaderText="Grade" />
                        <asp:BoundField DataField="DateAssigned" HeaderText="Date Assigned" DataFormatString="{0:yyyy-MM-dd}" />
                    </Columns>
                    <EmptyDataTemplate>
                        <p class="text-muted p-3">No grades recorded yet.</p>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

        <%-- Modify Personal Info Section --%>
        <div class="card mb-4">
            <div class="card-header"><strong>Modify Personal Information</strong></div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="<%= txtFirstName.ClientID %>" class="form-label">First Name</label>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" MaxLength="50" />
                    </div>
                    <div class="col-md-6">
                        <label for="<%= txtLastName.ClientID %>" class="form-label">Last Name</label>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" MaxLength="50" />
                    </div>
                    <div class="col-md-6">
                        <label for="<%= txtEmail.ClientID %>" class="form-label">Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" MaxLength="200" />
                    </div>
                    <div class="col-md-6">
                        <label for="<%= txtPassword.ClientID %>" class="form-label">New Password <small class="text-muted">(leave blank to keep current)</small></label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" MaxLength="100" />
                    </div>
                    <div class="col-12">
                        <asp:Button ID="btnUpdateInfo" runat="server" Text="Update My Info" CssClass="btn btn-primary" OnClick="btnUpdateInfo_Click" CausesValidation="false" />
                    </div>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
