-- VISTA DE LISTA TODOS LOS ITEMS, SOLO LOS NO VENDIDOS
CREATE VIEW Listado_Items_NoVendidos AS
SELECT ID_ItemFisico, ID_Articulo, Codigo, Detalles, EtiquetaLogistica,Condicion,PrecioVenta,PrecioCompra,Activo,FechaAlta
FROM ItemFisico
WHERE EtiquetaLogistica NOT LIKE 'vendido'

GO

-- LISTA QUE TE TIRA LA VENTA POR CATEGORIAS
CREATE VIEW Ventas_Categorias AS
SELECT
	ROW_NUMBER() OVER (ORDER BY SUM(dr.PrecioFinal) DESC) AS puesto,
	c.Nombre AS nombre_categoria,
	SUM(dr.PrecioFinal) AS total_vendido
FROM DetalleRemito dr
INNER JOIN ItemFisico i ON dr.ID_ItemFisico = i.ID_ItemFisico

INNER JOIN Articulo a ON i.ID_Articulo = a.ID_Articulo

INNER JOIN Categoria c ON a.ID_Categoria = c.ID_Categoria

GROUP BY c.ID_Categoria, c.Nombre;

GO

-- VENTAS POR CLIENTES
CREATE VIEW Ventas_Clientes AS
SELECT
	ROW_NUMBER() OVER (ORDER BY SUM(dr.PrecioFinal) DESC) AS puesto,
	c.Nombre AS nombre_cliente,
	c.Apellido AS apellido_cliente,
	c.DNI AS DNI_cliente,
	SUM(dr.PrecioFinal) AS total_vendido
FROM DetalleRemito dr
INNER JOIN Remito R ON dr.ID_Remito = R.ID_Remito

INNER JOIN Presupuesto p ON r.ID_Presupuesto = p.ID_Presupuesto

INNER JOIN Cliente c ON p.ID_Cliente = c.ID_Cliente

GROUP BY c.ID_Cliente, c.Nombre, c.Apellido, c.DNI;