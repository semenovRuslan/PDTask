use [BookStore]

--Mode
;with cte_count as(
select [ISBN]
, [Book-Rating]
, cntUsers = count(*)
from [dbo].[BX-Book-Ratings]
group by [ISBN], [Book-Rating]
),
 cte_modeBook as (
select [ISBN], [Book-Rating], cntUsers
, rank() over (partition by [ISBN] order by cntUsers desc) place
from cte_count
),
 cte_allRating as (
 select 
  [Book-Rating]
, cntUsers = count(*)
from [dbo].[BX-Book-Ratings]
group by [Book-Rating]
 ),
 cte_modeTotal as (
 select 
  [Book-Rating]
, rank() over (order by cntUsers desc) place
from cte_allRating
 )
select ft.[ISBN], ft.[Book-Rating], ft.cntUsers, [Book-Title], mtotal.[Book-Rating] totalMode
from cte_modeBook  ft
left join cte_modeTotal mtotal on (mtotal.place=1)
left join [dbo].[BX-Books] dbook on (ft.[ISBN]=dbook.ISBN)
where 
ft.place=1
order by 2 desc, 3 desc
