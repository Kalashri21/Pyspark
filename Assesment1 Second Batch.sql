use AdventureWorks2022;

--- A. Find employee having highest rate or highest pay frequency

SELECT * FROM HumanResources.Employee;
SELECT * FROM HumanResources.EmployeePayHistory;

SELECT BusinessEntityID,
       max(rate) as max_rate,
	   max(PayFrequency) as max_pay_freq
FROM HumanResources.EmployeePayHistory
GROUP BY BusinessEntityID;


--- C. Find the personal details with address and address type

SELECT * FROM Person.Person               
SELECT * FROM Person.AddressType
SELECT * FROM Person.Address
SELECT * FROM Person.BusinessEntityAddress

SELECT 
     (SELECT CONCAT_WS(' ',firstname,lastname) FROM Person.Person as p
	 WHERE p.BusinessEntityID = pba.BusinessEntityID) FullName,
	 (SELECT AddressLine1 FROM Person.Address pa
	 WHERE pa.AddressID = pba.AddressID) Address1,
	 (SELECT pat.Name FROM Person.AddressType as pat
	 WHERE pat.AddressTypeID = pba.AddressTypeID)  Address_type
FROM Person.BusinessEntityAddress as pba ;


--- D. Find the job title having more revised payments

SELECT * FROM HumanResources.Employee
SELECT * FROM HumanResources.EmployeePayHistory

	--- subquery

SELECT JobTitle,count(*)
FROM HumanResources.Employee as e
WHERE e.BusinessEntityID in (SELECT eph.BusinessEntityID
      FROM HumanResources.EmployeePayHistory as eph
	  GROUP BY eph.BusinessEntityID
	  HAVING count(*) > 1)
GROUP BY e.JobTitle

---------- 

SELECT jobtitle,count(*) FROM
(SELECT e.JobTitle as jobTitle,
	   eph.BusinessEntityID as ID,
	   count(*) as cnt
FROM HumanResources.Employee as e,
HumanResources.EmployeePayHistory as eph
WHERE eph.BusinessEntityID = e.BusinessEntityID
GROUP BY e.JobTitle,eph.BusinessEntityID
HAVING count(*) > 1) as t
Group BY t.jobtitle
ORDER BY count(*) DESC


--- E. Display special offer description, category and avg(discount pct) per the year

SELECT * FROM Sales.SpecialOffer    -- spe offer id, descrip, category, discountpct ,startdate

SELECT so.SpecialOfferID,
       so.Description,
	   so.Category,
	   so.DiscountPct,
	   year(so.startdate)year_of_date,
	   avg(so.DiscountPct) OVER (partition by year(startdate))avg_discount_per_year
FROM Sales.SpecialOffer so ;


--- F. Display special offer description, category and avg(discount pct) per the month

SELECT * FROM Sales.SpecialOffer    -- spe offer id, descrip, category, discountpct ,startdate

SELECT so.SpecialOfferID,
       so.Description,
	   so.Category,
	   so.DiscountPct,
	   month(so.startdate)month_of_date,
	   avg(so.DiscountPct) OVER (partition by month(startdate))avg_discount_per_month
FROM Sales.SpecialOffer so ;


--- G. Using rank and dense rand find territory wise top sales person

SELECT * FROM Sales.SalesTerritory;
SELECT * FROM Sales.SalesPerson;
SELECT * FROM Person.Person;

SELECT st.name,
       p.firstname,
	   count(sp.salesQuota) territory_wise_cnt
FROM Sales.SalesTerritory st,
Sales.SalesPerson as sp,
Person.Person as p
WHERE sp.TerritoryID = st.TerritoryID
and sp.BusinessEntityID = p.BusinessEntityID
GROUP BY st.name,p.firstname
ORDER BY count(sp.salesQuota);


--- H.  Calculate total years of experience of the employee 
--- and find out employees those who server for more than 20 years

SELECT * FROM HumanResources.Employee
SELECT * FROM [HumanResources].[EmployeeDepartmentHistory]



--- I. Find the employee who is having more vacations than the average vacation taken by all employees

SELECT * FROM HumanResources.Employee

SELECT BusinessEntityID,
       VacationHours,
	   avg(VacationHours) OVER ( partition by VacationHours) avg_vacationhours
       FROM HumanResources.Employee
	   WHERE VacationHours > 99 ;


---- k Find the department name  having more employees

SELECT * FROM HumanResources.Department;
SELECT * FROM HumanResources.EmployeeDepartmentHistory;

SELECT 
      d.name,
	  count(*) dept_wise_count
FROM HumanResources.Department as d,
HumanResources.EmployeeDepartmentHistory as ed
WHERE d.DepartmentID = ed.DepartmentID
GROUP BY d.name 
ORDER BY count(*) DESC

 
SELECT 
      top 1 d.name,
	  count(*) dept_wise_count
FROM HumanResources.Department as d,
HumanResources.EmployeeDepartmentHistory as ed
WHERE d.DepartmentID = ed.DepartmentID
GROUP BY d.name 
ORDER BY count(*) DESC


--- L. Is there any person having more than one credit card (hint: PersonCreditCard)

SELECT * FROM Sales.PersonCreditCard   -- business id, credit card id
SELECT * FROM Sales.CreditCard         -- credit card id
SELECT * FROM Person.Person
SELECt count(*) FROM Sales.CreditCard  -- 19118
SELECT count(*) FROM Sales.PersonCreditCard  ---19118

SELECT  
      p.FirstName,
	  count(pcc.CreditCardID) cnt
FROM Sales.PersonCreditCard as pcc,
Sales.CreditCard as cc,
Person.Person as p
WHERE pcc.BusinessEntityID = p.BusinessEntityID
and pcc.CreditCardID = cc.CreditCardID
GROUP BY p.FirstName
HAVING count(pcc.CreditCardID) > 1 ;

--- M. Find how many subcategories are available per  product . (product sub category
 
SELECT * FROM Production.ProductSubcategory
SELECT * FROM Production.ProductCategory

SELECT 
	  pc.Name,
	  count(sc.Name)
FROM Production.ProductSubcategory as sc,
Production.ProductCategory as pc
WHERE sc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY count(sc.Name)


--- N.  Find total standard cost for the active Product where end date is not updated. (Product cost history)




--- O.  Which territory is having more customers (hint: customer)

