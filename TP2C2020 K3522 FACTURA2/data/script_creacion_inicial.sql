

--Borrar todo si existe, para volver a crearlo.

IF EXISTS (SELECT SCHEMA_ID FROM sys.schemas WHERE [name] = 'GDD2020')
BEGIN
	

	--Hay que eliminar CONTRAINTS y TABLAS


	IF OBJECT_ID('[GDD2020].[CLIENTE]', 'U') IS NOT NULL 
	DROP TABLE [GDD2020].[CLIENTE]

	
	IF OBJECT_ID('[GDD2020].[FABRICANTE]', 'U') IS NOT NULL 
	DROP TABLE [GDD2020].[FABRICANTE]

	
	IF OBJECT_ID('[GDD2020].[MODELO]', 'U') IS NOT NULL 
	DROP TABLE [GDD2020].[MODELO]

	
	IF OBJECT_ID('[GDD2020].[SUCURSAL]', 'U') IS NOT NULL 
	DROP TABLE [GDD2020].[SUCURSAL]

	
	IF OBJECT_ID('[GDD2020].[TIPOAUTO]', 'U') IS NOT NULL 
	DROP TABLE [GDD2020].[TIPOAUTO]

	DROP SCHEMA GDD2020

END


--Crear el esquema
EXEC('CREATE SCHEMA GDD2020 AUTHORIZATION dbo');

--Crear tablas

CREATE TABLE [GDD2020].[CLIENTE](
	[CLIENTE_CODIGO] BIGINT IDENTITY(1,1) PRIMARY KEY,
	[CLIENTE_DNI] [decimal](18, 0),
	[CLIENTE_APELLIDO] [nvarchar](255),
	[CLIENTE_NOMBRE] [nvarchar](255),
	[CLIENTE_DIRECCION] [nvarchar](255) NULL,
	[CLIENTE_FECHA_NAC] [datetime2](3) NULL,
	[CLIENTE_MAIL] [nvarchar](255) NULL
) ON [PRIMARY] -- insertado

CREATE TABLE [GDD2020].[TIPOAUTO](
	[TIPO_AUTO_CODIGO] [decimal](18, 0) PRIMARY KEY,
	[TIPO_AUTO_DESC] [nvarchar](255) NULL
) ON [PRIMARY] -- insertado

CREATE TABLE [GDD2020].[SUCURSAL](
	[SUCURSAL_CODIGO] BIGINT IDENTITY(1,1) PRIMARY KEY,
	[SUCURSAL_DIRECCION] [nvarchar](255) NULL, --TODO VER LOS NULL
	[SUCURSAL_MAIL] [nvarchar](255) NULL,
	[SUCURSAL_TELEFONO] [decimal](18, 0) NULL,
	[SUCURSAL_CIUDAD] [nvarchar](255) NULL
) ON [PRIMARY] -- insertado

CREATE TABLE [GDD2020].[COMPRA](
	[COMPRA_NRO] [decimal](18, 0) PRIMARY KEY,
	[SUCURSAL_CODIGO] BIGINT,
	[COMPRA_PRECIO] [decimal](18, 2) NULL,
	[COMPRA_CANT] [decimal](18, 0) NULL,
	[COMPRA_FECHA] [datetime2](3) NULL,
	[CLIENTE_CODIGO] BIGINT IDENTITY(1,1),
	CONSTRAINT FK_SUCURSAL_CODIGO FOREIGN KEY SUCURSAL_CODIGO REFERENCES [GDD2020].[SUCURSAL].[SUCURSAL_CODIGO],
	CONSTRAINT FK_CLIENTE_CODIGO FOREIGN KEY CLIENTE_CODIGO REFERENCES [GDD2020].[CLIENTE].[CLIENTE_CODIGO]
) ON PRIMARY --insertado

CREATE TABLE [GDD2020].[FACTURACION](
	[FACTURA_NRO] [decimal](18, 0) PRIMARY KEY,
	[SUCURSAL_CODIGO] BIGINT,
	[PRECIO_FACTURADO] [decimal](18, 2) NULL,
	[CLIENTE_CODIGO] BIGINT IDENTITY(1,1),
	CONSTRAINT FK_SUCURSAL_CODIGO FOREIGN KEY SUCURSAL_CODIGO REFERENCES [GDD2020].[SUCURSAL].[SUCURSAL_CODIGO],
	CONSTRAINT FK_CLIENTE_CODIGO FOREIGN KEY CLIENTE_CODIGO REFERENCES [GDD2020].[CLIENTE].[CLIENTE_CODIGO]
) ON PRIMARY --insertado

