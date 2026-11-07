using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Presupuesto
    {
        public long ID_Presupuesto { get; set; }
        
        // hasta 20 caracteres
        public string NroPresupuesto { get; set; }
        public Cliente ClienteComprador { get; set; }
        public DateTime Fecha { get; set; }

        // solo admite -poraprobar -enproceso -cancelado -terminado
        public string Estado { get; set; }
        public bool Envio {  get; set; }
        public decimal CostoEnvio { get; set; }
        public bool Activo { get; set; }

    }
}
