USE CandiesDB;
GO
/****** Object:  StoredProcedure [dbo].[AddToCart]    Script Date: 11/5/2020 4:01:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetShoppingCart]
	@cartGUID varchar(128)
AS
    SELECT * from vwShoppingCart WHERE cartGUID = @cartGUID
RETURN 0
GO