SELECT *
FROM EmployeeDemographics
UNION 
SELECT * 
FROM WareHouseEmployeeDemographics

SELECT * 
FROM EmployeeDemographics
Full Outer Join WareHouseEmployeeDemographics
ON EmployeeDemographics.EmployeeID = WareHouseEmployeeDemographics.EmployeeID