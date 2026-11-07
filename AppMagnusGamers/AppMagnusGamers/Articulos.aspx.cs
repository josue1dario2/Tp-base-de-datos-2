using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Services;
using System.Web.UI;
using dominio;
using servicio;

namespace AppMagnusGamers
{
    public partial class Articulos : Page
    {
        public DataTable TablaArticulos { get; set; } = new DataTable();
        public int TotalArticulos { get; set; } = 0;
        public List<Marca> ListaMarcas { get; set; } = new List<Marca>();
        public List<Categoria> ListaCategorias { get; set; } = new List<Categoria>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    CargarDatos();
                }
                catch (Exception)
                {
                    try
                    {
                        AccesoDatos.AsegurarProcedimientos();
                        CargarDatos();
                    }
                    catch (Exception ex2)
                    {
                        lblError.Text = "Error al conectar con la base de datos: " + ex2.Message;
                        lblError.Visible = true;
                    }
                }
            }
        }

        private void CargarDatos()
        {
            ArticuloServicio artService = new ArticuloServicio();
            MarcaService marcaService = new MarcaService();
            CategoriaService catService = new CategoriaService();

            ListaMarcas = marcaService.Listar();
            ListaCategorias = catService.Listar();
            
            TablaArticulos = artService.ListarDashboardDataTable();
            TotalArticulos = TablaArticulos.Rows.Count;

            repArticulos.DataSource = TablaArticulos;
            repArticulos.DataBind();
        }

        public string FormatearPrecio(object precioObj)
        {
            if (precioObj == null || precioObj is DBNull) return "-";
            decimal precio = Convert.ToDecimal(precioObj);
            if (precio <= 0) return "-";
            return precio.ToString("C0", new System.Globalization.CultureInfo("es-AR"));
        }

        public string ObtenerBadgeStock(object stockObj)
        {
            int stock = (stockObj != null && !(stockObj is DBNull)) ? Convert.ToInt32(stockObj) : 0;
            if (stock > 0)
            {
                return "<span class=\"badge bg-success-subtle text-success border border-success-subtle fs-6 px-3 py-2\"><i class=\"bi bi-check-circle me-1\"></i>" + stock + " disp.</span>";
            }
            return "<span class=\"badge bg-secondary-subtle text-muted border fs-6 px-3 py-2\">0 un.</span>";
        }

        public string ObtenerTextoSeguro(object obj)
        {
            if (obj == null || obj is DBNull) return string.Empty;
            return Server.HtmlEncode(obj.ToString());
        }

        [WebMethod]
        public static object ListarArticulosAjax(string texto)
        {
            try
            {
                ArticuloServicio servicio = new ArticuloServicio();
                DataTable dt = servicio.ListarDashboardDataTable(texto);
                var items = new List<object>();

                foreach (DataRow row in dt.Rows)
                {
                    decimal precio = Convert.ToDecimal(row["PrecioVenta"]);
                    items.Add(new
                    {
                        id = Convert.ToInt64(row["ID_Articulo"]),
                        nombre = row["Nombre"].ToString(),
                        descripcion = row["Descripcion"] is DBNull ? "" : row["Descripcion"].ToString(),
                        idMarca = Convert.ToInt64(row["ID_Marca"]),
                        marca = row["MarcaNombre"].ToString(),
                        idCategoria = Convert.ToInt64(row["ID_Categoria"]),
                        categoria = row["CategoriaNombre"].ToString(),
                        stock = Convert.ToInt32(row["StockDisponible"]),
                        precio = precio,
                        precioFormateado = precio > 0 ? precio.ToString("C0", new System.Globalization.CultureInfo("es-AR")) : "-"
                    });
                }

                return new { success = true, items = items };
            }
            catch (Exception)
            {
                try
                {
                    AccesoDatos.AsegurarProcedimientos();
                    ArticuloServicio servicio = new ArticuloServicio();
                    DataTable dt = servicio.ListarDashboardDataTable(texto);
                    var items = new List<object>();

                    foreach (DataRow row in dt.Rows)
                    {
                        decimal precio = Convert.ToDecimal(row["PrecioVenta"]);
                        items.Add(new
                        {
                            id = Convert.ToInt64(row["ID_Articulo"]),
                            nombre = row["Nombre"].ToString(),
                            descripcion = row["Descripcion"] is DBNull ? "" : row["Descripcion"].ToString(),
                            idMarca = Convert.ToInt64(row["ID_Marca"]),
                            marca = row["MarcaNombre"].ToString(),
                            idCategoria = Convert.ToInt64(row["ID_Categoria"]),
                            categoria = row["CategoriaNombre"].ToString(),
                            stock = Convert.ToInt32(row["StockDisponible"]),
                            precio = precio,
                            precioFormateado = precio > 0 ? precio.ToString("C0", new System.Globalization.CultureInfo("es-AR")) : "-"
                        });
                    }

                    return new { success = true, items = items };
                }
                catch (Exception ex2)
                {
                    return new { success = false, message = ex2.Message };
                }
            }
        }

        [WebMethod]
        public static object CrearArticuloAjax(string nombre, string descripcion, long idMarca, long idCategoria)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(nombre))
                    return new { success = false, message = "El nombre del artículo es obligatorio." };

                if (idMarca <= 0)
                    return new { success = false, message = "Debe seleccionar una marca válida." };

                if (idCategoria <= 0)
                    return new { success = false, message = "Debe seleccionar una categoría válida." };

                ArticuloServicio servicio = new ArticuloServicio();
                Articulo nuevo = new Articulo
                {
                    Nombre = nombre.Trim(),
                    Descripcion = string.IsNullOrWhiteSpace(descripcion) ? null : descripcion.Trim(),
                    IdMarca = idMarca,
                    IdCategoria = idCategoria,
                    Activo = true
                };

                long nuevoId = servicio.Agregar(nuevo);
                return new { success = true, id = nuevoId, message = "Artículo creado exitosamente con 0 unidades de stock." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = "Error al crear artículo: " + ex.Message };
            }
        }

        [WebMethod]
        public static object AgregarStockAjax(long idArticulo, int cantidad, string condicion, decimal nuevoPrecioVenta, decimal? precioCompra, string detalles)
        {
            try
            {
                if (idArticulo <= 0)
                    return new { success = false, message = "Artículo no válido." };

                if (cantidad <= 0)
                    return new { success = false, message = "La cantidad debe ser mayor a 0." };

                if (nuevoPrecioVenta <= 0)
                    return new { success = false, message = "El precio de venta debe ser mayor a 0." };

                if (string.IsNullOrWhiteSpace(condicion))
                    condicion = "nuevo";

                ArticuloServicio servicio = new ArticuloServicio();
                servicio.AgregarStockMasivo(idArticulo, cantidad, condicion, nuevoPrecioVenta, precioCompra, detalles);

                return new { success = true, message = $"Se ingresaron {cantidad} unidad(es) física(s) con éxito y se unificó el precio a {nuevoPrecioVenta.ToString("C0", new System.Globalization.CultureInfo("es-AR"))}." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = "Error al ingresar stock: " + ex.Message };
            }
        }

        [WebMethod]
        public static object ActualizarArticuloAjax(long idArticulo, string nombre, string descripcion, long idMarca, long idCategoria, bool actualizarPrecio, decimal? nuevoPrecioVenta, string condicion)
        {
            try
            {
                if (idArticulo <= 0)
                    return new { success = false, message = "Artículo no válido." };

                if (string.IsNullOrWhiteSpace(nombre))
                    return new { success = false, message = "El nombre del artículo es obligatorio." };

                if (idMarca <= 0)
                    return new { success = false, message = "Debe seleccionar una marca válida." };

                if (idCategoria <= 0)
                    return new { success = false, message = "Debe seleccionar una categoría válida." };

                if (actualizarPrecio)
                {
                    if (!nuevoPrecioVenta.HasValue || nuevoPrecioVenta.Value <= 0)
                        return new { success = false, message = "Si desea actualizar el precio de venta, debe ingresar un importe mayor a 0." };

                    if (string.IsNullOrWhiteSpace(condicion))
                        return new { success = false, message = "Debe seleccionar la condición para actualizar el precio del stock disponible." };
                }

                ArticuloServicio servicio = new ArticuloServicio();
                servicio.ActualizarArticuloYPrecio(idArticulo, nombre, descripcion, idMarca, idCategoria, actualizarPrecio, nuevoPrecioVenta, condicion);

                return new { success = true, message = "Artículo actualizado correctamente." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = "Error al actualizar artículo: " + ex.Message };
            }
        }

        [WebMethod]
        public static object EliminarArticuloAjax(long idArticulo, bool bajaCascada)
        {
            try
            {
                if (idArticulo <= 0)
                    return new { success = false, message = "Artículo no válido." };

                ArticuloServicio servicio = new ArticuloServicio();
                servicio.EliminarArticulo(idArticulo, bajaCascada);

                return new { success = true, message = "El artículo fue dado de baja exitosamente." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = "Error al dar de baja el artículo: " + ex.Message };
            }
        }
    }
}
