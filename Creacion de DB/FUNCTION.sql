USE MagnusGamers_DB;
GO

-- Devuelve el total de un presupuesto: ítems más costo de envío.

CREATE FUNCTION fn_TotalPresupuesto
(
    @ID_Presupuesto BIGINT
)
RETURNS DECIMAL(12,2)
AS
BEGIN
    DECLARE @Subtotal DECIMAL(12,2);
    DECLARE @CostoEnvio DECIMAL(12,2);

    SELECT
        @Subtotal = ISNULL(SUM(PrecioFinal), 0)
    FROM DetallePresupuesto
    WHERE ID_Presupuesto = @ID_Presupuesto;

    SELECT
        @CostoEnvio = CostoEnvio
    FROM Presupuesto
    WHERE ID_Presupuesto = @ID_Presupuesto;

    RETURN ISNULL(@Subtotal, 0) + ISNULL(@CostoEnvio, 0);
END;
GO