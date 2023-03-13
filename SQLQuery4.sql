
--SELECT FirstName, LastName, Salary,
--CASE
--	WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .10)
--	WHEN JobTitle = 'Accountant' THEN Salary + (Salary * .05)
--	WHEN JobTitle = 'HR' THEN Salary + (Salary * .000001)
--	ELSE Salary + (Salary * .03)
--END AS SalaryAfterRaise

--FROM EmployeeDemographics
--JOIN EmployeeSalary
--ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--SELECT JobTitle, COUNT(JobTitle)
--FROM EmployeeDemographics
--JOIN EmployeeSalary
--ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
--GROUP BY JobTitle
--HAVING COUNT(JobTitle) > 1

--SELECT JobTitle, AVG(Salary)
--FROM EmployeeDemographics
--JOIN EmployeeSalary
--ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
--GROUP BY JobTitle
--HAVING AVG(Salary) > 45000
--ORDER BY AVG(Salary)

--SELECT * 
--FROM EmployeeSalary

--DELETE
--FROM EmployeeSalary
--WHERE EmployeeID = 1013 

--Insert into EmployeeDemographics 
--VALUES(1011, 'Ryan', 'Howard', 26, 'Male'),

--(NULL, 'Holly','Flax', NULL, 'Male'),

--(1013, 'Darryl', 'Philbin', NULL, 'Male')

--Insert into EmployeeSalary VALUES

--(1010, NULL, 47000),

--(NULL, 'Salesman', 43000)

SELECT * 
FROM EmployeeDemographics

UPDATE EmployeeDemographics
SET Age = 30
WHERE EmployeeID = 1013