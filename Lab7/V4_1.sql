USE AdventureWorks2012;
GO

/*Вывести значения полей BusinessEntityID, Name, AccountNumber из таблицы 
  Purchasing.Vendor в виде xml, сохраненного в переменную.*/
DECLARE
    @xml XML;

SET @xml =
(
	SELECT
		BusinessEntityID AS 'ID',
		Name AS 'Name',
		AccountNumber AS 'AccountNumber'
	FROM
		Purchasing.Vendor
	FOR XML
		PATH ('Vendor'),
		ROOT ('Vendors')
)

SELECT @xml;

/*Создать хранимую процедуру, возвращающую таблицу, заполненную из xml переменной представленного вида.*/
CREATE PROCEDURE dbo.GetVendorTableFromXML @xmlTable XML
AS
BEGIN
	CREATE TABLE #resultVendorTable
    (
		BusinessEntityID int,
		Name NVARCHAR(50),
		AccountNumber NVARCHAR(15)
	);

	INSERT INTO #resultVendorTable
    SELECT 
		BusinessEntityID = node.value('ID[1]', 'INT'),
		Name = node.value('Name[1]', 'NVARCHAR(50)'),
		AccountNumber = node.value('AccountNumber[1]', 'NVARCHAR(15)')
	FROM @xmlTable.nodes('/Vendors/Vendor') AS XML(node);

	SELECT * FROM #resultVendorTable;
END;
GO

DROP PROCEDURE dbo.GetVendorTableFromXML;
GO

/*Вызвать эту процедуру для заполненной на первом шаге переменной.*/
DECLARE
    @xml XML;

SET @xml =
(
	SELECT
		BusinessEntityID AS 'ID',
		Name AS 'Name',
		AccountNumber AS 'AccountNumber'
	FROM
		Purchasing.Vendor
	FOR XML
		PATH ('Vendor'),
		ROOT ('Vendors')
)

EXEC dbo.GetVendorTableFromXML @xml;
GO