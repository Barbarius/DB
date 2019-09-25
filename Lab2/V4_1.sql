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
SELECT AdventureWorks2012.HumanResources.Employee.BusinessEntityID as BusinessEntityID,
AdventureWorks2012.HumanResources.Employee.JobTitle as JobTitle,
AdventureWorks2012.HumanResources.EmployeePayHistory.Rate as Rate
FROM AdventureWorks2012.HumanResources.Employee
INNER JOIN AdventureWorks2012.HumanResources.EmployeePayHistory
ON AdventureWorks2012.HumanResources.Employee.BusinessEntityID = AdventureWorks2012.HumanResources.EmployeePayHistory.BusinessEntityID;
GO