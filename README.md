# Task
# Load data:

I started of by load data from site (BX-SQL-Dump.zip). I modifyed SQL Script for load data to my SQL Server.
1.	Create DataBase(Script1_DateBaseCreate.sql)
2.	I created Staging tables. We need this type of table, because sometimes data in source conflict with condition of task and we need to load data and after that work out them. 
3.	In this table we add additional field for identifying record,  and do not create indexes.
4.	I can’t  load data automatically because of special symbol which were in fields and wrong punctuality that’s why I created small utility which row  by row try to inserts data and shows which row consist errors for understanding reason of mistakes : (Project was added to folder UTILITY)
>RowsLoader.exe "D:\itog\data\BX-Books_Data.sql" - load data BX-Books

>RowsLoader.exe "D:\itog\data\BX-User_Data.sql" - load data BX-UsersData

>RowsLoader.exe "D:\itog\data\BX-Book-Ratings_Data.sql" - load data BX-Book-RatingsData

# Clear data 
(Script2_CleanData.sql):

We have a lot of mistakes in raw data which conflict with task’s conditions and human’s sense. I corrected these mistakes in script:
1.	Correct symbol in string Key Fields for opportunities to join
2.	Clear Doubled key in Dimensions
3.	Modify Doubled key in Fact(AVG in task’s case) 

# Load WH tables
(Script3_LoadDimensionBook.sql; Script4_LoadDimensionUsers.sql; Script5_LoadFactRating.sql)

This sort of tables  was made according to user’s requirements. When we use script to load this table we should 
1.	to update data which exists in our Dim table
2.	to insert New Data
Important case when dictionary don’t have information about Data in Fact table. We have to use template and load this data in Dimension. When data comes late we just update row (1 st case of our activities)

# Query Task 
(Task1.sql; Task2_mean.sql; Task2_median.sql; Task2_mode.sql; Task2_range.sql; Task3_pareto.sql ):

1.  How many users have made exactly 2 ratings?
Answer: 12502

2. Find the mean, median, mode, and range for number of ratings made for book (that's
actually 4 tasks :-)
total median answer: 0 
total mode answer: 0 
total mean answer: 2.86694747425375 
lower and upper range answer: 0, 10 

3 If you look for users and ratings, does Pareto principle hold?
Yes defenetelly 19,94 % users made 84,45% of all bals


#PS:
Backup for SQL Server 2017(BookSrore.bak) published in DBBackups folder (https://github.com/semenovRuslan/DBBackups)
