
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 01/20/2021 14:04:05
-- Generated from EDMX file: C:\Users\dschenck\src\github\donschenck\NetCandyStore\Models\CandiesDBModel.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [CandiesDB];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------


-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[ProductCategories]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ProductCategories];
GO
IF OBJECT_ID(N'[dbo].[Products]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Products];
GO
IF OBJECT_ID(N'[dbo].[ShoppingCart]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ShoppingCart];
GO
IF OBJECT_ID(N'[dbo].[ShoppingCartItem]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ShoppingCartItem];
GO
IF OBJECT_ID(N'[dbo].[StatusCodes]', 'U') IS NOT NULL
    DROP TABLE [dbo].[StatusCodes];
GO
IF OBJECT_ID(N'[CandiesDBModelStoreContainer].[vwProducts]', 'U') IS NOT NULL
    DROP TABLE [CandiesDBModelStoreContainer].[vwProducts];
GO
IF OBJECT_ID(N'[CandiesDBModelStoreContainer].[vwShoppingCartItems]', 'U') IS NOT NULL
    DROP TABLE [CandiesDBModelStoreContainer].[vwShoppingCartItems];
GO
IF OBJECT_ID(N'[CandiesDBModelStoreContainer].[database_firewall_rules]', 'U') IS NOT NULL
    DROP TABLE [CandiesDBModelStoreContainer].[database_firewall_rules];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'ProductCategories'
CREATE TABLE [dbo].[ProductCategories] (
    [Id] int  NOT NULL,
    [displayName] varchar(50)  NULL,
    [isActive] tinyint  NULL
);
GO

-- Creating table 'ShoppingCarts'
CREATE TABLE [dbo].[ShoppingCarts] (
    [cartGUID] varchar(128)  NOT NULL,
    [cartStatus] tinyint  NOT NULL,
    [buyerName] varchar(50)  NULL,
    [buyerAddress1] varchar(50)  NULL,
    [buyerAddress2] varchar(50)  NULL,
    [buyerCity] varchar(50)  NULL,
    [buyerState] char(2)  NULL,
    [buyerZipCode] char(5)  NULL,
    [cartTotal] decimal(19,4)  NULL
);
GO

-- Creating table 'ShoppingCartItems'
CREATE TABLE [dbo].[ShoppingCartItems] (
    [Id] int  NOT NULL,
    [cartGUID] varchar(128)  NOT NULL,
    [productID] int  NULL,
    [quantity] int  NULL,
    [productPrice] decimal(19,4)  NULL,
    [status] tinyint  NULL
);
GO

-- Creating table 'StatusCodes'
CREATE TABLE [dbo].[StatusCodes] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [statusCodeDescription] varchar(20)  NULL
);
GO

-- Creating table 'Products'
CREATE TABLE [dbo].[Products] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [statusCodeId] tinyint  NULL,
    [displayName] varchar(50)  NULL,
    [description] varchar(max)  NULL,
    [itemPrice] decimal(19,4)  NULL,
    [itemPackageType] varchar(15)  NULL,
    [quantityPerPackage] int  NULL,
    [keywords] varchar(128)  NULL,
    [imageURL] varchar(255)  NULL,
    [productCategoryId] int  NULL
);
GO

-- Creating table 'vwProducts'
CREATE TABLE [dbo].[vwProducts] (
    [Id] int  NOT NULL,
    [statusCodeId] tinyint  NULL,
    [displayName] varchar(50)  NULL,
    [description] varchar(max)  NULL,
    [itemPrice] decimal(19,4)  NULL,
    [itemPackageType] varchar(15)  NULL,
    [quantityPerPackage] int  NULL,
    [keywords] varchar(128)  NULL,
    [imageURL] varchar(255)  NULL,
    [productCategoryId] int  NULL,
    [statusCodeDescription] varchar(20)  NULL,
    [ProductCategory] varchar(50)  NULL
);
GO

-- Creating table 'vwShoppingCartItems'
CREATE TABLE [dbo].[vwShoppingCartItems] (
    [cartGUID] varchar(128)  NOT NULL,
    [Id] int  NOT NULL,
    [productID] int  NULL,
    [productPrice] decimal(19,4)  NULL,
    [quantity] int  NULL,
    [LineItemTotal] decimal(19,4)  NULL,
    [displayName] varchar(50)  NULL,
    [description] varchar(max)  NULL,
    [imageURL] varchar(255)  NULL,
    [itemPackageType] varchar(15)  NULL,
    [productCategoryId] int  NULL,
    [quantityPerPackage] int  NULL,
    [ProductCategory] varchar(50)  NULL
);
GO

-- Creating table 'database_firewall_rules'
CREATE TABLE [dbo].[database_firewall_rules] (
    [id] int IDENTITY(1,1) NOT NULL,
    [name] nvarchar(128)  NOT NULL,
    [start_ip_address] varchar(45)  NOT NULL,
    [end_ip_address] varchar(45)  NOT NULL,
    [create_date] datetime  NOT NULL,
    [modify_date] datetime  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'ProductCategories'
ALTER TABLE [dbo].[ProductCategories]
ADD CONSTRAINT [PK_ProductCategories]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [cartGUID] in table 'ShoppingCarts'
ALTER TABLE [dbo].[ShoppingCarts]
ADD CONSTRAINT [PK_ShoppingCarts]
    PRIMARY KEY CLUSTERED ([cartGUID] ASC);
GO

-- Creating primary key on [Id] in table 'ShoppingCartItems'
ALTER TABLE [dbo].[ShoppingCartItems]
ADD CONSTRAINT [PK_ShoppingCartItems]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'StatusCodes'
ALTER TABLE [dbo].[StatusCodes]
ADD CONSTRAINT [PK_StatusCodes]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Products'
ALTER TABLE [dbo].[Products]
ADD CONSTRAINT [PK_Products]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'vwProducts'
ALTER TABLE [dbo].[vwProducts]
ADD CONSTRAINT [PK_vwProducts]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [cartGUID], [Id] in table 'vwShoppingCartItems'
ALTER TABLE [dbo].[vwShoppingCartItems]
ADD CONSTRAINT [PK_vwShoppingCartItems]
    PRIMARY KEY CLUSTERED ([cartGUID], [Id] ASC);
GO

-- Creating primary key on [id], [name], [start_ip_address], [end_ip_address], [create_date], [modify_date] in table 'database_firewall_rules'
ALTER TABLE [dbo].[database_firewall_rules]
ADD CONSTRAINT [PK_database_firewall_rules]
    PRIMARY KEY CLUSTERED ([id], [name], [start_ip_address], [end_ip_address], [create_date], [modify_date] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------