--task à)

DROP TABLE [dbo].[StateProvince];
GO

CREATE TABLE [dbo].[StateProvince](								
	[StateProvinceID] INT NOT NULL,
	[StateProvinceCode] NCHAR(3) NOT NULL,
	[CountryRegionCode] NVARCHAR(3) NOT NULL,
	[IsOnlyStateProvinceFlag] FLAG NOT NULL,
	[Name] NAME NOT NULL,
	[TerritoryID] INT NOT NULL,
	[ModifiedDate] DATETIME NOT NULL,
	CONSTRAINT [PK_StateProvince_StateProvinceID] PRIMARY KEY CLUSTERED ([StateProvinceID]),
	CONSTRAINT [FK_CountryRegion_CountryRegionCode] FOREIGN KEY ([CountryRegionCode]) REFERENCES [Person].[CountryRegion]([CountryRegionCode]),
	CONSTRAINT [FK_SalesTerritory_TerritoryID] FOREIGN KEY ([TerritoryID]) REFERENCES [Sales].[SalesTerritory](TerritoryID)
);
GO

--task b)
ALTER TABLE [dbo].[StateProvince]
ADD CONSTRAINT [AK_StateProvince_Name_Unique] UNIQUE ([Name]);
GO

--task c)
ALTER TABLE [dbo].[StateProvince]
ADD CONSTRAINT [CHK_StateProvince_CountryRegionCode_Only_Alphabets] CHECK (CountryRegionCode NOT LIKE '%[^A-Z]%') 
GO

--task d)
ALTER TABLE [dbo].[StateProvince]
ADD CONSTRAINT [DF_StateProvince_ModifiedDate] DEFAULT GETDATE() FOR [ModifiedDate];
GO

--task e)
INSERT INTO [dbo].[StateProvince] (
	[StateProvinceID],
	[StateProvinceCode],
	[CountryRegionCode],
	[IsOnlyStateProvinceFlag],
	[Name],
	[TerritoryID],
	[ModifiedDate]
) SELECT
	[st].[StateProvinceID],
	[st].[StateProvinceCode],
	[st].[CountryRegionCode],
	[st].[IsOnlyStateProvinceFlag],
	[st].[Name],
	[st].[TerritoryID],
	[st].[ModifiedDate]
FROM [Person].[StateProvince] as st
INNER JOIN [Person].[CountryRegion] as cr ON cr.CountryRegionCode = st.CountryRegionCode
WHERE cr.Name = st.Name;
GO

--task  f)
ALTER TABLE [dbo].[StateProvince] DROP COLUMN IsOnlyStateProvinceFlag;
GO

ALTER TABLE [dbo].[StateProvince] ADD CountryNum INT NULL;
GO

SELECT *
FROM [dbo].[StateProvince]

SELECT *
FROM Person.[StateProvince]
