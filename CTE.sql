WITH CTE_Employee AS
(SELECT FirstName, LastName, Gender, Salary,
COUNT(gender) OVER (PARTITION BY Gender) AS TotalGender,
AVG(Salary) OVER (PARTITION BY Gender) AS AvgSalary
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
ON emp.EmployeeId = sal.EmployeeID
WHERE Salary > '45000')

SELECT *
FROM CTE_Employee