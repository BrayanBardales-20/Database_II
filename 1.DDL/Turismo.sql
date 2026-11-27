/*
Base Datos Turismo
------------------------------
Incluye Reservas, Clientes, Empleados, Transporte, Hospedaje
Lugares Turisticos, Proveedores ect.
*/

--USA MODELO BASE
use master;
go

--Validar existencia base de datos
IF DB_ID ('Turismo_BJBC') is not null
begin
	DROP DATABASE Turismo_BJBC;
	print 'Base de datos Turismo_BJBC Eliminada';
end
go

--Crear la base de datos
CREATE DATABASE Turismo_BJBC;
print 'Se ha creado la base de datos Turismo_BJBC';
go

--usar la base de datos creada
use Turismo_BJBC;
print 'Usando Turismo_BJBC';
go

--Crear esquema
if SCHEMA_ID(N'RRHH') is null
begin
	EXEC (N'Create Schema RRHH Authorization dbo;');
	print 'Esquema RRHH Creado';
end 
else
begin
	print 'Esquema RRHH existe';
end;
go

if SCHEMA_ID(N'Compras') is null
begin
	EXEC (N'Create Schema Compras Authorization dbo;');
	print 'Esquema Compras Creado';
end 
else
begin
	print 'Esquema Compras existe';
end;
go

if SCHEMA_ID(N'Ventas') is null
begin
	EXEC (N'Create Schema Ventas Authorization dbo;');
	print 'Esquema Ventas Creado';
end 
else
begin
	print 'Esquema Ventas existe';
end;
go

if SCHEMA_ID(N'UNC') is null
begin
	EXEC (N'Create Schema UNC Authorization dbo;');
	print 'Esquema UNC Creado';
end 
else
begin
	print 'Esquema UNC existe';
end;
go

if SCHEMA_ID(N'BJBC') is null
begin
	EXEC (N'Create Schema BJBC Authorization dbo;');
	print 'Esquema BJBC Creado';
end 
else
begin
	print 'Esquema BJBC existe';
end;
go

if SCHEMA_ID(N'Hospedaje') is null
begin
	EXEC (N'Create Schema Hospedaje Authorization dbo;');
	print 'Esquema Hospedaje Creado';
end 
else
begin
	print 'Esquema Hospedaje existe';
end;
go
/*
Creacion de Tablas
-- Validar Existencia
-- Crear la Tabla
*/

-- Crear Tabla Pais
if OBJECT_ID('BJBC.Pais', 'U') is not null
begin
	Drop Table BJBC.pais;
	print 'La tabla BJBC.Pais Eliminada'; 
end
go

CREATE TABLE BJBC.Pais (
	--primera forma poner PK
	idpais int primary key identity(1,1),
	nombrepais varchar(40) not null,
	codigoiso varchar(3) not null, --PER, ARG, CHL, COL
	fecha_registro datetime default getdate(),
	constraint UQ_nombrepais
	UNIQUE (nombrepais),
	constraint UQ_codigoiso
	UNIQUE (codigoiso)
);
print 'La tabla BJBC.Pais creada';
go

--crear tabla nacionalidad
if OBJECT_ID('BJBC.Nacionalidad', 'U') is not null
begin
	Drop Table BJBC.Nacionalidad;
	print 'La tabla BJBC.Nacionalidad Eliminada'; 
end
go

CREATE TABLE BJBC.Nacionalidad (
	idnacionalidad int identity(1,1),
	nomnacionalidad varchar(80) not null,
	idpais int not null,
	fecha_registro datetime default getdate(),
	constraint PK_nacionalidad
	primary key (idnacionalidad),
	constraint UQ_nacionalidad
	UNIQUE (nomnacionalidad),
	constraint FK_pais_nacionalidad
	foreign key (idpais) References BJBC.Pais (idpais)
);
print 'La tabla BJBC.Nacionalidad Creada';
go

--Crear tabla region (Departamento)
if OBJECT_ID('BJBC.Region', 'U') is not null
begin
	Drop Table BJBC.Region;
	print 'La tabla BJBC.Region Eliminada'; 
end
go

CREATE TABLE BJBC.Region (
	idregion int identity (1,1),
	nomregion varchar (80) not null,
	codigoubigeo varchar(3) not null,--CAJ, LIM, CUS
	idpais int not null,
	fecha_registro datetime default getdate(),
	constraint PK_region primary key (idregion),
	constraint UQ_nomregion UNIQUE (nomregion),
	constraint FK_region_pais
	foreign key (idpais) References BJBC.Pais (idpais)
);
print 'La tabla BJBC.Region Creada';
go

