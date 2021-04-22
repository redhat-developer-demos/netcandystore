USE CandiesDB;
GO
/****** Object:  StoredProcedure [dbo].[GetShoppingCartItems]    Script Date: 11/5/2020 4:01:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetShoppingCartItems]
	@cartGUID varchar(128)
AS
	SELECT * from vwShoppingCartItems WHERE cartGUID=@cartGUID ORDER BY displayName, Id
RETURN 0
GO
ALTER DATABASE [CandiesDB] SET  READ_WRITE 
GO