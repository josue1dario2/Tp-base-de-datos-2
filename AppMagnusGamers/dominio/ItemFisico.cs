using System;

namespace dominio
{
    public class ItemFisico
    {
        public long IdItemFisico { get; set; }
        public long IdArticulo { get; set; }
        public Articulo Articulo { get; set; }

        // Hasta 40
        public string Codigo { get; set; }

        // hasta 500
        public string Detalles { get; set; }

        // solo admite: -disponible -reservado -vendido -service
        public string EtiquetaLogistica { get; set; } = "disponible";

        // solo admite: -nuevo -seminuevo -usado -reacondicionado
        public string Condicion { get; set; }
        public decimal PrecioVenta { get; set; }
        public decimal? PrecioCompra { get; set; }
        public bool Activo { get; set; } = true;
        public DateTime FechaAlta { get; set; } = DateTime.Now;
    }
}

