CREATE TABLE [dbo].[DimCustomer] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [Customer ID]   INT            NULL,
    [Customer Name] NVARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

