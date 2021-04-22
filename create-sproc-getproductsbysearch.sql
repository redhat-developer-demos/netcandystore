USE CandiesDB;
GO
/****** Object:  StoredProcedure [dbo].[GetProductsBySearch]    Script Date: 11/5/2020 4:01:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProductsBySearch]
	@searchTerm varchar(50)
AS
 	SELECT * FROM vwProducts WHERE keywords LIKE '%'+ LTRIM(RTRIM(@searchTerm)) + '%' OR displayName LIKE '%'+ LTRIM(RTRIM(@searchTerm)) + '%' OR ProductCategory LIKE '%'+ LTRIM(RTRIM(@searchTerm)) + '%'
RETURN 0
GO
