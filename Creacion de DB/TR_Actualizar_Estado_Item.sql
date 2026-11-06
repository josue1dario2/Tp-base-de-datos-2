USE MagnusGamers_DB

GO

CREATE TRIGGER  tr_Actualizar_Estado_Item ON DetalleRemito
AFTER INSERT
AS
BEGIN 
  BEGIN TRY
      BEGIN TRANSACTION
      IF EXISTS ( SELECT 1 FROM inserted I
      JOIN ItemFisico F ON F.ID_ItemFisico = I.ID_ItemFisico
      where F.Activo = 0 OR F.EtiquetaLogistica NOT IN ('disponible', 'reservado'))
      BEGIN
      RAISERROR('Error en la disponibilidad de items', 16, 10);
      END

      UPDATE F SET F.EtiquetaLogistica = 'vendido' FROM ItemFisico F
      JOIN inserted I ON I.ID_ItemFisico = F.ID_ItemFisico;
      COMMIT TRANSACTION
   END TRY
   
  BEGIN CATCH
      ROLLBACK TRANSACTION;
      DECLARE @Mensaje NVARCHAR(2048); 
      SET @Mensaje = ERROR_MESSAGE();
      RAISERROR('No se puedo actualizar el estado de producto', 16, 10);
  END CATCH

END


