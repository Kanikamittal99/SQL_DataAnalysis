CREATE database sample1

Alter database sample1 set single_user with Rollback immediate

drop database sample1

Use Sample1
GO

Create table Gender
(
ID INT NOT NULL Primary Key,
Gender nvarchar(50) not null
)

Create table Person
(
ID INT NOT NULL Primary Key,
Name nvarchar(20) not null,
Email nvarchar(20) not null,
GenderId nvarchar(50) null
)

--Change column datatype
Alter table Person
Alter column GenderId int

Alter table Person add constraint Person_GenderID_FK
Foreign Key (GenderID) references Gender (ID)

---Adding Default Constraint---
select * from Person
select * from Gender
insert into Person(ID, Name, Email) values(8, 'Rich','r@r.com')

insert into Gender(Id, Gender) values(3,'Unknown')

Alter table Person
Add Constraint DF_Person_GenderId
Default 3 for GenderID

insert into Person(ID, Name, Email) values(9, 'Mike','mike@m.com')
insert into Person(ID, Name, Email,GenderId) values(6, 'Sarah','sarah@s.com',NULL)

Alter table Person
Drop Constraint DF_Person_GenderId

Alter table Person
Add BloodGroup nvarchar(3) NULL
Constraint DF_Person_BloodGroup Default 'N/A'

insert into Person(ID, Name, Email,GenderId) values(4, 'Karan','karan@k.com',2)

---Cascading Referential Integrity---
Delete from Gender where ID = 1

Delete from Gender where ID = 3

Alter table Person 
drop constraint Person_GenderID_FK 

ALTER TABLE Person 
ADD CONSTRAINT Person_GenderID_FK 
FOREIGN KEY(GenderId)
REFERENCES Gender(ID)
ON DELETE set default

---Check Constraint---
select * from Person

Alter table Person
Add Age int null

Alter table Person 
Add constraint CK_Person_Age
check (Age > 0 AND Age <150)

insert into Person values(7, 'raman','raman@r.com',2,null, -970)

delete from Person where id = 7

insert into Person values(8, 'riya','riya@r.com',1,null, null)

---Identity Column---
select * from Person1

--Create new table
Create table Person1
(
PersonID int identity(1,1) Primary Key,
Name nvarchar(20) not null
)

--insert record
insert into Person1 values('Karan')
insert into Person1 values('Ram')

--delete record
delete from Person1 where PersonId =1

--insert record
insert into Person1 values('Sonia')

--Id 1 will never be used now.How to use that then?
--We have to turn IDENTITY_INSERT ON
insert into Person1(PersonId, Name) values(1,'Jai')

SET IDENTITY_INSERT Person1 OFF

--error
--Turn off identity_insert first
insert into Person1 values('kaya') 

--
Delete from Person1
insert into Person1 values('maya') 

---last generated identity column value---

create table test1
(
ID int identity(1,1),
Value nvarchar(20)
)
create table test2
(
ID int identity(1,1),
Value nvarchar(20)
)

select SCOPE_IDENTITY()
select @@IDENTITY
select IDENT_CURRENT('test2')

select * from test1
select * from test2
insert into test1 values('Z')

Create Trigger trForInsert ON test1 for Insert
as 
Begin
	Insert into test2 values('YYY')
END

--User 1
insert into test2 values ('ZZZ')



---Unique key constraint---
select * from Person

alter table Person
add constraint UK_Person_Email unique(Email)

--error , duplicate email
Insert into Person values(9,'shama','riya@r.com',2,null,22)

Alter table Person 
Drop constraint UK_Person_Email




---SELECT---
Alter table Person 
Drop constraint DF_Person_BloodGroup

Alter table Person 
drop column BloodGroup

Insert into Person(ID,name,email,GenderId, Age) values(10,'daren','daren@d.com',3,22)


Alter table Person
Add City nvarchar(50) null

Select distinct city from Person

select count(distinct city) from Person

select distinct name, City from Person

select * from Person where City = 'Japan'

--not equal
select * from Person where City <> 'Japan'
select * from Person where City != 'Japan'

select * from Person
select * from Person where age in (19,22,23,25)
select * from Person where age between 19 and 25

select * from Person where city like 'L%'
select * from Person where email not like '%@%'

