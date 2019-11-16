USE AdventureWorks2012;
GO

/*—оздайте хранимую процедуру, котора€ будет возвращать сводную таблицу (оператор PIVOT),
  отображающую данные о количестве работников, нан€тых в каждый отдел (HumanResources.Department)
  за определЄнный год (HumanResources.EmployeeDepartmentHistory.StartDate).
  —писок лет передайте в процедуру через входной параметр.*/
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

/*“аким образом, вызов процедуры будет выгл€деть следующим образом:
  EXECUTE dbo.EmpCountByDep С[2003],[2004],[2005]Т*/
EXECUTE dbo.EmpCountByDep '[2003],[2004],[2005]';
GO

DROP PROCEDURE dbo.EmpCountByDep;
GO