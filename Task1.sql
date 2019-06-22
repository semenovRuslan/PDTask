use [BookStore]
go

with cte_user as(
select [User-ID], 
countActivities = count(*)
from [dbo].[BX-Book-Ratings]
group by [User-ID])
select count(*) from cte_user ft
where countActivities=2