--Crear tabla subregion (Provincia)
if OBJECT_ID('BJBC.SubRegion', 'U') is not null
begin
	Drop Table BJBC.SubRegion;
	print 'La tabla BJBC.SubRegion Eliminada'; 
end
go

CREATE TABLE BJBC.Subregion (
	idsubregion int identity(1,1),
	nomsubregion nvarchar(100) not null,
	codigo_ubigeo varchar(4) not null,
	idregion int not null,
	fecha_registro datetime default getdate(),
	constraint PK_subregion primary key (idsubregion),
	constraint FK_subregion_region
	foreign key (idregion)
	references BJBC.Region (idregion)
);
print 'La tabla BJBC.Subregion creada';
go

--Crear tabla ciudad o distrito
if OBJECT_ID('BJBC.ciudad', 'U') is not null
begin
	Drop Table BJBC.Ciudad;
	print 'La tabla BJBC.Ciudad Eliminada'; 
end
go

CREATE TABLE BJBC.Ciudad (
	idciudad int identity(1,1),
	nomciudad varchar(80) not null,
	codigo_ubigeo varchar(6),
	idsubregion int not null,
	fecha_registro datetime default getdate(),
	constraint PK_ciudad primary key (idciudad),
	constraint FK_ciudad_subregion
	foreign key (idsubregion)
	References BJBC.Subregion (idsubregion)
);
print 'La tabla BJBC.Ciudad creada';
go

--Crear tabla Tipo_documento
if OBJECT_ID('RRHH.TipoDocumento', 'U') is not null
begin
	Drop Table RRHH.TipoDocumento;
	print 'La tabla RRHH.TipoDocumento Eliminada'; 
end
go

CREATE TABLE RRHH.TipoDocumento(
	idtipodocumento int identity(1,1),
	nombredoc varchar(50) not null,
	abreviatura char(10) not null,
	fecha_registro datetime default getdate(),
	constraint PK_tipodocumento
	primary key (idtipodocumento),
	constraint UQ_nombredoc UNIQUE (nombredoc),
	constraint UQ_abreviatura UNIQUE (abreviatura)
);
print 'Tabla TipoDocumento Creado';
go

--Crear tabla Persona 
if OBJECT_ID('RRHH.Persona', 'U') is not null
begin
	Drop Table RRHH.Persona;
	print 'La tabla RRHH.Persona Eliminada'; 
end
go

CREATE TABLE RRHH.Persona (
	idpersona int identity(1,1),
	tipo_persona char(1) not null --N: Natural,J:Juridica
	constraint CHK_tipo_persona
	CHECK (tipo_persona in ('N', 'J')),
	
	nombres varchar(100),
	apaterno varchar(100),
	amaterno varchar(100),

	razon_social varchar (200) not null,
	nombre_comercial varchar(200),

	idtipodocumento int not null,
	numero_documento varchar(20) not null,
	telefono varchar(20)
	constraint CHK_numero_telefono
	CHECK (Len(Ltrim(Rtrim(telefono))) between 12 and 20
	and telefono not like '%[^0-9+()]%'),
	email varchar(150),
	idnacionalidad int not null,
	estado varchar(20) default 'Activo',
	fecha_registro datetime default getdate(),

	constraint CHK_estado
	CHECK (estado in ('Activo', 'Inactivo')),

	constraint PK_persona primary key (idpersona),
	constraint UQ_persona_documento
	UNIQUE (idtipodocumento, numero_documento),

	constraint FK_Persona_tipodocumento
	foreign key (idtipodocumento)
	References RRHH.TipoDocumento (idtipodocumento),
	constraint FK_persona_nacionalidad
	foreign key (idnacionalidad)
	References BJBC.Nacionalidad (idnacionalidad)
);
print 'Tabla Persona Creada';
go

--Crear tabla Cargo 
if OBJECT_ID('RRHH.Cargo', 'U') is not null
begin
	Drop Table RRHH.Cargo;
	print 'La tabla RRHH.Cargo Eliminada'; 
end
go

