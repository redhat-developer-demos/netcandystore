USE CandiesDB;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CalculateCartTotal]
	@cartGUID varchar(50)
AS
    UPDATE ShoppingCart 
    SET
        cartTotal = (SELECT SUM(LineItemTotal) FROM vwShoppingCartItems WHERE vwShoppingCartItems.cartGUID = @cartGUID )
    WHERE
        ShoppingCart.cartGUID = @cartGUID
RETURN 0
GO