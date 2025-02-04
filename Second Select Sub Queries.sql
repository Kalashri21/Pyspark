use AdventureWorks2022;

SELECT * FROM HumanResources.Employee;

SELECT BusinessEntityID,
    NationalIDNumber,
	JobTitle,
	(SELECT FirstName FROM Person.Person p
	WHERE p.BusinessEntityID = e.BusinessEntityID) FirstName
    FROM HumanResources.Employee e;

-- add personal details of employee middle name ,last name
SELECT BusinessEntityID,
       NationalIDNumber,
	   JobTitle,
	   (SELECT firstname FROM Person.Person p
	   WHERE p.BusinessEntityID = e.BusinessEntityID) FirstName,
	   (SELECT middlename FROM Person.Person p
	   WHERE p.BusinessEntityID = e.BusinessEntityID) MiddleName,
	   (SELECT lastname FROM Person.Person p
	   WHERE p.BusinessEntityID = e.BusinessEntityID) lastName
       FROM HumanResources.Employee e;

--- Using Concat_Ws

SELECT BusinessEntityID,
       NationalIDNumber,
	   JobTitle,
	   (SELECT CONCAT_WS(' ',firstname,middlename,lastname) FROM Person.Person p
	   WHERE p.BusinessEntityID = e.BusinessEntityID) FullName
	   FROM HumanResources.Employee e

--- display national id ,first name ,last name & dept name ,dept group

SELECT * FROM HumanResources.Employee;
SELECT * FROM Person.Person
SELECT * FROM HumanResources.Department
SELECT * FROM HumanResources.EmployeeDepartmentHistory


SELECT (SELECT CONCAT_WS (' ',firstname,lastname) FROM Person.Person p
        WHERE p.BusinessEntityID = ed.BusinessEntityID) Person_Details ,
(SELECT NationalIDNumber FROM HumanResources.Employee e
        WHERE e.BusinessEntityID = ed.BusinessEntityID) NationalID,
(SELECT CONCAT(name,GroupName) FROM HumanResources.Department d
        WHERE d.DepartmentID = ed.DepartmentID)dept_details
FROM HumanResources.EmployeeDepartmentHistory ed;

--- Display first name,lastname ,department ,shift time

SELECT * FROM HumanResources.Department --- dept id , 
SELECT * FROM HumanResources.EmployeeDepartmentHistory -- busssi id, dept id,shift id,sart date
SELECT * FROM Person.Person    --bussi entity,first name ,last name
SELECT * FROM HumanResources.Shift  --- shiftid,start time,end time


SELECT (SELECT CONCAT_WS(' ',firstname,lastname) FROM Person.Person p
        WHERE p.BusinessEntityID = ed.BusinessEntityID) FullName,
		(SELECT Name FROM HumanResources.Department d
		WHERE d.DepartmentID = ed.DepartmentID) Dept_name,
		(SELECT CONCAT_WS(' ',starttime,endtime) FROM HumanResources.shift s
		WHERE s.ShiftID = ed.ShiftID ) Shift_time 
		FROM HumanResources.EmployeeDepartmentHistory ed



--- Display product name and product review based on production schema

SELECT * FROM Production.Product   -- prod id
SELECT * FROM Production.ProductReview  -- prod review id

SELECT 
(SELECT name FROM Production.Product p
WHERE p.ProductID = pr.ProductID)name,comments
FROM Production.ProductReview pr    
  

--- Find th e Employees name,Job title,card details whose 
--- credit card expired in month 11 and year 2008

SELECT* from Sales.CreditCard ---ID NUMBER, CARD TYPE, CARDNUM,EXP MONTH EXP YR
SELECT* FROM SALES.PersonCreditCard--- BUSINESSENTITYID, CREDIT ID
SELECT* FROM SALES.SalesPerson
SELECT* FROM SALES.SalesOrderDetail
select* from HumanResources.Employee

SELECT BusinessEntityID,
     (SELECT firstname FROM Person.Person p
	 WHERE p.BusinessEntityID = pc.BusinessEntityID) ename,
	 (SELECT JobTitle FROM HumanResources.Employee e
	 WHERE e.BusinessEntityID = pc.BusinessEntityID) Job_title,
	 (SELECT CONCAT_WS(' ',cc.CardType,cc.ExpMonth,cc.ExpYear) FROM Sales.CreditCard cc
	 WHERE cc.CreditCardID = pc.CreditCardId) credit_card
