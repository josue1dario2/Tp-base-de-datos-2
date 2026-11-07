using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class DetallePresupuesto
    {
        public long ID_DetallePresupuesto {  get; set; }
        public Presupuesto PresupuestoRelacionado { get; set; }
        public ItemFisico ItemFisicoRelacionado { get; set; }
        public decimal PrecioFinal {  get; set; }
    }
}