select * from Person where name like '[MST]%'

select * from Person where name like '[^MST]%'

select * from Person 
where (city = 'London' OR city = 'Bali')
And age >20
order by name desc

select * from Person
order by name desc, age desc

select top 2 * from Person
select top 2 name,age from Person
--total 9 rows, displays 5 rows
select top 50 Percent * from Person

--to find eldest person. 
--to find highest salary
select top 1 * from Person order by age desc 

select top 2 * from Person

---Group By---
select * from Person

Alter table Person
Add Salary int 

select min(salary) from Person

--prints null city value too
select City,sum(Salary) as TotalSalary
from Person
group by City

select * from Person

--even if india male has 1 null value in slaary column, it still prints another rows value
select p.City, g.gender, count(p.id) as [Total Employees] ,sum(p.Salary) as TotalSalary
from Person as p join Gender as g
on p.genderId = g.ID
group by City, Gender
order by city


select p.City, g.gender, count(p.id) as [Total Employees] ,sum(p.Salary) as TotalSalary
from Person as p join Gender as g
on p.genderId = g.ID
where g.gender = 'male'
group by City, Gender
order by city

select p.City, g.gender, count(p.id) as [Total Employees] ,sum(p.Salary) as TotalSalary
from Person as p join Gender as g
on p.genderId = g.ID
group by City, Gender
having g.gender = 'male'
order by city

--error
select * from Person where sum(Salary) > 4000

--works fine
select City,sum(Salary) as TotalSalary
from Person
group by City
having sum(salary) > 4000

--JOINS---

Create table Employee
(
Id int primary key,
Name nvarchar(30),
Gender nvarchar(10), 
Salary int,
DepartmentId int,
constraint FK_Employee_DepartmentId
foreign key(DepartmentId) references Department(Id)
)

Create table Department
(
ID int primary key,
DepartmentName nvarchar(30),
Location nvarchar(20),
DepartmentHead nvarchar(20)
)

Select * from Department
Select * from Employee

insert into Department values(1,'IT','London','Rick')
insert into Department values(2,'Payroll','Delhi','Shaya')
insert into Department values(3,'Sales','New York','Gara')
insert into Department values(4,'Other Department','Sydney','Tamari')

insert into Employee values(1,'Tom','Male',4000,1)
insert into Employee values(2,'Maya','Female',3000,2)
insert into Employee(id,name,gender,salary) values(3,'Raya','Female',7000)
--insert into Employee values(3,'Raya','Female',7000,null)
insert into Employee values(4,'Kiara','Female',2000,3)
insert into Employee values(5,'Shriyansh','Male',8000,1)
insert into Employee values(6,'Nobita','Male',10000,4)

select e.name, e.gender,e.salary, d.departmentName
from Employee as e inner join Department as d
on e.DepartmentId = d.Id

select e.name, e.gender,e.salary, d.departmentName
from Employee as e left join Department as d
on e.DepartmentId = d.Id

select e.name, e.gender,e.salary, d.departmentName
from Employee as e RIGHT join Department as d
on e.DepartmentId = d.Id

select name, gender,salary, departmentName
from Employee as e FULL OUTER join Department as d
on e.DepartmentId = d.Id

select e.name, e.gender,e.salary, d.departmentName
from Employee as e cross join Department as d


--update a row
Update Employee
Set DepartmentId = 2
where Id = 6

select * from Department
select * from Employee

-- fetch non matching rows from left table
select e.name, e.gender,e.salary, d.departmentName
from Employee as e left outer join Department as d
on e.DepartmentId = d.Id
where d.Id is null

-- same using "except"
select e.name, e.gender,e.salary, d.departmentName
from Employee as e left join Department as d
on e.DepartmentId = d.Id 
except
select e.name, e.gender,e.salary, d.departmentName
from Employee as e inner join Department as d
on e.DepartmentId = d.Id


-- fetch non matching rows from right table
-- those rows whose existence is present in right table but not in left table
select e.name, e.gender,e.salary, d.departmentName
from Employee as e right outer join Department as d
on e.DepartmentId = d.Id
where e.departmentId is null

-- fetch non matching rows from both table
select e.name, e.gender,e.salary, d.departmentName
from Employee as e full outer join Department as d
on e.DepartmentId = d.Id
where e.departmentId is null or d.ID is null