CREATE TABLE RRHH.Cargo (
	idcargo int identity(1,1),
	nomcargo varchar(50) not null,
	descripcion varchar(max),
	salario_base decimal(10,2) not null,
	fecha_registro datetime default getdate(),
	constraint PK_cargo Primary key (idcargo)
);
print 'Tabla Cargo Creada';
go

--Crear tabla Direccion 
if OBJECT_ID('BJBC.Direccion', 'U') is not null
begin
	Drop Table BJBC.Direccion;
	print 'La tabla BJBC.Direccion Eliminada'; 
end
go

CREATE TABLE BJBC.Direccion(
	iddireccion int identity(1,1),
	idciudad int not null,
	tipo_calle nvarchar(50) not null, --Av. Jr.
	calle nvarchar(200) not null, --Atahualpa
	numero nvarchar(10) default 'S/N',
	referencia nvarchar(max),
	codigo_postal nvarchar(10) not null,
	fecha_registro datetime default getdate(),
	constraint CHK_zip
	CHECK (len(codigo_postal) between 5 and 10), --06001
	latitud decimal(10,8) null,
	longitud decimal(10,8) null,
	altitud decimal(10,8) null,
	constraint PK_direccion primary key(iddireccion),
	constraint FK_direccion_ciudad 
	foreign key(idciudad) references BJBC.Ciudad(idciudad)
);
print 'La tabla Direccion creada';
go

--Crear tabla Ventas.Cliente
if OBJECT_ID('Ventas.Cliente', 'U') is not null
begin
	Drop Table Ventas.Cliente;
	print 'La tabla Ventas.Cliente Eliminada'; 
end
go

CREATE TABLE Ventas.Cliente(
	idpersona int not null
	constraint PK_Cliente primary key (idpersona),
	fecha_nacimineto date not null,
	genero varchar(20), --Maculino, Femenino, Empresa, No Especifica, Prefiero no decirlo
	preferencia_viaje varchar(150) null,
	contacto_emergencia varchar(150) null,
	telefono_emergencia varchar(20) null,
	observaciones varchar(max) null, --Informacion adicional
	puntos_fidelidad int default 0,
	fecha_registro datetime default getdate(),
	nivel_cliente varchar(20) not null default 'Basico' --Basico, Bronze, Plata
	constraint FK_cliente_persona
	foreign key (idpersona) references RRHH.Persona(idpersona)
);
print 'Tabla Cliente creada';
go

--Crear tabla Empleado
if OBJECT_ID('RRHH.Empleado', 'U') is not null
begin
	Drop Table RRHH.Empleado;
	print 'La tabla RRHH.Empleado Eliminada'; 
end
go

CREATE TABLE RRHH.Empleado(
	idpersona int not null,
	constraint PK_empleado primary key (idpersona),
	cod_empleado varchar(15) null,
	fecha_ingreso date not null,
	fecha_cese date null,
	tipo_contrato varchar(30) null,
	estado_laboral varchar(20) not null default 'Activo',
	constraint CHK_Estado_Laboral
	CHECK (estado_laboral in ('Activo', 'Inactivo', 'Suspendido')),
	jornada_laboral varchar(30) null,
	regimen_laboral varchar(30) null,
	id_supervisor int null,
	contacto_emergencia varchar(150) null,
	telefono_emergencia varchar(20) null,
	observaciones varchar(max) null, --Informacion adicional
	fecha_registro datetime default getdate(),
	constraint FK_empleado_persona
	foreign key (idpersona) references RRHH.Persona(idpersona),
	constraint FK_empleado_supervisor
	foreign key (id_supervisor) references RRHH.Persona(idpersona)
);
print 'Tabla Empleado creada';
go

--Crear tabla Direccion_cliente
if OBJECT_ID('Ventas.Direccion_Cliente', 'U') is not null
begin
	Drop Table Ventas.Direccion_Cliente;
	print 'La tabla Ventas.Direccion_Cliente Eliminada'; 
end
go

CREATE TABLE Ventas.Direccion_Cliente(
	idpersona int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null,
	constraint CHK_tipo_direccion
	CHECK (tipo_direccion in ('Casa', 'Trabajo', 'Facturacion', 'Etrega')),
	es_principal bit not null default 0,
	estado_direccion varchar(20) not null default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_Estado_Laboral
	CHECK (estado_direccion in ('Activo', 'Inactivo', 'Suspendido')),
	constraint PK_direccion_cliente
	primary key (idpersona, iddireccion),
	constraint FK_direccion_cliente_persona
	foreign key (idpersona) references RRHH.Persona(idpersona),
	constraint FK_direccion_cliente
	foreign key (iddireccion) references BJBC.Direccion(iddireccion)
);
print 'Tabla direccion_cliente creada';
go

