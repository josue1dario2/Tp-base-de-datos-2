using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Remito
    {
        public long ID_Remito {  get; set; }
        public string NroRemito { get; set; }
        public Presupuesto PresupuestoRelacionado { get; set; }
        public DateTime Fecha {  get; set; }

        // solo admite -entregado (default) -cancelado
        public string Estado { get; set; }
        public bool Envio {  get; set; }
        public decimal CostoEnvio { get; set; }
        public bool Activo { get; set; }
    }
}