---SELF JOIN---
Create table EmployeeManager
(
EmployeeId int primary key,
Name nvarchar(20),
ManagerId int 
)

select * from EmployeeManager

insert into EmployeeManager values(1,'Mike',3)
insert into EmployeeManager values(2,'Ricky',1)
insert into EmployeeManager values(3,'Gara',NULL)
insert into EmployeeManager values(4,'Sonia',1)

--shows all employees, even with no managers
select e.name as Employee, m.name as Manager
from EmployeeManager as e left join EmployeeManager as m
on e.ManagerId = m.EmployeeId

--shows all employees and managers, even with no manager,employee 
select e.name as Employee, m.name as Manager
from EmployeeManager as e full join EmployeeManager as m
on e.ManagerId = m.EmployeeId

--If we want to print NO manager if manager is null 
select e.name as Employee, ISNULL(m.name,123456789) as Manager
from EmployeeManager as e left join EmployeeManager as m
on e.ManagerId = m.EmployeeId

--checkes if first expression is NULL, if yes, return 2nd parameter
select ISNULL(NULL,'No Manager') as Manager
select ISNULL('Kanika','No Manager')

--Coaleasce(): returns first non-null value
select COALESCE(NULL,'No Manager') as Manager

select e.name as Employee, COALESCE(m.name,'No manager') as Manager
from EmployeeManager as e left join EmployeeManager as m
on e.ManagerId = m.EmployeeId

-- second value is limited acc. to first's length
declare @test varchar(3)  
select isnull(@test, 'ABCD') AS ISNULLResult  
select coalesce(@test, 'ABCD') AS coalesceResult  

--CASE
--CASE WHEN Expression THEN '' ELSE '' END
select e.name as Employee, Case when m.name IS NULL THEN 'No manager' ELSE m.name END as Manager
from EmployeeManager as e left join EmployeeManager as m
on e.ManagerId = m.EmployeeId

--rename table name
exec sp_rename 'tblDepartment', 'Department' 

select * from Department

CREATE PROCEDURE spGetEmployeeDepartment
as 
BEGIN
	select e.name, d.departmentName
	from Employee as e join Department as d
	on e.departmentID = d.ID
	Order by d.departmentName
END

--run stored procedure
spGetEmployeeDepartment
exec spGetEmployeeDepartment
execute spGetEmployeeDepartment

select * from Employee

Create Proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
as
BEGIN
	select name, Gender, departmentID from Employee
	where Gender = @Gender and DepartmentId = @DepartmentId
END

-- procedure expects parameters now
spGetEmployeesByGenderAndDepartment 'Male',1

-- 1 can be converted to nvarchar, no problem. But nvarchar (male) cannot be converted to int
spGetEmployeesByGenderAndDepartment 1, 'Male'

--specifying parameters
spGetEmployeesByGenderAndDepartment @departmentId=1, @Gender='Male'

--to check the implementation of stored procedure
sp_helptext spGetEmployeeDepartment

--alter procedure
Alter Procedure spGetEmployeesByGenderAndDepartment 
@Gender nvarchar(50),
@DepartmentId int
as
Begin
	select name, Gender, departmentID from Employee
	where Gender = @Gender and DepartmentId = @DepartmentId
	order by name
End

--to delete
drop proc spGetEmployeeDepartment

--encrypt
Alter Procedure spGetEmployeesByGenderAndDepartment 
@Gender nvarchar(50),
@DepartmentId int
with Encryption
as
Begin
	select name, Gender, departmentID from Employee
	where Gender = @Gender and DepartmentId = @DepartmentId
	order by name
End

--doesnot show contents now
sp_helptext spGetEmployeesByGenderAndDepartment


--- GET DEPARTMENT NAME BY Employee NAME
create procedure spGetDepartmentByName
@name nvarchar(20),
@departmentName nvarchar(10) output
AS
BEGIN
	select @departmentName=d.DepartmentName
	from Employee as e join Department as d
	on e.DepartmentId = d.ID
	where name = @name
END

declare @department nvarchar(10)
exec spGetDepartmentByName 'Tom', @department output
print @department

drop proc spGetDepartmentByName