FROM Sales.PersonCreditCard pc
WHERE pc.CreditCardID in (select CreditCardID
             FROM Sales.CreditCard crd
			 WHERE crd.ExpMonth = 11 and crd.ExpYear = 2008);


--- Display EMP name ,teritory name,group,SalesLastYear,Sales Quota,bonus
--- Display EMP name ,teritory name,group,SalesLastYear,Sales Quota,bonus from Germany and United Kingdom
--- Find all employees who work in all North America Teritory


--- Display EMP name ,teritory name,group,SalesLastYear,Sales Quota,bonus
SELECT * FROM Sales.SalesTerritory   --- teri id, teri name, group, Sales last year
SELECT * FROM Sales.SalesPerson      ---Business id , teri id , sales quota, bonus, Sales last year
SELECT * FROM HumanResources.Employee --- Business id
SELECT * FROM Person.Person           --- Business id, name
SELECT * FROM Sales.Customer          --- Cust id, teri id
SELECT * FROM Sales.SalesOrderDetail  --- sales id ,sale detail id
SELECT * FROM Sales.SalesTaxRate      --- sales tax rate id

SELECT 
       (SELECT firstname FROM Person.Person pp
	   WHERE pp.BusinessEntityID = sp.BusinessEntityID) Emp_name, 
       (SELECT [Group] FROM Sales.SalesTerritory st
	   WHERE st.TerritoryID = sp.TerritoryID)Territory_group,
	   (SELECT name FROM Sales.SalesTerritory st
	   WHERE st.TerritoryID = sp.TerritoryID)Territory_name	,
SalesQuota,Bonus,SalesLastYear 
FROM Sales.SalesPerson sp;
	 

--- Display EMP name ,teritory name,group,SalesLastYear,Sales Quota,bonus from Germany and United Kingdom

SELECT
      (SELECT firstname FROM Person.Person pp
	   WHERE pp.BusinessEntityID = sp.BusinessEntityID) Emp_name,
	  (SELECT [Group] FROM Sales.SalesTerritory st
	   WHERE st.TerritoryID = sp.TerritoryID)Territory_group,
	  (SELECT name FROM Sales.SalesTerritory st
	   WHERE st.TerritoryID = sp.TerritoryID)Territory_name,	
SalesQuota,Bonus,SalesLastYear 
FROM Sales.SalesPerson sp
WHERE TerritoryID in
            (SELECT TerritoryID FROM Sales.SalesTerritory st
			WHERE Name = 'Germany' or Name = 'United Kingdom')


--- Find all employees who work in all North America Teritory

SELECT * FROM Sales.SalesTerritory   --- teri id, teri name, group, Sales last year
SELECT * FROM Sales.SalesPerson      --- Business id , teri id , sales quota, bonus, Sales last year
SELECT * FROM Person.Person          --- Business id, name

SELECT
      (SELECT firstname FROM Person.Person pp
	  WHERE pp.BusinessEntityID = sp.BusinessEntityID) Emp_name,
	  (SELECT [Group] FROM Sales.SalesTerritory st
	  WHERE st.TerritoryID = sp.TerritoryID) 
FROM Sales.SalesPerson sp
WHERE TerritoryID IN
	       (SELECT TerritoryID FROM Sales.SalesTerritory st
	       WHERE [Group] = 'North America') 


--- Find the product details in cart
--- Find the product with special offer
--- display product,sell start date, sell end date, minOrderQty and maxORDERQty

--- Find the product details in cart

SELECT * FROM Production.Product       --- productid , prod_name
SELECT * FROM Sales.ShoppingCartItem   -- Prod id

SELECT sc.*,
      (SELECT name FROM Production.Product pp
	   WHERE pp.ProductID = sc.ProductID)Product_name
FROM Sales.ShoppingCartItem sc

--- Find the product with special offer	

select * from sales.SpecialOffer               --- spe offer id, 
select * from Purchasing.ShipMethod            --- ship method id , name
select * from Purchasing.ProductVendor         --- prod id, business id, min orde qty, max order qyt
select * from Purchasing.PurchaseOrderDetail   --- 
select * from Production.Product
select * from Sales.SpecialOfferProduct

SELECT sp.*,
     (SELECT ProductID FROM Sales.SpecialOffer so
	 WHERE so.SpecialOfferID=sp.SpecialOfferID) special_offer_product
	 FROM Sales.SpecialOfferProduct sp
