using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Services;
using System.Web.UI;
using dominio;
using servicio;

namespace AppMagnusGamers
{
    public partial class _Default : Page
    {
        public List<ItemFisico> ListaItems { get; set; } = new List<ItemFisico>();
        public List<Categoria> ListaCategorias { get; set; } = new List<Categoria>();
        public List<Marca> ListaMarcas { get; set; } = new List<Marca>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    CargarDatosIniciales();
                }
                catch (Exception)
                {
                    try
                    {
                        AccesoDatos.AsegurarProcedimientos();
                        CargarDatosIniciales();
                    }
                    catch (Exception ex2)
                    {
                        lblError.Text = "Ocurrió un error al cargar el catálogo de ítems: " + ex2.Message;
                        lblError.Visible = true;
                    }
                }
            }
        }

        private void CargarDatosIniciales()
        {
            CategoriaService catService = new CategoriaService();
            ListaCategorias = catService.Listar();

            MarcaService marcaService = new MarcaService();
            ListaMarcas = marcaService.Listar();

            ItemFisicoServicio itemService = new ItemFisicoServicio();
            ListaItems = itemService.Filtrar();

            repItems.DataSource = ListaItems;
            repItems.DataBind();
        }

        public string ObtenerClaseCondicion(object condicion)
        {
            if (condicion == null) return "bg-warning text-dark";
            string c = condicion.ToString().ToLower();
            if (c == "nuevo") return "bg-primary";
            if (c == "seminuevo") return "bg-success";
            return "bg-warning text-dark";
        }

        public string ObtenerBadgeLogistica(object etiqueta)
        {
            if (etiqueta == null) return "<span class=\"badge bg-light text-muted border\">Sin estado</span>";
            string e = etiqueta.ToString().ToLower();
            if (e == "disponible") return "<span class=\"badge bg-success-subtle text-success border border-success\">Disponible</span>";
            if (e == "reservado") return "<span class=\"badge bg-warning-subtle text-warning border border-warning\">Reservado</span>";
            if (e == "vendido") return "<span class=\"badge bg-danger text-white\">Vendido</span>";
            return "<span class=\"badge bg-light text-muted border\">" + Server.HtmlEncode(etiqueta.ToString()) + "</span>";
        }

        public string ObtenerDetallesHtml(object detalles)
        {
            if (detalles == null || string.IsNullOrWhiteSpace(detalles.ToString())) return "";
            return "<div class=\"alert alert-light border py-1 px-2 small mb-2 text-secondary\"><svg xmlns=\"http://www.w3.org/2000/svg\" width=\"14\" height=\"14\" fill=\"currentColor\" class=\"bi bi-info-circle me-1\" viewBox=\"0 0 16 16\"><path d=\"M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z\"/><path d=\"m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z\"/></svg>" + Server.HtmlEncode(detalles.ToString()) + "</div>";
        }

        public string FormatearPrecio(object precio)
        {
            if (precio == null || precio is DBNull) return "$ 0";
            try
            {
                decimal p = Convert.ToDecimal(precio);
                return p.ToString("C0", new System.Globalization.CultureInfo("es-AR"));
            }
            catch
            {
                return "$ 0";
            }
        }

        [WebMethod]
        public static object FiltrarItemsFisicosAjax(string texto, string idCategoria, string idMarca, string precioMin, string precioMax, string condicion, bool soloDisponibles, string orden)
        {
            try
            {
                ItemFisicoServicio servicio = new ItemFisicoServicio();

                long? catId = null;
                if (long.TryParse(idCategoria, out long c) && c > 0)
                    catId = c;

                long? marId = null;
                if (long.TryParse(idMarca, out long m) && m > 0)
                    marId = m;

                decimal? pMin = null;
                if (!string.IsNullOrWhiteSpace(precioMin))
                {
                    if (decimal.TryParse(precioMin, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal min) ||
                        decimal.TryParse(precioMin, out min))
                    {
                        if (min >= 0) pMin = min;
                    }
                }

                decimal? pMax = null;
                if (!string.IsNullOrWhiteSpace(precioMax))
                {
                    if (decimal.TryParse(precioMax, System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal max) ||
                        decimal.TryParse(precioMax, out max))
                    {
                        if (max >= 0) pMax = max;
                    }
                }

                List<ItemFisico> lista = servicio.Filtrar(texto, catId, marId, pMin, pMax, condicion, soloDisponibles, orden);

                var itemsJson = lista.Select(i => new
                {
                    id = i.IdItemFisico,
                    codigo = i.Codigo,
                    detalles = i.Detalles ?? "",
                    condicion = i.Condicion,
                    etiquetaLogistica = i.EtiquetaLogistica,
                    precioVenta = i.PrecioVenta,
                    precioFormateado = i.PrecioVenta.ToString("C0", new System.Globalization.CultureInfo("es-AR")),
                    disponible = string.Equals(i.EtiquetaLogistica, "disponible", StringComparison.OrdinalIgnoreCase),
                    idArticulo = i.IdArticulo,
                    nombre = i.Articulo != null ? i.Articulo.Nombre : "",
                    descripcion = i.Articulo != null ? (i.Articulo.Descripcion ?? "") : "",
                    marca = (i.Articulo != null && i.Articulo.Marca != null) ? i.Articulo.Marca.Nombre : "",
                    categoria = (i.Articulo != null && i.Articulo.Categoria != null) ? i.Articulo.Categoria.Nombre : ""
                }).ToList();

                return new
                {
                    success = true,
                    items = itemsJson,
                    total = itemsJson.Count
                };
            }
            catch (Exception)
            {
                try
                {
                    AccesoDatos.AsegurarProcedimientos();
                    ItemFisicoServicio servicio = new ItemFisicoServicio();

                    long? catId = null;
                    if (long.TryParse(idCategoria, out long c) && c > 0) catId = c;

                    long? marId = null;
                    if (long.TryParse(idMarca, out long m) && m > 0) marId = m;

                    decimal? pMin = null;
                    if (!string.IsNullOrWhiteSpace(precioMin) && decimal.TryParse(precioMin, out decimal min) && min >= 0)
                        pMin = min;

                    decimal? pMax = null;
                    if (!string.IsNullOrWhiteSpace(precioMax) && decimal.TryParse(precioMax, out decimal max) && max >= 0)
                        pMax = max;

                    List<ItemFisico> lista = servicio.Filtrar(texto, catId, marId, pMin, pMax, condicion, soloDisponibles, orden);

                    var itemsJson = lista.Select(i => new
                    {
                        id = i.IdItemFisico,
                        codigo = i.Codigo,
                        detalles = i.Detalles ?? "",
                        condicion = i.Condicion,
                        etiquetaLogistica = i.EtiquetaLogistica,
                        precioVenta = i.PrecioVenta,
                        precioFormateado = i.PrecioVenta.ToString("C0", new System.Globalization.CultureInfo("es-AR")),
                        disponible = string.Equals(i.EtiquetaLogistica, "disponible", StringComparison.OrdinalIgnoreCase),
                        idArticulo = i.IdArticulo,
                        nombre = i.Articulo != null ? i.Articulo.Nombre : "",
                        descripcion = i.Articulo != null ? (i.Articulo.Descripcion ?? "") : "",
                        marca = (i.Articulo != null && i.Articulo.Marca != null) ? i.Articulo.Marca.Nombre : "",
                        categoria = (i.Articulo != null && i.Articulo.Categoria != null) ? i.Articulo.Categoria.Nombre : ""
                    }).ToList();

                    return new
                    {
                        success = true,
                        items = itemsJson,
                        total = itemsJson.Count
                    };
                }
                catch (Exception retryEx)
                {
                    return new
                    {
                        success = false,
                        message = "Error al filtrar ítems físicos: " + retryEx.Message
                    };
                }
            }
        }
    }
}
