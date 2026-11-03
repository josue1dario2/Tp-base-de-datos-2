USE MagnusGamers_DB;
GO

INSERT INTO Marca (Nombre) VALUES
(N'Sony'),
(N'Nintendo'),
(N'Microsoft'),
(N'Logitech'),
(N'Razer'),
(N'HyperX'),
(N'JBL'),
(N'Asus');
GO

INSERT INTO Categoria (Nombre) VALUES
(N'Consolas'),
(N'Videojuegos'),
(N'Periféricos'),
(N'Accesorios'),
(N'Audio y Micrófonos'),
(N'Monitores');
GO

INSERT INTO Articulo (Nombre, Descripcion, ID_Marca, ID_Categoria) VALUES
(N'PlayStation 5 Slim', N'Consola Sony PlayStation 5 Slim.', 1, 1),
(N'Nintendo Switch OLED', N'Consola híbrida Nintendo Switch OLED.', 2, 1),
(N'Xbox Series S', N'Consola digital Microsoft Xbox Series S.', 3, 1),
(N'Joystick DualSense', N'Control inalámbrico para PlayStation 5.', 1, 3),
(N'Teclado Logitech G Pro', N'Teclado mecánico para gaming.', 4, 3),
(N'EA Sports FC 25', N'Videojuego de fútbol para PlayStation 5.', 1, 2),
(N'The Legend of Zelda: Tears of the Kingdom', N'Videojuego para Nintendo Switch.', 2, 2),
(N'Headset HyperX Cloud Stinger 2', N'Auriculares gamer multiplataforma.', 6, 5),
(N'Mouse Razer DeathAdder V3', N'Mouse ergonómico de alta precisión.', 5, 3),
(N'God of War Ragnarök', N'Videojuego de acción y aventura para PS5.', 1, 2),
(N'Control Inalámbrico Xbox Series X/S', N'Control color Negro Carbón.', 3, 3),
(N'Parlante Bluetooth JBL Quantum Duo', N'Parlantes para gaming con iluminación RGB.', 7, 5);
GO

INSERT INTO ItemFisico (ID_Articulo, Codigo, Detalles, EtiquetaLogistica, Condicion, PrecioVenta, PrecioCompra) VALUES
(1, N'PS5-001', N'Caja original y garantía vigente.', 'reservado', 'nuevo', 760000, 600000),
(1, N'PS5-002', N'Equipo con una semana de uso.', 'disponible', 'seminuevo', 700000, 550000),
(2, N'SWITCH-001', N'Incluye dock y dos Joy-Con.', 'disponible', 'nuevo', 520000, 400000),
(2, N'SWITCH-002', N'Consola usada, incluye cargador.', 'disponible', 'usado', 430000, 300000),
(3, N'XBOX-001', N'Consola digital con joystick original.', 'reservado', 'nuevo', 580000, 460000),
(4, N'DS-001', N'Joystick blanco en perfecto estado.', 'disponible', 'nuevo', 125000, 85000),
(4, N'DS-002', N'Joystick negro vendido.', 'vendido', 'nuevo', 130000, 85000),
(5, N'LOGI-001', N'Teclado en revisión técnica.', 'service', 'usado', 90000, 40000),
(6, N'FC25-001', N'Juego físico sellado.', 'disponible', 'nuevo', 110000, 75000),
(7, N'ZELDA-001', N'Juego físico usado con caja original.', 'vendido', 'usado', 115000, 70000),
(8, N'HYPERX-001', N'Auriculares nuevos en caja cerrada.', 'disponible', 'nuevo', 65000, 42000),
(9, N'RAZER-001', N'Mouse con cable Speedflex.', 'disponible', 'nuevo', 95000, 60000),
(10, N'GOW-001', N'Disco físico impecable.', 'disponible', 'seminuevo', 55000, 35000),
(11, N'XBOX-CTRL-001', N'Joystick color negro original.', 'vendido', 'nuevo', 98000, 70000),
(12, N'JBL-001', N'Parlantes con sonido envolvente.', 'disponible', 'nuevo', 180000, 120000),
(3, N'XBOX-002', N'Consola abierta para exposición.', 'disponible', 'seminuevo', 540000, 430000);
GO

INSERT INTO Cliente (Nombre, Apellido, DNI, Telefono, Direccion) VALUES
(N'Juan', N'Pérez', '40111222', '1122334455', N'General Pacheco'),
(N'María', N'Gómez', '38999888', '1144556677', N'Tigre'),
(N'Lucas', N'Rodríguez', '42555666', '1166778899', N'San Fernando'),
(N'Sofía', N'Martínez', '41222333', '1199001122', N'Benavídez'),
(N'Martina', N'López', '43111222', '1188990011', N'San Isidro'),
(N'Federico', N'Benítez', '37444555', '1133221100', N'Vicente López'),
(N'Camila', N'Fernández', '39888777', '1155443322', N'Capital Federal'),
(N'Joaquín', N'Álvarez', '35222333', '1177889900', N'Maipú'),
(N'Valentina', N'Ríos', '44333222', '1111223344', N'Godoy Cruz'),
(N'Mateo', N'Silva', '36777888', '1199887766', N'Mendoza');
GO

INSERT INTO Presupuesto (NroPresupuesto, ID_Cliente, Fecha, Estado, Envio, CostoEnvio) VALUES
('PRES-0001', 1, '2026-03-10', 'enproceso', 1, 15000),
('PRES-0002', 2, '2026-03-05', 'terminado', 0, 0),
('PRES-0003', 3, '2026-03-12', 'poraprobar', 0, 0),
('PRES-0004', 5, '2026-03-15', 'terminado', 1, 12000),
('PRES-0005', 6, '2026-03-16', 'enproceso', 0, 0),
('PRES-0006', 8, '2026-03-18', 'poraprobar', 1, 18000);
GO

INSERT INTO DetallePresupuesto (ID_Presupuesto, ID_ItemFisico, PrecioFinal) VALUES
(1, 1, 760000),
(1, 6, 125000),
(2, 10, 115000),
(2, 7, 130000),
(4, 11, 65000),
(4, 12, 95000),
(5, 14, 98000),
(5, 15, 180000),
(3, 3, 520000),
(6, 5, 580000);
GO

INSERT INTO Remito (NroRemito, ID_Presupuesto, Fecha, Estado, Envio, CostoEnvio) VALUES
('REM-0001', 2, '2026-03-05', 'Entregado', 0, 0),
('REM-0002', 4, '2026-03-15', 'Entregado', 1, 12000),
('REM-0003', 1, '2026-03-11', 'Pendiente', 1, 15000);
GO

INSERT INTO DetalleRemito (ID_Remito, ID_ItemFisico, PrecioFinal) VALUES
(1, 10, 115000),
(1, 7, 130000),
(2, 11, 65000),
(2, 12, 95000),
(3, 1, 760000);
GO

INSERT INTO AuditoriaItemFisico (ID_ItemFisico, Operacion, EstadoAnterior, EstadoNuevo, Observacion) VALUES
(7, 'Venta', 'reservado', 'vendido', N'Venta cargada como dato inicial.'),
(10, 'Venta', 'reservado', 'vendido', N'Venta cargada como dato inicial.'),
(11, 'Venta', 'disponible', 'vendido', N'Venta mediante presupuesto PRES-0004.'),
(12, 'Venta', 'disponible', 'vendido', N'Venta mediante presupuesto PRES-0004.'),
(14, 'Venta', 'disponible', 'vendido', N'Venta por mostrador.'),
(8, 'Modificacion', 'disponible', 'service', N'Enviado a soporte técnico por fallas en teclas.');
GO