CREATE TABLE [GDD2020].[MODELO](
	[MODELO_CODIGO] [decimal](18, 0) PRIMARY KEY,
	[MODELO_NOMBRE] [nvarchar](255) ,
	[MODELO_POTENCIA] [decimal](18, 0)
) ON [PRIMARY] --insertado


CREATE TABLE [GDD2020].[FABRICANTE](
	[FABRICANTE_CODIGO] BIGINT IDENTITY(1,1) PRIMARY KEY,
	[FABRICANTE_NOMBRE] [nvarchar](255) 
) ON [PRIMARY] -- insertado

CREATE TABLE [GDD2020].[COMPRA_AUTOPARTE](
	[CODIGO_COMPRA_AUTOPARTE] BIGINT IDENTITY(1,1) PRIMARY KEY,
	[MODELO_CODIGO] [decimal](18, 0),
	[FABRICANTE_CODIGO] BIGINT IDENTITY(1,1),
	[SUCURSAL_CODIGO] BIGINT,
	[COMPRA_NRO] [decimal](18, 0),
	CONSTRAINT FK_MODELO_CODIGO FOREIGN KEY MODELO_CODIGO REFERENCES [GDD2020].[MODELO].[MODELO_CODIGO],
	CONSTRAINT FK_FABRICANTE_CODIGO FOREIGN KEY FABRICANTE_CODIGO REFERENCES [GDD2020].[FABRICANTE].[FABRICANTE_CODIGO],
	CONSTRAINT FK_SUCURSAL_CODIGO FOREIGN KEY SUCURSAL_CODIGO REFERENCES [GDD2020].[SUCURSAL].[SUCURSAL_CODIGO],
	CONSTRAINT FK_COMPRA_NRO FOREIGN KEY COMPRA_NRO REFERENCES [GDD2020].[COMPRA].[COMPRA_NRO]
) ON PRIMARY --insert

CREATE TABLE [GDD2020].[FACTURA_AUTOPARTE](
	[FAC_AUTOPARTE_CODIGO] BIGINT IDENTITY(1,1) PRIMARY KEY,
	[SUCURSAL_CODIGO] BIGINT IDENTITY(1,1),
	[CANT_FACTURADA] [decimal](18, 0) NULL,
	[FACTURA_NRO] [decimal](18, 0),
	CONSTRAINT FK_SUCURSAL_CODIGO FOREIGN KEY SUCURSAL_CODIGO REFERENCES [GDD2020].[SUCURSAL].[SUCURSAL_CODIGO],
	CONSTRAINT FK_FACTURA_NRO FOREIGN KEY FACTURA_NRO REFERENCES [GDD2020].[FACTURACION].[FACTURA_NRO]
) ON PRIMARY --insertado

CREATE TABLE [GDD2020].[AUTOPARTE](
	[AUTO_PARTE_CODIGO] [decimal](18, 0) PRIMARY KEY,
	[AUTO_PARTE_DESCRIPCION] [nvarchar](255) NULL
	[CODIGO_COMPRA_AUTOPARTE] BIGINT,
	[FAC_AUTOPARTE_CODIGO] BIGINT,
	[MODELO_CODIGO] [decimal](18, 0),
	[FABRICANTE_CODIGO] BIGINT,
	CONSTRAINT FK_CODIGO_COMPRA_AUTOPARTE FOREIGN KEY CODIGO_COMPRA_AUTOPARTE REFERENCES [GDD2020].[COMPRA_AUTOPARTE].[CODIGO_COMPRA_AUTOPARTE],
	CONSTRAINT FK_FAC_AUTOPARTE_CODIGO FOREIGN KEY FAC_AUTOPARTE_CODIGO REFERENCES [GDD2020].[FACTURA_AUTOPARTE].[AUTO_PARTE_CODIGO],
	CONSTRAINT FK_MODELO_CODIGO FOREIGN KEY MODELO_CODIGO REFERENCES [GDD2020].[MODELO].[MODELO_CODIGO],
	CONSTRAINT FK_FABRICANTE_CODIGO FOREIGN KEY FABRICANTE_CODIGO REFERENCES [GDD2020].[FABRICANTE].[FABRICANTE_CODIGO]
) ON [PRIMARY] --insertado

