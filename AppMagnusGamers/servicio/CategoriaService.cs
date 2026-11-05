using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using dominio;

namespace servicio
{
    public class CategoriaService
    {
        public List<Categoria> Listar()
        {
            List<Categoria> lista = new List<Categoria>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("SP_ListarCategorias");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Categoria cat = new Categoria();
                    cat.IdCategoria = (long)datos.Lector["ID_Categoria"];
                    cat.Nombre = (string)datos.Lector["Nombre"];
                    cat.Activo = true;

                    lista.Add(cat);
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

        public long Agregar(string nombre)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("SP_InsertarCategoria");
                datos.setearParametro("@Nombre", nombre);

                object resultado = datos.ejecutarAccionScalar();
                return Convert.ToInt64(resultado);
            }
            catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
            {
                throw new Exception($"La categoría '{nombre}' ya existe en el sistema. Por favor elija otro nombre.");
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
