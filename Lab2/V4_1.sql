USE AdventureWorks2012;
GO

--task1
SELECT DISTINCT dep.Name as DepartmentName,
emp.JobTitle as JobTitle,
COUNT(emp.BusinessEntityID) OVER (partition BY EDH.DepartmentID) as EmpCount
FROM AdventureWorks2012.HumanResources.Department as dep
INNER JOIN AdventureWorks2012.HumanResources.EmployeeDepartmentHistory as EDH
ON dep.DepartmentID = EDH.DepartmentID 
INNER JOIN AdventureWorks2012.HumanResources.Employee as emp
ON EDH.BusinessEntityID = emp.BusinessEntityID
ORDER BY dep.Name ASC;
GO

--task2
SELECT emp.BusinessEntityID as BusinessEntityID,
emp.JobTitle as JobTitle,
sh.Name as Name,
sh.StartTime as StartTime,
sh.EndTime as EndTime
FROM AdventureWorks2012.HumanResources.Employee as emp
INNER JOIN AdventureWorks2012.HumanResources.EmployeeDepartmentHistory as EDH
ON emp.BusinessEntityID = EDH.BusinessEntityID
INNER JOIN AdventureWorks2012.HumanResources.Shift as sh
ON EDH.ShiftID = sh.ShiftID
WHERE sh.Name = 'Night';
GO

--task3
SELECT [emp].[BusinessEntityID], [emp].[JobTitle], [temp_emp].[Rate], 
LAG([temp_emp].[Rate], 1, 0) OVER (PARTITION BY [emp].[BusinessEntityID] ORDER BY [temp_emp].[Rate]) as PrevRate, 
([temp_emp].[Rate] - LAG([temp_emp].[Rate], 1, 0) OVER (PARTITION BY [emp].[BusinessEntityID] ORDER BY [temp_emp].[Rate])) as Increased 
FROM [AdventureWorks2012].[HumanResources].[Employee] AS emp
INNER JOIN [HumanResources].[EmployeePayHistory] as temp_emp
ON [emp].[BusinessEntityID] = [temp_emp].[BusinessEntityID]; 
GO