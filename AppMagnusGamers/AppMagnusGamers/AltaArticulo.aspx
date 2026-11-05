<%@ Page Title="Agregar Artículo - Magnus Gamers" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="AltaArticulo.aspx.cs" Inherits="AppMagnusGamers.AltaArticulo" ResponseEncoding="utf-8"
    EnableEventValidation="false" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <main class="py-4">
            <!-- Encabezado en estilo idéntico a Default.aspx -->
            <div class="row mb-4">
                <div class="col-12 text-center">
                    <h1 class="display-5 fw-bold text-primary">Agregar Art&iacute;culo</h1>
                    <p class="lead text-muted">Complet&aacute; el formulario para registrar un nuevo producto en el
                        cat&aacute;logo.</p>
                </div>
            </div>

            <div class="row justify-content-center">
                <div class="col-12 col-md-8 col-lg-6">

                    <!-- Card estilo Default.aspx: fondo limpio, sombra suave y sin bordes toscos -->
                    <div class="card shadow-sm border-0">
                        <div class="card-body p-4">
                            <!-- Alertas de éxito / error -->
                            <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="d-block mb-3">
                            </asp:Label>

                            <!-- Nombre -->
                            <div class="mb-3">
                                <label for="txtNombre" class="form-label fw-semibold text-secondary">Nombre del
                                    Art&iacute;culo</label>
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"
                                    placeholder="Ej: PlayStation 5 Slim" required="required"></asp:TextBox>
                            </div>

                            <!-- Descripción -->
                            <div class="mb-3">
                                <label for="txtDescripcion"
                                    class="form-label fw-semibold text-secondary">Descripci&oacute;n</label>
                                <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" Rows="3"
                                    CssClass="form-control" placeholder="Detalles generales del artículo...">
                                </asp:TextBox>
                            </div>

                            <!-- Marca con botón [+] para Modal -->
                            <div class="mb-3">
                                <label for="ddlMarca" class="form-label fw-semibold text-secondary">Marca</label>
                                <div class="input-group">
                                    <asp:DropDownList ID="ddlMarca" runat="server" CssClass="form-select"
                                        ClientIDMode="Static">
                                    </asp:DropDownList>
                                    <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal"
                                        data-bs-target="#modalNuevaMarca" title="Nueva Marca">
                                        <strong>+</strong>
                                    </button>
                                </div>
                            </div>

                            <!-- Categoría con botón [+] para Modal -->
                            <div class="mb-4">
                                <label for="ddlCategoria"
                                    class="form-label fw-semibold text-secondary">Categor&iacute;a</label>
                                <div class="input-group">
                                    <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-select"
                                        ClientIDMode="Static">
                                    </asp:DropDownList>
                                    <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal"
                                        data-bs-target="#modalNuevaCategoria" title="Nueva Categoría">
                                        <strong>+</strong>
                                    </button>
                                </div>
                            </div>

                            <!-- Botones de Acción -->
                            <div class="d-grid gap-2">
                                <asp:Button ID="btnGuardar" runat="server" Text="Guardar Artículo"
                                    CssClass="btn btn-primary btn-lg fw-bold" OnClick="btnGuardar_Click" />
                                <a href="Default.aspx" class="btn btn-outline-secondary">Volver al Catálogo</a>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </main>

        <!-- ========================================== -->
        <!-- Modal: Nueva Marca                         -->
        <!-- ========================================== -->
        <div class="modal fade" id="modalNuevaMarca" tabindex="-1" aria-labelledby="modalNuevaMarcaLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow border-0">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-primary" id="modalNuevaMarcaLabel">Nueva Marca</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="txtNuevaMarca" class="form-label fw-semibold text-secondary">Nombre de la
                                Marca</label>
                            <input type="text" id="txtNuevaMarca" class="form-control" placeholder="Ej: SteelSeries" />
                            <div id="errorMarca" class="alert alert-danger py-2 small mt-2 d-none" role="alert"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" id="btnGuardarMarca" class="btn btn-primary fw-bold">Guardar
                            Marca</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========================================== -->
        <!-- Modal: Nueva Categoría                     -->
        <!-- ========================================== -->
        <div class="modal fade" id="modalNuevaCategoria" tabindex="-1" aria-labelledby="modalNuevaCategoriaLabel"
            aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow border-0">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-primary" id="modalNuevaCategoriaLabel">Nueva
                            Categor&iacute;a</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="txtNuevaCategoria" class="form-label fw-semibold text-secondary">Nombre de la
                                Categor&iacute;a</label>
                            <input type="text" id="txtNuevaCategoria" class="form-control"
                                placeholder="Ej: Realidad Virtual" />
                            <div id="errorCategoria" class="alert alert-danger py-2 small mt-2 d-none" role="alert">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" id="btnGuardarCategoria" class="btn btn-primary fw-bold">Guardar
                            Categoría</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========================================== -->
        <!-- Lógica JavaScript / Fetch API para Modales -->
        <!-- ========================================== -->
        <script type="text/javascript">
            document.addEventListener("DOMContentLoaded", function () {

                // Función auxiliar para traducir errores de base de datos a mensajes amigables
                function formatearError(tipo, msg, nombre) {
                    if (!msg) return `No se pudo registrar la ${tipo}.`;
                    if (msg.includes("UNIQUE KEY") || msg.includes("clave duplicada") || msg.includes("2627") || msg.includes("2601")) {
                        return `La ${tipo} '${nombre}' ya existe en el sistema. Por favor elija otro nombre.`;
                    }
                    return msg.replace(/^Error:\s*/i, "");
                }

                // --- Guardar Marca vía AJAX WebMethod ---
                const btnGuardarMarca = document.getElementById("btnGuardarMarca");
                const txtNuevaMarca = document.getElementById("txtNuevaMarca");
                const errorMarca = document.getElementById("errorMarca");
                const ddlMarca = document.getElementById("ddlMarca");
                const modalMarcaEl = document.getElementById("modalNuevaMarca");

                btnGuardarMarca.addEventListener("click", function () {
                    const nombre = txtNuevaMarca.value.trim();

                    if (!nombre) {
                        errorMarca.innerText = "Por favor ingrese un nombre para la marca.";
                        errorMarca.classList.remove("d-none");
                        return;
                    }
                    errorMarca.classList.add("d-none");
                    btnGuardarMarca.disabled = true;

                    fetch('<%= ResolveUrl("~/AltaArticulo.aspx/AgregarMarcaAjax") %>', {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json; charset=utf-8"
                        },
                        body: JSON.stringify({ nombre: nombre })
                    })
                        .then(async response => {
                            if (!response.ok) {
                                const errorText = await response.text();
                                let msg = "Error " + response.status;
                                try {
                                    const errObj = JSON.parse(errorText);
                                    if (errObj.Message) msg = errObj.Message;
                                } catch (e) {
                                    if (errorText && errorText.length < 250) msg = errorText;
                                }
                                throw new Error(msg);
                            }
                            return response.json();
                        })
                        .then(result => {
                            btnGuardarMarca.disabled = false;
                            const data = result.d || result;

                            if (data.success) {
                                const nuevaOpcion = new Option(data.nombre, data.id, true, true);
                                ddlMarca.add(nuevaOpcion);
                                ddlMarca.value = data.id;

                                txtNuevaMarca.value = "";
                                const modal = bootstrap.Modal.getInstance(modalMarcaEl) || new bootstrap.Modal(modalMarcaEl);
                                modal.hide();
                            } else {
                                errorMarca.innerText = formatearError("marca", data.message, nombre);
                                errorMarca.classList.remove("d-none");
                            }
                        })
                        .catch(err => {
                            btnGuardarMarca.disabled = false;
                            errorMarca.innerText = formatearError("marca", err.message, nombre);
                            errorMarca.classList.remove("d-none");
                        });
                });

                // --- Guardar Categoría vía AJAX WebMethod ---
                const btnGuardarCategoria = document.getElementById("btnGuardarCategoria");
                const txtNuevaCategoria = document.getElementById("txtNuevaCategoria");
                const errorCategoria = document.getElementById("errorCategoria");
                const ddlCategoria = document.getElementById("ddlCategoria");
                const modalCategoriaEl = document.getElementById("modalNuevaCategoria");

                btnGuardarCategoria.addEventListener("click", function () {
                    const nombre = txtNuevaCategoria.value.trim();

                    if (!nombre) {
                        errorCategoria.innerText = "Por favor ingrese un nombre para la categoría.";
                        errorCategoria.classList.remove("d-none");
                        return;
                    }
                    errorCategoria.classList.add("d-none");
                    btnGuardarCategoria.disabled = true;

                    fetch('<%= ResolveUrl("~/AltaArticulo.aspx/AgregarCategoriaAjax") %>', {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json; charset=utf-8"
                        },
                        body: JSON.stringify({ nombre: nombre })
                    })
                        .then(async response => {
                            if (!response.ok) {
                                const errorText = await response.text();
                                let msg = "Error " + response.status;
                                try {
                                    const errObj = JSON.parse(errorText);
                                    if (errObj.Message) msg = errObj.Message;
                                } catch (e) {
                                    if (errorText && errorText.length < 250) msg = errorText;
                                }
                                throw new Error(msg);
                            }
                            return response.json();
                        })
                        .then(result => {
                            btnGuardarCategoria.disabled = false;
                            const data = result.d || result;

                            if (data.success) {
                                const nuevaOpcion = new Option(data.nombre, data.id, true, true);
                                ddlCategoria.add(nuevaOpcion);
                                ddlCategoria.value = data.id;

                                txtNuevaCategoria.value = "";
                                const modal = bootstrap.Modal.getInstance(modalCategoriaEl) || new bootstrap.Modal(modalCategoriaEl);
                                modal.hide();
                            } else {
                                errorCategoria.innerText = formatearError("categoría", data.message, nombre);
                                errorCategoria.classList.remove("d-none");
                            }
                        })
                        .catch(err => {
                            btnGuardarCategoria.disabled = false;
                            errorCategoria.innerText = formatearError("categoría", err.message, nombre);
                            errorCategoria.classList.remove("d-none");
                        });
                });

            });
        </script>
    </asp:Content>