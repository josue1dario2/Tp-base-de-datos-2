using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Services;
using System.Web.UI;
using dominio;
using servicio;

namespace AppMagnusGamers
{
    public partial class _Default : Page
    {
        public DataTable TablaCatalogo { get; set; } = new DataTable();
        public int TotalArticulos { get; set; } = 0;
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
                        lblError.Text = "Ocurrió un error al cargar el catálogo: " + ex2.Message;
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

            ArticuloServicio artService = new ArticuloServicio();
            TablaCatalogo = artService.FiltrarCatalogo();
            TotalArticulos = TablaCatalogo.Rows.Count;

            repItems.DataSource = TablaCatalogo;
            repItems.DataBind();
        }

        public string ObtenerBadgeStock(object stockObj)
        {
            int stock = (stockObj != null && !(stockObj is DBNull)) ? Convert.ToInt32(stockObj) : 0;
            if (stock > 1)
            {
                return "<span class=\"badge bg-success-subtle text-success border border-success fw-semibold px-2 py-1\"><i class=\"bi bi-box-seam me-1\"></i>" + stock + " unidades disponibles</span>";
            }
            if (stock == 1)
            {
                return "<span class=\"badge bg-success-subtle text-success border border-success fw-semibold px-2 py-1\"><i class=\"bi bi-box-seam me-1\"></i>1 unidad disponible</span>";
            }
            return "<span class=\"badge bg-secondary-subtle text-muted border px-2 py-1\">Sin stock disponible</span>";
        }

        public string ObtenerTextoSeguro(object obj)
        {
            if (obj == null || obj is DBNull) return string.Empty;
            return Server.HtmlEncode(obj.ToString());
        }

        public string FormatearPrecio(object precio)
        {
            if (precio == null || precio is DBNull) return "Consultar";
            try
            {
                decimal p = Convert.ToDecimal(precio);
                if (p <= 0) return "Consultar";
                return p.ToString("C0", new System.Globalization.CultureInfo("es-AR"));
            }
            catch
            {
                return "Consultar";
            }
        }

        [WebMethod]
        public static object FiltrarItemsFisicosAjax(string texto, string idCategoria, string idMarca, string precioMin, string precioMax, string condicion, bool soloDisponibles, string orden)
        {
            try
            {
                ArticuloServicio servicio = new ArticuloServicio();

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

                DataTable dt = servicio.FiltrarCatalogo(texto, catId, marId, pMin, pMax, condicion, soloDisponibles, orden);
                var itemsJson = new List<object>();

                foreach (DataRow r in dt.Rows)
                {
                    decimal precio = Convert.ToDecimal(r["PrecioVenta"]);
                    int stock = Convert.ToInt32(r["StockDisponible"]);

                    itemsJson.Add(new
                    {
                        id = Convert.ToInt64(r["ID_Articulo"]),
                        nombre = r["Nombre"].ToString(),
                        descripcion = r["Descripcion"] is DBNull ? "" : r["Descripcion"].ToString(),
                        idMarca = Convert.ToInt64(r["ID_Marca"]),
                        marca = r["MarcaNombre"].ToString(),
                        idCategoria = Convert.ToInt64(r["ID_Categoria"]),
                        categoria = r["CategoriaNombre"].ToString(),
                        stock = stock,
                        precioVenta = precio,
                        precioFormateado = precio > 0 ? precio.ToString("C0", new System.Globalization.CultureInfo("es-AR")) : "Consultar"
                    });
                }

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
                    ArticuloServicio servicio = new ArticuloServicio();

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

                    DataTable dt = servicio.FiltrarCatalogo(texto, catId, marId, pMin, pMax, condicion, soloDisponibles, orden);
                    var itemsJson = new List<object>();

                    foreach (DataRow r in dt.Rows)
                    {
                        decimal precio = Convert.ToDecimal(r["PrecioVenta"]);
                        int stock = Convert.ToInt32(r["StockDisponible"]);

                        itemsJson.Add(new
                        {
                            id = Convert.ToInt64(r["ID_Articulo"]),
                            nombre = r["Nombre"].ToString(),
                            descripcion = r["Descripcion"] is DBNull ? "" : r["Descripcion"].ToString(),
                            idMarca = Convert.ToInt64(r["ID_Marca"]),
                            marca = r["MarcaNombre"].ToString(),
                            idCategoria = Convert.ToInt64(r["ID_Categoria"]),
                            categoria = r["CategoriaNombre"].ToString(),
                            stock = stock,
                            precioVenta = precio,
                            precioFormateado = precio > 0 ? precio.ToString("C0", new System.Globalization.CultureInfo("es-AR")) : "Consultar"
                        });
                    }

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
                        message = "Error al filtrar catálogo: " + retryEx.Message
                    };
                }
            }
        }
    }
}
