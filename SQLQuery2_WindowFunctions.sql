

--RANK VS DENSE RANK VS ROW NUMBER

SELECT id,name,departmentid,salary,
RANK() over(partition by departmentid order by Salary desc) [rank],
DENSE_RANK() over(partition by departmentid order by Salary desc) denseRank,
ROW_NUMBER() over(partition by departmentid order by Salary desc) rowNum
from Employee

--Max salary employee from each dept
--cannot use rank or dense rank here. In case 1 is used twice for single dept id
select * from(
SELECT id,name,departmentid,salary,
row_number() over(partition by departmentid order by Salary desc) [rank]
from Employee) a
where [rank] = 1


---Max salary for ech gender
select * from(
select id,name,Gender,salary,
DENSE_RANK() over (partition by gender order by salary desc) denseRank
from Employee) al
where denseRank = 1


-- error: Column 'tblEmployee.emp_ID' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.
select emp_id,dept_name,MAX(salary) from tblEmployee
group by dept_name



-- USING AGGREGATE FUNCTIONS as WINDOW FUNCTIONS


-- Over() : sql creates 1 window for all the record, changes aggregate function to window functions
-- adds maxSalary column against each record
-- since no window created, default FRAME CLAUSE not used, hence no error 
select *,
MAX(salary) over() maxSalary
from tblEmployee

-- window over dept_name and applies function(max()) over each of the windows record
-- max salary for each department
select *,
MAX(salary) over(partition by dept_name) maxSalary
from tblEmployee

select AVG(salary) from tblemployee

--incorrect due to default FRAME CLAUSE in sql
select *,
avg(salary) over(order by salary) average,
count(salary) over(order by salary) [count],
max(salary) over(order by salary) [max]
from tblEmployee

--correct
select *,
avg(salary) over(partition by dept_name order by salary rows between unbounded preceding and unbounded following) average,
count(salary) over(partition by dept_name order by salary rows between unbounded preceding and unbounded following) [count],
max(salary) over(partition by dept_name order by salary rows between unbounded preceding and unbounded following) [max]
from tblEmployee

--first row count is 2 ; 1 row before curr row+ curr row+ 1 row after curr row; this happens for every partition
select *,
avg(salary) over(partition by dept_name order by salary rows between 1 preceding and 1 following) average,
count(salary) over(partition by dept_name order by salary rows between 1 preceding and 1 following) count_of_Rows_inFrame,
max(salary) over(partition by dept_name order by salary rows between 1 preceding and 1 following) [max]
from tblEmployee

-- to compute RUNNING TOTAL
--incorrect
select *,
SUM(salary) over(order by salary) runningTotal
from Employee

--CORRECT
select *,
SUM(salary) over(order by id) runningTotal
from Employee




--RANGE vs ROWS
-- duplicates as distinct in rows

-- calculate running total for each employee
select emp_name, salary,
SUM(salary) over(order by salary rows between unbounded preceding and current row) runningtotal_byRows,
SUM(salary) over(order by salary range between unbounded preceding and current row) runningtotal_byRange,
avg(salary) over(order by salary rows between unbounded preceding and current row) avgtotal_byRows,
avg(salary) over(order by salary range between unbounded preceding and current row) avgtotal_byRange,
count(salary) over(order by salary rows between unbounded preceding and current row) count_byRows,
count(salary) over(order by salary range between unbounded preceding and current row) count_byRange
from tblemployee






-- top 2 employees who joined company first from each dept
select * from(
select *,
ROW_NUMBER() over(partition by dept_name order by emp_id) rowNum
from tblEmployee) a
where a.rowNum < 3

-- fetch top 3 employees
-- error : Finance fetches 4 employees
select * from(
select *,
Rank() over(partition by dept_name order by salary) rowNum
from tblEmployee) a
where a.rowNum < 4



-- lead and lag


-- fetch a query to display if the salary of an employee is higher, lower or equal to the previous employee.
select *,
lag(salary) over(partition by dept_name order by emp_id) as prev_empl_sal,
case when salary > lag(salary) over(partition by dept_name order by emp_id) then 'Higher than previous employee'
     when salary < lag(salary) over(partition by dept_name order by emp_id) then 'Lower than previous employee'
	 when salary = lag(salary) over(partition by dept_name order by emp_id) then 'Same than previous employee' 
	 end sal_range
from tblemployee 

--lag: fetch previous record
-- lead: fetch next record
select *,
lag(salary) over(partition by dept_name order by emp_id) as prev_empl_sal,
lead(salary) over(partition by dept_name order by emp_id) as next_empl_sal
from tblEmployee

-- fetch 2 records prev to current; default: 0
select *,
lag(salary,2,0) over(partition by dept_name order by emp_id) as prev_empl_sal
from tblEmployee

--to find next highest salary for each employee. If highest, return same salary
select *,
LEAD(salary,1,salary) over(partition by dept_name order by salary) nextHighest
from tblEmployee




--FIRST_VALUE, LAST_VALUE, NTH_VALUE, NTILE, CUME_DIST and PERCENT_RANK.




-- FIRST_VALUE 
-- Write query to display the most expensive product under each category (corresponding to each record)
select *,
first_value(product_name) over(partition by product_category order by price desc) as most_exp_product
from product;



-- LAST_VALUE 
-- Write query to display the least expensive product under each category (corresponding to each record)
--incorrect: bec of default frame clause that SQL is using
select *,
last_value(product_name) over(partition by product_category order by price desc) as most_exp_product
from product;

--incorrect
--frame: subset of partition;earphone has 4 record so default frame clauses 4 frames
-- unbounded preceding-> from the very first row of partition consider all rows preceding the current row
-- range forms the frame, over which window function is applied
select *,
last_value(product_name) 
    over(partition by product_category order by price desc
        range between unbounded preceding and current row)			--default frame clause(used by sql)
    as least_exp_product    
from product


--CORRECT
--unbounded following : all rows after current row till end of partition
select *,
last_value(product_name) 
    over(partition by product_category order by price desc
        range between unbounded preceding and unbounded following)   
    least_exp_product    
from product


-- Alternate way to write SQL query using Window functions
-- to lessen the use of Over clause; repetitve code
select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product    
from product
WHERE product_category ='Phone'
window w as (partition by product_category order by price desc
            range between unbounded preceding and unbounded following)



--NTILE
select *,
NTILE(2) over(order by salary) as [Ntile]   --10%2 = 0 So each grp has 5 rows 
from Employee

select *,
NTILE(3) over(order by salary) as [Ntile]   
from Employee

select *,
NTILE(3) over(partition by gender order by salary) as [Ntile]   
from Employee




