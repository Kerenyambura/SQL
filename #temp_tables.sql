CREATE TABLE #temp_Employee (
EmployeeId int,
JobTitle varchar(100),
Salary int
)
SELECT *
FROM #temp_Employee

INSERT INTO #temp_Employee 
VALUES ('1001', 'HR', '45000')

INSERT INTO #temp_Employee
SELECT *
FROM EmployeeSalary

CREATE TABLE #Temp_Employee2 (
JobTitle varchar(100),
EmployeesPerJob int,
AvgAge int,
AvgSalary int)

INSERT INTO #Temp_Employee2
SELECT JobTitle, COUNT(JobTitle), AVG(Age), Avg(Salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
ON emp.EmployeeID = sal.EmployeeID
group by JobTitle

select *
from #Temp_Employee2