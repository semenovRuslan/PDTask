USE [master]
GO

CREATE DATABASE [BookStore]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BookStore', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\BookStore.mdf' )
 LOG ON 
( NAME = N'BookStore_log', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\BookStore_log.ldf')
GO

USE [BookStore]
GO

--CREATE STAGING TABLE WHERE WE CAN MANIPULATE WITH DATA:
--BX-Books
DROP TABLE IF EXISTS [BX-Books_STAGINGTABLE]
CREATE TABLE [BX-Books_STAGINGTABLE] (
  ISBN varchar(13) NOT NULL default '',
  "Book-Title" varchar(400) default NULL,
  "Book-Author" varchar(255) default NULL,
  "Year-Of-Publication" int  default NULL,
  "Publisher" varchar(255) default NULL,
  "Image-URL-S" varchar(255)  default NULL,
 "Image-URL-M" varchar(255)  default NULL,
  "Image-URL-L" varchar(255)  default NULL,
   uuid int NOT NULL IDENTITY (1, 1)			--This field need us for avoiding doubling data
);
GO
--Users 
DROP TABLE IF EXISTS [BX-Users_STAGINGTABLE]
CREATE TABLE [BX-Users_STAGINGTABLE](
  "User-ID" int NOT NULL default 0,
  "Location" varchar(250) default NULL,
  "Age" int default NULL,
) ;
GO

--Rating fact
DROP TABLE IF EXISTS [BX-Book-Ratings_STAGINGTABLE]
CREATE TABLE [BX-Book-Ratings_STAGINGTABLE] (
  "User-ID" int NOT NULL default '0',
  "ISBN" varchar(20) NOT NULL default '',  --made grater size acording to errors during loading data
  "Book-Rating" int  NOT NULL default '0',
  uuid int NOT NULL IDENTITY (1, 1)			--This field need us for avoiding doubling data
);
GO


--CREATING Warehous tables acording to users requrements
--DimBooks
DROP TABLE IF EXISTS [BX-Books]
CREATE TABLE [dbo].[BX-Books](
	[ISBN] [varchar](13) NOT NULL,
	[Book-Title] [varchar](400) NULL,
	[Book-Author] [varchar](255) NULL,
	[Year-Of-Publication] [int] NULL,
	[Publisher] [varchar](255) NULL,
	[Image-URL-S] [varchar](255) NULL,
	[Image-URL-M] [varchar](255) NULL,
	[Image-URL-L] [varchar](255) NULL,
 CONSTRAINT [PK_BX-Books] PRIMARY KEY CLUSTERED 
(
	[ISBN] ASC
));
GO
--DimUsers
DROP TABLE IF EXISTS [dbo].[BX-Users]
CREATE TABLE [dbo].[BX-Users](
	[User-ID] [int] NOT NULL,
	[Location] [varchar](250) NULL,
	[Age] [int] NULL,
 CONSTRAINT [PK_BX-Users] PRIMARY KEY CLUSTERED 
(
	[User-ID] ASC
));
GO
--FactRating
DROP TABLE IF EXISTS [dbo].[BX-Book-Ratings]
CREATE TABLE [dbo].[BX-Book-Ratings](
	[User-ID] [int] NOT NULL,
	[ISBN] [varchar](13) NOT NULL,
	[Book-Rating] [int] NOT NULL,
 CONSTRAINT [PK_BX-Book-Ratings] PRIMARY KEY CLUSTERED 
(
	[User-ID] ASC,
	[ISBN] ASC
)) 
GO
