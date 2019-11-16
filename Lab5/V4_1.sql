USE AdventureWorks2012;
GO

/*Создайте scalar-valued функцию, которая будет принимать в качестве входного
  параметра id заказа (Sales.SalesOrderHeader.SalesOrderID) и возвращать максимальную
  цену продукта из заказа (Sales.SalesOrderDetail.UnitPrice).*/
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

/*Создайте inline table-valued функцию, которая будет принимать в качестве входных параметров 
  id продукта (Production.Product.ProductID) и количество строк, которые необходимо вывести.

  Функция должна возвращать определенное количество инвентаризационных записей о продукте 
  с наибольшим его количеством (по Quantity) из Production.ProductInventory. Функция должна 
  возвращать только продукты, хранящиеся в отделе А (Production.ProductInventory.Shelf).*/
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

/*Вызовите функцию для каждого продукта, применив оператор CROSS APPLY.*/
SELECT *
FROM Production.Product AS Prod CROSS APPLY Sales.GetRowsWithMaxQuantityFromShelfA(Prod.ProductID, 5);
GO

/*Вызовите функцию для каждого продукта, применив оператор OUTER APPLY.*/
SELECT *
FROM Production.Product AS Prod OUTER APPLY Sales.GetRowsWithMaxQuantityFromShelfA(Prod.ProductID, 5);
GO


/*Измените созданную inline table-valued функцию, сделав ее multistatement table-valued 
  (предварительно сохранив для проверки код создания inline table-valued функции).*/
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