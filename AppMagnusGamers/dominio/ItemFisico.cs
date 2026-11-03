using System;

namespace dominio
{
    public class ItemFisico
    {
        public long IdItemFisico { get; set; }
        public long IdArticulo { get; set; }
        public Articulo Articulo { get; set; }
        public string Codigo { get; set; }
        public string Detalles { get; set; }
        public string EtiquetaLogistica { get; set; } = "disponible";
        public string Condicion { get; set; }
        public decimal PrecioVenta { get; set; }
        public decimal? PrecioCompra { get; set; }
        public bool Activo { get; set; } = true;
        public DateTime FechaAlta { get; set; } = DateTime.Now;
    }
}

