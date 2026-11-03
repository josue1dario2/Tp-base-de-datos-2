USE MagnusGamers_DB;
GO

CREATE OR ALTER PROCEDURE sp_ListarArticulos
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

