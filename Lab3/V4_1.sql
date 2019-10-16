USE AdventureWorks2012;
GO

--task a)
ALTER TABLE dbo.StateProvince
ADD CountryRegionName nvarchar(50);
GO

--task b)
DECLARE @tableVar TABLE(
	StateProvinceID INT NOT NULL,
	StateProvinceCode NCHAR(3) NOT NULL,
	CountryRegionCode NVARCHAR(3) NOT NULL,
	Name NAME NOT NULL,
	TerritoryID INT NOT NULL,
	ModifiedDate DATETIME NOT NULL,
	CountryNum INT NULL,
	CountryRegionName nvarchar(50)
);
INSERT INTO @tableVar(
	StateProvinceID,
	StateProvinceCode,
	CountryRegionCode,
	Name,
	TerritoryID,
	ModifiedDate,
	CountryNum,
	CountryRegionName
) SELECT
	StateProvinceID,
	StateProvinceCode,
	CountryRegionCode,
	Name,
	TerritoryID,
	ModifiedDate,
	CountryNum,
	(SELECT Name FROM Person.CountryRegion WHERE Person.CountryRegion.CountryRegionCode = dbo.StateProvince.CountryRegionCode)
FROM dbo.StateProvince;

SELECT * FROM @tableVar;

--task c)
UPDATE dbo.StateProvince
SET dbo.StateProvince.CountryRegionName = tableVar.CountryRegionName
FROM @tableVar AS tableVar
WHERE dbo.StateProvince.StateProvinceID = tableVar.StateProvinceID;
GO

SELECT * FROM dbo.StateProvince;
GO

--task d)
DELETE dbo.StateProvince
FROM dbo.StateProvince
WHERE NOT EXISTS (SELECT 1 FROM Person.Address WHERE dbo.StateProvince.StateProvinceID = Person.Address.StateProvinceID);
GO

SELECT * FROM dbo.StateProvince;
GO

--task e)
SELECT *
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'StateProvince';
GO

ALTER TABLE dbo.StateProvince DROP COLUMN CountryRegionName;
ALTER TABLE dbo.StateProvince DROP CONSTRAINT AK_StateProvince_Name_Unique;
ALTER TABLE dbo.StateProvince DROP CONSTRAINT CHK_StateProvince_CountryRegionCode_Only_Alphabets;
ALTER TABLE dbo.StateProvince DROP CONSTRAINT DF_StateProvince_ModifiedDate;

--task f)
DROP TABLE dbo.StateProvince;
GO