USE CandiesDB;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCart](
    cartGUID [varchar](50) NOT NULL,
	cartStatus tinyint NOT NULL,
    buyerName [varchar](50) NULL,
    buyerAddress1 [varchar](50) NULL,
    buyerAddress2 [varchar](50) NULL,
    buyerCity [varchar]( 50 ) NULL,
    buyerState [varchar](2) NULL,
    buyerZipCode [varchar](10) NULL,
    cartTotal money NULL
PRIMARY KEY CLUSTERED 
(
	[cartGUID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO