--After

CREATE TABLE EMPLOYEEDETAILS
(
	EmployeeID Int Primary Key,
	EmployeeName Varchar(100) Not Null,
	ContactNo Varchar(100) Not Null,
	Department Varchar(100) Not Null,
	Salary Decimal(10,2) Not Null,
	JoiningDate DateTime Null
)

CREATE TABLE EmployeeLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
	EmployeeName VARCHAR(100) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
);

--1)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to display the message "Employee record inserted", "Employee record updated", "Employee record deleted"
--After Insert
create trigger tr_insert_EmpDetails
on EmployeeDetails
after insert
as
begin
	print 'Employee record inserted'
end;

drop trigger tr_insert_EmpDetails;

insert into EMPLOYEEDETAILS values(1, 'Dhairya', '8401710628', 'Computer', '300000', '2024-01-28');

--After Update
create trigger tr_update_EmpDetails
on EmployeeDetails
after update
as
begin
	print 'Employee record updated'
end;

drop trigger tr_update_EmpDetails;

update EMPLOYEEDETAILS
set Salary = '500000'
where EmployeeID = 1;

--After Delete
create trigger tr_delete_EmpDetails
on EmployeeDetails
after delete
as
begin
	print 'Employee record deleted'
end;

drop trigger tr_delete_EmpDetails;

delete from EMPLOYEEDETAILS
where EmployeeID = 1;

--2)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to log all operations into the EmployeeLog table.
--After Insert
create trigger tr_insert_log_EmpDetails
on EmployeeDetails
after insert
as
begin
	declare @eid int, @ename varchar(100)
	select @eid = EmployeeId, @ename = EmployeeName
	from inserted

	insert into EmployeeLogs values (@eid, @ename, 'inserted', GETDATE())
end;

drop trigger tr_insert_log_EmpDetails;

--After Update
create trigger tr_update_log_EmpDetails
on EmployeeDetails
after update
as
begin
	declare @eid int, @ename varchar(100)
	select @eid = EmployeeId, @ename = EmployeeName
	from inserted

	insert into EmployeeLogs values (@eid, @ename, 'updated', GETDATE())
end;

drop trigger tr_update_log_EmpDetails;

--After Delete
create trigger tr_delete_log_EmpDetails
on EmployeeDetails
after delete
as
begin
	declare @eid int, @ename varchar(100)
	select @eid = EmployeeId, @ename = EmployeeName
	from deleted

	insert into EmployeeLogs values (@eid, @ename, 'deleted', GETDATE())
end;

drop trigger tr_delete_log_EmpDetails;

--3)	Create a trigger that fires AFTER INSERT to automatically calculate the joining bonus (10% of the salary) for new employees and update a bonus column in the EmployeeDetails table.
create trigger tr_insert_bonus_EmpDetails
on EmployeeDetails
after insert
as
begin
	declare @eid int, @salary decimal(10, 2)

	select @eid = EmployeeId, @salary = Salary
	from inserted

	set @salary = @salary + @salary*0.1

	update EMPLOYEEDETAILS
	set Salary = @salary
	where EmployeeID = @eid
end;

drop trigger tr_insert_bonus_EmpDetails;

--4)	Create a trigger to ensure that the JoiningDate is automatically set to the current date if it is NULL during an INSERT operation.
CREATE TRIGGER tr_SetJoiningDate
ON EmployeeDetails
AFTER INSERT
AS
BEGIN
    UPDATE EMPLOYEEDETAILS
    SET JoiningDate = GETDATE()
    WHERE JoiningDate IS NULL AND EmployeeID IN (SELECT EmployeeID FROM Inserted);
END;

drop trigger tr_SetJoiningDate;

--5)	Create a trigger that ensure that ContactNo is valid during insert (Like ContactNo length is 10)
create trigger tr_valid_contact
on EmployeeDetails
after insert
as
begin
	declare @eid int, @contact varchar(100)

	select @eid = EmployeeId, @contact = ContactNo
	from inserted

	if LEN(@contact) <> 10
	begin
		print 'Invalid contact no'

		delete from EMPLOYEEDETAILS
		where EmployeeID = @eid
	end
end;

drop trigger tr_valid_contact;

--Instead Of

CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieTitle VARCHAR(255) NOT NULL,
    ReleaseYear INT NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Rating DECIMAL(3, 1) NOT NULL,
    Duration INT NOT NULL
);

