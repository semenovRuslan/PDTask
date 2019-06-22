use [BookStore]
go

;with cte_useractivities as(
select [User-ID], 
cnt= 1.000,
cntAll = count(*) over () ,
reslt = sum([Book-Rating]) 
from [dbo].[BX-Book-Ratings]
group by [User-ID]
), 
ctp_pareto as (
select
[User-ID],
sum(cnt) over (ORDER BY reslt desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)/cntAll [%users],
reslt, 
sum(reslt) over (ORDER BY reslt desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)/convert(numeric(20,8),sum(reslt) over()) activTotal
from cte_useractivities 
)
select f.*,duser.location, duser.age from ctp_pareto f
left join [dbo].[BX-Users] duser on (f.[User-ID]=duser.[User-ID])
where [%users]<=0.2
order by 3 desc 