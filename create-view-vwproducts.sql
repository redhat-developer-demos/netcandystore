USE CandiesDB;
GO
CREATE VIEW vwProducts
AS
SELECT 
    Products.Id                         as Id,
    Products.statusCodeId               as statusCodeId,
    Products.displayName                as displayName,
    Products.description                as [description],
    Products.itemPrice                  as itemPrice,
    Products.itemPackageType            as itemPackageType,
    Products.quantityPerPackage         as quantityPerPackage,
    Products.keywords                   as keywords,
    Products.imageURL                   as imageURL,
    Products.productCategoryId          as productCategoryId,
    StatusCodes.statusCodeDescription   as statusCodeDescription,
    ProductCategories.displayName       as ProductCategory 
FROM    
    Products
JOIN
    StatusCodes ON Products.statusCodeId = StatusCodes.Id 
JOIN
    ProductCategories ON Products.productCategoryId = ProductCategories.Id 
GO 