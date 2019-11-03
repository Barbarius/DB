USE AdventureWorks2012;
GO

--task a)
CREATE VIEW Production.ProductModelView
    WITH ENCRYPTION, SCHEMABINDING
AS
SELECT
	cult.CultureID,
	cult.Name             AS CultureName,
	cult.ModifiedDate     AS CultureModifiedDate,
	PM.CatalogDescription,
	PM.Instructions,
	PM.Name            AS ProductModelName,
	PM.ProductModelID,
	PM.ModifiedDate    AS ProductModelModifiedDate,
	PD.[Description],
	PD.ProductDescriptionID,
	PD.rowguid,
	PD.ModifiedDate    AS ProductDescriptionModifiedDate,
	PMPDC.ModifiedDate AS PMPDC_ModifiedDate
FROM Production.ProductModel AS PM
JOIN Production.ProductModelProductDescriptionCulture AS PMPDC
	ON PM.ProductModelID = PMPDC.ProductModelID
JOIN Production.Culture AS cult
	ON cult.CultureID = PMPDC.CultureID
JOIN Production.ProductDescription AS PD
	ON PD.ProductDescriptionID = PMPDC.ProductDescriptionID;
GO

CREATE UNIQUE CLUSTERED INDEX INDX_ProductModelID_CultureID
	ON Production.ProductModelView(ProductModelID, CultureID);
GO

--task b)
CREATE TRIGGER Production.OnInsertIntoProductModelVIew
    ON Production.ProductModelView
    INSTEAD OF INSERT 
AS
BEGIN
	INSERT INTO Production.ProductModel(Name)
    SELECT ProductModelName
    FROM INSERTED;

	INSERT INTO Production.Culture(CultureID, Name)
    SELECT CultureID, CultureName
    FROM INSERTED;
	
	INSERT INTO Production.ProductDescription([Description])
    SELECT [Description]
    FROM INSERTED;

	INSERT INTO Production.ProductModelProductDescriptionCulture(CultureID, ProductModelID, ProductDescriptionID)
    VALUES ((SELECT CultureID FROM INSERTED),
            IDENT_CURRENT('Production.ProductModel'),
            IDENT_CURRENT('Production.ProductDescription'));
END;
GO

CREATE TRIGGER Production.OnUpdateIntoProductModelVIew
    ON Production.ProductModelView
    INSTEAD OF UPDATE 
AS
BEGIN
    UPDATE Production.ProductModel
    SET Name = (SELECT ProductModelName FROM INSERTED),
        ModifiedDate = GETDATE()
    WHERE Name = (SELECT ProductModelName FROM DELETED);

	UPDATE Production.Culture
    SET Name = (SELECT CultureName FROM INSERTED),
        ModifiedDate = GETDATE()
    WHERE Name = (SELECT CultureName FROM DELETED);
	
    UPDATE Production.ProductDescription
    SET [Description] = (SELECT [Description] FROM INSERTED),
        ModifiedDate  = GETDATE()
    WHERE [Description] = (SELECT [Description] FROM DELETED);
END;
GO

CREATE TRIGGER Production.OnDeleteIntoProductModelVIew
    ON Production.ProductModelView
    INSTEAD OF DELETE 
AS
BEGIN
	DECLARE @CultureID NCHAR(6);
    DECLARE @ProductDescriptionID [int];
    DECLARE @ProductModelID [int];
    SELECT @CultureID = CultureID,
           @ProductDescriptionID = ProductDescriptionID,
           @ProductModelID = ProductModelID
    FROM DELETED;

    IF @ProductModelID NOT IN (SELECT ProductModelID FROM Production.ProductModelProductDescriptionCulture)
    BEGIN
		DELETE FROM Production.ProductModel
		 WHERE ProductModelID = @ProductModelID;
	END;

    IF @CultureID NOT IN (SELECT CultureID FROM Production.ProductModelProductDescriptionCulture)
    BEGIN
		DELETE FROM Production.Culture
		WHERE CultureID = @CultureID;
    END;

    IF @ProductDescriptionID NOT IN (SELECT ProductDescriptionID FROM Production.ProductModelProductDescriptionCulture)
    BEGIN
		DELETE FROM Production.ProductDescription
		WHERE ProductDescriptionID = @ProductDescriptionID;
    END;
END;
GO

--task c)
INSERT INTO Production.ProductModelView
    (
		ProductModelName,
        CultureID,
        CultureName,
        [Description]
    )
VALUES
	(
		'ktm 250 sxf',
		'by',
		'Belarus',
		'Stainless steel'
	);
GO

UPDATE Production.ProductModelView
SET
	ProductModelName = 'ktm 250 exc',
	CultureName = 'Belarussian',
	[Description] = 'Cast iron'
WHERE
	CultureID = 'by'
	AND ProductModelID = IDENT_CURRENT('Production.ProductModel')
	AND ProductDescriptionID = IDENT_CURRENT('Production.ProductDescription');
GO

DELETE FROM Production.ProductModelView
WHERE
	CultureID = 'by'
	AND ProductModelID = IDENT_CURRENT('Production.ProductModel')
	AND ProductDescriptionID = IDENT_CURRENT('Production.ProductDescription');
GO

SELECT * FROM Production.ProductModelView
WHERE
	CultureID = 'by';
GO

SELECT * FROM Production.ProductModelView;
GO

DROP VIEW Production.ProductModelView;
GO