--Crear tabla Direccion_Empleado
if OBJECT_ID('RRHH.Direccion_Empleado', 'U') is not null
begin
	Drop Table RRHH.Direccion_Empleado;
	print 'La tabla RRHH.Direccion_Empleado Eliminada'; 
end
go

CREATE TABLE RRHH.Direccion_Empleado(
	idpersona int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null,
	constraint CHK_tipo_direccion_empleado
	CHECK (tipo_direccion in ('Casa', 'Trabajo')),
	es_principal bit not null default 0,
	estado_direccion varchar(20) not null default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_Estado_Direccion_Empleado
	CHECK (estado_direccion in ('Activo', 'Inactivo', 'Suspendido')),
	constraint PK_direccion_empleado
	primary key (idpersona, iddireccion),
	constraint FK_direccion_empleado_persona
	foreign key (idpersona) references RRHH.Persona(idpersona),
	constraint FK_direccion_empleado
	foreign key (iddireccion) references BJBC.Direccion(iddireccion)
);
print 'Tabla direccion empeado creado';
go

--Crear tabla Categoria_Proveedor
if OBJECT_ID('Compras.Categoria_Proveedor', 'U') is not null
begin
	Drop Table Compras.Categoria_Proveedor;
	print 'La tabla Compras.Categoria_Proveedor Eliminada'; 
end
go

CREATE TABLE Compras.Categoria_Proveedor(
	idcat_proveedor int identity (1,1),
	nomcat_proveedor varchar(60) not null,
	descripcion varchar(max),
	fecha_registro datetime default getdate(),
	constraint PK_cat_proveedor primary key(idcat_proveedor),
	constraint UQ_nombre_cat_proveedor unique(nomcat_proveedor)
);
print 'tabla categoria proveedor creada'
go

--Crear tabla Proveedor
if OBJECT_ID('Compras.Proveedor', 'U') is not null
begin
	Drop Table Compras.Proveedor;
	print 'La tabla Compras.Proveedor Eliminada'; 
end
go

CREATE TABLE Compras.Proveedor(
	idpersona int not null,
	cod_proveedor varchar(15) null,
	fecha_inicio_relacion date not null,
	fecha_fin_relacion date null,
	sitio_web nvarchar(250) null,
	requiere_contrato bit not null default 0,
	estado_proveedor varchar(20) not null default 'Activo',
	observaciones nvarchar(max) null,
	fecha_registro datetime default getdate(),
	constraint PK_proveedor primary key (idpersona),
	constraint CHK_Estado_Proveedor
	CHECK (estado_proveedor in ('Activo', 'Inactivo', 'Suspendido')),
	constraint FK_proveedor_persona
	foreign key(idpersona) references RRHH.Persona(idpersona)
);
print 'tabla preveedor creada';
go

--Crear tabla Direccion_Proveedor
if OBJECT_ID('Compras.Direccion_Proveedor', 'U') is not null
begin
	Drop Table Compras.Direccion_Proveedor;
	print 'La tabla Compras.Direccion_Proveedor Eliminada'; 
end
go

CREATE TABLE Compras.Direccion_Proveedor(
	idpersona int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null,
	constraint CHK_tipo_direccion_proveedor
	CHECK (tipo_direccion in ('Fiscal', 'Envio', 'Fisica', 'Atenciaon', 'Pago', 'Sucursal', 'Almacen', 'Operativa')),
	es_principal bit not null default 0,
	estado_proveedor varchar(20) not null default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_Estado_Direccion_Proveedor
	CHECK (estado_proveedor in ('Activo', 'Inactivo', 'Suspendido')),
	constraint PK_direccion_proveedor
	primary key (idpersona, iddireccion),
	constraint FK_direccion_empleado_persona
	foreign key (idpersona) references RRHH.Persona(idpersona),
	constraint FK_direccion_empleado
	foreign key (iddireccion) references BJBC.Direccion(iddireccion)
);
print 'Tabla direccion proveedor creado';
go

