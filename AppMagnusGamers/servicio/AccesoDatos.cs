using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace servicio
{
    public class AccesoDatos
    {
        private SqlConnection conexion;
        private SqlCommand comando;
        private SqlDataReader lector;

        public SqlDataReader Lector
        {
            get { return lector; }
        }

        public AccesoDatos()
        {
            string connectionString = null;
            if (ConfigurationManager.ConnectionStrings["cadenaConexion"] != null)
            {
                connectionString = ConfigurationManager.ConnectionStrings["cadenaConexion"].ConnectionString;
            }

            if (string.IsNullOrWhiteSpace(connectionString))
            {
                connectionString = "server=.\\SQLEXPRESS; database=MagnusGamers_DB; integrated security=true; Encrypt=False;";
            }

            conexion = new SqlConnection(connectionString);
            comando = new SqlCommand();
        }

        public void setearProcedimiento(string sp)
        {
            comando.CommandType = CommandType.StoredProcedure;
            comando.CommandText = sp;
        }

        public void setearConsulta(string consulta)
        {
            comando.CommandType = CommandType.Text;
            comando.CommandText = consulta;
        }

        public void setearParametro(string nombre, object valor)
        {
            comando.Parameters.AddWithValue(nombre, valor ?? DBNull.Value);
        }

        public void ejecutarLectura()
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                lector = comando.ExecuteReader();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public int ejecutarAccion()
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                return comando.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public object ejecutarAccionScalar()
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                return comando.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void cerrarConexion()
        {
            if (lector != null && !lector.IsClosed)
            {
                lector.Close();
            }
            if (conexion != null && conexion.State == ConnectionState.Open)
            {
                conexion.Close();
            }
        }

        public static void AsegurarProcedimientos()
        {
            string[] scripts = new string[]
            {
                @"CREATE OR ALTER PROCEDURE dbo.SP_ListarMarcas
                  AS
                  BEGIN
                      SET NOCOUNT ON;
                      SELECT ID_Marca, Nombre FROM Marca WHERE Activo = 1 ORDER BY Nombre ASC;
                  END;",

                @"CREATE OR ALTER PROCEDURE dbo.SP_ListarCategorias
                  AS
                  BEGIN
                      SET NOCOUNT ON;
                      SELECT ID_Categoria, Nombre FROM Categoria WHERE Activo = 1 ORDER BY Nombre ASC;
                  END;",

                @"CREATE OR ALTER PROCEDURE dbo.SP_InsertarMarca
                      @Nombre NVARCHAR(50)
                  AS
                  BEGIN
                      SET NOCOUNT ON;
                      INSERT INTO Marca (Nombre, Activo) VALUES (@Nombre, 1);
                      SELECT SCOPE_IDENTITY() AS NuevoID;
                  END;",

                @"CREATE OR ALTER PROCEDURE dbo.SP_InsertarCategoria
                      @Nombre NVARCHAR(50)
                  AS
                  BEGIN
                      SET NOCOUNT ON;
                      INSERT INTO Categoria (Nombre, Activo) VALUES (@Nombre, 1);
                      SELECT SCOPE_IDENTITY() AS NuevoID;
                  END;",

                @"CREATE OR ALTER PROCEDURE dbo.SP_InsertarArticulo
                      @Nombre NVARCHAR(100),
                      @Descripcion NVARCHAR(500),
                      @ID_Marca BIGINT,
                      @ID_Categoria BIGINT
                  AS
                  BEGIN
                      SET NOCOUNT ON;
                      INSERT INTO Articulo (Nombre, Descripcion, ID_Marca, ID_Categoria, Activo)
                      VALUES (@Nombre, @Descripcion, @ID_Marca, @ID_Categoria, 1);
                      SELECT SCOPE_IDENTITY() AS NuevoID;
                  END;"
            };

            foreach (var script in scripts)
            {
                AccesoDatos datos = new AccesoDatos();
                try
                {
                    datos.setearConsulta(script);
                    datos.ejecutarAccion();
                }
                catch
                {
                }
                finally
                {
                    datos.cerrarConexion();
                }
            }
        }
    }
}