CREATE TABLE MoviesLog
(
	LogID INT PRIMARY KEY IDENTITY(1,1),
	MovieID INT NOT NULL,
	MovieTitle VARCHAR(255) NOT NULL,
	ActionPerformed VARCHAR(100) NOT NULL,
	ActionDate	DATETIME  NOT NULL
);

--1.	Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the Movies table. For that, log all operations performed on the Movies table into MoviesLog.
--Insert
create trigger tr_insert_Movies
on Movies
instead of insert
as
begin
	declare @mid int, @mname varchar(255)

	select @mid = MovieId, @mname = MovieTitle
	from inserted

	insert into MoviesLog values (@mid, @mname, 'insert', GETDATE())
end;

drop trigger tr_insert_Movies;

--Update
create trigger tr_update_Movies
on Movies
instead of update
as
begin
	declare @mid int, @mname varchar(255)

	select @mid = MovieId, @mname = MovieTitle
	from inserted

	insert into MoviesLog values (@mid, @mname, 'update', GETDATE())
end;

drop trigger tr_update_Movies;

--Delete
create trigger tr_delete_Movies
on Movies
instead of delete
as
begin
	declare @mid int, @mname varchar(255)

	select @mid = MovieId, @mname = MovieTitle
	from deleted

	insert into MoviesLog values (@mid, @mname, 'delete', GETDATE())
end;

drop trigger tr_delete_Movies;

--2.	Create a trigger that only allows to insert movies for which Rating is greater than 5.5 .
create trigger tr_insert_basedOn_rating
on Movies
instead of insert
as
begin
	declare @mid int, @mtitle varchar(255), @releaseYear int, @genre varchar(100), @rating decimal(3, 1), @duration int

	select @mid = MovieID, @mtitle = MovieTitle, @releaseYear = ReleaseYear, @genre = Genre, @rating = Rating, @duration = Duration
	from inserted

	if @rating > 5.5
	begin
		insert into Movies values (@mid, @mtitle, @releaseYear, @genre, @rating, @duration)
	end
end;

drop trigger tr_insert_basedOn_rating;

--3.	Create trigger that prevent duplicate 'MovieTitle' of Movies table and log details of it in MoviesLog table.
CREATE TRIGGER PreventDuplicateMovieTitle
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @MovieTitle VARCHAR(255);
    DECLARE @MovieID INT;
    
    SELECT @MovieTitle = MovieTitle, @MovieID = MovieID FROM inserted;

    IF NOT EXISTS (SELECT 1 FROM Movies WHERE MovieTitle = @MovieTitle AND MovieID != @MovieID)
    BEGIN
        INSERT INTO Movies
        SELECT MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration FROM inserted;
    END
    ELSE
    BEGIN
        INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
        SELECT MovieID, MovieTitle, 'Duplicate MovieTitle Attempt', GETDATE() FROM inserted;
    END
END;

--4.	Create trigger that prevents to insert pre-release movies.
CREATE TRIGGER PreventPreReleaseMovies
ON Movies
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @ReleaseYear INT;
    
    SELECT @ReleaseYear = ReleaseYear FROM inserted;

    IF @ReleaseYear <= YEAR(GETDATE())
    BEGIN
        INSERT INTO Movies
        SELECT MovieID, MovieTitle, ReleaseYear, Genre, Rating, Duration FROM inserted;
    END
    ELSE
    BEGIN
        INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
        SELECT MovieID, MovieTitle, 'Pre-release Movie Attempt', GETDATE() FROM inserted;
    END
END;

--5.	Develop a trigger to ensure that the Duration of a movie cannot be updated to a value greater than 120 minutes (2 hours) to prevent unrealistic entries.
CREATE TRIGGER PreventDurationUpdateAbove120Minutes
ON Movies
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @NewDuration INT;
    DECLARE @MovieID INT;
    
    SELECT @NewDuration = Duration, @MovieID = MovieID FROM inserted;

    IF @NewDuration <= 120
    BEGIN
        UPDATE Movies
        SET MovieTitle = inserted.MovieTitle, ReleaseYear = inserted.ReleaseYear, Genre = inserted.Genre, Rating = inserted.Rating, Duration = inserted.Duration
        FROM inserted
        WHERE Movies.MovieID = inserted.MovieID;
    END
    ELSE
    BEGIN
        INSERT INTO MoviesLog (MovieID, MovieTitle, ActionPerformed, ActionDate)
        SELECT MovieID, MovieTitle, 'Duration Update Attempt > 120 Minutes', GETDATE() FROM inserted;
    END
END;