--Crear tabla Tipo_Alojamiento
if OBJECT_ID('Hospedaje.Tipo_Alojamiento', 'U') is not null
begin
	Drop Table Hospedaje.Tipo_Alojamiento;
	print 'La tabla Hospedaje.Tipo_Alojamiento Eliminada'; 
end
go

CREATE TABLE Hospedaje.Tipo_Alojamiento(
	idtipoalojamiento int identity(1,1),
	nombre_tipo varchar(50) not null, --Hotel, casa de campo, hostal
	descripcion nvarchar(max) null,
	icono_url varchar(255)null,
	fecha_registro datetime default getdate(),
	constraint PK_tipo_alojamiento primary key (idtipoalojamiento),
	constraint UQ_nombre_tipo_aloj unique (nombre_tipo)
);
print 'Tabla Tipo de alojamiento creada';
go

--Crear tabla Alojamiento
if OBJECT_ID('Hospedaje.Alojamiento', 'U') is not null
begin
	Drop Table Hospedaje.Alojamiento;
	print 'La tabla Hospedaje.Alojamiento Eliminada'; 
end
go

CREATE TABLE Hospedaje.Alojamiento(
	idalojamiento int identity (1,1),
	idtipoalojamiento int not null,
	constraint PK_alojamiento primary key (idalojamiento),
	constraint FK_tipoalojamiento foreign key (idtipoalojamiento) 
	references Hospedaje.Tipo_Alojamiento (idtipoalojamiento),
	nombre varchar(100) not null,
	telefono varchar(20),
	correo varchar(100),
	Categoria_Estrellas tinyint,
	fecha_registro datetime default getdate(),
	constraint CHK_categoria_estrellas check (categoria_estrellas between 1 and 5) --solo a hoteles
);
print 'Tabla alojamiento creada';
go

--Crear tabla Direccion_Alojamiento
if OBJECT_ID('Hospedaje.Direccion_Alojamiento', 'U') is not null
begin
	Drop Table Hospedaje.Direccion_Alojamiento;
	print 'La tabla Hospedaje.Direccion_Alojamiento Eliminada'; 
end
go

CREATE TABLE Hospedaje.Direccion_Alojamiento(
	idalojamiento int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null default 'fisica',
	referencia varchar(max),
	es_principal bit default 0,
	fecha_registro datetime default getdate(),
	constraint PK_dire_alojamiento primary key (idalojamiento, iddireccion),
	constraint FK_id_alojamiento foreign key (idalojamiento)  
	references Hospedaje.Alojamiento (idalojamiento),
	constraint FK_id_direccion foreign key (iddireccion) 
	references BJBC.Direccion (iddireccion)

);
print 'tabla direccion alojamiento creada';
go

--Crear tabla Proveedor_Alojamiento
if OBJECT_ID('Hospedaje.Proveedor_Alojamiento', 'U') is not null
begin
	Drop Table Hospedaje.Proveedor_Alojamiento;
	print 'La tabla Hospedaje.Proveedor_Alojamiento Eliminada'; 
end
go

CREATE TABLE Hospedaje.Proveedor_Alojamiento(
	idproveedoralojamiento int not null identity (1,1),
	idpersona int not null,
	idalojamiento int not null,
	fecha_registro datetime default getdate(),
	constraint PK_Proveedor_Alojamiento primary key(idproveedoralojamiento),
	constraint FK_idpersona_provee_alojamiento 
	foreign key (idpersona) references RRHH.Persona (idpersona),
	constraint FK_idalojamiento_provee_alojamiento 
	foreign key (idalojamiento) references Hospedaje.Alojamiento (idalojamiento)
);
print 'tabla proveedor alojamiento creada';
go

--Crear tabla Tipo_Habitacion
if OBJECT_ID('Hospedaje.Tipo_Habitacion', 'U') is not null
begin
	Drop Table Hospedaje.Tipo_Habitacion;
	print 'La tabla Hospedaje.Tipo_Habitacion Eliminada'; 
end
go

CREATE TABLE Hospedaje.Tipo_Habitacion(
	idtipohabitacion int identity(1,1),
	nombrehabitacion varchar(50) not null,
	capacidad_persona int not null,
	descripcion varchar(max),
	fecha_registro datetime default getdate(),
	constraint PK_idtipohabitacion primary key (idtipohabitacion),
	constraint UQ_nomhabitacion unique(nombrehabitacion)
);
print 'tabla tipo habitacion creada'
go

