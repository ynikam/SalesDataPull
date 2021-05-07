-- =============================================
-- Author:		Yogesh Nikam
-- Create date: 05/06/2021
-- Description:	Process Fact & Dimension Tables
-- =============================================
CREATE PROCEDURE usp_ProcessFactAndDimTables

AS
BEGIN


	SET NOCOUNT ON;

	--Merge DimCustomer Table
	MERGE [DimCustomer] AS T  
	USING (SELECT DISTINCT [Customer ID]  ,	[Customer Name] fROM [Staging].[Orders]) AS S 
	ON T.[Customer ID] = S.[Customer ID]
	WHEN MATCHED THEN  
		UPDATE SET  T.[Customer Name] = S.[Customer Name]
	WHEN NOT MATCHED THEN  
		INSERT ([Customer ID],[Customer Name]) VALUES (S.[Customer ID],S.[Customer Name]);

	--Merge [dbo].[DimCustomerSegment]
	MERGE [DimCustomerSegment] AS T  
		USING (SELECT DISTINCT [Customer Segment] fROM [Staging].[Orders]) AS S 
		ON T.[Customer Segment] = S.[Customer Segment]
	WHEN NOT MATCHED THEN  
			INSERT ([Customer Segment]) VALUES (S.[Customer Segment]);

	--Merge [dbo].[dbo].[DimGeography]
	MERGE [dbo].[DimGeography] AS T  
		USING (SELECT DISTINCT [Country]
      ,[Region]
      ,[State or Province]
      ,[City]
      ,[Postal Code]
       FROM [Staging].[Orders]) AS S ON T.[Country] = S.[Country]
										AND T.[Region] = S.[Region]
										AND T.[State or Province] = S.[State or Province]
										AND T.[City] = S.[City]
										AND T.[Postal Code] = S.[Postal Code]
	WHEN NOT MATCHED THEN  
			INSERT ([Country]
           ,[Region]
           ,[State or Province]
           ,[City]
           ,[Postal Code])
     VALUES
           (
		   S.[Country]
           ,S.[Region]
           ,S.[State or Province]
           ,S.[City]
           ,S.[Postal Code]);

	--Merge [dbo].[DimOrderPriority]
	MERGE [dbo].[DimOrderPriority] AS T  
		USING (SELECT DISTINCT [Order Priority] fROM [Staging].[Orders]) AS S 
		ON T.[Order Priority] = S.[Order Priority]
	WHEN NOT MATCHED THEN  
			INSERT ([Order Priority]) VALUES (S.[Order Priority]);

	--Merge [dbo].[DimProduct]
	MERGE [dbo].[DimProduct] AS T  
		USING (SELECT DISTINCT [Product Name],[Product Base Margin] fROM [Staging].[Orders]) AS S 
		ON T.[Product Name] = S.[Product Name] AND T.[Product Base Margin] = S.[Product Base Margin]
	WHEN MATCHED THEN DELETE;

	MERGE [dbo].[DimProduct] AS T  
		USING (SELECT DISTINCT [Product Name],[Product Base Margin] fROM [Staging].[Orders]) AS S 
		ON T.[Product Name] = S.[Product Name] AND T.[Product Base Margin] = S.[Product Base Margin]
	WHEN NOT MATCHED THEN  
			INSERT ([Product Name],[Product Base Margin]) VALUES (S.[Product Name],S.[Product Base Margin]);

	--Merge [dbo].[DimProductCategory]
	MERGE [dbo].[DimProductCategory] AS T  
		USING (SELECT DISTINCT [Product Category] fROM [Staging].[Orders]) AS S 
		ON T.[Product Category] = S.[Product Category]
	WHEN NOT MATCHED THEN  
			INSERT ([Product Category]) VALUES (S.[Product Category]);

	--Merge [dbo].[DimProductSubCategory]
	MERGE [dbo].[DimProductSubCategory] AS T  
		USING (SELECT DISTINCT [Product sub-Category], pc.id [Product Category Key] fROM [Sales].[Staging].[Orders] o 
				join [DimProductCategory] pc on o.[Product Category] = pc.[Product Category]) AS S 
		ON T.[Product Sub-Category] = S.[Product Sub-Category]
	WHEN MATCHED THEN UPDATE SET T.[Product Category Key] = S.[Product Category Key]
	WHEN NOT MATCHED THEN  
			INSERT ([Product Sub-Category],[Product Category Key]) VALUES (S.[Product Sub-Category],S.[Product Category Key]);

	--Merge [dbo].[DimProductContainer]
	MERGE [dbo].[DimProductContainer] AS T  
		USING (SELECT DISTINCT [Product Container] fROM [Staging].[Orders]) AS S 
		ON T.[Product Container] = S.[Product Container]
	WHEN NOT MATCHED THEN  
			INSERT ([Product Container]) VALUES (S.[Product Container]);

	--Merge [dbo].[DimShipMode]
	MERGE [dbo].[DimShipMode] AS T  
		USING (SELECT DISTINCT [Ship Mode] fROM [Staging].[Orders]) AS S 
		ON T.[Ship Mode] = S.[Ship Mode]
	WHEN NOT MATCHED THEN  
			INSERT ([Ship Mode]) VALUES (S.[Ship Mode]);


