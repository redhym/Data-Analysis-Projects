/* Create database */
CREATE DATABASE crime_NZ;
GO

/* Check the table */
SELECT * FROM [crime_NZ]
GO

/* Let's check the top 10 districts with highest crime*/

SELECT TOP 10
       [Territorial_Authority],
       SUM([Victimisations]) as crime_count
FROM [dbo].[crime_NZ]
GROUP BY [Territorial_Authority]
ORDER BY crime_count DESC;

/* Let's check if there is an increase in crime when compared to month to month*/

SELECT 
    [Year_Month],
    SUM([Victimisations]) as crime_count,
    LAG(SUM([Victimisations])) OVER (ORDER BY  [Year_Month]) AS previous_month,
    SUM([Victimisations]) - LAG(SUM([Victimisations])) OVER (ORDER BY  [Year_Month]) AS monthr_difference
FROM [dbo].[crime_NZ]
GROUP BY  [Year_Month];

/* Let's check in which month number of crimes were committed*/

SELECT TOP 1 
[Year_Month], COUNT(*) as crime_count
FROM [dbo].[crime_NZ]
GROUP BY [Year_Month]
ORDER BY crime_count DESC;

/* Let's check on which day hightest number of crimes were committed*/

SELECT TOP 1 
[Occurrence_Day_Of_Week], COUNT(*) as crime_count
FROM [dbo].[crime_NZ]
GROUP BY [Occurrence_Day_Of_Week]
ORDER BY crime_count DESC;

/* Number various crimes commited over time*/

SELECT YEAR([Year_Month]) as year, [ANZSOC_Division], COUNT(*) as various_crime_count
FROM [dbo].[crime_NZ]
GROUP BY YEAR([Year_Month]), [ANZSOC_Division]
ORDER BY various_crime_count DESC;

/* Let's check the high crime areas for certain crimes*/

SELECT TOP 10
[ANZSOC_Group], [ANZSOC_Division], [Area_Unit], COUNT(*) as various_crime_count
FROM [dbo].[crime_NZ] 
GROUP BY [ANZSOC_Group], [ANZSOC_Division], [Area_Unit]
ORDER BY various_crime_count DESC;

/* At what time most crimes were reported*/

SELECT TOP 10
[Occurrence_Hour_Of_Day], [ANZSOC_Division], COUNT(*) as crime_count
FROM [dbo].[crime_NZ] 
GROUP BY [Occurrence_Hour_Of_Day], [ANZSOC_Division]
ORDER BY crime_count DESC;




    