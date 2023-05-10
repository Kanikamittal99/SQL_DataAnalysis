-- VIEWS
select * from Employee

create view vWEmployeesData as
(
Select e.Id, e.Name, e.Gender, DepartmentId, email
from Employee e
)

drop view vWEmployeesData

--can update since referring to single table
update vWEmployeesData
set Name='Karen' where ID=2

select * from Employee
--can update since referring to single table
Delete from vWEmployeesData where Id = 2
Insert into vWEmployeesData values (2, 'Mikey', 'Male',2,'mikey@m.com') --cannot give salary since not pr in view

sp_helptext vWEmployeesData


-- JOIN IN VIEWS

create view vWEmployeesByDepartment as
(
Select e.Id, e.Name, e.Salary, e.Gender, d.DepartmentName
from Employee e
join Department d
on e.DepartmentId = d.Id
)

select * from vWEmployeesByDepartment

-- Changes other records with HR dept to 'Other Department' also
-- incorrect, since updates underlying table dept & employee too [russell record changed]
update vWEmployeesByDepartment
set DepartmentName = 'Other Department' where Name='Sara'

-- data changed here too
select * from Department
select * from Employee

--cannot update
Delete from vWEmployeesByDepartment where Id = 2




--  INDEXED VIEWS

select * from tblProduct
select * from tblProductSales

Create view vWTotalSalesByProduct
With SchemaBinding
as
(
select Name,
SUM(ISNULL((QuantitySold * UnitPrice),0)) as TotalSales,
COUNT_BIG(*) as TotalTransactions
from dbo.tblProductSales
join dbo.tblProduct 
on tblProduct.ProductId = tblProductSales.ProductId
group by Name
)

select * from vWTotalSalesByProduct

--create index on view
Create Unique Clustered Index UIX_vWTotalSalesByProduct_Name
on vWTotalSalesByProduct(Name)

