SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

SELECT continent, date, total_cases, new_cases, total_deaths,population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- Looking at the total cases vs total deaths

SELECT continent, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Kenya%'
WHERE continent is not null
ORDER BY 1,2


--Loking at the total cases versus the population
--Shows what percentage of population got covid

SELECT location, date, population, total_cases,  (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location like '%Kenya%'
AND continent is not null
ORDER BY 1,2


--What country has the highest infection rate compared to the population

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS 
  PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Kenya%'
Group by Location, population
ORDER BY PercentPopulationInfected DESC


--The country that had the highest death count per population

SELECT Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Kenya%'
WHERE continent is not null
Group by Location
ORDER BY TotalDeathCount DESC


----Showing Continent with highest death count

SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Kenya%'
WHERE continent is not null
Group by continent
ORDER BY TotalDeathCount DESC

-- Global Numbers

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths as int)) As total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases) *100 As DeathPercentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%Kenya%'
WHERE continent is not null
Group by date
ORDER BY 1,2

--join the two tables
--look at the totalpopulation vs vaccinations

SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated,
(RollingPeopleVaccinated/dea.population)*100

FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


--USE CTE

WITH PopvsVac (continent, location,date, population, new_vaccinations, RollingPeopleVaccinated)
AS 
(
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/dea.population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac


--TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert Into #PercentPopulationVaccinated
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/dea.population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


--creating view to strote data for later visualisations

CREATE VIEW PercentPopulationVaccinated AS 
SELECT dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/dea.population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

Select *
From PercentPopulationVaccinated