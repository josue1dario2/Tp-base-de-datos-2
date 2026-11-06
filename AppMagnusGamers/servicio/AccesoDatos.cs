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
                  END;",

                @"CREATE OR ALTER PROCEDURE dbo.sp_ListarArticulos
                  AS
                  BEGIN
                      SET NOCOUNT ON;
                      SELECT 
                          A.ID_Articulo,
                          A.Nombre,
                          A.Descripcion,
                          A.Activo,
                          A.ID_Marca,
                          M.Nombre AS MarcaNombre,
                          A.ID_Categoria,
                          C.Nombre AS CategoriaNombre
                      FROM Articulo A
                      INNER JOIN Marca M ON A.ID_Marca = M.ID_Marca
                      INNER JOIN Categoria C ON A.ID_Categoria = C.ID_Categoria
                      WHERE A.Activo = 1
                      ORDER BY A.Nombre ASC;
                  END;",

                @"CREATE OR ALTER PROCEDURE dbo.sp_FiltrarItemsFisicos
                      @Texto NVARCHAR(100) = NULL,
                      @IdCategoria BIGINT = NULL,
                      @IdMarca BIGINT = NULL,
                      @PrecioMin DECIMAL(12,2) = NULL,
                      @PrecioMax DECIMAL(12,2) = NULL,
                      @Condicion VARCHAR(20) = NULL,
                      @SoloDisponibles BIT = 0,
                      @Orden VARCHAR(20) = 'nombre_asc'
                  AS
                  BEGIN
                      SET NOCOUNT ON;

                      IF LTRIM(RTRIM(@Texto)) = '' SET @Texto = NULL;
                      IF LTRIM(RTRIM(@Condicion)) = '' SET @Condicion = NULL;
                      IF @IdCategoria <= 0 SET @IdCategoria = NULL;
                      IF @IdMarca <= 0 SET @IdMarca = NULL;

                      SELECT 
                          I.ID_ItemFisico,
                          I.Codigo,
                          I.Detalles,
                          I.EtiquetaLogistica,
                          I.Condicion,
                          I.PrecioVenta,
                          I.PrecioCompra,
                          I.Activo AS ItemActivo,
                          I.FechaAlta,
                          A.ID_Articulo,
                          A.Nombre AS ArticuloNombre,
                          A.Descripcion AS ArticuloDescripcion,
                          A.Activo AS ArticuloActivo,
                          M.ID_Marca,
                          M.Nombre AS MarcaNombre,
                          C.ID_Categoria,
                          C.Nombre AS CategoriaNombre
                      FROM ItemFisico I
                      INNER JOIN Articulo A ON I.ID_Articulo = A.ID_Articulo
                      INNER JOIN Marca M ON A.ID_Marca = M.ID_Marca
                      INNER JOIN Categoria C ON A.ID_Categoria = C.ID_Categoria
                      WHERE I.Activo = 1 
                        AND A.Activo = 1
                        AND (@Texto IS NULL OR A.Nombre LIKE '%' + @Texto + '%' OR A.Descripcion LIKE '%' + @Texto + '%' OR I.Codigo LIKE '%' + @Texto + '%' OR I.Detalles LIKE '%' + @Texto + '%')
                        AND (@IdCategoria IS NULL OR A.ID_Categoria = @IdCategoria)
                        AND (@IdMarca IS NULL OR A.ID_Marca = @IdMarca)
                        AND (@Condicion IS NULL OR I.Condicion = @Condicion)
                        AND (@SoloDisponibles = 0 OR I.EtiquetaLogistica = 'disponible')
                        AND (@PrecioMin IS NULL OR I.PrecioVenta >= @PrecioMin)
                        AND (@PrecioMax IS NULL OR I.PrecioVenta <= @PrecioMax)
                      ORDER BY 
                          CASE WHEN @Orden = 'precio_asc' THEN I.PrecioVenta END ASC,
                          CASE WHEN @Orden = 'precio_desc' THEN I.PrecioVenta END DESC,
                          CASE WHEN @Orden = 'nombre_desc' THEN A.Nombre END DESC,
                          CASE WHEN @Orden = 'nombre_asc' OR @Orden IS NULL THEN A.Nombre END ASC,
                          I.ID_ItemFisico ASC;
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
