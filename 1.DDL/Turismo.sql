/*
Base Datos Turismo
------------------------------
Incluye Reservas, Clientes, Empleados, Transporte, Hospedaje
Lugares Turisticos, Proveedores ect.
*/

--USA BASE MODELO
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
	Drop Table JLLB.Region;
	print 'La tabla BJBC.Region Eliminada'; 
end
go

CREATE TABLE BJBC.Region (
	idregion int identity (1,1),
	nomregion varchar (80) not null,
	codigoubigeo varchar(3) not null,--CAJ, LIM, CUS
	idpais int not null,
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
	estado varchar(20) default 'Activo'
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
	constraint PK_cargo Primary key (idcargo)
);
print 'Tabla Cargo Creada';
go

