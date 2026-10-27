CREATE DATABASE MagnusGamers_DB
GO
USE MagnusGamers_DB;
GO

-- CREACION DE LAS TABLAS

CREATE TABLE Marca (
ID_Marca BIGINT IDENTITY (1,1) PRIMARY KEY NOT NULL,
Nombre NVARCHAR (50) NOT NULL,
Activo BIT CONSTRAINT DF_Marca_Activo DEFAULT 1 NOT NULL
);

CREATE TABLE Categoria (
ID_Categoria BIGINT IDENTITY (1,1) PRIMARY KEY NOT NULL,
Nombre NVARCHAR (50) NOT NULL,
Activo BIT CONSTRAINT DF_Categoria_Activo DEFAULT 1 NOT NULL
);

CREATE TABLE Articulo(
ID_Articulo BIGINT IDENTITY (1,1) PRIMARY KEY NOT NULL,
Nombre NVARCHAR (100) NOT NULL,
Descripcion NVARCHAR (500) NULL,
ID_Marca BIGINT NOT NULL,
ID_Categoria BIGINT NOT NULL,
Activo BIT CONSTRAINT DF_Articulo_Activo DEFAULT 1 NOT NULL
);

CREATE TABLE ItemFisico(
ID_ItemFisico BIGINT IDENTITY (1,1) PRIMARY KEY NOT NULL,
ID_Articulo BIGINT NOT NULL,
Codigo NVARCHAR (40) NULL,
Detalles NVARCHAR (500) NULL,
EtiquetaLogistica VARCHAR (20) NOT NULL
	CONSTRAINT CK_ItemFisico_EtiquetaLogistica
	CHECK (EtiquetaLogistica IN ('disponible', 'reservado', 'vendido', 'service')),
Condicion VARCHAR (20) NOT NULL
	CONSTRAINT CK_ItemFisico_Condicion
	CHECK (Condicion IN ('nuevo', 'seminuevo', 'usado', 'reacondicionado')),
PrecioVenta DECIMAL (10,2) NULL,
PrecioCompra DECIMAL (10,2) NULL,
Activo BIT CONSTRAINT DF_ItemFisico DEFAULT 1 NOT NULL
);

CREATE TABLE Cliente (
ID_Cliente BIGINT IDENTITY (1,1) PRIMARY KEY NOT NULL,
Nombre NVARCHAR (40) NOT NULL,
Apellido NVARCHAR (40) NULL,
DNI VARCHAR(8)
	CONSTRAINT CK_Cliente_DNI
	CHECK (DNI IS NULL OR DNI NOT LIKE '%[^0-9]%') NULL,
Telefono VARCHAR(20)
	CONSTRAINT CK_Cliente_Telefono
	CHECK (Telefono IS NULL OR Telefono NOT LIKE '%[^0-9]%') NULL,
Direccion NVARCHAR (50) NULL,
Activo BIT CONSTRAINT DF_Cliente DEFAULT 1 NOT NULL
);

CREATE TABLE Presupuesto (
ID_Presupuesto BIGINT IDENTITY (1,1) PRIMARY KEY NOT NULL,
NroPresupuesto VARCHAR (20) NOT NULL UNIQUE,
ID_Cliente BIGINT NOT NULL,
Fecha DATE NOT NULL,
Estado VARCHAR (20) NOT NULL
	CONSTRAINT CK_Presupuesto_Estado
	CHECK (Estado IN ('poraprobar', 'enproceso', 'cancelado', 'terminado')),
Envio BIT CONSTRAINT DF_Presupuesto_Envio DEFAULT 0 NOT NULL,
CostoEnvio DECIMAL (10,2) CONSTRAINT DF_Presupuesto_CostoEnvio DEFAULT 0.00 NOT NULL,
Activo BIT CONSTRAINT DF_Presupuesto DEFAULT 1 NOT NULL,

-- Check que involucra varias columnas
CONSTRAINT CK_Presupuesto_CostoEnvio CHECK ((Envio = 0 AND CostoEnvio = 0) OR (Envio = 1 AND CostoEnvio >= 0))
);

