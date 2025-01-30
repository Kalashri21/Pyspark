use AdventureWorks2022;

SELECT * FROM HumanResources.Employee;

SELECT * FROM HumanResources.Employee
WHERE MaritalStatus = 'M';

----- find all employee under job title marketing
SELECT * FROM HumanResources.Employee
WHERE JobTitle = 'Marketing Specialist';

SELECT * FROM HumanResources.Employee WHERE JobTitle like 'Marketing%';

SELECT COUNT(*) FROM HumanResources.Employee;      -- give count for tota employee for data

SELECT COUNT(*) FROM HumanResources.Employee       
WHERE Gender = 'M';                                -- give count for male employee

--- Find employee having salaried flag as 1
SELECT SalariedFlag FROM HumanResources.Employee
WHERE SalariedFlag = 1;

--- Find all employee having Vacation hour more than 70
SELECT * FROM HumanResources.Employee
WHERE  VacationHours = 70;

--- Vacation hour more than 70 but less than 90
SELECT * FROM HumanResources.Employee
WHERE  VacationHours > 70 and VacationHours < 90;

--- Find all jobs having title as Designer
SELECT DISTINCT JobTitle FROM HumanResources.Employee

SELECT * FROM HumanResources.Employee
WHERE JobTitle like 'Design%';

--- Find total employees worked as Texchnician
SELECT * FROM HumanResources.Employee
WHERE JobTitle like '%Technician%';

--- Display data having NationalIDNumber,job title,marital status,gender for all under marketing job title
SELECT NationalIDNumber,JobTitle,MaritalStatus,Gender FROM HumanResources.Employee
WHERE JobTitle like '%Marketing%';

--- Find all unique marital status
SELECT DISTINCT MaritalStatus FROM HumanResources.Employee;

--- Find the max Vacation hr
SELECT MAX(VacationHours) as maximum_vacation_hours FROM HumanResources.Employee; 

--- Find less sick leaves
SELECT MIN(SickLeaveHours)as minimum_sick_leaves FROM HumanResources.Employee;



--- Find all employee from Production department

SELECT * FROM HumanResources.Department WHERE name = 'Production';

SELECT * FROM HumanResources.Employee
WHERE BusinessEntityID in
(SELECT BusinessEntityID
FROM HumanResources.EmployeeDepartmentHistory
WHERE DepartmentID = 7);

--- find all department under Research and development

SELECT * FROM HumanResources.Department;

SELECT * FROM HumanResources.Department WHERE GroupName = 'Research and Development';

--- find all emp under research and dev

SELECT * FROM HumanResources.EmployeeDepartmentHistory;

SELECT * FROM HumanResources.EmployeeDepartmentHistory 
WHERE DepartmentID in
(SELECT DepartmentID FROM HumanResources.Department
WHERE GroupName = 'Research and Development');

-----
SELECT * FROM HumanResources.Employee
WHERE BusinessEntityID in 
(SELECT BusinessEntityID FROM HumanResources.EmployeeDepartmentHistory 
WHERE DepartmentID in
(SELECT DepartmentID FROM HumanResources.Department
WHERE GroupName = 'Research and Development'));

-- Find all employees who work in day shift

SELECT * FROM HumanResources.Shift;
SELECT * FROM HumanResources.Shift WHERE name = 'day'

SELECT * FROM HumanResources.EmployeeDepartmentHistory
WHERE ShiftID in
(SELECT ShiftID FROM HumanResources.Shift WHERE name = 'day')

-- All Query
-- For multiple value use in

SELECT * FROM HumanResources.Employee
WHERE BusinessEntityID in
(SELECT BusinessEntityID FROM HumanResources.EmployeeDepartmentHistory
WHERE ShiftID =
(SELECT ShiftID FROM HumanResources.Shift WHERE name = 'day'));

--- Find all employees where pay frequency is 1 -- pay

SELECT * FROM HumanResources.EmployeePayHistory;

SELECT * FROM HumanResources.Employee
WHERE BusinessEntityID in
(SELECT BusinessEntityID FROM HumanResources.EmployeePayHistory WHERE PayFrequency = 1);

--- Find out all job id which are not place

SELECT * FROM HumanResources.JobCandidate;

SELECT * FROM HumanResources.JobCandidate
WHERE BusinessEntityID is null;

--- Find the address of Employees

SELECT * FROM HumanResources.Employee
WHERE BusinessEntityID in
(SELECT BusinessEntityID FROM Person.BusinessEntityAddress
WHERE AddressID in
(SELECT AddressID FROM Person.Address));

SELECT * FROM Person.Address
WHERE AddressID in
(SELECT AddressID FROM Person.BusinessEntityAddress
WHERE BusinessEntityID in
(SELECT BusinessEntityID from HumanResources.Employee))


--- Find the name for employee working in group research and development

SELECT * FROM HumanResources.EmployeeDepartmentHistory
SELECT * FROM HumanResources.Department
SELECT * FROM Person.Person

SELECT * FROM Person.Person
WHERE BusinessEntityID in 
(SELECT BusinessEntityID FROM HumanResources.EmployeeDepartmentHistory
WHERE DepartmentID in
(SELECT DepartmentID FROM HumanResources.Department
WHERE GroupName = 'Research and Development'))




