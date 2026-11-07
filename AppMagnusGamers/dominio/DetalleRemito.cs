using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class DetalleRemito
    {
        public long ID_DetalleRemito { get; set; }
        public Remito RemitoRelacionado { get; set; }
        public ItemFisico ItemFisicoRelacionado { get; set; }
        public decimal PrecioFinal { get; set; }
    }
}
