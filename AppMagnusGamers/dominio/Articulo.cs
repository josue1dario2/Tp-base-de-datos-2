using System;

namespace dominio
{
    public class Articulo
    {
        public long IdArticulo { get; set; }
        
        // Hasta 100, es único
        public string Nombre { get; set; }

        // hasta 500
        public string Descripcion { get; set; }
        public long IdMarca { get; set; }
        public Marca Marca { get; set; }
        public long IdCategoria { get; set; }
        public Categoria Categoria { get; set; }
        public bool Activo { get; set; } = true;

        public override string ToString()
        {
            return Nombre;
        }
    }
}
