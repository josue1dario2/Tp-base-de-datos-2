
CREATE DATABASE MagnusGamers_DB;
GO

USE MagnusGamers_DB;
GO

CREATE TABLE Marca (
    ID_Marca BIGINT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Categoria (
    ID_Categoria BIGINT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);
GO

CREATE TABLE Articulo (
    ID_Articulo BIGINT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(500) NULL,
    ID_Marca BIGINT NOT NULL,
    ID_Categoria BIGINT NOT NULL,
    Activo BIT NOT NULL DEFAULT 1,

    CONSTRAINT UQ_Articulo_Nombre_Marca_Categoria
        UNIQUE (Nombre, ID_Marca, ID_Categoria),

    FOREIGN KEY (ID_Marca) REFERENCES Marca(ID_Marca),
    FOREIGN KEY (ID_Categoria) REFERENCES Categoria(ID_Categoria)
);
GO

CREATE TABLE ItemFisico (
    ID_ItemFisico BIGINT IDENTITY(1,1) PRIMARY KEY,
    ID_Articulo BIGINT NOT NULL,
    Codigo NVARCHAR(40) NOT NULL UNIQUE,
    Detalles NVARCHAR(500) NULL,
    EtiquetaLogistica VARCHAR(20) NOT NULL DEFAULT 'disponible',
    Condicion VARCHAR(20) NOT NULL,
    PrecioVenta DECIMAL(12,2) NOT NULL,
    PrecioCompra DECIMAL(12,2) NULL,
    Activo BIT NOT NULL DEFAULT 1,
    FechaAlta DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    FOREIGN KEY (ID_Articulo) REFERENCES Articulo(ID_Articulo),

    CONSTRAINT CK_ItemFisico_EtiquetaLogistica
        CHECK (EtiquetaLogistica IN ('disponible', 'reservado', 'vendido', 'service')),

    CONSTRAINT CK_ItemFisico_Condicion
        CHECK (Condicion IN ('nuevo', 'seminuevo', 'usado', 'reacondicionado')),

    CONSTRAINT CK_ItemFisico_Precios
        CHECK (
            PrecioVenta >= 0
            AND (PrecioCompra IS NULL OR PrecioCompra >= 0)
        )
);
GO

CREATE TABLE Cliente (
    ID_Cliente BIGINT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(40) NOT NULL,
    Apellido NVARCHAR(40) NULL,
    DNI VARCHAR(8) NULL UNIQUE,
    Telefono VARCHAR(20) NULL,
    Direccion NVARCHAR(100) NULL,
    Activo BIT NOT NULL DEFAULT 1,

    CONSTRAINT CK_Cliente_DNI
        CHECK (
            DNI IS NULL
            OR (LEN(DNI) = 8 AND DNI NOT LIKE '%[^0-9]%')
        ),

    CONSTRAINT CK_Cliente_Telefono
        CHECK (
            Telefono IS NULL
            OR Telefono NOT LIKE '%[^0-9]%'
        )
);
GO

CREATE TABLE Presupuesto (
    ID_Presupuesto BIGINT IDENTITY(1,1) PRIMARY KEY,
    NroPresupuesto VARCHAR(20) NOT NULL UNIQUE,
    ID_Cliente BIGINT NOT NULL,
    Fecha DATE NOT NULL DEFAULT GETDATE(),
    Estado VARCHAR(20) NOT NULL DEFAULT 'poraprobar',
    Envio BIT NOT NULL DEFAULT 0,
    CostoEnvio DECIMAL(12,2) NOT NULL DEFAULT 0,
    Activo BIT NOT NULL DEFAULT 1,

    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente),

    CONSTRAINT CK_Presupuesto_Estado
        CHECK (Estado IN ('poraprobar', 'enproceso', 'cancelado', 'terminado')),

    CONSTRAINT CK_Presupuesto_CostoEnvio
        CHECK (
            (Envio = 0 AND CostoEnvio = 0)
            OR (Envio = 1 AND CostoEnvio >= 0)
        )
);
GO

CREATE TABLE DetallePresupuesto (
    ID_DetallePresupuesto BIGINT IDENTITY(1,1) PRIMARY KEY,
    ID_Presupuesto BIGINT NOT NULL,
    ID_ItemFisico BIGINT NOT NULL,
    PrecioFinal DECIMAL(12,2) NOT NULL,

    FOREIGN KEY (ID_Presupuesto) REFERENCES Presupuesto(ID_Presupuesto),
    FOREIGN KEY (ID_ItemFisico) REFERENCES ItemFisico(ID_ItemFisico),

    CONSTRAINT UQ_DetallePresupuesto_Item
        UNIQUE (ID_Presupuesto, ID_ItemFisico),

    CONSTRAINT CK_DetallePresupuesto_PrecioFinal
        CHECK (PrecioFinal >= 0)
);
GO

CREATE TABLE Remito (
    ID_Remito BIGINT IDENTITY(1,1) PRIMARY KEY,
    NroRemito VARCHAR(20) NOT NULL UNIQUE,
    ID_Presupuesto BIGINT NOT NULL UNIQUE,
    Fecha DATE NOT NULL DEFAULT GETDATE(),
    Estado VARCHAR(20) NOT NULL DEFAULT 'entregado',
    Envio BIT NOT NULL DEFAULT 0,
    CostoEnvio DECIMAL(12,2) NOT NULL DEFAULT 0,
    Activo BIT NOT NULL DEFAULT 1,

    FOREIGN KEY (ID_Presupuesto) REFERENCES Presupuesto(ID_Presupuesto),

    CONSTRAINT CK_Remito_Estado
        CHECK (Estado IN ('entregado', 'cancelado')),

    CONSTRAINT CK_Remito_CostoEnvio
        CHECK (
            (Envio = 0 AND CostoEnvio = 0)
            OR (Envio = 1 AND CostoEnvio >= 0)
        )
);
GO

CREATE TABLE DetalleRemito (
    ID_DetalleRemito BIGINT IDENTITY(1,1) PRIMARY KEY,
    ID_Remito BIGINT NOT NULL,
    ID_ItemFisico BIGINT NOT NULL,
    PrecioFinal DECIMAL(12,2) NOT NULL,

    FOREIGN KEY (ID_Remito) REFERENCES Remito(ID_Remito),
    FOREIGN KEY (ID_ItemFisico) REFERENCES ItemFisico(ID_ItemFisico),

    CONSTRAINT UQ_DetalleRemito_Item
        UNIQUE (ID_Remito, ID_ItemFisico),

    CONSTRAINT CK_DetalleRemito_PrecioFinal
        CHECK (PrecioFinal >= 0)
);
GO

CREATE TABLE AuditoriaItemFisico (
    ID_Auditoria BIGINT IDENTITY(1,1) PRIMARY KEY,
    ID_ItemFisico BIGINT NOT NULL,
    Operacion VARCHAR(30) NOT NULL,
    EstadoAnterior VARCHAR(20) NULL,
    EstadoNuevo VARCHAR(20) NULL,
    Fecha DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Observacion NVARCHAR(500) NULL,

    FOREIGN KEY (ID_ItemFisico) REFERENCES ItemFisico(ID_ItemFisico),

    CONSTRAINT CK_AuditoriaItemFisico_Operacion
        CHECK (Operacion IN ('RESERVA', 'LIBERACION', 'VENTA', 'ACTUALIZACION'))
);
GO

CREATE INDEX IX_ItemFisico_Estado
ON ItemFisico (EtiquetaLogistica, Activo);
GO

CREATE INDEX IX_Remito_Fecha_Estado
ON Remito (Fecha, Estado);
GO