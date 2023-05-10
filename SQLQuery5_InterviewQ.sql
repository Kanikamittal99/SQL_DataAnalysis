

--NTH HIGHEST VALUE


--USING SUBQUERY

--only for 2nd highest salary
select MAX(salary) 
from Employee
where salary < ( select MAX(salary) from Employee)

--3rd highest/nth highest
select top 1 salary from	
(select distinct top 3 salary
from Employee
order by Salary desc)result
order by Salary asc	--flipping rows

--second highest product in each category
select * 
from  (select *,
		dense_rank() over(partition by product_category order by price desc) as [rank] 
		from product
		)as tab 
where tab.[rank]=2  

-- USING CTE
WITH Result as
(
	select Salary, DENSE_RANK() over(order by salary desc) DENSERANK
	from employee
)
select top 1 salary  --top: since getting 2 rows
from Result where 
result.DENSERANK = 2


---recursive CTE
--Empid of josh = 2, look for those records with managerid = 2, that's level = 2
