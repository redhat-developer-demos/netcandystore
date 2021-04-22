USE CandiesDB;
BULK INSERT dbo.Products FROM '/tmp/Products.csv' WITH (FORMAT='CSV',FIELDTERMINATOR=',',ROWTERMINATOR = '\r\n');
GO
SELECT Id, displayName FROM dbo.Products;
GO