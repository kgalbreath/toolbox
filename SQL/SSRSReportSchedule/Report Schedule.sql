SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT	c.Name AS ReportName
	,p.Name AS ReportManagerLocation
	,CASE su.DeliveryExtension
	    WHEN 'Report Server FileShare' THEN 'FileShare'
	    WHEN 'Report Server Email' THEN 'Email'
	END AS DeliveryMethod
	,CASE sc.RecurrenceType
	    WHEN 1 THEN 'Once'
	    WHEN 3 THEN 'Repeat Every X Number of Days'
	    WHEN 4 THEN 'Repeat Every X Number of Weeks on Specific Days of the Week'
	    WHEN 5 THEN 'Month(s) with the Day(s) of the Month'
	    WHEN 6 THEN 'Month(s) with the Week and Day of that Week (i.e. Monday, Tuesday, etc.)'
	END AS Recurrence
	,CASE WHEN sc.RecurrenceType = 3 THEN sc.DaysInterval ELSE NULL END AS DaysInterval
	,CASE WHEN sc.RecurrenceType = 4 THEN sc.WeeksInterval ELSE NULL END AS WeeksInterval
	,SUBSTRING(REVERSE(REPLICATE('0', 7 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek))) + dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek)), 1, 1) AS Sunday
	,SUBSTRING(REVERSE(REPLICATE('0', 7 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek))) + dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek)), 2, 1) AS Monday
	,SUBSTRING(REVERSE(REPLICATE('0', 7 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek))) + dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek)), 3, 1) AS Tuesday
	,SUBSTRING(REVERSE(REPLICATE('0', 7 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek))) + dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek)), 4, 1) AS Wednesday
	,SUBSTRING(REVERSE(REPLICATE('0', 7 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek))) + dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek)), 5, 1) AS Thursday
	,SUBSTRING(REVERSE(REPLICATE('0', 7 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek))) + dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek)), 6, 1) AS Friday
	,SUBSTRING(REVERSE(REPLICATE('0', 7 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek))) + dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfWeek)), 7, 1) AS Saturday
	,SUBSTRING(REVERSE(REPLICATE('0', 12 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.Month))) + dbo.FN_DECIMAL_TO_BINARY(sc.Month)), 1, 1) AS January
	,SUBSTRING(REVERSE(REPLICATE('0', 12 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.Month))) + dbo.FN_DECIMAL_TO_BINARY(sc.Month)), 2, 1) AS February
	,SUBSTRING(REVERSE(REPLICATE('0', 12 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.Month))) + dbo.FN_DECIMAL_TO_BINARY(sc.Month)), 3, 1) AS March
	,SUBSTRING(REVERSE(REPLICATE('0', 12 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.Month))) + dbo.FN_DECIMAL_TO_BINARY(sc.Month)), 4, 1) AS April
	,SUBSTRING(REVERSE(REPLICATE('0', 12 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.Month))) + dbo.FN_DECIMAL_TO_BINARY(sc.Month)), 5, 1) AS May
	,SUBSTRING(REVERSE(REPLICATE('0', 12 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.Month))) + dbo.FN_DECIMAL_TO_BINARY(sc.Month)), 6, 1) AS June
	,SUBSTRING(REVERSE(REPLICATE('0', 12 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.Month))) + dbo.FN_DECIMAL_TO_BINARY(sc.Month)), 7, 1) AS July
	,SUBSTRING(REVERSE(REPLICATE('0', 12 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.Month))) + dbo.FN_DECIMAL_TO_BINARY(sc.Month)), 8, 1) AS August
	,SUBSTRING(REVERSE(REPLICATE('0', 12 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.Month))) + dbo.FN_DECIMAL_TO_BINARY(sc.Month)), 9, 1) AS September
	,SUBSTRING(REVERSE(REPLICATE('0', 12 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.Month))) + dbo.FN_DECIMAL_TO_BINARY(sc.Month)), 10, 1) AS October
	,SUBSTRING(REVERSE(REPLICATE('0', 12 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.Month))) + dbo.FN_DECIMAL_TO_BINARY(sc.Month)), 11, 1) AS November
	,SUBSTRING(REVERSE(REPLICATE('0', 12 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.Month))) + dbo.FN_DECIMAL_TO_BINARY(sc.Month)), 12, 1) AS December
	,dbo.FN_CONVERT_MONTH_BIT_MASK(REVERSE(REPLICATE('0', 31 - LEN(dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfMonth))) + dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfMonth))) AS DaysOfMonth
	,sc.MonthlyWeek WeekOfMonth
	,sc.LastRunTime AS LastRunDateTime
	,su.LastStatus AS LastRunStatus
FROM	dbo.Catalog c
	INNER JOIN dbo.Catalog p
	    ON c.ParentId = p.ItemId
	INNER JOIN dbo.ReportSchedule rs 
	    ON c.ItemID = rs.ReportID
	INNER JOIN dbo.Schedule sc
	    ON rs.ScheduleID = sc.ScheduleID
	INNER JOIN dbo.Subscriptions su
	    ON rs.SubscriptionID = su.SubscriptionID
ORDER BY p.Name 
	,c.Name;
