USE CandiesDB;
GO
/****** Object:  Table [dbo].[Products]    Script Date: 11/5/2020 4:01:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[statusCodeId] [tinyint] NULL,
	[displayName] [varchar](50) NULL,
	[description] [text] NULL,
	[itemPrice] [money] NULL,
	[itemPackageType] [varchar](15) NULL,
	[quantityPerPackage] [int] NULL,
	[keywords] [varchar](128) NULL,
	[imageURL] [varchar](255) NULL,
	[productCategoryId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO