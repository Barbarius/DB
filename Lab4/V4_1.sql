USE AdventureWorks2012;
GO

--task a)
CREATE TABLE Production.ProductModelHst
(
    ID INT IDENTITY(1, 1),
    Action NVARCHAR(6) NOT NULL CHECK (Action IN('insert', 'update', 'delete')),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    SourceID NCHAR(3) NOT NULL,
    UserName Name NOT NULL
);
GO

--task b)
CREATE TRIGGER Production.OnProductModelInsert
ON Production.ProductModel
AFTER
	INSERT
AS
	INSERT INTO Production.ProductModelHst
		(
			Action,
			ModifiedDate,
			SourceID,
			UserName
		)
	SELECT
		'insert',
		INSERTED.ModifiedDate,
		ProductModelID,
		CURRENT_USER
	FROM
		INSERTED;
GO

CREATE TRIGGER Production.OnProductModelUpdate
ON Production.ProductModel
AFTER
	UPDATE
AS
	INSERT INTO Production.ProductModelHst
		(
			Action,
			ModifiedDate,
			SourceID,
			UserName
		)
	SELECT
		'update',
		INSERTED.ModifiedDate,
		ProductModelID,
		CURRENT_USER
	FROM
		INSERTED;
GO

CREATE TRIGGER Production.OnProductModelDelete
ON Production.ProductModel
AFTER
	DELETE
AS
	INSERT INTO Production.ProductModelHst
		(
			Action,
			ModifiedDate,
			SourceID,
			UserName
		)
	SELECT
		'delete',
		DELETED.ModifiedDate,
		ProductModelID,
		CURRENT_USER
	FROM
		DELETED;
GO

--task c)
CREATE VIEW
    Production.ProductModelView
AS
    SELECT *
    FROM Production.ProductModel;
GO

--task d)
INSERT INTO Production.ProductModel (Name)
VALUES ('Husaberg FE 250');
GO

UPDATE Production.ProductModel
SET Name = 'Husqvarna FE 250'
WHERE Name = 'Husaberg FE 250';
GO

DELETE FROM Production.ProductModel
WHERE Name = 'Husqvarna FE 250';
GO

SELECT * FROM Production.ProductModelHst;
GO