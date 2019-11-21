USE AdventureWorks2012;
GO

/*Создайте хранимую процедуру, которая будет возвращать сводную таблицу (оператор PIVOT),
  отображающую данные о количестве работников, нанятых в каждый отдел (HumanResources.Department)
  за определённый год (HumanResources.EmployeeDepartmentHistory.StartDate).
  Список лет передайте в процедуру через входной параметр.*/
CREATE PROCEDURE dbo.EmpCountByDep @yearsList NVARCHAR(MAX)
AS
BEGIN
	DECLARE @sqlQuery as NVARCHAR(MAX);
	
	SET @sqlQuery = '
		SELECT
			Name,
			' + @yearsList + '
		FROM
		(
			SELECT
				D.DepartmentID,
				D.Name AS Name,
				YEAR(EDH.StartDate) AS currentYear
			FROM
				HumanResources.Department AS D
				INNER JOIN HumanResources.EmployeeDepartmentHistory AS EDH
				ON D.DepartmentID = EDH.DepartmentID
			WHERE
				EndDate IS NULL
		) AS SourceTable
		PIVOT
		(
			COUNT(DepartmentID)
			FOR
				currentYear
			IN
			(
				' + @yearsList + '
			)
		) AS PivotTable
		ORDER BY Name;
	';

	EXEC (@sqlQuery);
END;
GO

/*Таким образом, вызов процедуры будет выглядеть следующим образом:
  EXECUTE dbo.EmpCountByDep ‘[2003],[2004],[2005]’*/
EXECUTE dbo.EmpCountByDep '[2003],[2004],[2005]';
GO

DROP PROCEDURE dbo.EmpCountByDep;
GO