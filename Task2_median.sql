use [BookStore]

--MEDIAN
;with cte_median as
(
SELECT distinct 
 [ISBN], 
--[Book-Rating],
Median = PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Book-Rating]) OVER (PARTITION BY [ISBN])  
FROM [dbo].[BX-Book-Ratings]
),
cte_median_total as
(
SELECT distinct
Median = PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Book-Rating]) OVER ()  
FROM [dbo].[BX-Book-Ratings]
)
select ft.[ISBN], ft.Median, total.Median MedianTotal, [Book-Title]
from cte_median ft
left join cte_median_total total on (1=1)
left join [dbo].[BX-Books] dbook on (ft.[ISBN]=dbook.ISBN)
order by 2 desc
