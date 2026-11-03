using System;

namespace dominio
{
    public class Marca
    {
        public long IdMarca { get; set; }
        public string Nombre { get; set; }
        public bool Activo { get; set; } = true;

        public override string ToString()
        {
            return Nombre;
        }
    }
}

