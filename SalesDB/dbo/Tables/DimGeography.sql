CREATE TABLE [dbo].[DimGeography] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Country]           NVARCHAR (500) NULL,
    [Region]            NVARCHAR (500) NULL,
    [State or Province] NVARCHAR (500) NULL,
    [City]              NVARCHAR (500) NULL,
    [Postal Code]       INT            NULL
);

