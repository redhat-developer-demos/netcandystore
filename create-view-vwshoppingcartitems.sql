USE CandiesDB;
GO
CREATE VIEW vwShoppingCartItems
AS
SELECT 
    t1.cartGUID,
    t1.Id,
    t1.productID,
    t1.productPrice,
    t1.quantity,
    t1.productPrice * t1.quantity AS LineItemTotal,
    t2.displayName,
    t2.description,
    t2.imageURL,
    t2.itemPackageType,
    t2.productCategoryId,
    t2.quantityPerPackage,
    t3.displayname AS ProductCategory
FROM    
    ShoppingCartItem AS t1
JOIN
    Products AS t2 ON t2.Id = productID 
JOIN
    ProductCategories AS t3 ON t2.productCategoryId = t3.Id 
GO 