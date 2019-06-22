use [BookStore]

;with cte_boundBook as(
select 
[ISBN],
LowBound = min([Book-Rating]),
HightBound = max([Book-Rating])
from [dbo].[BX-Book-Ratings]
group by [ISBN]
),
cte_totalBoundBook as (
select LowBound = min([Book-Rating]),
HightBound = max([Book-Rating])
from [dbo].[BX-Book-Ratings]
)
select ft.* , ft.HightBound-ft.LowBound delta, db.[Book-Title], total.HightBound MaxEstimation, total.LowBound  MinEstimation
from cte_boundBook as ft
left join [dbo].[BX-Books] db on (ft.[ISBN]=db.[ISBN])
left join cte_totalBoundBook total on (1=1)

order by delta
;
go