-- to initializa output parameter
Create Procedure spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
AS
BEGIN
	Select @EmployeeCount = Count(Id) from Employee
	where gender = @gender
END


-- Create variable, to hold the output parameter value
Declare @EmployeeTotal int
--run SP
execute spGetEmployeeCountByGender 'Male', @EmployeeTotal Output
Print @EmployeeTotal

--Without out parameter
Declare @EmployeeTotal int
execute spGetEmployeeCountByGender 'Male', @EmployeeTotal
if(@EmployeeTotal IS NULL)
PRINT('TOTAL COUNT IS NULL')
else
Print @EmployeeTotal

--Order of params doesn't matter if you specify variable
Declare @EmployeeTotal int
execute spGetEmployeeCountByGender  @EmployeeCount = @EmployeeTotal out, @gender = 'male' 
Print @EmployeeTotal

--System stored
sp_help Employee
sp_depends spGetEmployeeCountByGender

--Before deleting a table, check dependencies
sp_Depends Employee


--- stored procedure output params VS return values---
Create Proc spGetTotalCountOfEmployees
@TotalCount int out
AS
BEGIN
	select @TotalCount = Count(Id) from Employee
END

Declare @TotalEmployees int
Exec spGetTotalCountOfEmployees @TotalEmployees out
print @TotalEmployees

--using return values
Create Proc spGetTotalCountOfEmployees1
AS
BEGIN
	return(select Count(Id) from Employee)
END

Declare @TotalEmployees int
Exec @TotalEmployees = spGetTotalCountOfEmployees1
print @TotalEmployees

--Here, output params can be used but return values not 
Create Procedure spGetNameById1
@ID int,
@name nvarchar(20) out
as 
begin
	select @name = name from Employee
	where id = @id
END

Declare @EmployeeName nvarchar(20)
Execute spGetNameById1 1, @EmployeeName out
Print 'Name = ' + @EmployeeName

--using return
--error : Conversion failed when converting the nvarchar value 'Tom' to data type int.
--Value of return value should always be integer, here its nvarchar.
Create Procedure spGetNameById2
@ID int
as 
begin
	return(select name from Employee
	where id = @id)
END

Declare @EmployeeName nvarchar(20)
Execute @EmployeeName = spGetNameById2 1
Print 'Name = ' + @EmployeeName



---STRING FUNCTIONS---
--ascii: gives ascii of first character
select ASCII('A')
--same as above
select ASCII('ABC')

--To print A to Z
Declare @start int
Set @start = 65
While (@start <= 90)
BEGIN
	Print char(@start)
	Set @start = @start + 1
END

select Ltrim('   Hello')
select len(' Four     ') as [total characters]

select left('Hello',3)
select right('Hello',3)

--to find index of @ in 'sara@aaa.com'
--start location is optional
select CHARINDEX('@','sara@aaa.com',1)

-- to fetch domain of email
select SUBSTRING('sara@aaa.com',CHARINDEX('@','sara@aaa.com',1)+1
,len('sara@aaa.com')-CHARINDEX('@','sara@aaa.com',1))

select * from employee

-- To fetch email domain and Count of them
select SUBSTRING(email,(CHARINDEX('@',email,1)+1)
,len(email)-CHARINDEX('@',email,1)) as EmailDomain, 
count(email) as Total
from employee
group by SUBSTRING(email,(CHARINDEX('@',email,1)+1)
,len(email)-CHARINDEX('@',email,1))

--Replicate
select REPLICATE('Kanika ',3)

-- mask email with * using replicate
select substring('sara@aaa.com',1,2)+ REPLICATE('*',5) + substring('sara@aaa.com',CHARINDEX('@','sara@aaa.com',1),len('sara@aaa.com')-CHARINDEX('@','sara@aaa.com',1)+1)

--select space function
select 'Hello'+space(5)+'Kanika'

--patindex, pattern index, if pattern not found it returns zero
-- Flexibility of using wild cards; cannot use wildcards in charindex
select email, patindex('%@aaa.com',Email) as FirstOcurrence
from employee
where patindex('%@aaa.com',Email) > 0

---replace
select email, replace(email,'.com','.net') as convertedEmail
from employee

