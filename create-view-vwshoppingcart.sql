USE CandiesDB;
GO

CREATE VIEW [vwShoppingCart]
AS
SELECT  ShoppingCart.cartGUID, 
        ShoppingCart.cartStatus, 
        ShoppingCart.buyerName, 
        ShoppingCart.buyerAddress1, 
        ShoppingCart.buyerAddress2, 
        ShoppingCart.buyerCity, 
        ShoppingCart.buyerState, 
        ShoppingCart.buyerZipCode, 
        ShoppingCart.cartTotal, 
        StatusCodes.statusCodeDescription
FROM    ShoppingCart INNER JOIN
        StatusCodes ON ShoppingCart.cartStatus = StatusCodes.Id
GO
