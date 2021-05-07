CREATE TABLE [dbo].[DimPeriod] (
    [PeriodKey]         INT          NOT NULL,
    [PeriodDate]        DATE         NULL,
    [CalCenturyYear]    SMALLINT     NULL,
    [CalDayNumInMonth]  SMALLINT     NULL,
    [CalMonthAbrv]      VARCHAR (35) NULL,
    [CalMonthName]      VARCHAR (35) NULL,
    [CalQtrAbrv]        VARCHAR (35) NULL,
    [CalQtrNumInYear]   SMALLINT     NULL,
    [DayAbrv]           VARCHAR (35) NULL,
    [DayName]           VARCHAR (35) NULL,
    [FisCenturyYear]    SMALLINT     NULL,
    [FisDayNumInPeriod] SMALLINT     NULL,
    [FisQtrAbrv]        VARCHAR (35) NULL
);

