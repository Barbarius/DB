USE AdventureWorks2012;
GO

/*�������� scalar-valued �������, ������� ����� ��������� � �������� ��������
  ��������� id ������ (Sales.SalesOrderHeader.SalesOrderID) � ���������� ������������
  ���� �������� �� ������ (Sales.SalesOrderDetail.UnitPrice).*/
CREATE FUNCTION Sales.GetMaxCost(@SalesOrderID [int])
	RETURNS 
		MONEY
    WITH
        EXECUTE AS CALLER
AS
BEGIN
	RETURN 
	(
		SELECT MAX(SOD.UnitPrice)
		FROM Sales.SalesOrderDetail AS SOD
		JOIN Sales.SalesOrderHeader AS SOH
		ON SOD.SalesOrderID = SOH.SalesOrderID
		WHERE @SalesOrderID = SOH.SalesOrderID
	);
END;
GO

DROP FUNCTION Sales.GetMaxCost;
GO

/*�������� inline table-valued �������, ������� ����� ��������� � �������� ������� ���������� 
  id �������� (Production.Product.ProductID) � ���������� �����, ������� ���������� �������.

  ������� ������ ���������� ������������ ���������� ������������������ ������� � �������� 
  � ���������� ��� ����������� (�� Quantity) �� Production.ProductInventory. ������� ������ 
  ���������� ������ ��������, ���������� � ������ � (Production.ProductInventory.Shelf).*/
CREATE FUNCTION Sales.GetRowsWithMaxQuantityFromShelfA(@ProductID [int], @rowCount [INTEGER])
	RETURNS TABLE
	AS RETURN
	(
		SELECT 
			*
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY ProductID) AS countOfRows,
				ProductID,
				LocationID,
				Shelf,
				Bin,
				MAX(Quantity) OVER (PARTITION BY ProductID) AS Quantity,
				rowguid,
				ModifiedDate
			FROM Production.ProductInventory
		) AS Result
		WHERE countOfRows <= @rowCount AND ProductID = @ProductID AND Shelf = 'A'
	);
GO

/*�������� ������� ��� ������� ��������, �������� �������� CROSS APPLY.*/
SELECT *
FROM Production.Product AS Prod CROSS APPLY Sales.GetRowsWithMaxQuantityFromShelfA(Prod.ProductID, 5);
GO

/*�������� ������� ��� ������� ��������, �������� �������� OUTER APPLY.*/
SELECT *
FROM Production.Product AS Prod OUTER APPLY Sales.GetRowsWithMaxQuantityFromShelfA(Prod.ProductID, 5);
GO


/*�������� ��������� inline table-valued �������, ������ �� multistatement table-valued 
  (�������������� �������� ��� �������� ��� �������� inline table-valued �������).*/
DROP FUNCTION Sales.GetRowsWithMaxQuantityFromShelfA;
GO

CREATE FUNCTION Sales.GetRowsWithMaxQuantityFromShelfA(@ProductID [int], @rowCount [int])
	RETURNS 
	@ProductQuantityTable TABLE
	(
		ProductID int,
		LocationID smallint,
		Shelf nvarchar(10),
		Bin tinyint,
		Quantity smallint,
		rowguid uniqueidentifier,
		ModifiedDate datetime
	)
	AS
	BEGIN
		INSERT INTO @ProductQuantityTable
		SELECT 
			ProductID,
			LocationID,
			Shelf,
			Bin,
			Quantity,
			rowguid,
			ModifiedDate
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY ProductID) AS countOfRows,
				ProductID,
				LocationID,
				Shelf,
				Bin,
				MAX(Quantity) OVER (PARTITION BY ProductID) AS Quantity,
				rowguid,
				ModifiedDate
			FROM Production.ProductInventory
		) AS Result
		WHERE countOfRows <= @rowCount AND ProductID = @ProductID AND Shelf = 'A'
	RETURN
	END;
GO

SELECT *
FROM Sales.GetRowsWithMaxQuantityFromShelfA(2, 5);
GO