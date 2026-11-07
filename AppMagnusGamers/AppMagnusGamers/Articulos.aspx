<%@ Page Title="Gestión de Artículos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Articulos.aspx.cs" Inherits="AppMagnusGamers.Articulos" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container-fluid py-3">
            <div id="toastAlerta"
                class="alert alert-dismissible fade d-none position-fixed top-0 end-0 m-3 shadow-lg z-3" role="alert"
                style="min-width: 320px; z-index: 1060;">
                <span id="toastMensaje"></span>
                <button type="button" class="btn-close" onclick="cerrarAlerta()" aria-label="Close"></button>
            </div>

            <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block mb-3" Visible="false">
            </asp:Label>

            <div class="row align-items-center mb-3">
                <div class="col-md-7">
                    <h2 class="fw-bold mb-1 text-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" fill="currentColor"
                            class="bi bi-box-seam me-2" viewBox="0 0 16 16">
                            <path
                                d="M8.186 1.113a.5.5 0 0 0-.372 0L1.846 3.5l2.404.961L10.404 2l-2.218-.887zm3.564 1.426L5.596 5 8 5.961 14.154 3.5l-2.404-.961zm3.25 1.7-6.5 2.6v7.922l6.5-2.6V4.24zM7.5 14.762V6.838L1 4.239v7.923l6.5 2.6zM7.443.184a1.5 1.5 0 0 1 1.114 0l7.129 2.852A.5.5 0 0 1 16 3.5v8.662a1 1 0 0 1-.629.928l-7.185 2.874a.5.5 0 0 1-.372 0L.63 13.09a1 1 0 0 1-.63-.928V3.5a.5.5 0 0 1 .314-.464L7.443.184z" />
                        </svg>Gestión de Artículos e Inventario
                    </h2>
                    <p class="text-muted mb-0">Administración simplificada del catálogo de modelos y control de stock
                        físico</p>
                </div>
                <div class="col-md-5 text-md-end mt-3 mt-md-0">
                    <button type="button" class="btn btn-success btn-lg shadow-sm px-4 fw-semibold"
                        onclick="abrirModalNuevoArticulo()">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor"
                            class="bi bi-plus-circle me-1" viewBox="0 0 16 16">
                            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z" />
                            <path
                                d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z" />
                        </svg>+ Agregar Artículo
                    </button>
                </div>
            </div>

            <div class="card shadow-sm border-0 mb-4 bg-light">
                <div class="card-body p-3">
                    <div class="row g-2 align-items-center">
                        <div class="col-12 col-md-8">
                            <div class="input-group">
                                <span class="input-group-text bg-white border-end-0 text-primary">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="currentColor"
                                        class="bi bi-search" viewBox="0 0 16 16">
                                        <path
                                            d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z" />
                                    </svg>
                                </span>
                                <input type="text" id="txtBuscarArticulo" class="form-control border-start-0"
                                    placeholder="Buscar por nombre de artículo o marca..." autocomplete="off"
                                    onkeyup="filtrarTablaArticulos()" />
                                <button class="btn btn-outline-secondary border-start-0 bg-white" type="button"
                                    onclick="limpiarFiltro()" title="Limpiar búsqueda">✕</button>
                            </div>
                        </div>
                        <div class="col-12 col-md-4 text-md-end text-muted small">
                            Total en catálogo: <strong id="lblTotalArticulos" class="text-dark">
                                <%= TotalArticulos %>
                            </strong> modelos activos
                        </div>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm border-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0" id="tablaArticulos">
                        <thead class="table-dark">
                            <tr>
                                <th scope="col" style="min-width: 250px;">Artículo</th>
                                <th scope="col" style="min-width: 140px;">Marca</th>
                                <th scope="col" class="text-end" style="min-width: 150px;">Precio de Venta</th>
                                <th scope="col" class="text-center" style="min-width: 140px;">Stock Disponible</th>
                                <th scope="col" class="text-end" style="min-width: 200px;">Acciones</th>
                            </tr>
                        </thead>
                        <tbody id="tbodyArticulos">
                            <asp:Repeater ID="repArticulos" runat="server">
                                <ItemTemplate>
                                    <tr class="fila-articulo" data-id='<%# Eval("ID_Articulo") %>'
                                        data-nombre='<%# ObtenerTextoSeguro(Eval("Nombre")) %>'
                                        data-descripcion='<%# ObtenerTextoSeguro(Eval("Descripcion")) %>'
                                        data-id-marca='<%# Eval("ID_Marca") %>'
                                        data-marca='<%# ObtenerTextoSeguro(Eval("MarcaNombre")) %>'
                                        data-id-categoria='<%# Eval("ID_Categoria") %>'
                                        data-categoria='<%# ObtenerTextoSeguro(Eval("CategoriaNombre")) %>'
                                        data-stock='<%# Eval("StockDisponible") %>'
                                        data-precio='<%# Eval("PrecioVenta") %>'>
                                        <td>
                                            <div class="fw-bold text-dark fs-6">
                                                <%# Eval("Nombre") %>
                                            </div>
                                            <div class="text-muted small text-truncate" style="max-width: 320px;">
                                                <%# Eval("Descripcion") %>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark border px-2 py-1">
                                                <%# Eval("MarcaNombre") %>
                                            </span>
                                        </td>
                                        <td class="text-end fw-bold text-success fs-6">
                                            <%# FormatearPrecio(Eval("PrecioVenta")) %>
                                        </td>
                                        <td class="text-center">
                                            <%# ObtenerBadgeStock(Eval("StockDisponible")) %>
                                        </td>
                                        <td class="text-end text-nowrap">
                                            <button type="button" class="btn btn-outline-primary btn-sm me-1 px-2"
                                                title="Editar datos del artículo y precio"
                                                onclick="abrirModalEditar(this)">
                                                ✏️ Editar
                                            </button>
                                            <button type="button" class="btn btn-primary btn-sm me-1 px-2"
                                                title="Ingresar nuevas unidades físicas y unificar precio"
                                                onclick="abrirModalStock(this)">
                                                📦 + Stock
                                            </button>
                                            <button type="button" class="btn btn-outline-danger btn-sm px-2"
                                                title="Dar de baja artículo" onclick="abrirModalBaja(this)">
                                                🗑️
                                            </button>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
                <div id="divSinResultados" class="text-center py-5 d-none text-muted">
                    <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="currentColor"
                        class="bi bi-inbox mb-3 text-secondary" viewBox="0 0 16 16">
                        <path
                            d="M4.98 4a.5.5 0 0 0-.39.188L1.54 8H6a.5.5 0 0 1 .5.5 1.5 1.5 0 1 0 3 0A.5.5 0 0 1 10 8h4.46l-3.05-3.812A.5.5 0 0 0 11.02 4H4.98zm-1.17-.437A1.5 1.5 0 0 1 4.98 3h6.04a1.5 1.5 0 0 1 1.17.563l3.7 4.625a1 1 0 0 1 .11.812l-1.5 6A1 1 0 0 1 13.52 16H2.48a1 1 0 0 1-.97-.799l-1.5-6a1 1 0 0 1 .11-.813l3.69-4.625zM2.08 9l1.25 5h9.34l1.25-5H10.5a2.5 2.5 0 0 1-5 0H2.08z" />
                    </svg>
                    <h5>No se encontraron artículos activos</h5>
                    <p class="small mb-0">Prueba ajustando el texto de búsqueda o agrega un nuevo artículo.</p>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalNuevoArticulo" tabindex="-1" aria-labelledby="modalNuevoArticuloLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow border-0">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title fw-bold" id="modalNuevoArticuloLabel">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor"
                                class="bi bi-plus-square me-1" viewBox="0 0 16 16">
                                <path
                                    d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z" />
                                <path
                                    d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z" />
                            </svg>Nuevo Artículo en Catálogo
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Nombre del Artículo <span
                                    class="text-danger">*</span></label>
                            <input type="text" id="txtNuevoNombre" class="form-control"
                                placeholder="Ej: PlayStation 5 Slim 1TB" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Descripción</label>
                            <textarea id="txtNuevaDescripcion" class="form-control" rows="2"
                                placeholder="Detalles generales del modelo o versión..."></textarea>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Marca <span class="text-danger">*</span></label>
                                <select id="ddlNuevaMarca" class="form-select">
                                    <option value="">-- Seleccionar --</option>
                                    <% foreach (var m in ListaMarcas) { %>
                                        <option value="<%= m.IdMarca %>">
                                            <%= m.Nombre %>
                                        </option>
                                        <% } %>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Categoría <span
                                        class="text-danger">*</span></label>
                                <select id="ddlNuevaCategoria" class="form-select">
                                    <option value="">-- Seleccionar --</option>
                                    <% foreach (var c in ListaCategorias) { %>
                                        <option value="<%= c.IdCategoria %>">
                                            <%= c.Nombre %>
                                        </option>
                                        <% } %>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-outline-secondary"
                            data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-success fw-semibold px-4" id="btnGuardarNuevo"
                            onclick="guardarNuevoArticulo()">Guardar Artículo</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalAgregarStock" tabindex="-1" aria-labelledby="modalAgregarStockLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow border-0">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold" id="modalAgregarStockLabel">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor"
                                class="bi bi-box-arrow-in-down me-1" viewBox="0 0 16 16">
                                <path fill-rule="evenodd"
                                    d="M3.5 6a.5.5 0 0 0-.5.5v8a.5.5 0 0 0 .5.5h9a.5.5 0 0 0 .5-.5v-8a.5.5 0 0 0-.5-.5h-2a.5.5 0 0 1 0-1h2A1.5 1.5 0 0 1 14 6.5v8a1.5 1.5 0 0 1-1.5 1.5h-9A1.5 1.5 0 0 1 2 14.5v-8A1.5 1.5 0 0 1 3.5 5h2a.5.5 0 0 1 0 1h-2z" />
                                <path fill-rule="evenodd"
                                    d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z" />
                            </svg>Ingresar Stock Físico
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="p-3 bg-light rounded border mb-3">
                            <div class="small text-muted text-uppercase fw-semibold">Artículo seleccionado:</div>
                            <div class="h5 fw-bold text-dark mb-0" id="lblStockNombreArticulo">-</div>
                            <div class="small text-secondary" id="lblStockMarcaArticulo">-</div>
                        </div>

                        <input type="hidden" id="hdnStockIdArticulo" value="0" />

                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Cantidad a Ingresar <span
                                        class="text-danger">*</span></label>
                                <input type="number" id="txtStockCantidad" class="form-control" min="1" max="999"
                                    value="1" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Condición <span
                                        class="text-danger">*</span></label>
                                <select id="ddlStockCondicion" class="form-select">
                                    <option value="nuevo">Nuevo</option>
                                    <option value="seminuevo">Seminuevo</option>
                                    <option value="usado">Usado</option>
                                    <option value="reacondicionado">Reacondicionado</option>
                                </select>
                            </div>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Nuevo Precio Venta ($) <span
                                        class="text-danger">*</span></label>
                                <input type="number" id="txtStockPrecioVenta" class="form-control" step="0.01" min="1"
                                    placeholder="Ej: 750000" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Precio Compra ($) <span
                                        class="text-muted small">(opc.)</span></label>
                                <input type="number" id="txtStockPrecioCompra" class="form-control" step="0.01" min="0"
                                    placeholder="Ej: 500000" />
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Detalles / Observaciones <span
                                    class="text-muted small">(opc.)</span></label>
                            <input type="text" id="txtStockDetalles" class="form-control"
                                placeholder="Ej: Sellado en caja, garantía 12 meses..." />
                        </div>

                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-outline-secondary"
                            data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-primary fw-semibold px-4" id="btnGuardarStock"
                            onclick="guardarStock()">Confirmar Ingreso</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalEditarArticulo" tabindex="-1" aria-labelledby="modalEditarArticuloLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow border-0">
                    <div class="modal-header bg-dark text-white">
                        <h5 class="modal-title fw-bold" id="modalEditarArticuloLabel">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor"
                                class="bi bi-pencil-square me-1" viewBox="0 0 16 16">
                                <path
                                    d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z" />
                                <path fill-rule="evenodd"
                                    d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z" />
                            </svg>Editar Artículo
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" id="hdnEditarIdArticulo" value="0" />

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Nombre del Artículo <span
                                    class="text-danger">*</span></label>
                            <input type="text" id="txtEditarNombre" class="form-control" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Descripción</label>
                            <textarea id="txtEditarDescripcion" class="form-control" rows="2"></textarea>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Marca <span class="text-danger">*</span></label>
                                <select id="ddlEditarMarca" class="form-select">
                                    <option value="">-- Seleccionar --</option>
                                    <% foreach (var m in ListaMarcas) { %>
                                        <option value="<%= m.IdMarca %>">
                                            <%= m.Nombre %>
                                        </option>
                                        <% } %>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Categoría <span
                                        class="text-danger">*</span></label>
                                <select id="ddlEditarCategoria" class="form-select">
                                    <option value="">-- Seleccionar --</option>
                                    <% foreach (var c in ListaCategorias) { %>
                                        <option value="<%= c.IdCategoria %>">
                                            <%= c.Nombre %>
                                        </option>
                                        <% } %>
                                </select>
                            </div>
                        </div>

                        <div class="card border-primary-subtle bg-light mb-0">
                            <div class="card-body p-3">
                                <div class="form-check form-switch mb-2">
                                    <input class="form-check-input" type="checkbox" id="chkActualizarPrecio"
                                        onchange="toggleActualizarPrecio()" />
                                    <label class="form-check-label fw-bold text-primary" for="chkActualizarPrecio">
                                        ¿Actualizar Precio de Venta en stock disponible?
                                    </label>
                                </div>

                                <div id="seccionNuevoPrecio" class="d-none mt-2">
                                    <div class="row g-2">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold">Condición a afectar</label>
                                            <select id="ddlEditarCondicion" class="form-select form-select-sm">
                                                <option value="nuevo">Nuevo</option>
                                                <option value="seminuevo">Seminuevo</option>
                                                <option value="usado">Usado</option>
                                                <option value="reacondicionado">Reacondicionado</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold">Nuevo Precio de Venta
                                                ($)</label>
                                            <input type="number" id="txtEditarPrecioVenta"
                                                class="form-control form-control-sm" step="0.01" min="1"
                                                placeholder="Ej: 780000" />
                                        </div>
                                    </div>
                                    <div class="text-muted small mt-2">
                                        💡 Se actualizará el precio de todas las unidades disponibles con esa condición
                                        sin generar stock adicional.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-outline-secondary"
                            data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-primary fw-semibold px-4" id="btnGuardarEditar"
                            onclick="guardarEdicion()">Guardar Cambios</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalBajaArticulo" tabindex="-1" aria-labelledby="modalBajaArticuloLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow border-0">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title fw-bold" id="modalBajaArticuloLabel">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor"
                                class="bi bi-exclamation-triangle me-1" viewBox="0 0 16 16">
                                <path
                                    d="M7.938 2.016A.13.13 0 0 1 8.002 2a.13.13 0 0 1 .063.016.146.146 0 0 1 .054.057l6.857 11.667c.036.06.035.124.002.183a.163.163 0 0 1-.054.06.116.116 0 0 1-.066.017H1.146a.115.115 0 0 1-.066-.017.163.163 0 0 1-.054-.06.176.176 0 0 1 .002-.183L7.884 2.073a.147.147 0 0 1 .054-.057zm1.044-.45a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566z" />
                                <path
                                    d="M7.002 12a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 5.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995z" />
                            </svg>Dar de Baja Artículo
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" id="hdnBajaIdArticulo" value="0" />
                        <p class="mb-2">¿Estás seguro de que deseas dar de baja el artículo <strong
                                id="lblBajaNombreArticulo"></strong>?</p>

                        <div id="seccionBajaConStock" class="alert alert-warning py-3 mt-3 d-none">
                            <div class="fw-bold mb-1">⚠️ Advertencia de Stock Asociado</div>
                            <p class="mb-2 small">Este artículo cuenta actualmente con <strong
                                    id="lblBajaStockCount">0</strong> unidad(es) física(s) disponibles en el inventario.
                            </p>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="chkBajaCascada" checked />
                                <label class="form-check-label small fw-semibold" for="chkBajaCascada">
                                    Dar de baja también todas sus unidades físicas en cascada (recomendado)
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-outline-secondary"
                            data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-danger fw-semibold px-4" id="btnConfirmarBaja"
                            onclick="confirmarBaja()">Confirmar Baja</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            var bsModalNuevo, bsModalStock, bsModalEditar, bsModalBaja;

            document.addEventListener('DOMContentLoaded', function () {
                bsModalNuevo = new bootstrap.Modal(document.getElementById('modalNuevoArticulo'));
                bsModalStock = new bootstrap.Modal(document.getElementById('modalAgregarStock'));
                bsModalEditar = new bootstrap.Modal(document.getElementById('modalEditarArticulo'));
                bsModalBaja = new bootstrap.Modal(document.getElementById('modalBajaArticulo'));
            });

            function mostrarAlerta(mensaje, esExito) {
                var toast = document.getElementById('toastAlerta');
                var txt = document.getElementById('toastMensaje');
                txt.innerHTML = mensaje;
                toast.className = 'alert alert-dismissible fade show position-fixed top-0 end-0 m-3 shadow-lg z-3 ' + (esExito ? 'alert-success' : 'alert-danger');
                toast.classList.remove('d-none');
                setTimeout(function () {
                    cerrarAlerta();
                }, 5000);
            }

            function cerrarAlerta() {
                var toast = document.getElementById('toastAlerta');
                toast.classList.remove('show');
                setTimeout(function () {
                    toast.classList.add('d-none');
                }, 300);
            }

            function filtrarTablaArticulos() {
                var q = document.getElementById('txtBuscarArticulo').value.toLowerCase().trim();
                var filas = document.querySelectorAll('#tbodyArticulos tr.fila-articulo');
                var visibles = 0;

                filas.forEach(function (fila) {
                    var nombre = (fila.getAttribute('data-nombre') || '').toLowerCase();
                    var marca = (fila.getAttribute('data-marca') || '').toLowerCase();
                    var desc = (fila.getAttribute('data-descripcion') || '').toLowerCase();

                    if (q === '' || nombre.indexOf(q) !== -1 || marca.indexOf(q) !== -1 || desc.indexOf(q) !== -1) {
                        fila.style.display = '';
                        visibles++;
                    } else {
                        fila.style.display = 'none';
                    }
                });

                document.getElementById('lblTotalArticulos').textContent = visibles;
                var divSinRes = document.getElementById('divSinResultados');
                if (visibles === 0) {
                    divSinRes.classList.remove('d-none');
                } else {
                    divSinRes.classList.add('d-none');
                }
            }

            function limpiarFiltro() {
                document.getElementById('txtBuscarArticulo').value = '';
                filtrarTablaArticulos();
            }

            function abrirModalNuevoArticulo() {
                document.getElementById('txtNuevoNombre').value = '';
                document.getElementById('txtNuevaDescripcion').value = '';
                document.getElementById('ddlNuevaMarca').value = '';
                document.getElementById('ddlNuevaCategoria').value = '';
                bsModalNuevo.show();
            }

            function guardarNuevoArticulo() {
                var nombre = document.getElementById('txtNuevoNombre').value.trim();
                var descripcion = document.getElementById('txtNuevaDescripcion').value.trim();
                var idMarca = parseInt(document.getElementById('ddlNuevaMarca').value) || 0;
                var idCategoria = parseInt(document.getElementById('ddlNuevaCategoria').value) || 0;

                if (!nombre) {
                    mostrarAlerta('Por favor ingresa el nombre del artículo.', false);
                    return;
                }
                if (idMarca <= 0) {
                    mostrarAlerta('Por favor selecciona una marca.', false);
                    return;
                }
                if (idCategoria <= 0) {
                    mostrarAlerta('Por favor selecciona una categoría.', false);
                    return;
                }

                var btn = document.getElementById('btnGuardarNuevo');
                btn.disabled = true;
                btn.textContent = 'Guardando...';

                fetch('Articulos.aspx/CrearArticuloAjax', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: JSON.stringify({ nombre: nombre, descripcion: descripcion, idMarca: idMarca, idCategoria: idCategoria })
                })
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        btn.disabled = false;
                        btn.textContent = 'Guardar Artículo';
                        var res = data.d;
                        if (res.success) {
                            bsModalNuevo.hide();
                            mostrarAlerta(res.message, true);
                            recargarArticulos();
                        } else {
                            mostrarAlerta(res.message, false);
                        }
                    })
                    .catch(function (err) {
                        btn.disabled = false;
                        btn.textContent = 'Guardar Artículo';
                        mostrarAlerta('Error de comunicación: ' + err.message, false);
                    });
            }

            function abrirModalStock(btn) {
                var fila = btn.closest('tr');
                var id = fila.getAttribute('data-id');
                var nombre = fila.getAttribute('data-nombre');
                var marca = fila.getAttribute('data-marca');
                var precio = fila.getAttribute('data-precio') || '';

                document.getElementById('hdnStockIdArticulo').value = id;
                document.getElementById('lblStockNombreArticulo').textContent = nombre;
                document.getElementById('lblStockMarcaArticulo').textContent = 'Marca: ' + marca;
                document.getElementById('txtStockCantidad').value = '1';
                document.getElementById('ddlStockCondicion').value = 'nuevo';
                document.getElementById('txtStockPrecioVenta').value = (precio && parseFloat(precio) > 0) ? precio : '';
                document.getElementById('txtStockPrecioCompra').value = '';
                document.getElementById('txtStockDetalles').value = '';

                bsModalStock.show();
            }

            function guardarStock() {
                var idArticulo = parseInt(document.getElementById('hdnStockIdArticulo').value) || 0;
                var cantidad = parseInt(document.getElementById('txtStockCantidad').value) || 0;
                var condicion = document.getElementById('ddlStockCondicion').value;
                var nuevoPrecioVenta = parseFloat(document.getElementById('txtStockPrecioVenta').value) || 0;
                var precioCompraVal = document.getElementById('txtStockPrecioCompra').value.trim();
                var precioCompra = precioCompraVal !== '' ? parseFloat(precioCompraVal) : null;
                var detalles = document.getElementById('txtStockDetalles').value.trim();

                if (cantidad <= 0) {
                    mostrarAlerta('La cantidad a ingresar debe ser mayor a 0.', false);
                    return;
                }
                if (nuevoPrecioVenta <= 0) {
                    mostrarAlerta('Debes ingresar un precio de venta válido mayor a 0.', false);
                    return;
                }

                var btn = document.getElementById('btnGuardarStock');
                btn.disabled = true;
                btn.textContent = 'Ingresando stock...';

                fetch('Articulos.aspx/AgregarStockAjax', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: JSON.stringify({
                        idArticulo: idArticulo,
                        cantidad: cantidad,
                        condicion: condicion,
                        nuevoPrecioVenta: nuevoPrecioVenta,
                        precioCompra: precioCompra,
                        detalles: detalles
                    })
                })
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        btn.disabled = false;
                        btn.textContent = 'Confirmar Ingreso';
                        var res = data.d;
                        if (res.success) {
                            bsModalStock.hide();
                            mostrarAlerta(res.message, true);
                            recargarArticulos();
                        } else {
                            mostrarAlerta(res.message, false);
                        }
                    })
                    .catch(function (err) {
                        btn.disabled = false;
                        btn.textContent = 'Confirmar Ingreso';
                        mostrarAlerta('Error de comunicación: ' + err.message, false);
                    });
            }

            function abrirModalEditar(btn) {
                var fila = btn.closest('tr');
                var id = fila.getAttribute('data-id');
                var nombre = fila.getAttribute('data-nombre');
                var desc = fila.getAttribute('data-descripcion');
                var idMarca = fila.getAttribute('data-id-marca');
                var idCategoria = fila.getAttribute('data-id-categoria');
                var precio = fila.getAttribute('data-precio') || '';

                document.getElementById('hdnEditarIdArticulo').value = id;
                document.getElementById('txtEditarNombre').value = nombre;
                document.getElementById('txtEditarDescripcion').value = desc;
                document.getElementById('ddlEditarMarca').value = idMarca;
                document.getElementById('ddlEditarCategoria').value = idCategoria;

                document.getElementById('chkActualizarPrecio').checked = false;
                document.getElementById('seccionNuevoPrecio').classList.add('d-none');
                document.getElementById('txtEditarPrecioVenta').value = (precio && parseFloat(precio) > 0) ? precio : '';
                document.getElementById('ddlEditarCondicion').value = 'nuevo';

                bsModalEditar.show();
            }

            function toggleActualizarPrecio() {
                var chk = document.getElementById('chkActualizarPrecio').checked;
                var sec = document.getElementById('seccionNuevoPrecio');
                if (chk) {
                    sec.classList.remove('d-none');
                } else {
                    sec.classList.add('d-none');
                }
            }

            function guardarEdicion() {
                var idArticulo = parseInt(document.getElementById('hdnEditarIdArticulo').value) || 0;
                var nombre = document.getElementById('txtEditarNombre').value.trim();
                var descripcion = document.getElementById('txtEditarDescripcion').value.trim();
                var idMarca = parseInt(document.getElementById('ddlEditarMarca').value) || 0;
                var idCategoria = parseInt(document.getElementById('ddlEditarCategoria').value) || 0;
                var actualizarPrecio = document.getElementById('chkActualizarPrecio').checked;
                var nuevoPrecioVenta = null;
                var condicion = null;

                if (!nombre) {
                    mostrarAlerta('El nombre es obligatorio.', false);
                    return;
                }
                if (idMarca <= 0) {
                    mostrarAlerta('Selecciona una marca.', false);
                    return;
                }
                if (idCategoria <= 0) {
                    mostrarAlerta('Selecciona una categoría.', false);
                    return;
                }

                if (actualizarPrecio) {
                    var p = parseFloat(document.getElementById('txtEditarPrecioVenta').value) || 0;
                    if (p <= 0) {
                        mostrarAlerta('Ingresa un precio de venta válido mayor a 0.', false);
                        return;
                    }
                    nuevoPrecioVenta = p;
                    condicion = document.getElementById('ddlEditarCondicion').value;
                }

                var btn = document.getElementById('btnGuardarEditar');
                btn.disabled = true;
                btn.textContent = 'Guardando cambios...';

                fetch('Articulos.aspx/ActualizarArticuloAjax', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: JSON.stringify({
                        idArticulo: idArticulo,
                        nombre: nombre,
                        descripcion: descripcion,
                        idMarca: idMarca,
                        idCategoria: idCategoria,
                        actualizarPrecio: actualizarPrecio,
                        nuevoPrecioVenta: nuevoPrecioVenta,
                        condicion: condicion
                    })
                })
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        btn.disabled = false;
                        btn.textContent = 'Guardar Cambios';
                        var res = data.d;
                        if (res.success) {
                            bsModalEditar.hide();
                            mostrarAlerta(res.message, true);
                            recargarArticulos();
                        } else {
                            mostrarAlerta(res.message, false);
                        }
                    })
                    .catch(function (err) {
                        btn.disabled = false;
                        btn.textContent = 'Guardar Cambios';
                        mostrarAlerta('Error de comunicación: ' + err.message, false);
                    });
            }

            function abrirModalBaja(btn) {
                var fila = btn.closest('tr');
                var id = fila.getAttribute('data-id');
                var nombre = fila.getAttribute('data-nombre');
                var stock = parseInt(fila.getAttribute('data-stock')) || 0;

                document.getElementById('hdnBajaIdArticulo').value = id;
                document.getElementById('lblBajaNombreArticulo').textContent = nombre;

                var secStock = document.getElementById('seccionBajaConStock');
                if (stock > 0) {
                    document.getElementById('lblBajaStockCount').textContent = stock;
                    secStock.classList.remove('d-none');
                    document.getElementById('chkBajaCascada').checked = true;
                } else {
                    secStock.classList.add('d-none');
                    document.getElementById('chkBajaCascada').checked = false;
                }

                bsModalBaja.show();
            }

            function confirmarBaja() {
                var idArticulo = parseInt(document.getElementById('hdnBajaIdArticulo').value) || 0;
                var bajaCascada = document.getElementById('chkBajaCascada').checked;

                var btn = document.getElementById('btnConfirmarBaja');
                btn.disabled = true;
                btn.textContent = 'Dando de baja...';

                fetch('Articulos.aspx/EliminarArticuloAjax', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: JSON.stringify({ idArticulo: idArticulo, bajaCascada: bajaCascada })
                })
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        btn.disabled = false;
                        btn.textContent = 'Confirmar Baja';
                        var res = data.d;
                        if (res.success) {
                            bsModalBaja.hide();
                            mostrarAlerta(res.message, true);
                            recargarArticulos();
                        } else {
                            mostrarAlerta(res.message, false);
                        }
                    })
                    .catch(function (err) {
                        btn.disabled = false;
                        btn.textContent = 'Confirmar Baja';
                        mostrarAlerta('Error de comunicación: ' + err.message, false);
                    });
            }

            function recargarArticulos() {
                fetch('Articulos.aspx/ListarArticulosAjax', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: JSON.stringify({ texto: '' })
                })
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        var res = data.d;
                        if (!res.success) return;

                        var tbody = document.getElementById('tbodyArticulos');
                        tbody.innerHTML = '';

                        res.items.forEach(function (art) {
                            var tr = document.createElement('tr');
                            tr.className = 'fila-articulo';
                            tr.setAttribute('data-id', art.id);
                            tr.setAttribute('data-nombre', art.nombre);
                            tr.setAttribute('data-descripcion', art.descripcion || '');
                            tr.setAttribute('data-id-marca', art.idMarca);
                            tr.setAttribute('data-marca', art.marca);
                            tr.setAttribute('data-id-categoria', art.idCategoria);
                            tr.setAttribute('data-categoria', art.categoria);
                            tr.setAttribute('data-stock', art.stock);
                            tr.setAttribute('data-precio', art.precio);

                            var badgeStock = art.stock > 0
                                ? '<span class="badge bg-success-subtle text-success border border-success-subtle fs-6 px-3 py-2"><i class="bi bi-check-circle me-1"></i>' + art.stock + ' disp.</span>'
                                : '<span class="badge bg-secondary-subtle text-muted border fs-6 px-3 py-2">0 un.</span>';

                            tr.innerHTML =
                                '<td>' +
                                '<div class="fw-bold text-dark fs-6">' + escapeHtml(art.nombre) + '</div>' +
                                '<div class="text-muted small text-truncate" style="max-width: 320px;">' + escapeHtml(art.descripcion) + '</div>' +
                                '</td>' +
                                '<td><span class="badge bg-light text-dark border px-2 py-1">' + escapeHtml(art.marca) + '</span></td>' +
                                '<td class="text-end fw-bold text-success fs-6">' + art.precioFormateado + '</td>' +
                                '<td class="text-center">' + badgeStock + '</td>' +
                                '<td class="text-end text-nowrap">' +
                                '<button type="button" class="btn btn-outline-primary btn-sm me-1 px-2" title="Editar datos del artículo y precio" onclick="abrirModalEditar(this)">✏️ Editar</button>' +
                                '<button type="button" class="btn btn-primary btn-sm me-1 px-2" title="Ingresar nuevas unidades físicas y unificar precio" onclick="abrirModalStock(this)">📦 + Stock</button>' +
                                '<button type="button" class="btn btn-outline-danger btn-sm px-2" title="Dar de baja artículo" onclick="abrirModalBaja(this)">🗑️</button>' +
                                '</td>';

                            tbody.appendChild(tr);
                        });

                        document.getElementById('lblTotalArticulos').textContent = res.items.length;
                        filtrarTablaArticulos();
                    })
                    .catch(function (err) {
                        console.error('Error al recargar artículos:', err);
                    });
            }

            function escapeHtml(text) {
                if (!text) return '';
                var map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
                return text.replace(/[&<>"']/g, function (m) { return map[m]; });
            }
        </script>
    </asp:Content>