CREATE TABLE [GDD2020].[CAJA](
	[TIPO_CAJA_CODIGO] [decimal](18, 0) PRIMARY KEY,
	[TIPO_CAJA_DESC] [nvarchar](255) NULL,
	[AUTO_PARTE_CODIGO] [decimal](18, 0),
	CONSTRAINT FK_AUTO_PARTE_CODIGO FOREIGN KEY (AUTO_PARTE_CODIGO) REFERENCES [GDD2020].[AUTOPARTE][AUTO_PARTE_CODIGO]
) ON [PRIMARY] --insertado

CREATE TABLE [GDD2020].[MOTOR](
	[TIPO_MOTOR_CODIGO] [decimal](18, 0) PRIMARY KEY,
	[AUTO_PARTE_CODIGO] [decimal](18, 0),
	CONSTRAINT FK_AUTO_PARTE_CODIGO FOREIGN KEY AUTO_PARTE_CODIGO REFERENCES [GDD2020].[AUTOPARTE].[AUTO_PARTE_CODIGO]
) ON [PRIMARY] --insertado

CREATE TABLE [GDD2020].[TRANSMISION](
	[TIPO_TRANSMISION_CODIGO] [decimal](18, 0) PRIMARY KEY,
	[TIPO_TRANSMISION_DESC] [nvarchar](255) NULL,
	[AUTO_PARTE_CODIGO] [decimal](18, 0),
	CONSTRAINT FK_AUTO_PARTE_CODIGO FOREIGN KEY AUTO_PARTE_CODIGO REFERENCES [GDD2020].[AUTOPARTE].[AUTO_PARTE_CODIGO]
) ON [PRIMARY] --insertado

CREATE TABLE [GDD2020].[AUTOMOVIL](
	[AUTO_PATENTE] [nvarchar](50) PRIMARY KEY,
	[AUTO_NRO_CHASIS] [nvarchar](50),
	[AUTO_NRO_MOTOR] [nvarchar](50),
	[AUTO_CANT_KMS] [decimal](18, 0),
	[AUTO_FECHA_ALTA] [datetime2](3),
	[MODELO_CODIGO] [decimal](18, 0),
	[FABRICANTE_CODIGO] [SUCURSAL_CODIGO] BIGINT,
	[TIPO_AUTO_CODIGO] [decimal](18, 0),
	CONSTRAINT FK_MODELO_CODIGO FOREIGN KEY (MODELO_CODIGO) REFERENCES [GDD2020].[MODELO].[MODELO_CODIGO],
	CONSTRAINT FK_FABRICANTE_CODIGO FOREIGN KEY FABRICANTE_CODIGO REFERENCES [GDD2020].[FABRICANTE].[FABRICANTE_CODIGO],
	CONSTRAINT FK_TIPO_AUTO_CODIGO FOREIGN KEY TIPO_AUTO_CODIGO REFERENCES [GDD2020].[TIPOAUTO].[TIPO_AUTO_CODIGO]
) ON [PRIMARY] --insertado

CREATE TABLE [GDD2020].[USUARIO](
	[USUARIO_NOMBRE] [nvarchar](20) NOT NULL PRIMARY KEY,
	[USUARIO_PASSWORD] BINARY(256) NOT NULL
) ON PRIMARY --Este seguro no se use

CREATE TABLE [GDD2020].[COMPRA_AUTOMOVIL](
	[COMPRA_AUTOMOVIL_CODIGO] BIGINT IDENTITY(1,1) PRIMARY KEY,
	[AUTO_PATENTE] [nvarchar](50),
	[SUCURSAL_CODIGO] BIGINT,
	[COMPRA_NRO] [decimal](18, 0),
	CONSTRAINT FK_AUTO_PATENTE FOREIGN KEY AUTO_PATENTE REFERENCES [GDD2020].[AUTOMOVIL].[AUTO_PATENTE],
	CONSTRAINT FK_SUCURSAL_CODIGO FOREIGN KEY SUCURSAL_CODIGO REFERENCES [GDD2020].[SUCURSAL].[SUCURSAL_CODIGO],
	CONSTRAINT FK_COMPRA_NRO FOREIGN KEY COMPRA_NRO REFERENCES [GDD2020].[COMPRA].[COMPRA_NRO]
) ON PRIMARY --insertado

