--Note: for Table valued function use tables of Lab-2

--Part – A

--1. Write a function to print "hello world".
create or alter function FN_HELLO_WORLD()
returns varchar(50)
as
begin
	return 'Hello World'
end;

select dbo.FN_HELLO_WORLD();

--2. Write a function which returns addition of two numbers.
create or alter function FN_ADDITION(@num1 int, @num2 int)
returns int
as
begin
	return @num1 + @num2
end;

select dbo.FN_ADDITION(2, 3);

--3. Write a function to check whether the given number is ODD or EVEN.
create or alter function FN_ODD_EVEN(@num int)
returns varchar(10)
as
begin
	if(@num%2 = 0)
		return 'even'
	else
		return 'odd'
	return ''
end;

select dbo.FN_ODD_EVEN(3);

--4. Write a function which returns a table with details of a person whose first name starts with B.
create or alter function FN_PERSON_FIRSTNAME_STARTWITH_B()
returns table
as
return (select * from Person
		where FirstName like 'B%');

select * from FN_PERSON_FIRSTNAME_STARTWITH_B();

--5. Write a function which returns a table with unique first names from the person table.
create or alter function FN_UNIQUE_NAMES()
returns table
as
return (select distinct FirstName from Person);

select * from FN_UNIQUE_NAMES();

--6. Write a function to print number from 1 to N. (Using while loop)
create or alter function FN_1TON(@n int)
returns varchar(1000)
as
begin
	declare @res varchar(1000), @i int
	set @i = 1
	set @res = ''
	while(@i <= @n)
	begin
		set @res = @res + CAST(@i as varchar) + ' '
		set @i = @i + 1
	end
	return @res
end;

select dbo.FN_1TON(10);

--7. Write a function to find the factorial of a given integer.
create or alter function FN_FACTORIAL(@n int)
returns int
as
begin
	declare @res int, @i int
	set @res = 1
	set @i = 1
	while(@i <= @n)
	begin
		set @res = @res * @i
		set @i = @i + 1
	end
	return @res
end;

select dbo.FN_FACTORIAL(4);

--Part – B

--8. Write a function to compare two integers and return the comparison result. (Using Case statement)
CREATE FUNCTION FN_COMPARE_INTEGERS(
    @Int1 INT,
    @Int2 INT
)
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN 
    (
        CASE
            WHEN @Int1 > @Int2 THEN 'First number is greater'
            WHEN @Int1 < @Int2 THEN 'Second number is greater'
            ELSE 'Both numbers are equal'
        END
    );
END;

select dbo.FN_COMPARE_INTEGERS(5, 10);

--9. Write a function to print the sum of even numbers between 1 to 20.
create or alter function FN_EVEN_NUMBERS_FROM_1TO20()
returns varchar(1000)
as
begin
	declare @res varchar(1000), @i int
	set @res = ''
	set @i = 1
	while(@i <= 20)
	begin
		if(@i%2 = 0)
			set @res = @res + cast(@i as varchar) + ' '
		set @i = @i + 1
	end;
	return @res
end;

select dbo.FN_EVEN_NUMBERS_FROM_1TO20();

--10. Write a function that checks if a given string is a palindrome
create or alter function FN_PALINDROME(@str varchar(100))
returns varchar(50)
as
begin
	if(@str = REVERSE(@str))
		return 'Palindrome'
	return 'Not Palindrome'
end;

select dbo.FN_PALINDROME('abc');

--Part – C

--11. Write a function to check whether a given number is prime or not.
create or alter function FN_PRIME(@n int)
returns varchar(20)
as
begin
	declare @i int
	set @i = 2
	while(@i <= @n/2)
	begin
		if(@n%@i = 0)
			return 'Not Prime'
		set @i = @i + 1
	end;
	if(@n = 1)
		return 'Not Prime'
	return 'Prime'
end;

select dbo.FN_PRIME(182);

--12. Write a function which accepts two parameters start date & end date, and returns a difference in days.
create or alter function FN_DIFF_IN_DAYS(@start date, @end date)
returns int
as
begin
	return datediff(DAY, @start, @end)
end;

select dbo.FN_DIFF_IN_DAYS('01-15-1990', '01-20-1990');

--13. Write a function which accepts two parameters year & month in integer and returns total days each 
--year.
create or alter function FN_GET_TOTAL_DAYS(
    @Year int,
    @Month int
)
returns int
as
begin
    declare @TotalDays int;
    set @TotalDays = DAY(EOMONTH(CONCAT(@Year, '-', @Month, '-01')));
    return @TotalDays;
end;

select dbo.FN_GET_TOTAL_DAYS(2024, 2);

--14. Write a function which accepts departmentID as a parameter & returns a detail of the persons.
create or alter function FN_DETAILS_ON_DEPTID(@deptId int)
returns table
as
return (select * from Person
		where DepartmentID = @deptId);

select * from FN_DETAILS_ON_DEPTID(1);

--15. Write a function that returns a table with details of all persons who joined after 1-1-1991.
create or alter function FN_DETAILS_ON_DATE()
returns table
as
return (select * from Person
		where JoiningDate > '1-1-1991');

select * from FN_DETAILS_ON_DATE();