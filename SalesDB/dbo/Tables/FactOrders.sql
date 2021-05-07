CREATE TABLE [dbo].[FactOrders] (
    [ID]                   INT        IDENTITY (1, 1) NOT NULL,
    [Row ID]               INT        NULL,
    [Order ID]             INT        NULL,
    [OrderPriorityKey]     INT        NULL,
    [Discount]             FLOAT (53) NULL,
    [Unit Price]           FLOAT (53) NULL,
    [Shipping Cost]        FLOAT (53) NULL,
    [CustomerKey]          INT        NULL,
    [ShipModeKey]          INT        NULL,
    [CustomerSegmentKey]   INT        NULL,
    [ProductCategoryKey]   INT        NULL,
    [ProductSubCategory]   INT        NULL,
    [ProductContainerKey]  INT        NULL,
    [ProductKey]           INT        NULL,
    [GeographyKey]         INT        NULL,
    [Order Date]           DATETIME   NULL,
    [Ship Date]            DATETIME   NULL,
    [Profit]               FLOAT (53) NULL,
    [Quantity ordered new] INT        NULL,
    [Sales]                FLOAT (53) NULL,
    [PeriodKey]            INT        NULL
);

