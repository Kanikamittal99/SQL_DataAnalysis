
-- Using temp tables

--creating
select d.departmentName, COUNT(*) as TotalEmployees
into #TempEmployeeCount
from Employee e 
join Department d
on e.DepartmentId = d.Id
group by d.DepartmentName

--querying on temp table
select DepartmentName, totalEmployees 
from #TempEmployeeCount
where TotalEmployees > 2

drop table #TempEmployeeCount


---USING TABLE VARIABLE 


--Declaration
Declare @EmployeeCount table(DepartmentName nvarchar(50), DepartmentId int, TotalEmployees int)

--Insert table variable in query
insert @EmployeeCount
select d.departmentName, e.DepartmentId, COUNT(*) as TotalEmployees
from Employee e 
join Department d
on e.DepartmentId = d.Id
group by d.DepartmentName, e.DepartmentId

--querying the table using table variable formed
select DepartmentName, TotalEmployees
from @EmployeeCount
where TotalEmployees > 2


-- USING DERIVED TABLES

select DepartmentName, TotalEmployees
from (
		select d.departmentName, e.DepartmentId, COUNT(*) as TotalEmployees
		from Employee e 
		join Department d
		on e.DepartmentId = d.Id
		group by d.DepartmentName, e.DepartmentId
	) as EmployeeCount
where TotalEmployees > 2


--USING CTE

With EmployeeCount(DepartmentName, DepartmentId, TotalEmployees)  --Can use without params since using the same param name as query
as
(
		select d.departmentName, e.DepartmentId, COUNT(*) as TotalEmployees
		from Employee e 
		join Department d
		on e.DepartmentId = d.Id
		group by d.DepartmentName, e.DepartmentId	
)
select DepartmentName, TotalEmployees
from EmployeeCount
where TotalEmployees > 2


-- CTE join Table 

With EmployeeCount(DepId, Total)   --Cannot use without params since different name is referred to in below select query
as
(
	Select DepartmentId, COUNT(*) as TotalEmployees
	from Employee
	group by DepartmentId
)
Select DepartmentName, Total
from Department
join EmployeeCount
on Department.Id = EmployeeCount.DepId  --no column named deptId if params removed
order by Total



--- multiple CTE's using a single WITH clause
With EmployeesCountBy_Payroll_IT_Dept(DepartmentName, TotalEmployees)
as
(
 Select DepartmentName, COUNT(*) as TotalEmployees
 from Employee as e
 join Department as d
 on e.DepartmentId = d.Id
 where DepartmentName IN ('Payroll','IT')
 group by DepartmentName
),
EmployeesCountBy_HR_Other_Dept(DepartmentName, Total)
as
(
 Select DepartmentName, COUNT(*) as TotalEmployees
 from Employee
 join Department 
 on Employee.DepartmentId = Department.Id
 where DepartmentName IN ('HR','Other department')
 group by DepartmentName 
)
Select * from EmployeesCountBy_HR_Other_Dept 
UNION
Select * from EmployeesCountBy_Payroll_IT_Dept



---UPDATEABLE CTE


-- single base table, employee table gets updated
With Employees_Name_Gender
as
(
 Select Id, Name, Gender from Employee
)
Select * from Employees_Name_Gender
Update Employees_Name_Gender Set Gender = 'Female' where Id = 4



--CTE on 2 base tabbles, affecting only one base table  
With EmployeesByDepartment
as
(
 Select e.Id, Name, Gender, d.DepartmentName 
 from Employee as e
 join Department as d
 on D.Id = e.DepartmentId
)
Select * from EmployeesByDepartment
Update EmployeesByDepartment set Gender = 'Male' where Id = 4



--CTE on 2 base tabbles, affecting more than one base table  
--update not allowed
With EmployeesByDepartment
as
(
 Select e.Id, Name, Gender, d.DepartmentName 
 from Employee as e
 join Department as d
 on D.Id = e.DepartmentId
)
Update EmployeesByDepartment 
set Gender = 'Female', DepartmentName = 'IT'
where Id = 4


----CTE on 2 base tabbles, affecting only one base table  
--updates with Unexpected behavior
--changes other HR employees department to Other Department too
With EmployeesByDepartment
as
(
 Select e.Id, Name, Gender, d.DepartmentName 
 from Employee as e
 join Department as d
 on D.Id = e.DepartmentId
)
Update EmployeesByDepartment set 
DepartmentName = 'Other Department' where Id = 4	--Id 4 was HR employee

-- HR changes to Other dept in both tables
select * from Employee
select * from Department




---RECURSIVE CTE

--Output employeeName and managername
--Using left self join
select e.Name as employerName, ISNULL(m.name,'Super Boss') as ManagerName 
from EmployeeManager as e
left join EmployeeManager as m
on e.ManagerId = m.EmployeeId

--Another method : Recursive cte
--Ouput employee, manager as well as employee levels they are on 
With EmployeesCTE(EmployeeId, Name, ManagerId, [Level])
as
(
	select EmployeeId,name,ManagerId, 1			--setting level 1 on superboss(Josh, id=2)
	from EmployeeManager
	where ManagerId IS NULL

	union all
	
	select em.EmployeeId,em.name, em.ManagerID, ec.[level]+1
	from EmployeesCTE as ec
	join EmployeeManager as em
	on ec.employeeId = em.ManagerId		-- Tom, mike have managerId 2
)
--select * from EmployeesCTE
select empCTE.name as employee, isnull(mgrCTE.name,'SuperBoss') as manager, empCTE.[level]
from EmployeesCTE as empCTE
left join EmployeesCTE as mgrCTE			--withput left join, null managerid wont be included & that employee will be left out
on empCTE.ManagerId = mgrCTE.EmployeeId


--self join works? (join vs left join)
select e.*,m.*
from EmployeeManager e
left join EmployeeManager m
on e.ManagerId = m.EmployeeId


--Output employeeName , managername for the given employeeId and then their managerId all the way till we reach superBoss
--select * from EmployeeManager
Declare @ID int
Set @ID = 6;		-- using ; mandatory

With employeesCTE
as
(
	select EmployeeId, name,managerId 
	from EmployeeManager
	where EmployeeId = @id

	Union all 

	select em.EmployeeId, em.Name, em.ManagerId
	from EmployeeManager as em
	join employeesCTE as ec
	on ec.ManagerId = em.EmployeeId
)
--select * from employeesCTE
select empCTE.Name, mgrCTE.name
from employeesCTE as empCTE
left join employeesCTE as mgrCTE
on empCTE.ManagerId = mgrCTE.EmployeeId

