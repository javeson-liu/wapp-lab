<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WAPP_W5.Login" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main>
        <div class="row justify-content-center mt-5">
            <div class="col-md-5">
                <h2 class="mb-4 text-center">Login</h2>

                <%-- Status Message --%>
                <asp:Label ID="lblMessage" runat="server" CssClass="mb-3 d-block" />

                <div class="card">
                    <div class="card-body">
                        <div class="mb-3">
                            <label for="<%= txtEmail.ClientID %>" class="form-label">Email <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" MaxLength="200" />
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                                ErrorMessage="Email is required." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <div class="mb-3">
                            <label for="<%= txtPassword.ClientID %>" class="form-label">Password <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" MaxLength="100" />
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                                ErrorMessage="Password is required." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary w-100" OnClick="btnLogin_Click" />
                    </div>
                </div>

                <p class="text-muted text-center mt-3">
                    <small>Default teacher account: admin@school.com / password123</small>
                </p>
            </div>
        </div>
    </main>
</asp:Content>
