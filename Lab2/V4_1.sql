--task1
SELECT DISTINCT AdventureWorks2012.HumanResources.Department.Name as DepartmentName,
AdventureWorks2012.HumanResources.Employee.JobTitle as JobTitle,
COUNT(AdventureWorks2012.HumanResources.Employee.BusinessEntityID) as EmpCount
FROM AdventureWorks2012.HumanResources.Department 
INNER JOIN AdventureWorks2012.HumanResources.EmployeeDepartmentHistory 
ON AdventureWorks2012.HumanResources.Department.DepartmentID = AdventureWorks2012.HumanResources.EmployeeDepartmentHistory.DepartmentID 
INNER JOIN AdventureWorks2012.HumanResources.Employee 
ON AdventureWorks2012.HumanResources.EmployeeDepartmentHistory.BusinessEntityID = AdventureWorks2012.HumanResources.Employee.BusinessEntityID
GROUP BY AdventureWorks2012.HumanResources.Department.Name, AdventureWorks2012.HumanResources.Employee.JobTitle
ORDER BY AdventureWorks2012.HumanResources.Department.Name;
GO

--task2
SELECT AdventureWorks2012.HumanResources.Employee.BusinessEntityID as BusinessEntityID,
AdventureWorks2012.HumanResources.Employee.JobTitle as JobTitle,
AdventureWorks2012.HumanResources.Shift.Name as Name,
AdventureWorks2012.HumanResources.Shift.StartTime as StartTime,
AdventureWorks2012.HumanResources.Shift.EndTime as EndTime
FROM AdventureWorks2012.HumanResources.Employee
INNER JOIN AdventureWorks2012.HumanResources.EmployeeDepartmentHistory
ON AdventureWorks2012.HumanResources.Employee.BusinessEntityID = AdventureWorks2012.HumanResources.EmployeeDepartmentHistory.BusinessEntityID
INNER JOIN AdventureWorks2012.HumanResources.Shift
ON AdventureWorks2012.HumanResources.EmployeeDepartmentHistory.ShiftID = AdventureWorks2012.HumanResources.Shift.ShiftID
WHERE AdventureWorks2012.HumanResources.Shift.Name = 'Night';
GO

--task3
SELECT [emp].[BusinessEntityID], [emp].[JobTitle], [temp_emp].[Rate], 
LAG([temp_emp].[Rate], 1, 0) OVER (PARTITION BY [emp].[BusinessEntityID] ORDER BY [temp_emp].[Rate]) as PrevRate, 
([temp_emp].[Rate] - LAG([temp_emp].[Rate], 1, 0) OVER (PARTITION BY [emp].[BusinessEntityID] ORDER BY [temp_emp].[Rate])) as Increased 
FROM [AdventureWorks2012].[HumanResources].[Employee] AS emp
INNER JOIN [HumanResources].[EmployeePayHistory] as temp_emp
ON [emp].[BusinessEntityID] = [temp_emp].[BusinessEntityID]; 
GO