CREATE TABLE [GDD2020].[FACTURA_AUTO](
	[FAC_AUTO_CODIGO] BIGINT IDENTITY(1,1) PRIMARY KEY,
	[AUTO_PATENTE] [nvarchar](50),
	[FACTURA_NRO] [decimal](18, 0),
	CONSTRAINT FK_AUTO_PATENTE FOREIGN KEY AUTO_PATENTE REFERENCES [GDD2020].[AUTOMOVIL].[AUTO_PATENTE],
	CONSTRAINT FK_FACTURA_NRO FOREIGN KEY FACTURA_NRO REFERENCES [GDD2020].[FACTURACION].[FACTURA_NRO]
) ON PRIMARY --insertado

--Migrar datos

--Crear un usuario para la migración, no se si lo necesito

INSERT INTO GDD2020.USUARIO (USUARIO_NOMBRE,USUARIO_PASSWORD) VALUES ('administrador','1234')

--Crear rol

--Asigno rol al usuario

--INSERTAR en las tablas ( INSERT SELECT)

--CLIENTE
INSERT INTO GDD2020.CLIENTE(CLIENTE_DNI,CLIENTE_APELLIDO,CLIENTE_NOMBRE,CLIENTE_DIRECCION,CLIENTE_FECHA_NAC,CLIENTE_MAIL)
SELECT DISTINCT m.CLIENTE_DNI,m.CLIENTE_APELLIDO,m.CLIENTE_NOMBRE,m.CLIENTE_DIRECCION,m.CLIENTE_FECHA_NAC,m.CLIENTE_MAIL
FROM gd_esquema.Maestra m
WHERE CLIENTE_DNI IS NOT NULL

--TIPOAUTO
INSERT INTO GDD2020.TIPOAUTO (TIPO_AUTO_CODIGO,TIPO_AUTO_DESC)
SELECT DISTINCT m.TIPO_AUTO_CODIGO,m.TIPO_AUTO_DESC 
FROM gd_esquema.Maestra m
WHERE TIPO_AUTO_CODIGO IS NOT NULL

--SUCURSAL
INSERT INTO GDD2020.SUCURSAL (SUCURSAL_DIRECCION,SUCURSAL_MAIL,SUCURSAL_TELEFONO,SUCURSAL_CIUDAD)
SELECT DISTINCT m.SUCURSAL_DIRECCION,m.SUCURSAL_MAIL,m.SUCURSAL_TELEFONO,m.SUCURSAL_CIUDAD
FROM gd_esquema.Maestra m
WHERE SUCURSAL_DIRECCION IS NOT NULL

--COMPRA
INSERT INTO GDD2020.COMPRA(COMPRA_NRO,SUCURSAL_CODIGO,COMPRA_PRECIO,COMPRA_CANT,COMPRA_FECHA,CLIENTE_CODIGO)
SELECT DISTINCT m.COMPRA_NRO,su.SUCURSAL_CODIGO,m.COMPRA_PRECIO,m.COMPRA_CANT,m.COMPRA_FECHA,cli.CLIENTE_CODIGO
FROM gd_esquema.Maestra m
JOIN GDD2020.SUCURSAL
ON m.SUCURSAL_CODIGO = su.SUCURSAL_CODIGO
WHERE COMPRA_NRO IS NOT NULL
JOIN GDD2020.CLIENTE cli
ON m.CLIENTE_CODIGO = cli.CLIENTE_CODIGO
WHERE COMPRA_NRO IS NOT NULL

--FACTURACION
INSERT INTO GDD2020.FACTURACION(FACTURA_NRO,SUCURSAL_CODIGO,PRECIO_FACTURADO,CLIENTE_CODIGO)
SELECT DISTINCT m.FACTURA_NRO,su.SUCURSAL_CODIGO,m.PRECIO_FACTURADO,cli.CLIENTE_CODIGO
FROM gd_esquema.Maestra m
JOIN GDD2020.SUCURSAL su
ON m.SUCURSAL_CODIGO = su.SUCURSAL_CODIGO
WHERE FACTURA_NRO IS NOT NULL

--MODELO
INSERT INTO GDD2020.MODELO (MODELO_CODIGO,MODELO_NOMBRE,MODELO_POTENCIA)
SELECT DISTINCT m.MODELO_CODIGO,m.MODELO_NOMBRE,m.MODELO_POTENCIA
FROM gd_esquema.Maestra m
WHERE MODELO_CODIGO IS NOT NULL

