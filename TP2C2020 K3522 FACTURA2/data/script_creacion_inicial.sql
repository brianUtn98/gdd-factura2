--Crear el esquema
IF EXISTS (SELECT SCHEMA_ID FROM sys.schemas WHERE [name] = 'GDD2020')
BEGIN
	


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

--Borrar todo si existe, para volver a crearlo.

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



CREATE TABLE [GDD2020].[MODELO](
	[MODELO_CODIGO] [decimal](18, 0) PRIMARY KEY,
	[MODELO_NOMBRE] [nvarchar](255) ,
	[MODELO_POTENCIA] [decimal](18, 0)
) ON [PRIMARY] --insertado


CREATE TABLE [GDD2020].[FABRICANTE](
	[FABRICANTE_CODIGO] BIGINT IDENTITY(1,1) PRIMARY KEY,
	[FABRICANTE_NOMBRE] [nvarchar](255) 
) ON [PRIMARY] -- insertado



-- EJEMPLO para FOREIGN KEYS 	
--CONSTRAINT FK_TIPO_BUTACA FOREIGN KEY (TIPO_BUTACA_CODIGO) REFERENCES [GDD2020].[TIPO_BUTACA](TIPO_BUTACA_CODIGO)


CREATE TABLE [GDD2020].[CAJA](
	[TIPO_CAJA_CODIGO] [decimal](18, 0) PRIMARY KEY,
	[TIPO_CAJA_DESC] [nvarchar](255) NULL,
	[AUTO_PARTE_CODIGO] [decimal](18, 0)
	CONSTRAINT FK_AUTO_PARTE_CODIGO FOREIGN KEY (AUTO_PARTE_CODIGO) REFERENCES [GDD2020].[AUTOPARTE][AUTO_PARTE_CODIGO]
) ON [PRIMARY]

CREATE TABLE [GDD2020].[AUTOMOVIL](
	[AUTO_PATENTE] [nvarchar](50) PRIMARY KEY,
	[AUTO_NRO_CHASIS] [nvarchar](50),
	[AUTO_NRO_MOTOR] [nvarchar](50),
	[AUTO_CANT_KMS] [decimal](18, 0),
	[AUTO_FECHA_ALTA] [datetime2](3),
	[TIPO_TRANSMISION_CODIGO] [decimal](18, 0),
	[MODELO_CODIGO] [decimal](18, 0),
	[FABRICANTE_CODIGO] [SUCURSAL_CODIGO] BIGINT,
	[TIPO_AUTO_CODIGO] [decimal](18, 0)
	CONSTRAINT FK_TIPO_TRANSMISION_CODIGO FOREIGN KEY (TIPO_TRANSMISION_CODIGO) REFERENCES [GDD2020].[TRANSMISION].[TIPO_TRANSMISION_CODIGO]
	CONSTRAINT FK_MODELO_CODIGO FOREIGN KEY (MODELO_CODIGO) REFERENCES [GDD2020].[MODELO].[MODELO_CODIGO]
	CONSTRAINT FK_FABRICANTE_CODIGO FOREIGN KEY FABRICANTE_CODIGO REFERENCES [GDD2020].[FABRICANTE].[FABRICANTE_CODIGO]
	CONSTRAINT FK_TIPO_AUTO_CODIGO FOREIGN KEY TIPO_AUTO_CODIGO REFERENCES [GDD2020].[TIPOAUTO].[TIPO_AUTO_CODIGO]
) ON [PRIMARY]


CREATE TABLE [GDD2020].[MOTOR](
	[TIPO_MOTOR_CODIGO] [decimal](18, 0) PRIMARY KEY,
	[AUTO_PARTE_CODIGO]
	CONSTRAINT FK_AUTO_PARTE_CODIGO FOREIGN KEY AUTO_PARTE_CODIGO REFERENCES [GDD2020].[AUTOPARTE].[AUTO_PARTE_CODIGO]
) ON [PRIMARY]

CREATE TABLE [GDD2020].[TRANSMISION](
	[TIPO_TRANSMISION_CODIGO] [decimal](18, 0) PRIMARY KEY,
	[TIPO_TRANSMISION_DESC] [nvarchar](255) NULL,
	[AUTO_PARTE_CODIGO]
	CONSTRAINT FK_AUTO_PARTE_CODIGO FOREIGN KEY AUTO_PARTE_CODIGO REFERENCES [GDD2020].[AUTOPARTE].[AUTO_PARTE_CODIGO]
) ON [PRIMARY]

CREATE TABLE [GDD2020].[AUTOPARTE](
	[AUTO_PARTE_CODIGO] [decimal](18, 0) PRIMARY KEY,
	[AUTO_PARTE_DESCRIPCION] [nvarchar](255) NULL
	--TODO TERMINAR ESTA ENTIDAD (FALTA INFO DE FACTURACION)
) ON [PRIMARY] --insertado

CREATE TABLE [GDD2020].[USUARIO](
	[USUARIO_NOMBRE] [nvarchar](20) NOT NULL PRIMARY KEY,
	[USUARIO_PASSWORD] BINARY(256) NOT NULL
) ON PRIMARY





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

--MODELO
INSERT INTO GDD2020.MODELO (MODELO_CODIGO,MODELO_NOMBRE,MODELO_POTENCIA)
SELECT DISTINCT m.MODELO_CODIGO,m.MODELO_NOMBRE,m.MODELO_POTENCIA
FROM gd_esquema.Maestra m
WHERE MODELO_CODIGO IS NOT NULL

--FABRICANTE
INSERT INTO GDD2020.FABRICANTE (FABRICANTE_NOMBRE)
SELECT DISTINCT m.FABRICANTE_NOMBRE
FROM gd_esquema.Maestra m

--AUTOPARTE
INSERT INTO GDD2020.AUTOPARTE (AUTO_PARTE_CODIGO,AUTO_PARTE_DESCRIPCION)
SELECT DISTINCT m.AUTO_PARTE_CODIGO,m.AUTO_PARTE_DESCRIPCION
FROM gd_esquema.Maestra m
WHERE AUTO_PARTE_CODIGO IS NOT NULL --todo incompleto