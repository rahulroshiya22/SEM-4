----Database Name: Branch_DIV_Rollno (Example: CSE_3A_101 or Bsc_Hons_101)
----Note: Create all the tables under above database with design mode only.
----Table1: Artists (Artist_id (PK), Artist_name)
----Table2: Albums (Album_id(PK), Album_title, Artist_id(FK), Release_year)
----Table3: Songs (Song_id, Song_title, Duration (in minutes), Genre, Album_id(FK))

--Part – A

--1. Retrieve a unique genre of songs.
select distinct Genre
from Songs;

--2. Find top 2 albums released before 2010.
select top 2 Album_title
from Albums
where Release_year < 2010;

--3. Insert Data into the Songs Table. (1245, ‘Zaroor’, 2.55, ‘Feel good’, 1005)
insert into Songs values (1245, 'Zaroor', 2.55, 'Feel good', 1005);

--4. Change the Genre of the song ‘Zaroor’ to ‘Happy’
update Songs
set Genre ='Happy'
where Song_title = 'Zaroor';

--5. Delete an Artist ‘Ed Sheeran’
delete from Artists
where Artist_name = 'Ed Sheeran';

--6. Add a New Column for Rating in Songs Table. [Ratings decimal(3,2)]
Alter table Songs
add Ratings decimal(3, 2);

--7. Retrieve songs whose title starts with 'S'.
select Song_title
from Songs
where Song_title like 'S%';

--8. Retrieve all songs whose title contains 'Everybody'.
select Song_title
from Songs
where Song_title like '%Everybody%';

--9. Display Artist Name in Uppercase.
select upper(Artist_name)
from Artists;

--10. Find the Square Root of the Duration of a Song ‘Good Luck’
select sqrt(Duration)
from Songs
where Song_title = 'Good Luck';

--11. Find Current Date.
select GETDATE() as 'Current Date';

--12. Find the number of albums for each artist.
select ar.Artist_name, count(al.Album_title)
from Artists ar
join Albums al
on ar.Artist_id = al.Artist_id
group by ar.Artist_name;

--13. Retrieve the Album_id which has more than 5 songs in it.
select a.Album_id, count(s.Song_title)
from Albums a
join Songs s
on a.Album_id = s.Album_id
group by a.Album_id
having count(s.Song_title) > 5;

--14. Retrieve all songs from the album 'Album1'. (using Subquery)
select Song_title
from Songs
where Album_id in (select Album_id from Albums
				   where Album_title = 'Album1');

--15. Retrieve all albums name from the artist ‘Aparshakti Khurana’ (using Subquery)
select Album_title
from Albums
where Artist_id = (select Artist_id from Artists
				   where Artist_name = 'Aparshakti Khurana');

--16. Retrieve all the song titles with its album title.
select s.Song_title, a.Album_title
from Songs s
inner join Albums a
on s.Album_id = a.Album_id;

--17. Find all the songs which are released in 2020.
select Song_title
from Songs
where Album_id in (select Album_id from Albums
				   where Release_year = 2020);

--18. Create a view called ‘Fav_Songs’ from the songs table having songs with song_id 101-105.
create view Fav_Songs
as
select *
from Songs
where Song_id between 101 and 105;

--19. Update a song name to ‘Jannat’ of song having song_id 101 in Fav_Songs view.
update Fav_Songs
set Song_title = 'Jannat'
where Song_id = 101;

--20. Find all artists who have released an album in 2020.
select Artist_name
from Artists
where Artist_id in (select Artist_id from Albums
                    where Release_year = 2020);

--21. Retrieve all songs by Shreya Ghoshal and order them by duration. 
select s.Song_title, s.Duration
from Songs s
join Albums al
on s.Album_id = al.Album_id
join Artists ar
on al.Artist_id = ar.Artist_id
where ar.Artist_name = 'Shreya Ghoshal'
order by s.Duration;

--Part – B

--22. Retrieve all song titles by artists who have more than one album.
select ar.Artist_name, s.Song_title
from Artists ar
join Albums al
on ar.Artist_id = al.Artist_id
join Songs s
on al.Album_id = s.Album_id
where ar.Artist_id in (select Artist_id from Albums
					  group by Artist_id
					  having count(Album_title) > 1);

--23. Retrieve all albums along with the total number of songs.
select al.Album_title, count(s.Song_title)
from Albums al
join Songs s
on al.Album_id = s.Album_id
group by al.Album_title;

--24. Retrieve all songs and release year and sort them by release year.
select s.Song_title, a.Release_year
from Songs s
join Albums a
on s.Album_id = a.Album_id
order by a.Release_year;

--25. Retrieve the total number of songs for each genre, showing genres that have more than 2 songs.
select Genre, count(Song_title)
from Songs
group by Genre
having count(Song_title) > 2;

--26. List all artists who have albums that contain more than 3 songs.
select ar.Artist_name, al.Album_title, count(s.Song_title) as Songs
from Artists ar
join Albums al
on ar.Artist_id = al.Artist_id
join Songs s
on al.Album_id = s.Album_id
group by ar.Artist_name, al.Album_title
having count(s.Song_title) > 3;

--Part – C

--27. Retrieve albums that have been released in the same year as 'Album4'
select Album_title, Release_year
from Albums
where Album_title <> 'Album4'
and
Release_year = (select Release_year from Albums
   			    where Album_title = 'Album4');

--28. Find the longest song in each genre
select S.Genre, S.Song_title, S.Duration
from Songs S
where S.Duration = (
    select max(Duration)
    from Songs
    where Genre = S.Genre
);

--29. Retrieve the titles of songs released in albums that contain the word 'Album' in the title.
select s.Song_title
from Songs s
join Albums a
on s.Album_id = a.Album_id
where a.Album_title LIKE '%Album%';


--30. Retrieve the total duration of songs by each artist where total duration exceeds 15 minutes.
select ar.Artist_name, sum(s.Duration)
from Artists ar
join Albums al
on ar.Artist_id = al.Artist_id
join Songs s
on al.Album_id = s.Album_id
group by ar.Artist_name
having sum(s.Duration) > 15;