--FABRICANTE
INSERT INTO GDD2020.FABRICANTE (FABRICANTE_NOMBRE)
SELECT DISTINCT m.FABRICANTE_NOMBRE
FROM gd_esquema.Maestra m

--COMPRA_AUTOPARTE
INSERT INTO GDD2020.COMPRA_AUTOPARTE(MODELO_CODIGO,FABRICANTE_CODIGO,SUCURSAL_CODIGO,COMPRA_NRO)
SELECT DISTINCT mod.MODELO_CODIGO,fab.FABRICANTE_CODIGO,su.SUCURSAL_CODIGO,com.COMPRA_NRO
FROM gd_esquema.Maestra m
JOIN GDD2020.MODELO mod
ON m.MODELO_CODIGO = mod.MODELO_CODIGO
WHERE m.AUTO_PARTE_CODIGO IS NOT NULL AND m.COMPRA_NRO IS NOT NULL
JOIN GDD2020.FABRICANTE fab
ON m.FABRICANTE_CODIGO = fab.FABRICANTE_CODIGO
WHERE m.AUTO_PARTE_CODIGO IS NOT NULL AND m.COMPRA_NRO IS NOT NULL
JOIN GDD2020.SUCURSAL su
ON m.SUCURSAL_CODIGO = su.SUCURSAL_CODIGO
JOIN GDD2020.COMPRA com
ON m.COMPRA_NRO = com.COMPRA_NRO
WHERE m.AUTO_PARTE_CODIGO IS NOT NULL AND m.COMPRA_NRO IS NOT NULL

--FACTURA_AUTOPARTE
INSERT INTO GDD2020.FACTURA_AUTOPARTE(SUCURSAL_CODIGO,CANT_FACTURADA,FACTURA_NRO)
SELECT DISTINCT su.SUCURSAL_CODIGO,m.CANT_FACTURADA,fac.FACTURA_NRO
FROM gd_esquema.Maestra m
JOIN GDD2020.SUCURSAL su
ON m.SUCURSAL_CODIGO = su.SUCURSAL_CODIGO
WHERE m.AUTO_PARTE_CODIGO IS NOT NULL AND m.FACTURA_NRO IS NOT NULL
JOIN GDD2020.FACTURACION fac
ON m.FACTURA_NRO = fac.FACTURA_NRO
WHERE m.AUTO_PARTE_CODIGO IS NOT NULL AND m.FACTURA_NRO IS NOT NULL

--AUTOPARTE
INSERT INTO GDD2020.AUTOPARTE (AUTO_PARTE_CODIGO,AUTO_PARTE_DESCRIPCION,CODIGO_COMPRA_AUTOPARTE,FAC_AUTOPARTE_CODIGO,MODELO_CODIGO,FABRICANTE_CODIGO)
SELECT DISTINCT m.AUTO_PARTE_CODIGO,m.AUTO_PARTE_DESCRIPCION,ca.CODIGO_COMPRA_AUTOPARTE,fap.FAC_AUTOPARTE_CODIGO,mod.MODELO_CODIGO,fab.FABRICANTE_CODIGO
FROM gd_esquema.Maestra m
JOIN GDD2020.COMPRA_AUTOPARTE ca
ON m.COMPRA_NRO = ca.COMPRA_NRO
WHERE AUTO_PARTE_CODIGO IS NOT NULL
JOIN GDD2020.FACTURA_AUTOPARTE fap
ON m.FACTURA_NRO = fa.FACTURA_NRO
WHERE AUTO_PARTE_CODIGO IS NOT NULL
JOIN GDD2020.MODELO mod
ON m.MODELO_CODIGO = mod.MODELO_CODIGO
WHERE AUTO_PARTE_CODIGO IS NOT NULL
JOIN GDD2020.FABRICANTE fab
ON m.FABRICANTE_CODIGO = fab.FABRICANTE_CODIGO
WHERE AUTO_PARTE_CODIGO IS NOT NULL

--CAJA
INSERT INTO GDD2020.CAJA (TIPO_CAJA_CODIGO,TIPO_CAJA_DESC,AUTO_PARTE_CODIGO) 
SELECT DISTINCT m.TIPO_CAJA_CODIGO,m.TIPO_CAJA_DESC,ap.AUTO_PARTE_CODIGO
FROM gd_esquema.Maestra m
JOIN GDD2020.AUTOPARTE ap
ON m.AUTO_PARTE_CODIGO = ap.AUTO_PARTE_CODIGO
WHERE TIPO_CAJA_CODIGO IS NOT NULL

