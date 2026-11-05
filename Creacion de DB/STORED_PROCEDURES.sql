USE MagnusGamers_DB;
GO


CREATE OR ALTER PROCEDURE dbo.sp_ListarArticulos
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
END;
GO

CREATE OR ALTER PROCEDURE dbo.SP_ListarMarcas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ID_Marca, Nombre
    FROM Marca
    WHERE Activo = 1
    ORDER BY Nombre ASC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.SP_ListarCategorias
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ID_Categoria, Nombre
    FROM Categoria
    WHERE Activo = 1
    ORDER BY Nombre ASC;
END;
GO

CREATE OR ALTER PROCEDURE dbo.SP_InsertarMarca
    @Nombre NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Marca (Nombre, Activo)
    VALUES (@Nombre, 1);
    SELECT SCOPE_IDENTITY() AS NuevoID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.SP_InsertarCategoria
    @Nombre NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Categoria (Nombre, Activo)
    VALUES (@Nombre, 1);
    SELECT SCOPE_IDENTITY() AS NuevoID;
END;
GO

CREATE OR ALTER PROCEDURE dbo.SP_InsertarArticulo
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
END;
GO
