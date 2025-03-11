-- Create the Customers table
CREATE TABLE Customers (
 Customer_id INT PRIMARY KEY,
 Customer_Name VARCHAR(250) NOT NULL,
 Email VARCHAR(50) UNIQUE
);

-- Create the Orders table
CREATE TABLE Orders (
 Order_id INT PRIMARY KEY,
 Customer_id INT,
 Order_date DATE NOT NULL,
 FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id)
);

--From the above given tables perform the following queries:

--Part – A

--1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error.
begin try
	print 10/0
end try
begin catch
	print 'Error occurs that is - Divide by zero error'
end catch;

--2. Try to convert string to integer and handle the error using try…catch block.
begin try
	declare @num int
	set @num = cast('abc' as int)
end try
begin catch
	print 'Error: Unable to convert string to integer'
end catch;

--3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle
--exception with all error functions if any one enters string value in numbers otherwise print result.
create or alter procedure pr_sum
@s1 varchar(50), @s2 varchar(50)
as begin
	begin try
		declare @num1 int, @num2 int
		set @num1 = CAST(@s1 as int)
		set @num2 = CAST(@s2 as int)
		print @num1 + @num2
	end try
	begin catch
		print 'Error number: ' + cast(Error_Number() as varchar(100))
		print 'Error severity: ' + cast(Error_severity() as varchar(100))
		print 'Error state: ' + cast(Error_state() as varchar(100))
		print 'Error message' + cast(Error_message() as varchar(100))
	end catch
end;

pr_sum 20, 'abc';

--4. Handle a Primary Key Violation while inserting data into customers table and print the error details
--such as the error message, error number, severity, and state.
insert into Customers values (1, 'dhairya', 'dhairya@gmail.com');

begin try
	insert into Customers values (1, 'viraj', 'viraj@gmail.com')
end try
begin catch
	print 'Error number: ' + cast(Error_Number() as varchar(100))
	print 'Error severity: ' + cast(Error_severity() as varchar(100))
	print 'Error state: ' + cast(Error_state() as varchar(100))
	print 'Error message' + cast(Error_message() as varchar(100))
end catch;

--5. Throw custom exception using stored procedure which accepts Customer_id as input & that throws
--Error like no Customer_id is available in database.
create or alter procedure pr_check_custId
@cid int
as begin
	begin try
	if not exists (select 1 from Customers where Customer_id = @cid)
	begin
		throw 50001, 'Error: No Customer_id is available in database', 1;
	end
	else
	begin
		print 'Customer_id exists'
	end
	end try
	begin catch
	print Error_message()
end catch
end;

pr_check_custId 2

--Part – B

--6. Handle a Foreign Key Violation while inserting data into Orders table and print appropriate error
--message.
begin try
	insert into Orders values (1, 2, '2025-01-28')
end try
begin catch
	print 'Error number: ' + cast(Error_Number() as varchar(100))
	print 'Error severity: ' + cast(Error_severity() as varchar(100))
	print 'Error state: ' + cast(Error_state() as varchar(100))
	print 'Error message: ' + cast(Error_message() as varchar(100))
end catch;

--7. Throw custom exception that throws error if the data is invalid.
create or alter procedure pr_check_positive_negative
@num int
as begin
	if @num < 0
	begin
		throw 50002, 'Invalid data: Value cannot be negative', 1
	end
	else
	begin
		print 'Valid data'
	end
end;

pr_check_positive_negative -1

--8. Create a Procedure to Update Customer’s Email with Error Handling
create or alter procedure pr_update_email
@cid int, @email varchar(100)
as begin
	begin try
		update Customers
		set Email = @email
		where Customer_id = @cid
	end try
	begin catch
	print 'Error number: ' + cast(Error_Number() as varchar(100))
	print 'Error severity: ' + cast(Error_severity() as varchar(100))
	print 'Error state: ' + cast(Error_state() as varchar(100))
	print 'Error message: ' + cast(Error_message() as varchar(100))
end catch;
end;

--Part – C
--9. Create a procedure which prints the error message that “The Customer_id is already taken. Try another
--one”.
create or alter procedure pr_check_custId
@cid int
as begin
	begin try
	if exists (select 1 from Customers where Customer_id = @cid)
	begin
		throw 50001, 'Error: The Customer_id is already taken. Try another one.', 1;
	end
	else
	begin
		print 'Customer_id does not exists'
	end
	end try
	begin catch
	print Error_message()
end catch
end;

pr_check_custId 10

--10. Handle Duplicate Email Insertion in Customers Table.
	begin try
		insert into Customers values(5, 'viraj', 'dhairya@gmail.com')
	end try
	begin catch
	print 'Error number: ' + cast(Error_Number() as varchar(100))
	print 'Error severity: ' + cast(Error_severity() as varchar(100))
	print 'Error state: ' + cast(Error_state() as varchar(100))
	print 'Error message: ' + cast(Error_message() as varchar(100))
end catch;