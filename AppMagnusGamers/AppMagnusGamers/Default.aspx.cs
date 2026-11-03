using System;
using System.Collections.Generic;
using System.Web.UI;
using dominio;
using servicio;

namespace AppMagnusGamers
{
    public partial class _Default : Page
    {
        public List<Articulo> ListaArticulos { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    ArticuloServicio servicio = new ArticuloServicio();
                    ListaArticulos = servicio.ListarConSP();

                    repArticulos.DataSource = ListaArticulos;
                    repArticulos.DataBind();
                }
                catch (Exception ex)
                {
                    lblError.Text = "Ocurrió un error al cargar los artículos: " + ex.Message;
                    lblError.Visible = true;
                }
            }
        }
    }
}
