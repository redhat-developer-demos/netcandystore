USE CandiesDB;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCartItem](
	[Id] int IDENTITY(1,1) NOT NULL,
    cartGUID [varchar](50) NOT NULL,
    productID int NULL,
    quantity int NULL,
    productPrice money NULL,
	[status] tinyint NULL
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO