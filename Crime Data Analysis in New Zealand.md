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

![Top 10 ](https://user-images.githubusercontent.com/85157023/170952806-83fa8316-ff4d-414c-bd8d-4c9c0cf476c5.png)


/* Let's check if there is an increase in crime month to month*/

SELECT 
    [Year_Month],
    SUM([Victimisations]) as crime_count,
    LAG(SUM([Victimisations])) OVER (ORDER BY  [Year_Month]) AS previous_month,
    SUM([Victimisations]) - LAG(SUM([Victimisations])) OVER (ORDER BY  [Year_Month]) AS monthr_difference
FROM [dbo].[crime_NZ]
GROUP BY  [Year_Month];

![Month-month](https://user-images.githubusercontent.com/85157023/170952828-d9fb782d-275c-4350-9e57-3a6d3f322225.png)



/* Let's check in which month number of crimes were committed*/

SELECT TOP 1 
[Year_Month], COUNT(*) as crime_count
FROM [dbo].[crime_NZ]
GROUP BY [Year_Month]
ORDER BY crime_count DESC;

![max month](https://user-images.githubusercontent.com/85157023/170952898-311a89ed-7e0d-4fbd-b8e8-de829df3097f.png)


/* Let's check on which day hightest number of crimes were committed*/

SELECT TOP 1 
[Occurrence_Day_Of_Week], COUNT(*) as crime_count
FROM [dbo].[crime_NZ]
GROUP BY [Occurrence_Day_Of_Week]
ORDER BY crime_count DESC;


![day](https://user-images.githubusercontent.com/85157023/170952924-6385ff53-78b0-4faa-bb48-fd82f25f6d87.png)



/* Number various crimes commited over time*/

SELECT YEAR([Year_Month]) as year, [ANZSOC_Division], COUNT(*) as various_crime_count
FROM [dbo].[crime_NZ]
GROUP BY YEAR([Year_Month]), [ANZSOC_Division]
ORDER BY various_crime_count DESC;

![crimes co](https://user-images.githubusercontent.com/85157023/170952958-3625b974-84b5-4025-aa63-b461e0c97ee1.png)



/* Let's check the high crime areas for certain crimes*/

SELECT TOP 10
[ANZSOC_Group], [ANZSOC_Division], [Area_Unit], COUNT(*) as various_crime_count
FROM [dbo].[crime_NZ] 
GROUP BY [ANZSOC_Group], [ANZSOC_Division], [Area_Unit]
ORDER BY various_crime_count DESC;

![crime per area](https://user-images.githubusercontent.com/85157023/170952988-3b463441-3398-4424-9a06-7c32a6fa820a.png)



/* At what time most crimes were reported*/

SELECT TOP 10
[Occurrence_Hour_Of_Day], [ANZSOC_Division], COUNT(*) as crime_count
FROM [dbo].[crime_NZ] 
GROUP BY [Occurrence_Hour_Of_Day], [ANZSOC_Division]
ORDER BY crime_count DESC;


![time crime](https://user-images.githubusercontent.com/85157023/170953044-892d1901-e71b-47f7-884c-059b69ed8c84.png)




    
