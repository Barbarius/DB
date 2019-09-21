CREATE DATABASE Sergei_Bysov;
GO

CREATE SCHEMA scales;
GO

CREATE SCHEMA persons;
GO

CREATE TABLE scales.Orders (OrderNum INT NULL);
GO

BACKUP DATABASE Sergei_Bysov TO DISK='D:\Documents\DB\Lab1\Sergei_Bysov.bak';
GO

DROP DATABASE Sergei_Bysov;
GO

RESTORE DATABASE Sergei_Bysov FROM DISK='D:\Documents\DB\Lab1\Sergei_Bysov.bak';
GO