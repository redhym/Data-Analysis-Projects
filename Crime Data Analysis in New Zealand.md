**In this project we’re going to analyse crime victimisation in New Zealand. This dataset includes details of where and at what times of the day and week crime occurs.**

>The data can be download from the below link:

>https://www.police.govt.nz/about-us/publications-statistics/data-and-statistics/policedatanz/victimisation-time-and-place




/* Create database */
CREATE DATABASE crime_NZ;
GO

/* Check the table */
SELECT * FROM [crime_NZ]
GO

**1.Number of crimes that occurred in each district. The below result shows Auckland had most crimes.**

SELECT TOP 10
       [Territorial_Authority],
       SUM([Victimisations]) as crime_count
FROM [dbo].[crime_NZ]
GROUP BY [Territorial_Authority]
ORDER BY crime_count DESC;

![Top 10 ](https://user-images.githubusercontent.com/85157023/170952806-83fa8316-ff4d-414c-bd8d-4c9c0cf476c5.png)


**2.Let's check if there is an increase in crime month to month. There is an increase in the month of March 2022 as compared to Feb 2022.**

SELECT 
    [Year_Month],
    SUM([Victimisations]) as crime_count,
    LAG(SUM([Victimisations])) OVER (ORDER BY  [Year_Month]) AS previous_month,
    SUM([Victimisations]) - LAG(SUM([Victimisations])) OVER (ORDER BY  [Year_Month]) AS monthr_difference
FROM [dbo].[crime_NZ]
GROUP BY  [Year_Month];

![Month-month](https://user-images.githubusercontent.com/85157023/170952828-d9fb782d-275c-4350-9e57-3a6d3f322225.png)



**3.Let's check in which month most number of crimes were committed**

SELECT TOP 1 
[Year_Month], COUNT(*) as crime_count
FROM [dbo].[crime_NZ]
GROUP BY [Year_Month]
ORDER BY crime_count DESC;

![max month](https://user-images.githubusercontent.com/85157023/170952898-311a89ed-7e0d-4fbd-b8e8-de829df3097f.png)


**4.Let’s check highest crimes committed on which day of the week. The result shows ‘Thursday’, never expected this, as I thought most crimes were committed on weekends.**

SELECT TOP 1 
[Occurrence_Day_Of_Week], COUNT(*) as crime_count
FROM [dbo].[crime_NZ]
GROUP BY [Occurrence_Day_Of_Week]
ORDER BY crime_count DESC;


![day](https://user-images.githubusercontent.com/85157023/170952924-6385ff53-78b0-4faa-bb48-fd82f25f6d87.png)



**5.Various crimes committed over time. Clearly ‘ Theft and Related Offences” tops the chart.**

SELECT YEAR([Year_Month]) as year, [ANZSOC_Division], COUNT(*) as various_crime_count
FROM [dbo].[crime_NZ]
GROUP BY YEAR([Year_Month]), [ANZSOC_Division]
ORDER BY various_crime_count DESC;

![crimes co](https://user-images.githubusercontent.com/85157023/170952958-3625b974-84b5-4025-aa63-b461e0c97ee1.png)



**6.Let's check the high crime areas for certain crimes**

SELECT TOP 10
[ANZSOC_Group], [ANZSOC_Division], [Area_Unit], COUNT(*) as various_crime_count
FROM [dbo].[crime_NZ] 
GROUP BY [ANZSOC_Group], [ANZSOC_Division], [Area_Unit]
ORDER BY various_crime_count DESC;

![crime per area](https://user-images.githubusercontent.com/85157023/170952988-3b463441-3398-4424-9a06-7c32a6fa820a.png)



**7.At what time most crimes were reported- Wow around 3pm!**

SELECT TOP 10
[Occurrence_Hour_Of_Day], [ANZSOC_Division], COUNT(*) as crime_count
FROM [dbo].[crime_NZ] 
GROUP BY [Occurrence_Hour_Of_Day], [ANZSOC_Division]
ORDER BY crime_count DESC;


![time crime](https://user-images.githubusercontent.com/85157023/170953044-892d1901-e71b-47f7-884c-059b69ed8c84.png)


**8. Let's see in which age group most of the crimes were committed- It’s shocking to see most crimes were committed in the 20-24 age group.**

SELECT TOP 10
[Age_Group], COUNT(*) crime_count
FROM [dbo].[Age and Sex AES_Full Data_data]
GROUP BY [Age_Group]
ORDER BY COUNT(*) DESC;

![Screen Shot 2022-05-31 at 2 38 51 PM](https://user-images.githubusercontent.com/85157023/171082028-dafd6f14-ddc5-4400-a25e-107669ced279.png)


/* Now let's see crimes committed per age group*/

SELECT TOP 10
[Age_Group], [ANZSOC_Division], COUNT(*) crime_count
FROM [dbo].[Age and Sex AES_Full Data_data]
GROUP BY [Age_Group], [ANZSOC_Division]
ORDER BY COUNT(*) DESC;



![Screen Shot 2022-05-31 at 2 43 29 PM](https://user-images.githubusercontent.com/85157023/171082475-c63f2512-6e8a-44c5-b272-020e456b0d23.png)


/* Now let's see crimes committed per ethnicity*/

SELECT TOP 10
[Ethnicity], COUNT(*) group_count
FROM [dbo].[Age and Sex AES_Full Data_data]
GROUP BY [Ethnicity]
ORDER BY COUNT(*) DESC;

![Screen Shot 2022-05-31 at 2 47 38 PM](https://user-images.githubusercontent.com/85157023/171082900-a3ba0af1-69ed-4230-be9d-5204a147c0c0.png)

**Finally I created a dashboard using Tableau. The Dashboard features ‘Crime by Month,’. ‘Type of crimes’ and crime occurrence by hour and day. **


![Dashboard 1](https://user-images.githubusercontent.com/85157023/171099991-ad2c5c72-0cbc-41ae-9152-f8f2deec9b30.png)

>https://public.tableau.com/app/profile/hyma8492/viz/CrimeDataAnalysisNZ/Dashboard1?publish=yes

**I think this data analysis will be useful to help the police to make decisions to reduce the crimes. Like what areas to focus on and time of the day.**

    
