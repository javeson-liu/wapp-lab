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
