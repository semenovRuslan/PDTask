use [BookStore]
GO 
begin tran
--some rows can't be join because of error in key fields 

update [dbo].[BX-Book-Ratings_STAGINGTABLE] set [ISBN] = upper(ltrim(rtrim([ISBN])))
update [dbo].[BX-Books_STAGINGTABLE] set [ISBN] = upper(ltrim(rtrim([ISBN])))

update [dbo].[BX-Book-Ratings_STAGINGTABLE] set [ISBN] = replace([ISBN], '\"', '')
update [dbo].[BX-Book-Ratings_STAGINGTABLE] set [ISBN] = replace([ISBN], '\''', '')
commit 
go

--kill doubled row in dimension
begin tran

;with cte_dbl as (
		select sub.[ISBN], min(uuid) uuid
		from dbo.[BX-Books_STAGINGTABLE] sub
		group by sub.[ISBN]
		having count(*)>1
	)
delete
from dbo.[BX-Books_STAGINGTABLE]
where exists(
	select * from cte_dbl as ft
	where 
	 ft.[ISBN]=dbo.[BX-Books_STAGINGTABLE].[ISBN])
	and not exists(
	select * from cte_dbl as ft
	where 
	 ft.[ISBN]=dbo.[BX-Books_STAGINGTABLE].[ISBN]
	 and ft.uuid=dbo.[BX-Books_STAGINGTABLE].uuid
)
commit tran
go


--correct doubled row in fact
begin tran
; with cto_dbl as (
select [ISBN], [User-ID],
[Book-Rating] = avg([Book-Rating]) 
from dbo.[BX-Book-Ratings_STAGINGTABLE]  
group by  [ISBN],[User-ID]
having count(*)>1
)
update dbo.[BX-Book-Ratings_STAGINGTABLE]
set [Book-Rating] = (select [Book-Rating] from cto_dbl as sub
	where 
	 sub.[ISBN]=dbo.[BX-Book-Ratings_STAGINGTABLE].[ISBN]
	 and sub.[User-ID] = [BX-Book-Ratings_STAGINGTABLE].[User-ID])
from dbo.[BX-Book-Ratings_STAGINGTABLE]
where exists(
	select * from cto_dbl as ft
	where 
	 ft.[ISBN]=dbo.[BX-Book-Ratings_STAGINGTABLE].[ISBN]
	 and ft.[User-ID] = [BX-Book-Ratings_STAGINGTABLE].[User-ID]
)
GO

--delete doubled row in fact
; with cto_dbl as (
select [ISBN], [User-ID],
UUID = min(UUID) 
from dbo.[BX-Book-Ratings_STAGINGTABLE]  
group by  [ISBN],[User-ID]
having count(*)>1
)
delete from  dbo.[BX-Book-Ratings_STAGINGTABLE]
where 
exists(
	select * from cto_dbl as ft
	where 
	 ft.[ISBN]=dbo.[BX-Book-Ratings_STAGINGTABLE].[ISBN]
	 and ft.[User-ID] = [BX-Book-Ratings_STAGINGTABLE].[User-ID]
)
and not exists(
	select * from cto_dbl as ft
	where 
	 ft.[ISBN]=dbo.[BX-Book-Ratings_STAGINGTABLE].[ISBN]
	 and ft.[User-ID] = [BX-Book-Ratings_STAGINGTABLE].[User-ID]
	 and ft.UUID = [BX-Book-Ratings_STAGINGTABLE].UUID
)

--rollback
commit tran