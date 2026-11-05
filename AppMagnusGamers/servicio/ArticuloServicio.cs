using System;
using System.Collections.Generic;
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

                    // Mapeo del objeto Marca
                    art.IdMarca = (long)datos.Lector["ID_Marca"];
                    art.Marca = new Marca
                    {
                        IdMarca = art.IdMarca,
                        Nombre = (string)datos.Lector["MarcaNombre"]
                    };

                    // Mapeo del objeto Categoria
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
    }
}
