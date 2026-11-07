using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Cliente
    {
        public long ID_Cliente {  get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }

        //Solo admite numeros
        public string DNI {  get; set; }

        // solo admite numeros
        public string Telefono { get; set; }
        public string Direccion {  get; set; }
        public bool Activo { get; set; } = true;

    }
}
