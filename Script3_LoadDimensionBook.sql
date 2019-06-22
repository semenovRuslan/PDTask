--Load DATA to Table   [dbo].[BX-Users]
--sinhronise data [dbo].[BX-Users]
MERGE [dbo].[BX-Books] AS TARGET
USING [dbo].[BX-Books_STAGINGTABLE] AS SOURCE 
ON (TARGET.[ISBN] = SOURCE.[ISBN]) 
--update the records if there is any change
WHEN MATCHED AND TARGET.[Book-Title] <> SOURCE.[Book-Title] OR TARGET.[Book-Author] <> SOURCE.[Book-Author]  OR TARGET.[Year-Of-Publication] <> SOURCE.[Year-Of-Publication]  OR TARGET.[Publisher] <> SOURCE.[Publisher]  OR TARGET.[Image-URL-S] <> SOURCE.[Image-URL-S]  OR TARGET.[Image-URL-M] <> SOURCE.[Image-URL-M]  OR TARGET.[Image-URL-L] <> SOURCE.[Image-URL-L]
THEN UPDATE SET TARGET.[Book-Title] = SOURCE.[Book-Title], TARGET.[Book-Author] = SOURCE.[Book-Author] , TARGET.[Year-Of-Publication] = SOURCE.[Year-Of-Publication] , TARGET.[Publisher] = SOURCE.[Publisher] , TARGET.[Image-URL-S] = SOURCE.[Image-URL-S] , TARGET.[Image-URL-M] = SOURCE.[Image-URL-M] , TARGET.[Image-URL-L] = SOURCE.[Image-URL-L] 
--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT ([ISBN], [Book-Title], [Book-Author], [Year-Of-Publication], [Publisher], [Image-URL-S], [Image-URL-M], [Image-URL-L]) 
VALUES (SOURCE.[ISBN], SOURCE.[Book-Title], SOURCE.[Book-Author],SOURCE.[Year-Of-Publication], SOURCE.[Publisher], SOURCE.[Image-URL-S], SOURCE.[Image-URL-M], SOURCE.[Image-URL-L])
;
SELECT @@ROWCOUNT;
GO

--Insert data in DIMENSION which were absent in our system but we have FACT.
--Important moment save our data
insert into [dbo].[BX-Books]
([ISBN], [Book-Title], [Book-Author], [Year-Of-Publication], [Publisher], [Image-URL-S], [Image-URL-M], [Image-URL-L])
select [ISBN], 'unknown #' + [ISBN] as [Book-Title] , 'unknown' as [Book-Author] , null as [Year-Of-Publication] , 'unknown' as [Publisher] , 'unknown' as [Image-URL-S], 'unknown' as [Image-URL-M], 'unknown' as [Image-URL-L]
from [dbo].[BX-Book-Ratings_STAGINGTABLE]
where not exists(
select * from [dbo].[BX-Books] sub
where sub.[ISBN]=[dbo].[BX-Book-Ratings_STAGINGTABLE].[ISBN]
)
group by [ISBN];
SELECT @@ROWCOUNT;
GO
