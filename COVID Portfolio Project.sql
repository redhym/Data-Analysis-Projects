

-- 1. Death Percentage in India

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) as DeathPercentage
FROM PortfolioProject.coviddeaths
WHERE location like '%India%'
ORDER BY DeathPercentage DESC
LIMIT 10;

-- Catalogue the % of population contracted covid

SELECT location, date, population, total_cases, ROUND((total_cases/population)*100, 2) as CasesPercentage
FROM PortfolioProject.coviddeaths
WHERE location like '%India%'
ORDER BY CasesPercentage DESC
LIMIT 10;

-- Which countries have the highest infection rate per population

SELECT location, population, MAX(total_cases) as HighestCount, 
MAX(ROUND((total_cases/population)*100, 2))as CasesPercentage
FROM PortfolioProject.coviddeaths
GROUP BY location, population
ORDER BY CasesPercentage DESC
LIMIT 10;

-- Which countries have the highest Death Count per population 
-- We need to convert the total_deaths datatype from text to INT, so i used to CAST do that

SELECT location, MAX(CAST(total_deaths as SIGNED)) as TotalDeathCount
FROM PortfolioProject.coviddeaths
GROUP BY location
ORDER BY TotalDeathCount DESC
LIMIT 10;

-- Continents with the highest death rates

SELECT continent, MAX(CAST(total_deaths as SIGNED)) as TotalDeathCount
FROM PortfolioProject.coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global Numbers

SELECT SUM(new_cases) as TotalCases
, SUM(CAST(new_deaths as SIGNED)) as TotalDeaths
, SUM(CAST(new_deaths as SIGNED))/SUM(new_cases)* 100 as DeathPercentage
FROM PortfolioProject.coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Checking new vaccinations vs total population. Used partition by to count the rolling number of new vaccinations by location.

WITH vacglobal (continent, location, date, population, new_vaccinations, roll_vaccinated) AS
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations as SIGNED)) OVER (PARTITION BY cd.location ORDER by cd.location, cd.date) as roll_vaccinated
FROM PortfolioProject.coviddeaths cd
JOIN PortfolioProject.covidvaccinations cv
     ON cd.location = cv.location AND
     cd.date = cv.date
WHERE cd.continent IS NOT NULL
)
SELECT *, (roll_vaccinated/population)*100 as rollVaccination_percent
FROM  vacglobal

-- Creating view to store data for later visualisations.

CREATE VIEW vacglobal AS
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations as SIGNED)) OVER (PARTITION BY cd.location ORDER by cd.location, cd.date) as roll_vaccinated
FROM PortfolioProject.coviddeaths cd
JOIN PortfolioProject.covidvaccinations cv
     ON cd.location = cv.location AND
     cd.date = cv.date
WHERE cd.continent IS NOT NULL
;


