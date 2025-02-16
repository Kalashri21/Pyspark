use AdventureWorks2022 ;

--- A. Find first 20 employee who joined very early in company

SELECT * FROM HumanResources.Employee  
SELECT * FROM Person.Person

SELECT top 20 e.BusinessEntityID,p.FirstName,e.HireDate
FROM HumanResources.Employee as e,
Person.Person as p
WHERE e.BusinessEntityID = p.BusinessEntityID
ORDER BY HireDate ;


--- B. Find all employees name, job Title, card details whose credit card expired in the month 
--- 9 and year as 2009

SELECT * FROM HumanResources.Employee    --- Business id, job title
SELECT * FROM Person.Person              --- Business id, firstname
SELECT * FROM Sales.CreditCard           --- credit card id, exp month
SELECT * FROM Sales.PersonCreditCard     --- Business id, creditcard id

SELECT 
     e.BusinessEntityID,
     p.FirstName,
	 e.JobTitle,
	 cc.ExpMonth     
FROM HumanResources.Employee as e,
Person.Person as p,
Sales.CreditCard as cc,
Sales.PersonCreditCard as pc
WHERE e.BusinessEntityID = p.BusinessEntityID
and p.BusinessEntityID = pc.BusinessEntityID
and cc.CreditCardID = pc.CreditCardID
and cc.ExpMonth = 9 and cc.ExpMonth = 2009 ;


--- c.Find the store address and contact number based on table store and Business entity
--- check if any other table required

SELECT * FROM Sales.Store;
SELECT * FROM Person.PersonPhone;
SELECT * FROM Person.BusinessEntityAddress;

SELECT s.BusinessEntityID,s.name,p.PhoneNumber,a.AddressID
FROM Sales.Store as s,
Person.PersonPhone as p,
Person.BusinessEntityAddress as a
WHERE s.BusinessEntityID = p.BusinessEntityID
and p.BusinessEntityID = a.BusinessEntityID


--- D. Check if any employee from job candidate table having any payment revision

SELECT * FROM HumanResources.JobCandidate;
SELECT * FROM HumanResources.EmployeePayHistory;

SELECT * FROM HumanResources.EmployeePayHistory as eph
WHERE eph.BusinessEntityID in 
(SELECT jc.BusinessEntityID FROM HumanResources.JobCandidate jc
WHERE jc.BusinessEntityID is not null)


--- E. Check colour wise standard cost

SELECT p.color,
       sum(p.StandardCost) color_wise_std_cost
FROM Production.Product p
WHERE p.color is not NULL
GROUP BY p.Color;

--- F. Which Product is purchase more

select * from Purchasing.PurchaseOrderDetail

select top 1 pod.ProductID,p.Name,
       sum(pod.OrderQty) purchase_count
from Purchasing.PurchaseOrderDetail pod,
Production.Product p
where pod.ProductID=p.ProductID
group by p.Name,pod.ProductID
order by sum(pod.OrderQty) desc


--- G. Find the total values for line total product having maximum order

SELECT * FROM Production.Product
SELECT * FROM Purchasing.PurchaseOrderDetail

SELECT p.ProductLine,
	   sum(pd.OrderQty) maximum_order
FROM Production.Product as p,
Purchasing.PurchaseOrderDetail as pd
WHERE p.ProductID = pd.ProductID
and p.ProductLine is not null
GROUP BY p.ProductLine
ORDER BY sum(pd.OrderQty) DESC ;


--- H. Which product is the oldest product as on the date (refer  the product sell start date

select ProductID,Name,SellStartDate 
from Production.Product
order by SellStartDate;


--- I. Find all the employees whose salary is more than the average salary

SELECT * FROM HumanResources.Employee              -- business entity
SELECT * FROM HumanResources.EmployeePayHistory    -- business entity , rate

SELECT e.BusinessEntityID,
       eph.rate,
       avg(eph.Rate) over() avg_rate
FROM HumanResources.Employee as e,
HumanResources.EmployeePayHistory as eph
WHERE e.BusinessEntityID = eph.BusinessEntityID
GROUP BY e.BusinessEntityID,eph.rate
	
select * from 
	(select eph.BusinessEntityID,eph.Rate,
	avg(eph.Rate) over() avg_rate,
	rank() over(partition by eph.BusinessEntityID order by eph.Rate desc) _rank
	from HumanResources.EmployeePayHistory eph) t
	where t.Rate>t.avg_rate 
	and t._rank=1


--- J. Display country region code, group average sales quota based on territory id 

SELECT * FROM Sales.SalesTerritory              --- country region code,territory id,group
SELECT * FROM Sales.SalesPerson                 --- sales quota, business id, teritory id

SELECT Distinct st.[Group],st.CountryRegionCode,sp.TerritoryID,
       avg(sp.Salesquota) OVER (partition by st.territoryID)avg_sales_quota_based_on_territory_id
FROM Sales.SalesTerritory as st,
Sales.SalesPerson as sp
WHERE st.TerritoryID = sp.TerritoryID


--- K. Find the average age of male and female

SELECT * FROM HumanResources.Employee

SELECT e.Gender,
	   avg(DATEDIFF(year,e.BirthDate,GETDATE())) avg_age
	   FROM HumanResources.Employee e
	   GROUP BY e.Gender


--- L. which product is purchased more?(purchase order details)

SELECT * FROM Purchasing.PurchaseOrderDetail
SELECT * FROM Production.Product

SELECT top 1 po.ProductID,
       p.name,
       sum(OrderQty) Qty_of_product
FROM Purchasing.PurchaseOrderDetail as po,
Production.Product as p
WHERE po.ProductID = po.ProductID
GROUP BY po.ProductID,p.Name
ORDER BY sum(OrderQty) DESC;


---M) check for sales person details which are working in stores(find the sales person id)

SELECT * FROM Sales.SalesPerson
SELECT * FROM Sales.Store
SELECT * FROM Person.Person

SELECT distinct s.[Name],p.FirstName
FROM sales.Store as s,
Sales.SalesPerson as sp,
Person.Person as p
WHERE s.SalesPersonID=sp.BusinessEntityID
and p.BusinessEntityID = sp.BusinessEntityID


---N)display the product name and product price and count of product cost revised (productcosthistory)

SELECT * FROM Production.ProductCostHistory
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductListPriceHistory;
SELECT * FROM Production.TransactionHistory;

SELECT p.Name,th.ActualCost,count(pc.ProductID) 
FROM Production.ProductCostHistory as pc,
Production.Product as p,
Production.ProductListPriceHistory as ph,
Production.TransactionHistory as th
WHERE pc.ProductID = p.ProductID
and p.ProductID = ph.ProductID
and ph.ProductID = th.ProductID
GROUP BY p.Name,th.ActualCost
HAVING count(pc.ProductID) > 1 ; 


---O)check the department having more salary revision

SELECT * FROM HumanResources.EmployeePayHistory;
SELECT * FROM HumanResources.EmployeeDepartmentHistory;
SELECT * FROM HumanResources.Department;

SELECT d.DepartmentID,d.GroupName,count(eph.BusinessEntityID)
FROM HumanResources.EmployeePayHistory as eph,
HumanResources.EmployeeDepartmentHistory as edh,
HumanResources.Department as d
WHERE eph.BusinessEntityID = edh.BusinessEntityID
and edh.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentID,d.GroupName
HAVING count(eph.BusinessEntityID) > 1
ORDER BY count(eph.BusinessEntityID) DESC ;