CREATE TABLE Remito (
ID_Remito BIGINT IDENTITY (1,1) PRIMARY KEY NOT NULL,
NroRemito VARCHAR (20) NOT NULL UNIQUE,
ID_Presupuesto BIGINT NOT NULL UNIQUE,
Fecha DATE NOT NULL,
Estado VARCHAR (20) NOT NULL
	CONSTRAINT CK_Remito_Estado
	CHECK (Estado IN ('entregado', 'cancelado')),
Envio BIT CONSTRAINT DF_Remito_Envio DEFAULT 0 NOT NULL,
CostoEnvio DECIMAL (10,2) CONSTRAINT DF_Remito_CostoEnvio DEFAULT 0.00 NOT NULL,
Activo BIT CONSTRAINT DF_Remito DEFAULT 1 NOT NULL,

-- Check que involucra varias columnas
CONSTRAINT CK_Remito_CostoEnvio CHECK ((Envio = 0 AND CostoEnvio = 0) OR (Envio = 1 AND CostoEnvio >= 0))
);

CREATE TABLE DetallePresupuesto (
ID_DetallePresupuesto BIGINT IDENTITY (1,1) PRIMARY KEY NOT NULL,
ID_Presupuesto BIGINT NOT NULL,
ID_ItemFisico BIGINT NOT NULL,
PrecioFinal DECIMAL (10,2) NOT NULL
);

CREATE TABLE DetalleRemito (
ID_DetalleRemito BIGINT IDENTITY (1,1) PRIMARY KEY NOT NULL,
ID_Remito BIGINT NOT NULL,
ID_ItemFisico BIGINT NOT NULL,
PrecioFinal DECIMAL (10,2) NOT NULL
);
GO

-- DEFINO LAS FOREIGN KEY

-- Item fisico con articulo
ALTER TABLE ItemFisico
ADD CONSTRAINT FK_ItemFisico_Articulo
FOREIGN KEY (ID_Articulo)
REFERENCES Articulo(ID_Articulo);

-- Articulo con marca
ALTER TABLE Articulo
ADD CONSTRAINT FK_Articulo_Marca
FOREIGN KEY (ID_Marca)
REFERENCES Marca(ID_Marca);

-- Articulo con categoria
ALTER TABLE Articulo
ADD CONSTRAINT FK_Articulo_Categoria
FOREIGN KEY (ID_Categoria)
REFERENCES Categoria(ID_Categoria);

--Presupuesto con cliente
ALTER TABLE Presupuesto
ADD CONSTRAINT FK_Presupuesto_Cliente
FOREIGN KEY (ID_Cliente)
REFERENCES Cliente(ID_Cliente);

--Remito con presupuesto
ALTER TABLE Remito
ADD CONSTRAINT FK_Remito_Presupuesto
FOREIGN KEY (ID_Presupuesto)
REFERENCES Presupuesto(ID_Presupuesto);

--Detalle remito con remito
ALTER TABLE DetalleRemito
ADD CONSTRAINT FK_DetalleRemito_Remito
FOREIGN KEY (ID_Remito)
REFERENCES Remito(ID_Remito);

--Detalle remito con item fisico
ALTER TABLE DetalleRemito
ADD CONSTRAINT FK_DetalleRemito_ItemFisico
FOREIGN KEY (ID_ItemFisico)
REFERENCES ItemFisico(ID_ItemFisico);

--Detalle presupuesto con presupuesto
ALTER TABLE DetallePresupuesto
ADD CONSTRAINT FK_DetallePresupuesto_Presupuesto
FOREIGN KEY (ID_Presupuesto)
REFERENCES Presupuesto(ID_Presupuesto);

--Detalle presupuesto con item fisico
ALTER TABLE DetallePresupuesto
ADD CONSTRAINT FK_DetallePresupuesto_ItemFisico
FOREIGN KEY (ID_ItemFisico)
REFERENCES ItemFisico(ID_ItemFisico);
GO