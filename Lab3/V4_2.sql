USE AdventureWorks2012;
GO

DROP TABLE #StateProvince;
GO

--task a)
ALTER TABLE dbo.StateProvince
    ADD SalesYTD MONEY;
GO

ALTER TABLE dbo.StateProvince
    ADD SumSales MONEY;
GO

ALTER TABLE dbo.StateProvince
    ADD SalesPercent AS ROUND(SalesYTD / SumSales * 100, 0) persisted;
GO

--task b)
CREATE TABLE #StateProvince
(
	StateProvinceID [INT] NOT NULL PRIMARY KEY,
	StateProvinceCode [NCHAR](3) COLLATE sql_latin1_general_cp1_ci_as NOT NULL,
	CountryRegionCode [NVARCHAR](3) COLLATE sql_latin1_general_cp1_ci_as NOT NULL,
	Name VARCHAR(50) NOT NULL,
	TerritoryID [INT] NOT NULL,
	ModifiedDate [DATETIME] NOT NULL,
	CountryNum [INT],
	SalesYTD MONEY,
	SumSales MONEY
);

SELECT * FROM #StateProvince;
GO

--task c)
WITH SumSales_CTE AS (SELECT ST.TerritoryID, SUM(ST.SalesLastYear) AS SumSales
					  FROM dbo.StateProvince AS SP
					  JOIN Sales.SalesTerritory AS ST
					  ON SP.TerritoryID = ST.TerritoryID
					  GROUP BY ST.TerritoryID)
INSERT INTO #StateProvince
(
	StateProvinceID,
	StateProvinceCode,
	CountryRegionCode,
	Name,
	TerritoryID,
	ModifiedDate,
	CountryNum,
	SalesYTD,
	SumSales	
)
SELECT 
	SP.StateProvinceID,
	SP.StateProvinceCode,
	SP.CountryRegionCode,
	SP.Name,
	SP.TerritoryID,
	SP.ModifiedDate,
	SP.CountryNum,
	ST.SalesLastYear,
	SS.SumSales
FROM dbo.StateProvince AS SP
JOIN Sales.SalesTerritory AS ST
ON SP.TerritoryID = ST.TerritoryID
JOIN SumSales_CTE AS SS
ON SS.TerritoryID = SP.TerritoryID;

SELECT * FROM #StateProvince;
GO

--task d)
DELETE
FROM dbo.StateProvince
WHERE StateProvinceID = 5;

SELECT * FROM dbo.StateProvince;
GO

--task e)
MERGE dbo.StateProvince AS TARGET
USING #StateProvince AS SOURCE
ON (TARGET.StateProvinceID = SOURCE.StateProvinceID)
WHEN MATCHED THEN
	UPDATE SET SalesYTD = SOURCE.SalesYTD,
	SumSales = SOURCE.SumSales
WHEN NOT MATCHED BY TARGET THEN
	INSERT 
	(
		StateProvinceID,
		StateProvinceCode,
		CountryRegionCode,
		Name,
		TerritoryID,
		ModifiedDate,
		CountryNum,
		SalesYTD,
		SumSales	
	)
	VALUES 
	(
		StateProvinceID,
		StateProvinceCode,
		CountryRegionCode,
		Name,
		TerritoryID,
		ModifiedDate,
		CountryNum,
		SalesYTD,
		SumSales
	)
WHEN NOT MATCHED BY SOURCE THEN
	DELETE;
GO

SELECT * FROM dbo.StateProvince;
GO