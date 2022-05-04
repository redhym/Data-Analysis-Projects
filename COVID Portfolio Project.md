

-- 1. Death Percentage in India

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) as DeathPercentage
FROM PortfolioProject.coviddeaths
WHERE location like '%India%'
ORDER BY DeathPercentage DESC
LIMIT 10;

![Deathpercentage_1](https://user-images.githubusercontent.com/85157023/166828658-dd28c075-3fc8-4886-81a1-d71044aab601.png)



-- Catalogue the % of population contracted covid

SELECT location, date, population, total_cases, ROUND((total_cases/population)*100, 2) as CasesPercentage
FROM PortfolioProject.coviddeaths
WHERE location like '%India%'
ORDER BY CasesPercentage DESC
LIMIT 10;

![CasesPercentage](https://user-images.githubusercontent.com/85157023/166828724-e96f4abb-b492-408f-85e2-1f499f6dd3c2.png)



-- Which countries have the highest infection rate per population

SELECT location, population, MAX(total_cases) as HighestCount, 
MAX(ROUND((total_cases/population)*100, 2))as CasesPercentage
FROM PortfolioProject.coviddeaths
GROUP BY location, population
ORDER BY CasesPercentage DESC
LIMIT 10;

![Screen Shot 2022-05-05 at 9 30 59 AM](https://user-images.githubusercontent.com/85157023/166829129-b6e54da8-6db3-4349-8e43-9baefc2ff5ac.png)



-- Which countries have the highest Death Count per population 
-- We need to convert the total_deaths datatype from text to INT, so i used to CAST do that

SELECT location, MAX(CAST(total_deaths as SIGNED)) as TotalDeathCount
FROM PortfolioProject.coviddeaths
GROUP BY location
ORDER BY TotalDeathCount DESC
LIMIT 10;


![Highest Deaths](https://user-images.githubusercontent.com/85157023/166829189-0e656b78-e211-4623-9df4-54058eab1fad.png)



-- Continents with the highest death rates

SELECT continent, MAX(CAST(total_deaths as SIGNED)) as TotalDeathCount
FROM PortfolioProject.coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

![by continent](https://user-images.githubusercontent.com/85157023/166829207-ac01d6b1-1830-43e7-bb92-6e4a0286dc98.png)



-- Global Numbers

SELECT SUM(new_cases) as TotalCases
, SUM(CAST(new_deaths as SIGNED)) as TotalDeaths
, SUM(CAST(new_deaths as SIGNED))/SUM(new_cases)* 100 as DeathPercentage
FROM PortfolioProject.coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;


![Global Percentage](https://user-images.githubusercontent.com/85157023/166829221-340b0b3c-faba-46ad-af8e-5e093bd6945d.png)




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

![CTE Vacc](https://user-images.githubusercontent.com/85157023/166829259-ee609ce0-4800-488f-9a9a-35e18c79d4dd.png)



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