MERGE  [dbo].[FactOrders] AS T  
		USING (SELECT DISTINCT  
       [Row ID], [Order ID]
	  ,OP.ID [OrderPriorityKey] 
      ,[Discount] 
      ,[Unit Price] 
      ,[Shipping Cost] 
      ,C.ID[CustomerKey] 
      ,SM.ID[ShipModeKey] 
      ,CS.ID[CustomerSegmentKey] 
      ,PC.ID[ProductCategoryKey] 
      ,PSC.ID [ProductSubCategory] 
      ,PContainer.ID[ProductContainerKey] 
      ,P.ID[ProductKey] 
      ,G.ID[GeographyKey] 
      ,[Order Date] 
      ,[Ship Date] 
      ,[Profit] 
      ,[Quantity ordered new] 
      ,[Sales] 
      ,Period.[PeriodKey] 
 fROM [Staging].[Orders] O 
 LEFT join [dbo].[DimCustomer] C ON C.[Customer Name] = O.[Customer Name]
 LEFT JOIN [dbo].[DimCustomerSegment] CS ON CS.[Customer Segment] = O.[Customer Segment]
 LEFT JOIN [dbo].[DimGeography] G ON             G.[Country] = o.[Country]
										AND G.[Region] = o.[Region]
										AND G.[State or Province] = o.[State or Province]
										AND G.[City] = o.[City]
										AND G.[Postal Code] = o.[Postal Code]
 Left JOIN [dbo].[DimPeriod] Period ON PEriod.PEriodKEy = o.[Order Date]
 Left JOIN [dbo].[DimProduct] P ON P.[Product Name] = O.[Product Name] AND P.[Product Base Margin] = O.[Product Base Margin]
 Left JOIN [dbo].[DimProductCategory] PC ON PC.[Product Category] = O.[Product Category]
 Left JOIN [dbo].[DimProductContainer] PContainer ON PContainer.[Product Container] = O.[Product Container]
 Left JOIN [dbo].[DimProductSubCategory] PSC ON PSC.[Product Sub-Category] = o.[Product Sub-Category] AND psc.[Product Category Key] = pc.id
 Left JOIN [dbo].[DimOrderPriority] OP ON  OP.[Order Priority] = O.[Order Priority] 
 Left JOIN [dbo].[DimShipMode] SM ON SM.[Ship Mode] = O.[Ship Mode]
 ) AS S 
		ON T.[Order ID] = S.[Order ID] AND T.[Row ID] = S.[Row ID]
	WHEN NOT MATCHED THEN  
			INSERT (	[Row ID], [Order ID],[OrderPriorityKey] 
	,[Discount] 
	,[Unit Price] 
	,[Shipping Cost] 
	,[CustomerKey] 
	,[ShipModeKey] 
	,[CustomerSegmentKey] 
	,[ProductCategoryKey] 
	,[ProductSubCategory] 
	,[ProductContainerKey] 
	,[ProductKey] 
	,[GeographyKey] 
	,[Order Date] 
	,[Ship Date] 
	,[Profit] 
	,[Quantity ordered new] 
	,[Sales] 
	,[PeriodKey] ) 
	VALUES (	 S.[Row ID], S.[Order ID],S.[OrderPriorityKey] 
	,S.[Discount] 
	,S.[Unit Price] 
	,S.[Shipping Cost] 
	,S.[CustomerKey] 
	,S.[ShipModeKey] 
	,S.[CustomerSegmentKey] 
	,S.[ProductCategoryKey] 
	,S.[ProductSubCategory] 
	,S.[ProductContainerKey] 
	,S.[ProductKey] 
	,S.[GeographyKey] 
	,S.[Order Date] 
	,S.[Ship Date] 
	,S.[Profit] 
	,S.[Quantity ordered new] 
	,S.[Sales] 
	,S.[PeriodKey] );

END
