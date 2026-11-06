using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class AuditoriaItemFisico
    {
        public long ID_Auditoria {  get; set; }
        public ItemFisico ItemRelacionado { get; set; }
        
        // solo admite -RESERVA -LIBERACION -VENTA -ACTUALIZACION
        public string Operacion {  get; set; }
        public string EstadoAnterior { get; set; }
        public string EstadoNuevo { get; set; }
        public DateTime Fecha { get; set; }

        // hasta 500
        public string Observacion { get; set; }
    }
}
