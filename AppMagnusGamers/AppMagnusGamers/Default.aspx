<%@ Page Title="Catálogo - Magnus Gamers" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="AppMagnusGamers._Default" ResponseEncoding="utf-8" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <main class="py-4">
            <div class="row mb-4">
                <div class="col-12 text-center">
                    <h1 class="display-5 fw-bold text-primary">Cat&aacute;logo Magnus Gamers</h1>
                    <p class="lead text-muted">Listado de art&iacute;culos.</p>
                </div>
            </div>

            <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block mb-4" Visible="false">
            </asp:Label>

            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
                <asp:Repeater ID="repArticulos" runat="server">
                    <ItemTemplate>
                        <div class="col">
                            <div class="card h-100 shadow-sm border-0">
                                <div class="card-body d-flex flex-column">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="badge bg-secondary">#<%# Eval("IdArticulo") %></span>
                                        <div>
                                            <span class="badge bg-info text-dark">
                                                <%# Eval("Categoria.Nombre") %>
                                            </span>
                                            <span class="badge bg-dark">
                                                <%# Eval("Marca.Nombre") %>
                                            </span>
                                        </div>
                                    </div>
                                    <h5 class="card-title text-dark fw-bold mb-2">
                                        <%# Eval("Nombre") %>
                                    </h5>
                                    <p class="card-text text-muted flex-grow-1">
                                        <%# Eval("Descripcion") %>
                                    </p>
                                    <div class="mt-3 pt-2 border-top d-flex justify-content-between align-items-center">
                                        <span class="badge bg-success">Activo</span>
                                        <a href="#" class="btn btn-outline-primary btn-sm">Ver Detalle</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </main>
    </asp:Content>