using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using servicio;

namespace AppMagnusGamers
{
    public partial class AltaArticulo : Page
    {
        private MarcaService marcaService = new MarcaService();
        private CategoriaService categoriaService = new CategoriaService();
        private ArticuloServicio articuloServicio = new ArticuloServicio();

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect("~/Articulos", false);
            Context.ApplicationInstance.CompleteRequest();
            return;
        }

        private void CargarDesplegables()
        {
            // Cargar Marcas
            ddlMarca.DataSource = marcaService.Listar();
            ddlMarca.DataTextField = "Nombre";
            ddlMarca.DataValueField = "IdMarca";
            ddlMarca.DataBind();
            ddlMarca.Items.Insert(0, new ListItem("-- Seleccionar Marca --", ""));

            // Cargar Categorías
            ddlCategoria.DataSource = categoriaService.Listar();
            ddlCategoria.DataTextField = "Nombre";
            ddlCategoria.DataValueField = "IdCategoria";
            ddlCategoria.DataBind();
            ddlCategoria.Items.Insert(0, new ListItem("-- Seleccionar Categoría --", ""));
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(txtNombre.Text))
                {
                    MostrarMensaje("El nombre del artículo es obligatorio.", false);
                    return;
                }

                string idMarcaStr = Request.Form[ddlMarca.UniqueID] ?? Request.Form["ddlMarca"] ?? ddlMarca.SelectedValue;
                string idCategoriaStr = Request.Form[ddlCategoria.UniqueID] ?? Request.Form["ddlCategoria"] ?? ddlCategoria.SelectedValue;

                if (string.IsNullOrEmpty(idMarcaStr))
                {
                    MostrarMensaje("Debe seleccionar una marca.", false);
                    return;
                }

                if (string.IsNullOrEmpty(idCategoriaStr))
                {
                    MostrarMensaje("Debe seleccionar una categoría.", false);
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtCodigoItem.Text))
                {
                    MostrarMensaje("Debe ingresar un código para la unidad de stock (ej: PS5-001).", false);
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtPrecioVenta.Text) ||
                    (!decimal.TryParse(txtPrecioVenta.Text.Trim(), System.Globalization.NumberStyles.Any, System.Globalization.CultureInfo.InvariantCulture, out decimal precioVenta) &&
                     !decimal.TryParse(txtPrecioVenta.Text.Trim(), out precioVenta)) ||
                    precioVenta < 0)
                {
                    MostrarMensaje("Debe ingresar un precio de venta válido mayor o igual a 0.", false);
                    return;
                }

                string condicion = ddlCondicionItem.SelectedValue;
                if (string.IsNullOrWhiteSpace(condicion))
                    condicion = "nuevo";

                Articulo nuevoArticulo = new Articulo
                {
                    Nombre = txtNombre.Text.Trim(),
                    Descripcion = string.IsNullOrWhiteSpace(txtDescripcion.Text) ? null : txtDescripcion.Text.Trim(),
                    IdMarca = long.Parse(idMarcaStr),
                    IdCategoria = long.Parse(idCategoriaStr),
                    Activo = true
                };

                long nuevoIdArticulo = articuloServicio.Agregar(nuevoArticulo);

                ItemFisico nuevoItem = new ItemFisico
                {
                    IdArticulo = nuevoIdArticulo,
                    Codigo = txtCodigoItem.Text.Trim(),
                    Condicion = condicion,
                    PrecioVenta = precioVenta,
                    Detalles = string.IsNullOrWhiteSpace(txtDetallesItem.Text) ? null : txtDetallesItem.Text.Trim(),
                    EtiquetaLogistica = "disponible",
                    Activo = true
                };

                ItemFisicoServicio itemService = new ItemFisicoServicio();
                long nuevoIdItem = itemService.Agregar(nuevoItem);

                MostrarMensaje($"¡Artículo '{nuevoArticulo.Nombre}' registrado exitosamente con unidad física #{nuevoItem.Codigo} (${nuevoItem.PrecioVenta:N0})! Ya podés verlo en el catálogo.", true);
                LimpiarFormulario();
            }
            catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
            {
                if (ex.Message.Contains("UQ_Articulo") || ex.Message.Contains("Articulo"))
                {
                    MostrarMensaje($"Ya existe un artículo llamado '{txtNombre.Text.Trim()}' con la misma marca y categoría seleccionadas.", false);
                }
                else if (ex.Message.Contains("Codigo") || ex.Message.Contains("ItemFisico"))
                {
                    MostrarMensaje($"El código de unidad física '{txtCodigoItem.Text.Trim()}' ya existe en el sistema. Por favor elija un código único.", false);
                }
                else
                {
                    MostrarMensaje("Ya existe un registro con esos datos únicos en el sistema.", false);
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Ocurrió un error al guardar: " + ex.Message, false);
            }
        }

        private void LimpiarFormulario()
        {
            txtNombre.Text = string.Empty;
            txtDescripcion.Text = string.Empty;
            ddlMarca.SelectedIndex = 0;
            ddlCategoria.SelectedIndex = 0;
            txtCodigoItem.Text = string.Empty;
            txtPrecioVenta.Text = string.Empty;
            txtDetallesItem.Text = string.Empty;
            ddlCondicionItem.SelectedIndex = 0;
        }

        private void MostrarMensaje(string texto, bool esExito)
        {
            lblMensaje.Text = texto;
            lblMensaje.CssClass = esExito ? "alert alert-success d-block mb-3" : "alert alert-danger d-block mb-3";
            lblMensaje.Visible = true;
        }

        [WebMethod]
        public static object AgregarMarcaAjax(string nombre)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(nombre))
                    return new { success = false, message = "El nombre de la marca no puede estar vacío." };

                MarcaService service = new MarcaService();
                long nuevoId = service.Agregar(nombre.Trim());

                return new { success = true, id = nuevoId, nombre = nombre.Trim() };
            }
            catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
            {
                return new { success = false, message = $"La marca '{nombre.Trim()}' ya existe en el sistema. Por favor elija otro nombre." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = "No se pudo registrar la marca: " + ex.Message };
            }
        }

        [WebMethod]
        public static object AgregarCategoriaAjax(string nombre)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(nombre))
                    return new { success = false, message = "El nombre de la categoría no puede estar vacío." };

                CategoriaService service = new CategoriaService();
                long nuevoId = service.Agregar(nombre.Trim());

                return new { success = true, id = nuevoId, nombre = nombre.Trim() };
            }
            catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
            {
                return new { success = false, message = $"La categoría '{nombre.Trim()}' ya existe en el sistema. Por favor elija otro nombre." };
            }
            catch (Exception ex)
            {
                return new { success = false, message = "No se pudo registrar la categoría: " + ex.Message };
            }
        }
    }
}
