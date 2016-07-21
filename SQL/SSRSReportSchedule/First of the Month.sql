/*
MinutesInterval, DaysInterval, WeeksInterval, Month, DaysOfWeek, MonthlyWeek, DaysOfMonth,
sc.RecurrenceType columns.
here's some of it to get you started:
Sun = 1, Mon = 2, Tues = 4, Weds = 8, Th = 16, Fri = 32, Sat = 64
Do you see how the system works?  From there you can determine which days the sub runs.
Monday only = 2, M-F = 62 (2+4+8+16+32), Su-Sa = 127 (62(M-F)+1(Su)+64(Sa)).
Each of the date parts work the same.  For month it's Jan=1, Feb=2, Mar=4, etc.
It gets me real twitchy when it comes to calendar dates.  1st=1, 2nd=2, 3rd=4, 4th=8, 5th=16...allthe way to 31st.  I have one report that runs the 1st, 7th, 15th, 21st...the number for that is 2113665!
*/

SELECT DISTINCT  c.Name AS RptName,
sc.Name AS SchedName,
su.LastStatus,
su.LastRunTime AS SubLast,
sc.LastRunTime AS SchedLast,
sc.NextRunTime,
MinutesInterval as MinInt,
DaysInterval as DaysInt,
WeeksInterval as WeeksInt,
Month,
DaysOfWeek,
MonthlyWeek,
DaysOfMonth,
sc.RecurrenceType,
c.Path,
dbo.FN_DECIMAL_TO_BINARY(sc.Month),
dbo.FN_DECIMAL_TO_BINARY(sc.DaysOfMonth)
FROM     dbo.Catalog AS c INNER JOIN
               dbo.ReportSchedule AS rs ON c.ItemID = rs.ReportID INNER JOIN
               dbo.Schedule AS sc ON rs.ScheduleID = sc.ScheduleID INNER JOIN
               dbo.Subscriptions AS su ON rs.SubscriptionID = su.SubscriptionID
--WHERE sc.NextRunTime > GetDate()
WHERE	--WeeksInterval IS NOT NULL
	--SUBSTRING(REVERSE(dbo.FN_DECIMAL_TO_BINARY(DaysOfWeek)), 2, 1) = 1 
	--DaysOfMonth IS NOT NULL
	sc.RecurrenceType IN (5, 6)
ORDER BY 1