--DateTime functions
Create table tblDateTime
(
c_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from tblDateTime
-- current system date time from where sql server is installed
-- if SSMS is somewhere else and SQL server some where else, it gets date time from where sql server is
select GETDATE()
select CURRENT_TIMESTAMP
select SYSDATETIME()
select SYSDATETIMEOFFSET()
select GETUTCDATE()
select SYSUTCDATETIME()

insert into tblDateTime values(GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())

update tblDateTime 
set c_datetimeoffset = '2023-01-05 00:26:51.0766667 +10:00'
where c_datetimeoffset= '2023-01-05 00:26:51.0766667 +00:00'

Select ISDATE('kanika') -- returns 0
Select ISDATE(Getdate()) -- returns 1
Select ISDATE('2012-08-31 21:02:04.167') -- returns 1

Select ISDATE('2012-09-01 11:34:21.1918447') -- returns 0.

Select DAY(GETDATE()) -- Returns the day number of the month, based on current system datetime.
Select DAY('01-05-2023') -- Returns 5, mm-dd-yyyy, CORRECT
Select DAY('2023-01-05') -- Returns 5, yyyy-mm-dd, CORRECT
Select DAY('2023-05-01') -- Returns 1, yyyy-dd-mm, WRONG
Select DAY('05-01-2023') -- Returns 1, dd-mm-yyyy, WRONG

Select DATENAME(Day, '2012-09-30 12:43:46.837') -- Returns 30
Select DATENAME(WEEKDAY, '2012-09-30 12:43:46.837') -- Returns Sunday
Select DATENAME(Month, '2023-01-05 00:26:51.0766667 +10:00') -- Returns January

Select datepart(WEEKDAY, '2012-09-30 12:43:46.837') -- Returns 1
Select datepart(Month, '2023-01-05 00:26:51.0766667 +10:00') -- Returns 1

select DATEADD(day,20,'2023-01-05 00:26:51.076')
select DATEADD(day,-2,'2023-01-05 00:26:51.076')

-- SHORTCOMING OF DATEDIFF()
select DATEDIFF(week,'2023-01-05','2023-01-15') --incorrect, sun to sat consists of 1 week
select DATEDIFF(year,'2022-11-05','2023-01-05') -- incorrect, nov > jan
select DATEDIFF(year,'2022-02-05','2024-03-05') -- incorrect, nov > jan

select DATEDIFF(month,'2022-11-15','2022-12-01') --incorrect

-- logic for age calculation
select datediff(year,'2022/07/30','2023/01/30') -- returns 1, incorrect, july > Jan
select datediff(year,'2022/01/30','2023/03/30') --return 1, correct, Jan < March



-- Calculate age
CREATE FUNCTION fnComputeAge(@DOB datetime)
RETURNS nvarchar(50) 
AS
BEGIN

DECLARE @tempdate datetime, @years int, @months int, @days int
--set @DOB = '07/30/1999'
set @tempdate = @dob

set @years = DATEDIFF(year, @tempdate, GETDATE()) - 
			CASE
			WHEN (month(@tempdate) > month(GETDATE())) OR
			month(@tempdate) = month(GETDATE()) AND day(@tempdate) > day(GETDATE())
			THEN 1 ELSE 0
			END

SET @tempdate = DATEADD(year, @years, @tempdate)

SET @months = DATEDIFF(MONTH, @tempdate, getdate()) - 
			  CASE
			  WHEN (day(@tempdate) > day(GETDATE()))
			  THEN 1 ELSE 0
			  END
SET @tempdate = DATEADD(month, @months, @tempdate)

select @days = DATEDIFF(day, @tempdate, getdate())

-- copying data in new variable to print as char in single column
DECLARE @age nvarchar(50)
set @age = CAST(@years as nvarchar(4)) + ' years ' + CAST(@months as nvarchar(2))+ ' months ' + CAST(@days as nvarchar(2)) + ' days old'
Return @age
--select @years as years, @months as months, @days as days

END

--run func
select dbo.fnComputeAge('1999/07/30')

-- Select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age from tblEmployees

-----------------------------------------------------------------------------------------
---CAST AND CONVERT
CREATE TABLE Registrations
(Id int not null, 
Name nvarchar(10),
RegisteredDate datetime
)

insert into Registrations values(1,'John',2022-08-24)
-- update a record
update Registrations set RegisteredDate = '2022-07-29 10:15:04.543' where id = 1

insert into Registrations values(3,'Sia','2022-07-28 07:05:14.543')
insert into Registrations values(4,'Raya','2022-07-29 10:10:56.842')
insert into Registrations values(5,'Maya','2022-07-29 10:10:56.544')
insert into Registrations values(6,'Priya','2022-07-30 00:10:56.982')

select * from Registrations

-- To fetch the total number of registrations per day
select cast(RegisteredDate as date) as RegisteredDate, 
count(id) as TotalRegistrations
from Registrations
group by cast(RegisteredDate as date) 

-- MATHEMATICAL
select abs(2-3)

select rand()  --new number everytime only bw 0 & 1

select floor(rand() * 100) --whole nos bw 1 & 100
select floor(rand() * 1000)f

declare @counter int
Set @counter = 1
While(@counter <= 10)
BEGIN
	Print FLOOR(rand() * 100)
	Set @counter = @counter + 1
END

-- Round to 2 places after (to the right) the decimal point
Select ROUND(850.556, 2) -- Returns 850.560

-- Truncate anything after 2 places, after (to the right) the decimal point
Select ROUND(850.556, 2, 1) -- Returns 850.550

-- Round to 1 place after (to the right) the decimal point
Select ROUND(850.556, 1) -- Returns 850.600

-- Truncate anything after 1 place, after (to the right) the decimal point
Select ROUND(850.556, 1, 1) -- Returns 850.500

-- Round the last 2 places before (to the left) the decimal point
Select ROUND(850.556, -2) -- 900.000

-- Round the last 1 place before (to the left) the decimal point
Select ROUND(850.556, -1) -- 850.000

-- LOCAL TEMPORARY TABLE
Create Table #PersonDetails(Id int, Name nvarchar(20))

Insert into #PersonDetails Values(1, 'Mike')
Insert into #PersonDetails Values(2, 'John')
Insert into #PersonDetails Values(3, 'Todd')

Select * from #PersonDetails

-- to check if local temp table is created
Select name from tempdb..sysobjects 
where name like '#PersonDetails%'

-- Temp table can only be accessed inside stored procedure if it is created inside one.
Create Procedure spCreateLocalTempTable
as
Begin
Create Table #PersonDetails(Id int, Name nvarchar(20))
Insert into #PersonDetails Values(1, 'Mike')
Insert into #PersonDetails Values(2, 'John')
Insert into #PersonDetails Values(3, 'Todd')
Select * from #PersonDetails
End

-- Can execute
spCreateLocalTempTable

-- throws error : Invalid object name '#PersonDetails'.
Select * from #PersonDetails




-- GLOBAL TEMPORARY TABLE
Create Table ##EmployeeDetails(Id int, Name nvarchar(20))

Insert into ##EmployeeDetails Values(1, 'Mike')
Insert into ##EmployeeDetails Values(2, 'John')
Insert into ##EmployeeDetails Values(3, 'Todd')

Select * from ##EmployeeDetails




-- INDEXES
create index IX_Employee_Salary
on Employee(Salary asc)

-- to find index created on Employee table
SP_hELPINDEX Employee

drop index Employee. IX_Employee_Salary   -- mention table name too


-- CLUSTERED INDEX
sp_helpindex Employee --one indx is automatically created when pk is created.

--COMPOSIE CLUSTERED INDEX
--throws error since pk is using 1 index already and maximum 1 index per table can be made.
-- drop pk index first
Create clustered index IX_Employee_Gender_Salary
on Employee (Gender desc, Salary asc)

--still error
drop index Employee.PK__tblEmplo__3214EC27748AE380

select * from Employee  --we get indexed data now

--NON CLUSTERED INDEX
Create nonclustered index IX_Employee_Name
on Employee (Name)

select * from Employee --we do not get indexed data now, NCI doesnot affect actual data table

-- UNIQUE INDEX
Create Unique NonClustered Index UIX_tblEmployee_FirstName_LastName
On tblEmployee(FirstName, LastName)

ALTER TABLE Employee 
ADD CONSTRAINT UQ_Employee_Email
UNIQUE Clustered(email)

--drop
ALTER TABLE Employee 
drop CONSTRAINT UQ_Employee_Email

