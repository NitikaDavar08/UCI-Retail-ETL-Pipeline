-- Loads the cleaned CSV into dbo.retail_sales via a staging table.
-- Copy the CSV to C:\temp first (SQL Server may not be able to read user folders).
-- ROWTERMINATOR is 0x0a because the CSV uses LF line endings.
USE [UCI Retail ETL DB];
GO

DROP TABLE IF EXISTS dbo.stg_retail;
GO

CREATE TABLE dbo.stg_retail (
    InvoiceNo NVARCHAR(50), StockCode NVARCHAR(50), Description NVARCHAR(255),
    Quantity NVARCHAR(50), InvoiceDate NVARCHAR(50), UnitPrice NVARCHAR(50),
    CustomerID NVARCHAR(50), Country NVARCHAR(100), TotalSales NVARCHAR(50)
);
GO

BULK INSERT dbo.stg_retail
FROM 'C:\temp\cleaned_online.pandas_retail.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);
GO

INSERT INTO dbo.retail_sales
    (InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country, TotalSales)
SELECT InvoiceNo, StockCode, Description,
       CAST(Quantity AS INT),
       CAST(InvoiceDate AS DATETIME2(0)),
       CAST(UnitPrice AS DECIMAL(10,3)),
       CAST(CAST(NULLIF(CustomerID, '') AS FLOAT) AS INT),
       Country,
       CAST(TotalSales AS DECIMAL(12,3))
FROM dbo.stg_retail;
GO

DROP TABLE dbo.stg_retail;
GO
