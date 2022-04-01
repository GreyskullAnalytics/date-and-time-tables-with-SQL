/* generates a list with 10 values */
WITH 
List AS (
    SELECT  
        n
    FROM
        (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) v(n)
),

/* generates 100k rows by cross joining List with itself */
Range AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL))-1 AS RowNumber
    FROM
        List a
        CROSS JOIN List b
        CROSS JOIN List c
        CROSS JOIN List d
        CROSS JOIN List e 
),

/* query to create 24 hours worth of records */
Time AS(
SELECT
    DATEADD(SECOND, r.RowNumber, '1900-1-1' ) AS Time
FROM
    Range r
WHERE 
    DATEADD(SECOND, r.RowNumber, '1900-1-1' ) < '1900-1-2'
)

/* time table query */
SELECT
    CAST(t.Time AS TIME(0)) AS Time,
    CAST(DATEADD(MINUTE, DATEDIFF(MINUTE, 0, t.Time), 0) AS TIME(0)) AS Minute,
    CAST(DATEADD(HOUR, DATEDIFF(HOUR, 0, t.Time), 0) AS TIME(0)) AS Hour,
    FORMAT(t.Time, 'tt') AS [AM/PM]   
FROM
    Time t
