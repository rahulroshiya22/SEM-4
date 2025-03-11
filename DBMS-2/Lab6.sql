-- Create the Products table

CREATE TABLE Products (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);

-- Insert data into the Products table

INSERT INTO Products (Product_id, Product_Name, Price) VALUES
(1, 'Smartphone', 35000),
(2, 'Laptop', 65000),
(3, 'Headphones', 5500),
(4, 'Television', 85000),
(5, 'Gaming Console', 32000);

--From the above given tables perform the following queries: 

--Part - A

--1. Create a cursor Product_Cursor to fetch all the rows from a products table.
declare @pid int, @pname varchar(250), @price decimal(10, 2);

declare Product_Cursor cursor
for select * from Products;

open Product_Cursor;

fetch next from Product_Cursor
into @pid, @pname, @price;

while @@FETCH_STATUS = 0
begin
	select @pid, @pname, @price

	fetch next from Product_Cursor
	into @pid, @pname, @price
end;

close Product_Cursor;

deallocate Product_Cursor;

--2. Create a cursor Product_Cursor_Fetch to fetch the records in form of ProductID_ProductName.
--(Example: 1_Smartphone)
declare @pid int, @pname varchar(250);

declare Product_Cursor_Fetch cursor
for select Product_id, Product_Name
	from Products;

open Product_Cursor_Fetch;

fetch next from Product_Cursor_Fetch
into @pid, @pname;

while @@FETCH_STATUS = 0
begin
	print cast(@pid as varchar) + '_' + @pname

	fetch next from Product_Cursor_Fetch
	into @pid, @pname;
end;

close Product_Cursor_Fetch;

deallocate Product_Cursor_Fetch;

--3. Create a Cursor to Find and Display Products Above Price 30,000.
declare @pid int, @pname varchar(250), @price decimal(10, 2);

declare Price_Above_30000 cursor
for select * from Products
	where Price > 30000;

open Price_Above_30000;

fetch next from Price_Above_30000
into @pid, @pname, @price;

while @@FETCH_STATUS = 0
begin
	select @pid, @pname, @price

	fetch next from Price_Above_30000
	into @pid, @pname, @price
end;

close Price_Above_30000;

deallocate Price_Above_30000;

--4. Create a cursor Product_CursorDelete that deletes all the data from the Products table.
declare @pid int;

declare Product_CursorDelete cursor
for select Product_id
	from Products;

open Product_CursorDelete;

fetch next from Product_CursorDelete
into @pid;

while @@FETCH_STATUS = 0
begin
	delete from Products
	where Product_id = @pid

	fetch next from Product_CursorDelete
	into @pid
end;

close Product_CursorDelete;

deallocate Product_CursorDelete;

--Part – B

--5. Create a cursor Product_CursorUpdate that retrieves all the data from the products table and increases
--the price by 10%.
declare @pid int;

declare Product_CursorUpdate cursor
for select Product_id
	from Products;

open Product_CursorUpdate;

fetch next from Product_CursorUpdate
into @pid;

while @@FETCH_STATUS = 0
begin
	update Products
	set Price = Price + Price*0.1
	where Product_id = @pid;

	fetch next from Product_CursorUpdate
	into @pid
end;

close Product_CursorUpdate;

deallocate Product_CursorUpdate;

--6. Create a Cursor to Rounds the price of each product to the nearest whole number.
declare @pid int;

declare Product_CursorRoundPrice cursor
for select Product_id from Products;

open Product_CursorRoundPrice;

fetch next from Product_CursorRoundPrice
into @pid;

while @@FETCH_STATUS = 0
begin
	update Products
	set Price = ROUND(price, 0)
	where Product_id = @pid

	fetch next from Product_CursorRoundPrice
	into @pid
end;

close Product_CursorRoundPrice;

deallocate Product_CursorRoundPrice;

--Part – C

--7. Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop” 
--(Note: Create NewProducts table first with same fields as Products table)
CREATE TABLE NewProducts (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);

declare @pid int, @pname varchar(250), @price decimal(10, 2);

declare Insert_Into_NewProducts cursor
for select * from Products
	where Product_Name = 'Laptop';

open Insert_Into_NewProducts;

fetch next from Insert_Into_NewProducts
into @pid, @pname, @price;

while @@FETCH_STATUS = 0
begin
	insert into NewProducts values (@pid, @pname, @price)

	fetch next from Insert_Into_NewProducts
	into @pid, @pname, @price
end;

close Insert_Into_NewProducts;

deallocate Insert_Into_NewProducts;

--8. Create a Cursor to Archive High-Price Products in a New Table (ArchivedProducts), Moves products 
--with a price above 50000 to an archive table, removing them from the original Products table.
CREATE TABLE ArchivedProducts (
 Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
);

declare @pid int, @pname varchar(250), @price decimal(10, 2);

declare Insert_Into_ArchivedProducts cursor
for select * from Products
	where Price > 50000;

open Insert_Into_ArchivedProducts;

fetch next from Insert_Into_ArchivedProducts
into @pid, @pname, @price;

while @@FETCH_STATUS = 0
begin
	insert into ArchivedProducts values (@pid, @pname, @price)
	
	delete from Products
	where Product_id = @pid

	fetch next from Insert_Into_ArchivedProducts
	into @pid, @pname, @price
end;

close Insert_Into_ArchivedProducts;

deallocate Insert_Into_ArchivedProducts;