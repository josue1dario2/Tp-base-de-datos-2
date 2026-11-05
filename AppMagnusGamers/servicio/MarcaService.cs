using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using dominio;

namespace servicio
{
    public class MarcaService
    {
        public List<Marca> Listar()
        {
            List<Marca> lista = new List<Marca>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("SP_ListarMarcas");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Marca marca = new Marca();
                    marca.IdMarca = (long)datos.Lector["ID_Marca"];
                    marca.Nombre = (string)datos.Lector["Nombre"];
                    marca.Activo = true;

                    lista.Add(marca);
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
                datos.setearProcedimiento("SP_InsertarMarca");
                datos.setearParametro("@Nombre", nombre);

                object resultado = datos.ejecutarAccionScalar();
                return Convert.ToInt64(resultado);
            }
            catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
            {
                throw new Exception($"La marca '{nombre}' ya existe en el sistema. Por favor elija otro nombre.");
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