--MOTOR
INSERT INTO GDD2020.MOTOR (TIPO_MOTOR_CODIGO,AUTO_PARTE_CODIGO)
SELECT DISTINCT m.TIPO_MOTOR_CODIGO,ap.AUTO_PARTE_CODIGO
FROM gd_esquema.Maestra m
JOIN GDD2020.AUTOPARTE ap
ON m.AUTO_PARTE_CODIGO = ap.AUTO_PARTE_CODIGO
WHERE TIPO_MOTOR_CODIGO IS NOT NULL

--TIPO_TRANSMISION
INSERT INTO GDD2020.TRANSMISION(TIPO_TRANSMISION_CODIGO,TIPO_TRANSMISION_DESC,AUTO_PARTE_CODIGO)
SELECT DISTINCT m.TIPO_TRANSMISION_CODIGO,m.TIPO_TRANSMISION_DESC,ap.AUTO_PARTE_CODIGO
FROM gd_esquema.Maestra m
JOIN GDD2020.AUTOPARTE ap
ON m.AUTO_PARTE_CODIGO = ap.AUTO_PARTE_CODIGO
WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL

--AUTOMOVIL
INSERT INTO GDD2020.AUTOMOVIL(AUTO_PATENTE,AUTO_NRO_CHASIS,AUTO_NRO_MOTOR,AUTO_FECHA_ALTA,AUTO_CANT_KMS,MODELO_CODIGO,FABRICANTE_CODIGO,TIPO_AUTO_CODIGO)
SELECT DISTINCT m.AUTO_PATENTE,m.AUTO_NRO_CHASIS,m.AUTO_NRO_MOTOR,m.AUTO_CANT_KMS,m.AUTO_FECHA_ALTA,mod.MODELO_CODIGO,fab.FABRICANTE_CODIGO,ta.TIPO_AUTO_CODIGO
FROM gd_esquema.Maestra m
JOIN GDD2020.MODELO mod
ON m.MODELO_CODIGO = mod.MODELO_CODIGO
WHERE AUTO_PATENTE IS NOT NULL
JOIN GDD2020.FABRICANTE fab
ON m.FABRICANTE_CODIGO = fab.FABRICANTE_CODIGO
WHERE AUTO_PATENTE IS NOT NULL
JOIN GDD2020.TIPOAUTO ta
ON m.TIPO_AUTO_CODIGO = ta.TIPO_AUTO_CODIGO
WHERE AUTO_PATENTE IS NOT NULL

--COMPRA_AUTOMOVIL
INSERT INTO GDD2020.COMPRA_AUTOMOVIL(AUTO_PATENTE,SUCURSAL_CODIGO,COMPRA_NRO)
SELECT DISTINCT au.AUTO_PATENTE,su.SUCURSAL_CODIGO,com.COMPRA_NRO
FROM gd_esquema.Maestra m
JOIN GDD2020.AUTOMOVIL au
ON m.AUTO_PATENTE = au.AUTO_PATENTE
WHERE AUTO_PATENTE IS NOT NULL AND COMPRA_NRO IS NOT NULL
JOIN GDD2020.SUCURSAL su
ON m.SUCURSAL_CODIGO = su.SUCURSAL_CODIGO
WHERE m.AUTO_PATENTE IS NOT NULL AND m.COMPRA_NRO IS NOT NULL
JOIN GDD2020.COMPRA com
ON m.COMPRA_NRO = com.COMPRA_NRO
WHERE m.AUTO_PATENTE IS NOT NULL AND m.COMPRA_NRO IS NOT NULL


--FACTURA_AUTO
INSERT INTO GDD2020.FACTURA_AUTO(AUTO_PATENTE,FACTURA_NRO)
SELECT DISTINCT au.AUTO_PATENTE,fac.FACTURA_NRO
FROM gd_esquema.Maestra m
JOIN GDD2020.AUTOMOVIL au
ON m.AUTO_PATENTE = au.AUTO_PATENTE
WHERE m.AUTO_PATENTE IS NOT NULL AND m.FACTURA_NRO IS NOT NULL
JOIN GDD2020.FACTURACION fac
ON m.FACTURA_NRO = fac.FACTURA_NRO
WHERE m.AUTO_PATENTE IS NOT NULL AND m.FACTURA_NRO IS NOT NULL