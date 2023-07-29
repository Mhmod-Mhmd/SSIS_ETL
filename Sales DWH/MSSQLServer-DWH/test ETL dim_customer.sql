use AdventureWorks2014
go


select CustomerID as customer_id , PersonID
from sales.Customer
where PersonID is not null 
union all
select null , null 

select p.BusinessEntityID  as personid, 
		cast(isnull(FirstName , ' ')+' '+isnull(MiddleName, ' ')+' '+isnull(LastName, ' ')
		as nvarchar(150))as customer_name, 
		a.AddressLine1 as address1, a.AddressLine2 as address2 , a.City ,
        ph.PhoneNumber as phone 
from Person.Person p left join person.BusinessEntityAddress ba
on p.BusinessEntityID=ba.BusinessEntityID and ba.AddressTypeID = 2 
inner join Person.Address as a 
on a.AddressID = ba.AddressID
left join person.PersonPhone ph
on ph.BusinessEntityID = p.BusinessEntityID


use Salescase
go 
select count(*) from dim_customer



delete from dim_customer