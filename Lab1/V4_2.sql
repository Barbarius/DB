--task1
SELECT Name, GroupName
FROM AdventureWorks2012.HumanResources.Department
WHERE GroupName = 'Executive General and Administration';
GO

--task2
SELECT MAX(VacationHours) AS MaxVacationHours
FROM AdventureWorks2012.HumanResources.Employee;
GO

--task3
SELECT BusinessEntityID, JobTitle, Gender, BirthDate, HireDate
FROM AdventureWorks2012.HumanResources.Employee
WHERE CHARINDEX('Engineer', JobTitle) > 0;
GO