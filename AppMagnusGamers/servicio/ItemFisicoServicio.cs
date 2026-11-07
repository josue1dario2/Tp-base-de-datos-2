using System;
using System.Collections.Generic;
using dominio;

namespace servicio
{
    public class ItemFisicoServicio
    {
        public List<ItemFisico> Filtrar(string texto = null, long? idCategoria = null, long? idMarca = null, decimal? precioMin = null, decimal? precioMax = null, string condicion = null, bool soloDisponibles = false, string orden = "nombre_asc")
        {
            List<ItemFisico> lista = new List<ItemFisico>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("sp_FiltrarItemsFisicos");
                datos.setearParametro("@Texto", string.IsNullOrWhiteSpace(texto) ? (object)DBNull.Value : texto.Trim());
                datos.setearParametro("@IdCategoria", idCategoria.HasValue && idCategoria.Value > 0 ? (object)idCategoria.Value : DBNull.Value);
                datos.setearParametro("@IdMarca", idMarca.HasValue && idMarca.Value > 0 ? (object)idMarca.Value : DBNull.Value);
                datos.setearParametro("@PrecioMin", precioMin.HasValue && precioMin.Value >= 0 ? (object)precioMin.Value : DBNull.Value);
                datos.setearParametro("@PrecioMax", precioMax.HasValue && precioMax.Value >= 0 ? (object)precioMax.Value : DBNull.Value);
                datos.setearParametro("@Condicion", string.IsNullOrWhiteSpace(condicion) ? (object)DBNull.Value : condicion.Trim());
                datos.setearParametro("@SoloDisponibles", soloDisponibles);
                datos.setearParametro("@Orden", string.IsNullOrWhiteSpace(orden) ? "nombre_asc" : orden);

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    ItemFisico item = new ItemFisico();
                    item.IdItemFisico = (long)datos.Lector["ID_ItemFisico"];
                    item.IdArticulo = (long)datos.Lector["ID_Articulo"];
                    item.Codigo = (string)datos.Lector["Codigo"];

                    if (!(datos.Lector["Detalles"] is DBNull))
                        item.Detalles = (string)datos.Lector["Detalles"];

                    item.EtiquetaLogistica = (string)datos.Lector["EtiquetaLogistica"];
                    item.Condicion = (string)datos.Lector["Condicion"];
                    item.PrecioVenta = Convert.ToDecimal(datos.Lector["PrecioVenta"]);

                    if (!(datos.Lector["PrecioCompra"] is DBNull))
                        item.PrecioCompra = Convert.ToDecimal(datos.Lector["PrecioCompra"]);

                    item.Activo = (bool)datos.Lector["ItemActivo"];
                    item.FechaAlta = Convert.ToDateTime(datos.Lector["FechaAlta"]);

                    Articulo art = new Articulo();
                    art.IdArticulo = item.IdArticulo;
                    art.Nombre = (string)datos.Lector["ArticuloNombre"];

                    if (!(datos.Lector["ArticuloDescripcion"] is DBNull))
                        art.Descripcion = (string)datos.Lector["ArticuloDescripcion"];

                    art.Activo = (bool)datos.Lector["ArticuloActivo"];

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

                    item.Articulo = art;
                    lista.Add(item);
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

        public long Agregar(ItemFisico nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_InsertarItemFisico");
                datos.setearParametro("@ID_Articulo", nuevo.IdArticulo);
                datos.setearParametro("@Codigo", nuevo.Codigo.Trim());
                datos.setearParametro("@Detalles", string.IsNullOrWhiteSpace(nuevo.Detalles) ? (object)DBNull.Value : nuevo.Detalles.Trim());
                datos.setearParametro("@EtiquetaLogistica", string.IsNullOrWhiteSpace(nuevo.EtiquetaLogistica) ? "disponible" : nuevo.EtiquetaLogistica);
                datos.setearParametro("@Condicion", nuevo.Condicion);
                datos.setearParametro("@PrecioVenta", nuevo.PrecioVenta);
                datos.setearParametro("@PrecioCompra", nuevo.PrecioCompra.HasValue ? (object)nuevo.PrecioCompra.Value : DBNull.Value);

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
    }
}

