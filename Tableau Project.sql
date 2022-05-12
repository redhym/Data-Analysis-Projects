-- Queries used for Tableau Dashboard


-- 1. Global Numbers

SELECT SUM(new_cases) as TotalCases
, SUM(CAST(new_deaths as SIGNED)) as TotalDeaths
, SUM(CAST(new_deaths as SIGNED))/SUM(new_cases)* 100 as DeathPercentage
FROM PortfolioProjects.coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- 2. Global Numbers by location

SELECT location, SUM(cast(new_deaths as SIGNED)) as TotalDeathCount
FROM PortfolioProjects.coviddeaths
WHERE continent = '' 
GROUP by location
HAVING location IN ('Europe', 'North America', 'South America', 'Asia', 'Africa', 'Oceania')
ORDER by TotalDeathCount desc;

-- 3.Countries that have the highest infection rate per population

SELECT location, population, MAX(total_cases) as HighestInfecCount, 
MAX(ROUND((total_cases/population)*100, 2))as CasesPercentage
FROM PortfolioProjects.coviddeaths
GROUP BY location, population
ORDER BY CasesPercentage DESC;


-- 4. 

SELECT location, population, date, MAX(total_cases) as HighestInfecCount, 
MAX(ROUND((total_cases/population)*100, 2))as CasesPercentage
FROM PortfolioProjects.coviddeaths
GROUP BY location, population, date
ORDER BY CasesPercentage DESC;
