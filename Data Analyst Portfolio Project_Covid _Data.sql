SELECT *
FROM PortifolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3, 4;

-- Coverting the columns from string nvarchar to float (number)
ALTER TABLE PortifolioProject..CovidDeaths
ALTER COLUMN Total_deaths float;

ALTER TABLE PortifolioProject..CovidDeaths
ALTER COLUMN Total_cases float;

ALTER TABLE PortifolioProject..CovidDeaths
ALTER COLUMN population float;

ALTER TABLE PortifolioProject..CovidDeaths
ALTER COLUMN  new_deaths float;


ALTER TABLE PortifolioProject..CovidDeaths
ALTER COLUMN  new_cases float;

ALTER TABLE PortifolioProject..CovidVaccinations
ALTER COLUMN  new_vaccinations float;

-- Select the main data for this project
SELECT
location,
date,
total_cases,
new_cases,
total_deaths,
population
FROM
PortifolioProject..CovidDeaths
ORDER BY 3, 4;

--Total Cases vs Total Deahts In Brazil
--Shows the Likelihood of Dying if Covid is Contracted if You are a Brazilian Citzen
SELECT
location,
date,
total_cases,
total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
FROM
PortifolioProject..CovidDeaths
WHERE location like '%Brazil%'
ORDER BY 3, 4;

-- Loking at total cases vs population
-- Shows what percentagr of population got covid

SELECT
location,
date,
total_cases,
total_deaths,
(total_cases/population)*100 as "population_tested_(percentage)"
FROM
PortifolioProject..CovidDeaths
WHERE location like '%Brazil%'
ORDER BY 1, 2;

-- Loking at Countries With Highest Infection Rate Compared to Population
SELECT
location,
population,
MAX(total_cases) as HighestInfectionCount,
MAX((total_cases/population))*100 as PercentPopulationInfected
FROM
PortifolioProject..CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

SELECT
location,
MAX(total_deaths) as TotalDeathCount
FROM
PortifolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

--- let's break things by continent
-- Continet with the highest casualties per population

SELECT
Location,
MAX(cast(total_deaths as int)) as TotalDeathCount
FROM
PortifolioProject..CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount desc
--World	4,748,335

-- Global Numbers

SELECT
date,
SUM(new_cases) as total_cases,
SUM(new_deaths) as total_deaths,
SUM(new_deaths)/SUM(new_cases)*100 as DeathPercetage
FROM
PortifolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;


-- Loking total Population vs Vaccinations

SELECT 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeaopleVaccinated 
--(RolligPeopleVaccinated/population)*100 THIS IS NOT POSSIBLE
FROM PortifolioProject..CovidDeaths dea
join PortifolioProject..CovidVaccinations vac
	on  dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2, 3;


-- USE CTE

-- PopvsVac = Population vs Vaccination
WITH PopvsVac (continent, location, date,  population, new_vaccinations, RollingPeaopleVaccinated) 
AS
(
SELECT 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeaopleVaccinated
FROM PortifolioProject..CovidDeaths dea
join PortifolioProject..CovidVaccinations vac
	on  dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2, 3
)
SELECT *, (RollingPeaopleVaccinated/population)*100 as PeaopleVaccinatedPercent
FROM PopvsVac


-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeaopleVaccinated
FROM PortifolioProject..CovidDeaths dea
join PortifolioProject..CovidVaccinations vac
	on  dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent is not null
--order by 2, 3
SELECT 
*, 
(RollingPeopleVaccinated/population)*100 as PeaopleVaccinatedPercent
FROM #PercentPopulationVaccinated

-- Creating View to store data For later vizualizations 

SELECT *
FROM PortifolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3, 4;

-- Coverting the columns from string nvarchar to float (number)
ALTER TABLE PortifolioProject..CovidDeaths
ALTER COLUMN Total_deaths float;

ALTER TABLE PortifolioProject..CovidDeaths
ALTER COLUMN Total_cases float;

ALTER TABLE PortifolioProject..CovidDeaths
ALTER COLUMN population float;

ALTER TABLE PortifolioProject..CovidDeaths
ALTER COLUMN  new_deaths float;


ALTER TABLE PortifolioProject..CovidDeaths
ALTER COLUMN  new_cases float;

ALTER TABLE PortifolioProject..CovidVaccinations
ALTER COLUMN  new_vaccinations float;

-- Select the main data for this project
SELECT
location,
date,
total_cases,
new_cases,
total_deaths,
population
FROM
PortifolioProject..CovidDeaths
ORDER BY 3, 4;

--Total Cases vs Total Deahts In Brazil
--Shows the Likelihood of Dying if Covid is Contracted if You are a Brazilian Citzen
SELECT
location,
date,
total_cases,
total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage
FROM
PortifolioProject..CovidDeaths
WHERE location like '%Brazil%'
ORDER BY 3, 4;

-- Loking at total cases vs population
-- Shows what percentagr of population got covid

SELECT
location,
date,
total_cases,
total_deaths,
(total_cases/population)*100 as "population_tested_(percentage)"
FROM
PortifolioProject..CovidDeaths
WHERE location like '%Brazil%'
ORDER BY 1, 2;

-- Loking at Countries With Highest Infection Rate Compared to Population
SELECT
location,
population,
MAX(total_cases) as HighestInfectionCount,
MAX((total_cases/population))*100 as PercentPopulationInfected
FROM
PortifolioProject..CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

SELECT
location,
MAX(total_deaths) as TotalDeathCount
FROM
PortifolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

--- let's break things by continent
-- Continet with the highest casualties per population

SELECT
Location,
MAX(cast(total_deaths as int)) as TotalDeathCount
FROM
PortifolioProject..CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount desc
--World	4,748,335

-- Global Numbers

SELECT
date,
SUM(new_cases) as total_cases,
SUM(new_deaths) as total_deaths,
SUM(new_deaths)/SUM(new_cases)*100 as DeathPercetage
FROM
PortifolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;


-- Loking total Population vs Vaccinations

SELECT 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeaopleVaccinated 
--(RolligPeopleVaccinated/population)*100 THIS IS NOT POSSIBLE
FROM PortifolioProject..CovidDeaths dea
join PortifolioProject..CovidVaccinations vac
	on  dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2, 3;


-- USE CTE

-- PopvsVac = Population vs Vaccination
WITH PopvsVac (continent, location, date,  population, new_vaccinations, RollingPeaopleVaccinated) 
AS
(
SELECT 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeaopleVaccinated
FROM PortifolioProject..CovidDeaths dea
join PortifolioProject..CovidVaccinations vac
	on  dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2, 3
)
SELECT *, (RollingPeaopleVaccinated/population)*100 as PeaopleVaccinatedPercent
FROM PopvsVac


-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeaopleVaccinated
FROM PortifolioProject..CovidDeaths dea
join PortifolioProject..CovidVaccinations vac
	on  dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent is not null
--order by 2, 3
SELECT 
*, 
(RollingPeopleVaccinated/population)*100 as PeaopleVaccinatedPercent
FROM #PercentPopulationVaccinated

-- Creating View to store data For later vizualizations 

CREATE VIEW  PercentPopulationVaccinated AS
SELECT 
dea.continent,
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeaopleVaccinated
FROM PortifolioProject..CovidDeaths dea
join PortifolioProject..CovidVaccinations vac
	on  dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent is not null
--order by 2, 3c