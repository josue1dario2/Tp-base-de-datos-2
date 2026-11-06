USE MagnusGamers_DB

GO

CREATE TRIGGER tr_proteger_presuspuesto_activo ON Presupuesto
INSTEAD OF DELETE
AS
BEGIN
  BEGIN TRY
    BEGIN TRANSACTION
     IF EXISTS(
      SELECT 1 FROM deleted D
      JOIN Remito R ON R.ID_Presupuesto = D.ID_Presupuesto )
    BEGIN
     RAISERROR('Presupuesto con remito asociado, no se puede eliminar', 16, 10);
    END

    IF EXISTS(
    SELECT 1 FROM deleted D
    WHERE D.Estado IN('enproceso', 'terminado') )
    BEGIN
     RAISERROR('Presupuesto aprobado, no se puede eliminar', 16, 10);
    END

DELETE DP FROM DetallePresupuesto DP
JOIN deleted D ON D.ID_Presupuesto = DP.ID_DetallePresupuesto;

DELETE P FROM Presupuesto P
JOIN deleted D ON D.ID_Presupuesto = P.ID_Presupuesto;

COMMIT TRANSACTION
END TRY

BEGIN CATCH
    ROLLBACK TRANSACTION;
    DECLARE @Mensaje NVARCHAR(2048); 
    SET @Mensaje = ERROR_MESSAGE();
    RAISERROR('No se pudo proceder con la eliminación del presupuesto.', 16, 10);
  END CATCH

END