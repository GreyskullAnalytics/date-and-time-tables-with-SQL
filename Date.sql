/* generates a list with 10 values */
WITH 
List AS (
    SELECT  
        n
    FROM
        (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) v(n)
),

/* generates 10k rows by cross joining List with itself */
Range AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL))-1 AS RowNumber
    FROM
        List a
        CROSS JOIN List b
        CROSS JOIN List c
        CROSS JOIN List d
),

/* query to specify date range */
DateRange AS (
    SELECT
        CAST(CONCAT(YEAR(GETDATE())-5,'-01-01') AS DATE) AS StartDate /* should always start on 1st January */,
        CAST(CONCAT(YEAR(GETDATE())+1, '-12-31') AS DATE) AS EndDate /* should always end on 31st December*/
),

/* query to generate dates between given start date and end date */
Calendar AS (
SELECT
    DATEADD(DAY, r.RowNumber, dr.StartDate ) AS Date
FROM
    Range r
    CROSS JOIN DateRange dr
WHERE
    DATEADD(DAY, r.RowNumber, dr.StartDate ) <= dr.EndDate
)

/* date table query */
SELECT
    c.Date,
    YEAR(c.Date) AS Year,
    CONCAT('Qtr ',DATEPART(QUARTER, c.Date)) AS Quarter,
    DATENAME(MONTH, c.Date) AS Month,
    DAY(c.Date) AS Day,
    MONTH(c.Date) AS MonthNumber,
    DATEPART(WEEKDAY, c.Date) AS DayOfWeek,
    DATENAME(WEEKDAY, c.Date) AS DayOfWeekName,
    ROW_NUMBER() OVER (PARTITION BY YEAR(c.Date) ORDER BY c.Date) AS DayOfYear,
    DATEPART(WEEK, c.Date) AS Week,
    DATEPART(ISO_WEEK, c.Date) AS ISOWeek
FROM
    Calendar c
ORDER BY
    c.Date