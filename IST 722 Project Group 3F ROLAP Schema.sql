/****** Object:  Database ist722_hhkhan_cb3_dw    Script Date: 11/14/2020 10:19:42 AM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
USE ist722_hhkhan_cb3_dw

/* Drop table fudgemartflix.FactOrderFulfillment */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemartflix.FactOrderFulfillment') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemartflix.FactOrderFulfillment 
;

/* Drop table fudgemartflix.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemartflix.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemartflix.DimProduct 
;

/* Create table fudgemartflix.DimProduct */
CREATE TABLE fudgemartflix.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  varchar(20)   NOT NULL
,  [ProductName]  varchar(200)   NOT NULL
,  [ProductDepartment]  varchar(20)   NOT NULL
,  [ProductIsActive] varchar(3) DEFAULT 'N/A'  NOT NULL
,  [Mart_Or_Flix]  varchar(2)   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime DEFAULT '12/31/1899'  NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)
, CONSTRAINT [PK_fudgemartflix.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT fudgemartflix.DimProduct ON
;
INSERT INTO fudgemartflix.DimProduct (ProductKey, ProductID, ProductName, ProductDepartment, ProductIsActive, Mart_Or_Flix, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, '-1', 'None', 'None', 'NA', 'NA', 'Y', '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgemartflix.DimProduct OFF
;


/* Drop table fudgemartflix.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemartflix.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemartflix.DimCustomer 
;

/* Create table fudgemartflix.DimCustomer */
CREATE TABLE fudgemartflix.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  int   NOT NULL
,  [CustomerName]  varchar(101)   NOT NULL
,  [CustomerAddress]  varchar(1000)  DEFAULT 'None' NOT NULL
,  [CustomerCity]  varchar(50)   NULL
,  [CustomerZipcode]  varchar(20)   NULL
,  [CustomerState]  char(2)   NULL
,  [Mart_Or_Flix]  varchar(2)   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime DEFAULT '12/31/1899'  NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)
, CONSTRAINT [PK_fudgemartflix.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;
SET IDENTITY_INSERT fudgemartflix.DimCustomer ON
;
INSERT INTO fudgemartflix.DimCustomer (CustomerKey, CustomerID, CustomerName, CustomerAddress, CustomerCity, CustomerZipcode, CustomerState, Mart_Or_Flix, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'None', 'None', 'None', 'None', 'NA', 'NA', 'Y', '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT fudgemartflix.DimCustomer OFF
;

/* Drop table fudgemartflix.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'fudgemartflix.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE fudgemartflix.DimDate 
;

/* Create table fudgemartflix.DimDate */
CREATE TABLE fudgemartflix.DimDate (
   [DateKey] [int] NOT NULL,
	[Date] [datetime] NULL,
	[FullDateUSA] [nchar](11) NOT NULL,
	[DayOfWeek] [tinyint] NOT NULL,
	[DayName] [nchar](10) NOT NULL,
	[DayOfMonth] [tinyint] NOT NULL,
	[DayOfYear] [int] NOT NULL,
	[WeekOfYear] [tinyint] NOT NULL,
	[MonthName] [nchar](10) NOT NULL,
	[MonthOfYear] [tinyint] NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[QuarterName] [nchar](10) NOT NULL,
	[Year] [int] NOT NULL,
	[IsAWeekday] varchar(1) NOT NULL DEFAULT (('N')),
	constraint pkfudgemartflixDimDate PRIMARY KEY ([DateKey]))
;

INSERT INTO fudgemartflix.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsAWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;

/* Create table fudgemartflix.FactOrderFulfillment */
CREATE TABLE fudgemartflix.FactOrderFulfillment (
   [ProductKey]  int  NOT NULL
,  [CustomerKey]  int  NOT NULL
,  [OrderDateKey]  int  NOT NULL
,  [ShippedDateKey]  int  NOT NULL
,  [OrderID]  int   NOT NULL
,  [Mart_Or_Flix]  varchar(2)   NOT NULL
,  [OrderQty]  int   NOT NULL
,  [Rating]  int   NULL
,  [DeliveryDays]  int   NULL
, CONSTRAINT [PK_fudgemartflix.FactOrderFulfillment] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID], [Mart_Or_Flix] )
) ON [PRIMARY]
;


ALTER TABLE fudgemartflix.FactOrderFulfillment ADD CONSTRAINT
   FK_fudgemartflix_FactOrderFulfillment_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES fudgemartflix.DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgemartflix.FactOrderFulfillment ADD CONSTRAINT
   FK_fudgemartflix_FactOrderFulfillment_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES fudgemartflix.DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgemartflix.FactOrderFulfillment ADD CONSTRAINT
   FK_fudgemartflix_FactOrderFulfillment_OrderDateKey FOREIGN KEY
   (
   OrderDateKey
   ) REFERENCES fudgemartflix.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE fudgemartflix.FactOrderFulfillment ADD CONSTRAINT
   FK_fudgemartflix_FactOrderFulfillment_ShippedDateKey FOREIGN KEY
   (
   ShippedDateKey
   ) REFERENCES fudgemartflix.DimDate
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
