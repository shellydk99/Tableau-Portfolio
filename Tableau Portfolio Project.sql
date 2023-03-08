/*
Queries used for Tableu Project
*/

--1
SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortofolioProject..CovidDeaths
--where location = 'Indonesia'
WHERE continent is not null
-- Group by date
ORDER BY 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"Location

--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
--FROM PortfolioProject..CovidDeaths
-- Where location = 'Indonesia'
-- where location = 'World'
-- Group by date
-- order by 1,2

--2
--We take theses out as they are not included in the above queries and want to stay consistent
--European Union is part of Europe

SELECT location, SUM(cast(new_deaths as int)) as TotalDeathCount
FROM PortofolioProject..CovidDeaths
--where location = 'Indonesia'
WHERE continent = '' AND location not in ('World', 'High income', 'Upper middle income', 'Lower middle income', 'Low income', 'International', 'European Union')
GROUP BY location
ORDER BY TotalDeathCount desc

-- 3
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortofolioProject..CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

--4
SELECT location, population, date, MAX(total_cases) as HigestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM PortofolioProject..CovidDeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected desc

--5
--select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where location = 'Indonesia'
-- where continent is not null
-- order by 1,2

--took the above query and added population
SELECT location, date, population, total_cases, total_deaths
FROM PortofolioProject..CovidDeaths
--where location = 'Indonesia'
WHERE continent is not null
ORDER BY 1,2

--6
WITH PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) 
	OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
	-- , (RollingPeopleVaccinated/population)*100
	FROM PortofolioProject..CovidDeaths dea
	JOIN PortofolioProject..CovidVaccination vac
		on dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent is not null
	--order by 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100 as PercentPeopleVaccinated
FROM PopvsVac

-- 7
SELECT  date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected, 
MAX(total_deaths) as HighestDeathsCount, MAX((total_deaths/population))*100 as PercentPopulationDeaths
FROM PortofolioProject..CovidDeaths
where location = 'Indonesia'
GROUP BY date
ORDER BY PercentPopulationInfected desc

select location, sum(convert(float, total_cases)) as Cases
FROM PortofolioProject..CovidDeaths
WHERE continent = 'asia' AND total_cases is not NULL
group by location
order by Cases desc
