using System;
using System.Collections.Generic;
using System.Data;
using dominio;

namespace servicio
{
    public class ArticuloServicio
    {
        public List<Articulo> ListarConSP()
        {
            List<Articulo> lista = new List<Articulo>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("sp_ListarArticulos");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Articulo art = new Articulo();
                    art.IdArticulo = (long)datos.Lector["ID_Articulo"];
                    art.Nombre = (string)datos.Lector["Nombre"];
                    
                    if (!(datos.Lector["Descripcion"] is DBNull))
                        art.Descripcion = (string)datos.Lector["Descripcion"];

                    art.Activo = (bool)datos.Lector["Activo"];

                    art.IdMarca = (long)datos.Lector["ID_Marca"];
                    art.Marca = new Marca
                    {
                        IdMarca = art.IdMarca,
                        Nombre = (string)datos.Lector["MarcaNombre"]
                    };

                    art.IdCategoria = (long)datos.Lector["ID_Categoria"];
                    art.Categoria = new Categoria
                    {
                        IdCategoria = art.IdCategoria,
                        Nombre = (string)datos.Lector["CategoriaNombre"]
                    };

                    lista.Add(art);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public long Agregar(Articulo nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_InsertarArticulo");
                datos.setearParametro("@Nombre", nuevo.Nombre);
                datos.setearParametro("@Descripcion", (object)nuevo.Descripcion ?? DBNull.Value);
                datos.setearParametro("@ID_Marca", nuevo.IdMarca);
                datos.setearParametro("@ID_Categoria", nuevo.IdCategoria);

                object resultado = datos.ejecutarAccionScalar();
                return Convert.ToInt64(resultado);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public DataTable ListarDashboardDataTable(string texto = null)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("sp_ListarArticulosDashboard");
                datos.setearParametro("@Texto", string.IsNullOrWhiteSpace(texto) ? (object)DBNull.Value : texto.Trim());
                return datos.ejecutarLecturaDT();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public DataTable FiltrarCatalogo(string texto = null, long? idCategoria = null, long? idMarca = null, decimal? precioMin = null, decimal? precioMax = null, string condicion = null, bool soloDisponibles = false, string orden = "nombre_asc")
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("sp_FiltrarArticulosCatalogo");
                datos.setearParametro("@Texto", string.IsNullOrWhiteSpace(texto) ? (object)DBNull.Value : texto.Trim());
                datos.setearParametro("@IdCategoria", idCategoria.HasValue && idCategoria.Value > 0 ? (object)idCategoria.Value : DBNull.Value);
                datos.setearParametro("@IdMarca", idMarca.HasValue && idMarca.Value > 0 ? (object)idMarca.Value : DBNull.Value);
                datos.setearParametro("@PrecioMin", precioMin.HasValue && precioMin.Value >= 0 ? (object)precioMin.Value : DBNull.Value);
                datos.setearParametro("@PrecioMax", precioMax.HasValue && precioMax.Value >= 0 ? (object)precioMax.Value : DBNull.Value);
                datos.setearParametro("@Condicion", string.IsNullOrWhiteSpace(condicion) ? (object)DBNull.Value : condicion.Trim());
                datos.setearParametro("@SoloDisponibles", soloDisponibles);
                datos.setearParametro("@Orden", string.IsNullOrWhiteSpace(orden) ? "nombre_asc" : orden);

                return datos.ejecutarLecturaDT();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void AgregarStockMasivo(long idArticulo, int cantidad, string condicion, decimal nuevoPrecioVenta, decimal? precioCompra = null, string detalles = null)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("sp_AgregarStockMasivoYUnificarPrecio");
                datos.setearParametro("@ID_Articulo", idArticulo);
                datos.setearParametro("@Cantidad", cantidad);
                datos.setearParametro("@Condicion", condicion);
                datos.setearParametro("@NuevoPrecioVenta", nuevoPrecioVenta);
                datos.setearParametro("@PrecioCompra", precioCompra.HasValue && precioCompra.Value >= 0 ? (object)precioCompra.Value : DBNull.Value);
                datos.setearParametro("@Detalles", string.IsNullOrWhiteSpace(detalles) ? (object)DBNull.Value : detalles.Trim());

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void InsertarStockItemFisico(long idArticulo, string codigo, string condicion, decimal precioVenta, decimal? precioCompra = null, string detalles = null, string etiquetaLogistica = "disponible")
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_InsertarItemFisico");
                datos.setearParametro("@ID_Articulo", idArticulo);
                datos.setearParametro("@Codigo", codigo);
                datos.setearParametro("@Detalles", string.IsNullOrWhiteSpace(detalles) ? (object)DBNull.Value : detalles.Trim());
                datos.setearParametro("@EtiquetaLogistica", etiquetaLogistica);
                datos.setearParametro("@Condicion", condicion);
                datos.setearParametro("@PrecioVenta", precioVenta);
                datos.setearParametro("@PrecioCompra", precioCompra.HasValue && precioCompra.Value >= 0 ? (object)precioCompra.Value : DBNull.Value);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void ActualizarArticuloYPrecio(long idArticulo, string nombre, string descripcion, long idMarca, long idCategoria, bool actualizarPrecio, decimal? nuevoPrecioVenta, string condicion)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("sp_ActualizarArticuloYUnificarPrecio");
                datos.setearParametro("@ID_Articulo", idArticulo);
                datos.setearParametro("@Nombre", nombre.Trim());
                datos.setearParametro("@Descripcion", string.IsNullOrWhiteSpace(descripcion) ? (object)DBNull.Value : descripcion.Trim());
                datos.setearParametro("@ID_Marca", idMarca);
                datos.setearParametro("@ID_Categoria", idCategoria);
                datos.setearParametro("@ActualizarPrecio", actualizarPrecio);
                datos.setearParametro("@NuevoPrecioVenta", (actualizarPrecio && nuevoPrecioVenta.HasValue && nuevoPrecioVenta.Value > 0) ? (object)nuevoPrecioVenta.Value : DBNull.Value);
                datos.setearParametro("@Condicion", (actualizarPrecio && !string.IsNullOrWhiteSpace(condicion)) ? (object)condicion.Trim() : DBNull.Value);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void EliminarArticulo(long idArticulo, bool bajaCascada)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("sp_EliminarArticulo");
                datos.setearParametro("@ID_Articulo", idArticulo);
                datos.setearParametro("@BajaCascada", bajaCascada);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
