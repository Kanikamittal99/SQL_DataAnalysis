create table emp_compensation (
emp_id int,
salary_component_type varchar(20),
val int
);
insert into emp_compensation
values (1,'salary',10000),(1,'bonus',5000),(1,'hike_percent',10)
, (2,'salary',15000),(2,'bonus',7000),(2,'hike_percent',8)
, (3,'salary',12000),(3,'bonus',6000),(3,'hike_percent',7);
select * from emp_compensation;

-- PIVOTING DATA

-- multiple null values are created, wastes too much space.
 select emp_id,
  CASE WHEN salary_component_type = 'salary' Then val end as Salary,
  CASE WHEN salary_component_type = 'bonus' Then val end as Bonus,
  CASE WHEN salary_component_type = 'hike_percent' Then val end as Hike
 from emp_compensation

-- CASE with sum()
-- Saving as new Pivoted table
  select emp_id,
  sum(CASE WHEN salary_component_type = 'salary' Then val end) as Salary,
  sum(CASE WHEN salary_component_type = 'bonus' Then val end) as Bonus,
  sum(CASE WHEN salary_component_type = 'hike_percent' Then val end) as Hike
  into emp_compensation_pivot
 from emp_compensation
 group by emp_id


 select * from emp_compensation;
select * from emp_compensation_pivot

-- UNPIVOTING

-- sets Salary  as column name by default
-- should give same alias to all entries
select emp_id, 'salary' as salary_component_type, Salary as val from emp_compensation_pivot
union
select emp_id, 'bonus' as salary_component_type, Bonus as val from emp_compensation_pivot
union
select emp_id, 'hike_percent' as salary_component_type, Hike as val from emp_compensation_pivot
--order by val	--hike won't work