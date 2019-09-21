CREATE DATABASE NewDatabase;
GO

CREATE SCHEMA scales;
GO

CREATE SCHEMA persons;
GO

CREATE TABLE sales.Orders (OrderNum INT NULL);
GO

BACKUP DATABASE NewDatabase TO DISK='D:\Documents\DB\Lab1\NewDatabase.bak';
GO

DROP DATABASE NewDatabase;
GO

RESTORE DATABASE NewDatabase FROM DISK='D:\Documents\DB\Lab1\NewDatabase.bak';
GO