use [BookStore]

delete from  [dbo].[BX-Book-Ratings]

insert into [dbo].[BX-Book-Ratings]
([User-ID], [ISBN], [Book-Rating])
select duser.[User-ID], dbook.[ISBN], [Book-Rating]
from [dbo].[BX-Book-Ratings_STAGINGTABLE] ft
left join [dbo].[BX-Books] dbook on (ft.[ISBN]=dbook.[ISBN])
left join [dbo].[BX-Users] duser on (ft.[User-ID]=duser.[User-ID])
