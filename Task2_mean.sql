use [BookStore]

--Midle
;with cte_avgbook as(
select [ISBN]
, amount = convert(float, sum([Book-Rating]))
, cnt = convert(float, count(*))
from [dbo].[BX-Book-Ratings]
group by [ISBN]
),
cte_avgtotal as(
 select amount = convert(float, sum([Book-Rating]))
, cnt = convert(float, count(*))
from [dbo].[BX-Book-Ratings]
)

select ft.isbn, ft.amount/ft.cnt avgVal, [Book-Title] ,  total.amount/total.cnt avgTotal
from cte_avgbook  ft
left join cte_avgtotal total on (1=1)
left join [dbo].[BX-Books] dbook on (ft.[ISBN]=dbook.ISBN)
order by 2  desc