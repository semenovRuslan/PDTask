use [BookStore]
GO

--Load DATA to Table   [dbo].[BX-Users]
--sinhronise data [dbo].[BX-Users]
MERGE [dbo].[BX-Users] AS TARGET
USING [dbo].[BX-Users_STAGINGTABLE] AS SOURCE 
ON (TARGET.[User-ID] = SOURCE.[User-ID]) 
--update the records if there is any change
WHEN MATCHED AND TARGET.[Location] <> SOURCE.[Location] OR TARGET.[Age] <> SOURCE.[Age] 
THEN UPDATE SET TARGET.[Location] = SOURCE.[Location], TARGET.[Age] = SOURCE.[Age] 
--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT ([User-ID], [Location], [Age]) VALUES (SOURCE.[User-ID], SOURCE.[Location], SOURCE.[Age])
;
SELECT @@ROWCOUNT;
GO


--Insert data in DIMENSION which were absent in our system but we have FACT.
--Important moment save our data
insert into [dbo].[BX-Users]
([User-ID], [Location], [Age])
select [User-ID], 'unknown' as [Location] , NULL as [Age]
from [dbo].[BX-Book-Ratings_STAGINGTABLE]
where not exists(
select * from [dbo].[BX-Users] sub
where sub.[User-ID]=[dbo].[BX-Book-Ratings_STAGINGTABLE].[User-ID]
);
SELECT @@ROWCOUNT;
GO
