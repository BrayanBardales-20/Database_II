--Usar master
use master;
go

--validar existencia

IF DB_ID ('Turismo_JLLB') is not null
begin
	DROP DATABASE Turismo_JLLB;
	print 'Base de datos Turismo_JLLB Eliminada'
end
go

--crear base de datos
CREATE DATABASE Turismo_JLLB;
print 'Se ha creado la base de datos Turismo_JLLB'
go

--crear un esquema
if SCHEMA_ID(N'RRHH') is not null
exec (N'Create Schema RRHH Authorization RRHH;')
go
print 'Sea ha creado el esquema RRHH'
go

if SCHEMA_ID(N'Compras') is not null
exec (N'Create Schema Compras Auhtorization Compras;')
go
print 'Sea ha creado el esquema Compras'
go

if SCHEMA_ID(N'Ventas') is not null
exec (N'Create Schema Ventas Authorization Ventas;')
go
print 'Sea ha creado el esquema Ventas'
go

if SCHEMA_ID(N'UNC') is not null
exec (N'Create Schema UNC Authorization UNC;')
go
print 'Sea ha creado el esquema UNC'
go

if SCHEMA_ID(N'BJBC') is not null
exec (N'Create Schema BJBC Authorization BJBC;')
go
print 'Sea ha creado el esquema BJBC'
go

--creacion de tablas
--validar existenci
--crear tabla

if OBJECT_ID('JLLB.Pais') is not null
begin
	drop table JLLB.pais;
	print 'La tabla JLLB.Pais Eliminada'
end
go
Create table JLLB.Pais(
	--primera forma de poner pk
	idpais int primary key identity(1,1),
	nombrepais varchar(40)not null,
	codigoiso varchar(3) not null,--PER, ARG, CHL, COL
	constraint UQ_nombrepais
	UNIQUE(nombrepais),
	constraint Uq_codigoiso
	UNIQUE(codigoiso)
);
print'La tabla JLLB.Pais creada';