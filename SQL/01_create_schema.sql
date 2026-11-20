-- Creates the sales table with correct data types.
-- InvoiceNo is NVARCHAR because some invoices are non-numeric (e.g. A563185).
-- UnitPrice is DECIMAL(10,3) because a few prices are 0.001.
USE [UCI Retail ETL DB];
GO

DROP TABLE IF EXISTS dbo.retail_sales;
GO

CREATE TABLE dbo.retail_sales (
    SalesID      INT IDENTITY(1,1) PRIMARY KEY,
    InvoiceNo    NVARCHAR(20)  NOT NULL,
    StockCode    NVARCHAR(20)  NOT NULL,
    Description  NVARCHAR(100) NULL,
    Quantity     INT           NOT NULL,
    InvoiceDate  DATETIME2(0)  NOT NULL,
    UnitPrice    DECIMAL(10,3) NOT NULL,
    CustomerID   INT           NULL,
    Country      NVARCHAR(50)  NOT NULL,
    TotalSales   DECIMAL(12,3) NOT NULL
);
GO
