USE CandiesDB;
GO
/****** Object:  StoredProcedure [dbo].[AddToCart]    Script Date: 11/5/2020 4:01:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateShoppingCart]
	@cartGUID varchar(128),
	@status tinyint
AS
    SELECT cartGUID from ShoppingCart WHERE cartGUID = @cartGUID
	IF @@ROWCOUNT = 0
	BEGIN
		INSERT INTO ShoppingCart (cartGUID,[cartStatus])
		VALUES(@cartGUID,@status)
	END
	EXECUTE CalculateCartTotal @cartGUID
RETURN 0
GO