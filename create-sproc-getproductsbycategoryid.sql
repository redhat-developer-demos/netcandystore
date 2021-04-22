USE CandiesDB;
GO
/****** Object:  StoredProcedure [dbo].[GetProductsByCategoryId]    Script Date: 11/5/2020 4:01:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProductsByCategoryId]
	@categoryId int
AS
	SELECT * FROM vwProducts
	WHERE productCategoryId = @categoryId
	ORDER BY displayName
RETURN 0
GO