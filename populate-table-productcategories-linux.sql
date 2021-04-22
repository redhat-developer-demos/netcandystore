USE CandiesDB;
BULK INSERT dbo.ProductCategories FROM '/tmp/ProductCategories.csv' WITH (FORMAT='CSV',FIELDTERMINATOR=',',ROWTERMINATOR = '\n',KEEPIDENTITY);
GO
SELECT * FROM dbo.ProductCategories;
GO