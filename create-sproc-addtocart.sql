USE CandiesDB;
GO
/****** Object:  StoredProcedure [dbo].[AddToCart]    Script Date: 11/5/2020 4:01:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddToCart]
	@cartGUID varchar(128),
	@productId int,
	@productPrice money,
	@quantity int,
	@statusCode tinyint
AS
	-- Get any existing quantity and price if it exists
	DECLARE @existingQty	int
	DECLARE @existingPrice	money
	DECLARE @newPrice		money

	SELECT @existingQty = quantity, @existingPrice = productPrice
		FROM ShoppingCartItem
		WHERE cartGUID = @cartGUID AND productID = @productId

	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO ShoppingCartItem (cartGUID,productID,quantity,productPrice,[status])
		VALUES(@cartGUID,@productId,@quantity,@productPrice,@statusCode)
	END
	ELSE
	BEGIN
		SET @newPrice = @existingPrice
		BEGIN
		IF (@productPrice < @existingPrice)
			SET @newPrice = @productPrice
		END
		UPDATE ShoppingCartItem
			SET quantity = @existingQty+@quantity,
				productPrice = @newPrice
			WHERE
				cartGUID = @cartGUID AND productID = @productId
	END
	EXECUTE CalculateCartTotal @cartGUID
RETURN 0
GO