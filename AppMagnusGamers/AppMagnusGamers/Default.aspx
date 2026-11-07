<%@ Page Title="Catálogo de Stock - Magnus Gamers" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Default.aspx.cs" Inherits="AppMagnusGamers._Default" ResponseEncoding="utf-8" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <main class="py-4">
            <div class="row mb-4">
                <div class="col-12 text-center">
                    <h1 class="display-5 fw-bold text-primary">Cat&aacute;logo</h1>
                    <p class="lead text-muted">Explor&aacute; todos los artículos con stock consolidado y precios en
                        tiempo real.</p>
                </div>
            </div>

            <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block mb-4" Visible="false">
            </asp:Label>

            <div class="card shadow-sm border-0 mb-4 bg-light">
                <div class="card-body p-3 p-md-4">
                    <div class="row g-2 mb-4">
                        <div class="col-12">
                            <div
                                class="input-group shadow buscador-principal w-100 d-flex flex-nowrap align-items-stretch">
                                <span
                                    class="input-group-text bg-white border-0 text-primary ps-4 pe-2 d-flex align-items-center">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor"
                                        viewBox="0 0 16 16">
                                        <path
                                            d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z" />
                                    </svg>
                                </span>
                                <input type="text" id="txtBuscar"
                                    class="form-control form-control-lg fs-5 py-3 border-0 ps-2 flex-grow-1 w-100"
                                    placeholder="Buscar por artículo, marca o descripción..." autocomplete="off" />
                                <button
                                    class="btn btn-link border-0 text-secondary pe-4 ps-2 d-none fs-3 text-decoration-none"
                                    type="button" id="btnLimpiarTexto" title="Borrar búsqueda">
                                    &times;
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label
                            class="form-label small fw-bold text-uppercase text-muted mb-2">Categor&iacute;as:</label>
                        <div class="d-flex flex-wrap gap-2" id="contenedorPillsCategorias">
                            <button type="button" class="btn btn-sm btn-primary pill-categoria active" data-id="">
                                Todas
                            </button>
                            <% foreach (var cat in ListaCategorias) { %>
                                <button type="button" class="btn btn-sm btn-outline-primary pill-categoria"
                                    data-id="<%= cat.IdCategoria %>">
                                    <%= cat.Nombre %>
                                </button>
                                <% } %>
                        </div>
                    </div>

                    <hr class="text-muted my-3" />

                    <div class="row g-3 align-items-end">
                        <div class="col-12 col-sm-6 col-lg-3">
                            <label for="ddlMarca" class="form-label small fw-semibold text-secondary mb-1">Marca</label>
                            <select id="ddlMarca" class="form-select form-select-sm">
                                <option value="">Todas las marcas</option>
                                <% foreach (var marca in ListaMarcas) { %>
                                    <option value="<%= marca.IdMarca %>">
                                        <%= marca.Nombre %>
                                    </option>
                                    <% } %>
                            </select>
                        </div>

                        <div class="col-12 col-sm-6 col-lg-2">
                            <label for="ddlCondicion"
                                class="form-label small fw-semibold text-secondary mb-1">Condici&oacute;n</label>
                            <select id="ddlCondicion" class="form-select form-select-sm">
                                <option value="">Todas</option>
                                <option value="nuevo">Nuevo</option>
                                <option value="seminuevo">Seminuevo</option>
                                <option value="usado">Usado</option>
                                <option value="reacondicionado">Reacondicionado</option>
                            </select>
                        </div>

                        <div class="col-12 col-sm-6 col-lg-3">
                            <label class="form-label small fw-semibold text-secondary mb-1">Precio de Venta ($)</label>
                            <div class="input-group input-group-sm">
                                <span class="input-group-text">$</span>
                                <input type="number" id="txtPrecioMin" class="form-control" placeholder="Mínimo" min="0"
                                    step="1000" />
                                <span class="input-group-text">-</span>
                                <input type="number" id="txtPrecioMax" class="form-control" placeholder="Máximo" min="0"
                                    step="1000" />
                            </div>
                        </div>

                        <div class="col-12 col-sm-6 col-lg-2">
                            <label for="ddlOrden" class="form-label small fw-semibold text-secondary mb-1">Ordenar
                                por</label>
                            <select id="ddlOrden" class="form-select form-select-sm">
                                <option value="nombre_asc">Artículo (A - Z)</option>
                                <option value="nombre_desc">Artículo (Z - A)</option>
                                <option value="precio_asc">Menor precio</option>
                                <option value="precio_desc">Mayor precio</option>
                            </select>
                        </div>

                        <div class="col-12 col-lg-2 d-flex flex-column justify-content-end">
                            <div class="form-check form-switch mb-2">
                                <input class="form-check-input" type="checkbox" role="switch" id="chkSoloDisponibles" />
                                <label class="form-check-label small fw-semibold" for="chkSoloDisponibles">Solo
                                    Disponibles</label>
                            </div>
                            <button type="button" id="btnLimpiarTodo" class="btn btn-outline-secondary btn-sm w-100">
                                Limpiar filtros
                            </button>
                        </div>
                    </div>

                    <div class="mt-2 d-flex flex-wrap align-items-center gap-1 small">
                        <span class="text-muted me-1">Atajos de precio:</span>
                        <button type="button"
                            class="btn btn-link btn-sm p-0 me-2 text-decoration-none btn-preset-precio" data-min=""
                            data-max="100000">Hasta $100K</button>
                        <button type="button"
                            class="btn btn-link btn-sm p-0 me-2 text-decoration-none btn-preset-precio"
                            data-min="100000" data-max="500000">$100K a $500K</button>
                        <button type="button" class="btn btn-link btn-sm p-0 text-decoration-none btn-preset-precio"
                            data-min="500000" data-max="">M&aacute;s de $500K</button>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="d-flex align-items-center">
                    <span id="lblContador" class="badge bg-secondary fs-6 fw-normal px-3 py-2">
                        Mostrando <strong id="numTotalItems">
                        <%= TotalArticulos %>
                            </strong> artículos en cat&aacute;logo
                    </span>
                    <div id="spinnerCargando" class="spinner-border spinner-border-sm text-primary ms-3 d-none"
                        role="status">
                        <span class="visually-hidden">Cargando...</span>
                    </div>
                    <span id="textoCargando" class="text-muted small ms-2 d-none">Filtrando al instante...</span>
                </div>
            </div>

            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="contenedorItems">
                <asp:Repeater ID="repItems" runat="server">
                    <ItemTemplate>
                        <div class="col item-card">
                            <div class="card h-100 shadow-sm border-0 transition-card">
                                <div class="card-body d-flex flex-column">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                                <span class="badge bg-info text-dark">
                                                    <%# Eval("CategoriaNombre") %>
                                                </span>
                                                <span class="badge bg-secondary">
                                                    <%# Eval("MarcaNombre") %>
                                                </span>
                                    </div>

                                    <h5 class="card-title text-dark fw-bold mb-1">
                                            <%# Eval("Nombre") %>
                                    </h5>

                                    <div class="mb-2">
                                        <%# ObtenerBadgeStock(Eval("StockDisponible")) %>
                                    </div>

                                    <p class="card-text text-muted small mb-2">
                                            <%# Eval("Descripcion") %>
                                    </p>

                                                <div class="mt-auto pt-2 border-top">
                                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                                        <div>
                                                            <small class="text-muted d-block">Precio de
                                                                Referencia</small>
                                                            <span class="fs-4 fw-bold text-success">
                                                                <%# FormatearPrecio(Eval("PrecioVenta")) %>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div id="estadoVacio" class="text-center py-5 d-none">
                <div class="mb-3 text-muted">
                    <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor"
                        class="bi bi-search" viewBox="0 0 16 16">
                        <path
                            d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z" />
                    </svg>
                </div>
                <h4 class="fw-bold text-secondary">No se encontraron artículos en cat&aacute;logo</h4>
                <p class="text-muted">Prob&aacute; cambiando las palabras clave, ampliando el rango de precios o
                    quitando los filtros aplicados.</p>
                <button type="button" class="btn btn-primary btn-sm px-4 mt-2" onclick="limpiarTodosLosFiltros()">
                    Restablecer todos los filtros
                </button>
            </div>
        </main>

        <style>
            .buscador-principal {
                border-radius: 50rem;
                overflow: hidden;
                border: 2px solid #dee2e6;
                background-color: #fff;
                width: 100% !important;
                max-width: none !important;
                transition: border-color 0.2s ease, box-shadow 0.2s ease;
            }

            .buscador-principal:focus-within {
                border-color: #0d6efd;
                box-shadow: 0 0.5rem 1.5rem rgba(13, 110, 253, 0.2) !important;
            }

            .buscador-principal input#txtBuscar {
                width: 100% !important;
                max-width: none !important;
                flex: 1 1 auto !important;
                box-shadow: none;
                background-color: transparent;
            }

            .transition-card {
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .transition-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.12) !important;
            }

            .pill-categoria {
                border-radius: 50rem;
                padding-left: 1rem;
                padding-right: 1rem;
                font-weight: 500;
            }

            .bg-success-subtle {
                background-color: #d1e7dd !important;
            }

            .bg-warning-subtle {
                background-color: #fff3cd !important;
            }
        </style>

        <script type="text/javascript">
            document.addEventListener("DOMContentLoaded", function () {
                const txtBuscar = document.getElementById("txtBuscar");
                const btnLimpiarTexto = document.getElementById("btnLimpiarTexto");
                const pillsCategorias = document.querySelectorAll(".pill-categoria");
                const ddlMarca = document.getElementById("ddlMarca");
                const ddlCondicion = document.getElementById("ddlCondicion");
                const txtPrecioMin = document.getElementById("txtPrecioMin");
                const txtPrecioMax = document.getElementById("txtPrecioMax");
                const ddlOrden = document.getElementById("ddlOrden");
                const chkSoloDisponibles = document.getElementById("chkSoloDisponibles");
                const btnLimpiarTodo = document.getElementById("btnLimpiarTodo");
                const contenedorItems = document.getElementById("contenedorItems");
                const estadoVacio = document.getElementById("estadoVacio");
                const spinnerCargando = document.getElementById("spinnerCargando");
                const textoCargando = document.getElementById("textoCargando");
                const numTotalItems = document.getElementById("numTotalItems");
                const presetsPrecio = document.querySelectorAll(".btn-preset-precio");

                let categoriaSeleccionada = "";
                let debounceTimer = null;
                let abortController = null;

                const formateadorMoneda = new Intl.NumberFormat("es-AR", {
                    style: "currency",
                    currency: "ARS",
                    maximumFractionDigits: 0
                });

                function debouncedFiltrar(delay = 250) {
                    if (debounceTimer) clearTimeout(debounceTimer);
                    debounceTimer = setTimeout(() => {
                        ejecutarFiltroAjax();
                    }, delay);
                }

                function ejecutarFiltroAjax() {
                    spinnerCargando.classList.remove("d-none");
                    textoCargando.classList.remove("d-none");

                    if (abortController) {
                        abortController.abort();
                    }
                    abortController = new AbortController();

                    const payload = {
                        texto: txtBuscar.value.trim(),
                        idCategoria: categoriaSeleccionada,
                        idMarca: ddlMarca.value,
                        precioMin: txtPrecioMin.value.trim(),
                        precioMax: txtPrecioMax.value.trim(),
                        condicion: ddlCondicion.value,
                        soloDisponibles: chkSoloDisponibles.checked,
                        orden: ddlOrden.value
                    };

                    fetch('<%= ResolveUrl("~/Default.aspx/FiltrarItemsFisicosAjax") %>', {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json; charset=utf-8"
                        },
                        body: JSON.stringify(payload),
                        signal: abortController.signal
                    })
                        .then(response => {
                            if (!response.ok) {
                                throw new Error("HTTP error " + response.status);
                            }
                            return response.json();
                        })
                        .then(result => {
                            const data = result.d || result;
                            spinnerCargando.classList.add("d-none");
                            textoCargando.classList.add("d-none");

                            if (data.success) {
                                renderizarItems(data.items);
                                numTotalItems.textContent = data.total;
                            } else {
                                console.error("Error devuelto por el servidor:", data.message);
                            }
                        })
                        .catch(error => {
                            if (error.name !== "AbortError") {
                                spinnerCargando.classList.add("d-none");
                                textoCargando.classList.add("d-none");
                                console.error("Error al filtrar ítems:", error);
                            }
                        });
                }

                function renderizarItems(items) {
                    if (!items || items.length === 0) {
                        contenedorItems.innerHTML = "";
                        estadoVacio.classList.remove("d-none");
                        return;
                    }

                    estadoVacio.classList.add("d-none");

                    const html = items.map(item => {
                        const precioHtml = item.precioFormateado || (item.precioVenta > 0 ? formateadorMoneda.format(item.precioVenta) : "Consultar");

                            let stockBadge = `<span class="badge bg-secondary-subtle text-muted border px-2 py-1">Sin stock disponible</span>`;
                            if (item.stock > 1) {
                                stockBadge = `<span class="badge bg-success-subtle text-success border border-success fw-semibold px-2 py-1"><i class="bi bi-box-seam me-1"></i>${item.stock} unidades disponibles</span>`;
                            } else if (item.stock === 1) {
                                stockBadge = `<span class="badge bg-success-subtle text-success border border-success fw-semibold px-2 py-1"><i class="bi bi-box-seam me-1"></i>1 unidad disponible</span>`;
                            }

                            const descHtml = item.descripcion
                                ? `<p class="card-text text-muted small mb-2">${escaparHtml(item.descripcion)}</p>`
                                : "";

                            return `
                        <div class="col item-card">
                            <div class="card h-100 shadow-sm border-0 transition-card">
                                <div class="card-body d-flex flex-column">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="badge bg-info text-dark">${escaparHtml(item.categoria)}</span>
                                        <span class="badge bg-secondary">${escaparHtml(item.marca)}</span>
                                    </div>

                                    <h5 class="card-title text-dark fw-bold mb-1">
                                        ${escaparHtml(item.nombre)}
                                    </h5>

                                    <div class="mb-2">
                                        ${stockBadge}
                                    </div>

                                    ${descHtml}

                                    <div class="mt-auto pt-2 border-top">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div>
                                                <small class="text-muted d-block">Precio de Referencia</small>
                                                <span class="fs-4 fw-bold text-success">${precioHtml}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `;
                        }).join("");

                    contenedorItems.innerHTML = html;
                }

                function escaparHtml(texto) {
                    if (!texto) return "";
                    return texto
                        .replace(/&/g, "&amp;")
                        .replace(/</g, "&lt;")
                        .replace(/>/g, "&gt;")
                        .replace(/"/g, "&quot;")
                        .replace(/'/g, "&#039;");
                }

                txtBuscar.addEventListener("input", function () {
                    if (this.value.trim().length > 0) {
                        btnLimpiarTexto.classList.remove("d-none");
                    } else {
                        btnLimpiarTexto.classList.add("d-none");
                    }
                    debouncedFiltrar(250);
                });

                btnLimpiarTexto.addEventListener("click", function () {
                    txtBuscar.value = "";
                    btnLimpiarTexto.classList.add("d-none");
                    txtBuscar.focus();
                    ejecutarFiltroAjax();
                });

                pillsCategorias.forEach(pill => {
                    pill.addEventListener("click", function () {
                        pillsCategorias.forEach(p => {
                            p.classList.remove("btn-primary", "active");
                            p.classList.add("btn-outline-primary");
                        });
                        this.classList.remove("btn-outline-primary");
                        this.classList.add("btn-primary", "active");

                        categoriaSeleccionada = this.getAttribute("data-id") || "";
                        ejecutarFiltroAjax();
                    });
                });

                ddlMarca.addEventListener("change", () => ejecutarFiltroAjax());
                ddlCondicion.addEventListener("change", () => ejecutarFiltroAjax());
                ddlOrden.addEventListener("change", () => ejecutarFiltroAjax());
                chkSoloDisponibles.addEventListener("change", () => ejecutarFiltroAjax());

                txtPrecioMin.addEventListener("input", () => debouncedFiltrar(400));
                txtPrecioMax.addEventListener("input", () => debouncedFiltrar(400));

                presetsPrecio.forEach(btn => {
                    btn.addEventListener("click", function (e) {
                        e.preventDefault();
                        txtPrecioMin.value = this.getAttribute("data-min") || "";
                        txtPrecioMax.value = this.getAttribute("data-max") || "";
                        ejecutarFiltroAjax();
                    });
                });

                window.limpiarTodosLosFiltros = function () {
                    txtBuscar.value = "";
                    btnLimpiarTexto.classList.add("d-none");

                    pillsCategorias.forEach((p, idx) => {
                        if (idx === 0) {
                            p.classList.remove("btn-outline-primary");
                            p.classList.add("btn-primary", "active");
                        } else {
                            p.classList.remove("btn-primary", "active");
                            p.classList.add("btn-outline-primary");
                        }
                    });
                    categoriaSeleccionada = "";

                    ddlMarca.value = "";
                    ddlCondicion.value = "";
                    txtPrecioMin.value = "";
                    txtPrecioMax.value = "";
                    chkSoloDisponibles.checked = false;
                    ddlOrden.value = "nombre_asc";

                    ejecutarFiltroAjax();
                };

                btnLimpiarTodo.addEventListener("click", window.limpiarTodosLosFiltros);
            });
        </script>
    </asp:Content>