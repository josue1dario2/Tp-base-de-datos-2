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
            if (!IsPostBack)
            {
                try
                {
                    CargarDesplegables();
                }
                catch (Exception)
                {
                    try
                    {
                        AccesoDatos.AsegurarProcedimientos();
                        CargarDesplegables();
                    }
                    catch (Exception ex2)
                    {
                        MostrarMensaje("Error al conectar con la base de datos: " + ex2.Message, false);
                    }
                }
            }
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

                Articulo nuevo = new Articulo
                {
                    Nombre = txtNombre.Text.Trim(),
                    Descripcion = string.IsNullOrWhiteSpace(txtDescripcion.Text) ? null : txtDescripcion.Text.Trim(),
                    IdMarca = long.Parse(idMarcaStr),
                    IdCategoria = long.Parse(idCategoriaStr),
                    Activo = true
                };

                long nuevoId = articuloServicio.Agregar(nuevo);

                MostrarMensaje($"¡Artículo '{nuevo.Nombre}' registrado exitosamente con ID #{nuevoId}!", true);
                LimpiarFormulario();
            }
            catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
            {
                MostrarMensaje($"Ya existe un artículo llamado '{txtNombre.Text.Trim()}' con la misma marca y categoría seleccionadas.", false);
            }
            catch (Exception ex)
            {
                MostrarMensaje("Ocurrió un error al guardar el artículo: " + ex.Message, false);
            }
        }

        private void LimpiarFormulario()
        {
            txtNombre.Text = string.Empty;
            txtDescripcion.Text = string.Empty;
            ddlMarca.SelectedIndex = 0;
            ddlCategoria.SelectedIndex = 0;
        }

        private void MostrarMensaje(string texto, bool esExito)
        {
            lblMensaje.Text = texto;
            lblMensaje.CssClass = esExito ? "alert alert-success d-block mb-3" : "alert alert-danger d-block mb-3";
            lblMensaje.Visible = true;
        }

        // ========================================================
        // WebMethods para responder a peticiones AJAX desde Modales
        // ========================================================
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
