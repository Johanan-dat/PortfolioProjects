SELECT *
  FROM [PortfolioProject].[dbo].[coviddeaths]
   WHERE continent is not null
    ORDER BY 3,4

--SELECT *
--  FROM [PortfolioProject].[dbo].[covidvaccinations]
--    ORDER BY 3,4

SELECT Location, Date, Total_cases, new_cases, total_deaths, population
   FROM [PortfolioProject].[dbo].[coviddeaths]
     ORDER BY 1,2

--Looking at total cases vs total deaths (percentage of people who died from having covid)

SELECT Location, Date, Total_cases, new_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 AS DeathPercentage
  FROM [PortfolioProject].[dbo].[coviddeaths]
     ORDER BY 1,2

--looking at total cases vs the population (infection rate) in USA

SELECT Location, Date, Total_cases, population, (cast(total_cases as float)/cast(population as float))*100 AS InfectionRate
  FROM [PortfolioProject].[dbo].[coviddeaths]
    WHERE location like '%States%'
     ORDER BY 1,2

--What countries have the highest infection rate?

SELECT Location, population, MAX(Total_cases) AS HighestCount,  (MAX(total_cases)/cast(population as float))*100 AS PercentagePopulationInfected
  FROM [PortfolioProject].[dbo].[coviddeaths]
    Group by Location, population
     ORDER BY 4 desc

-- continents with highest death count

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
   FROM [PortfolioProject].[dbo].[coviddeaths]
    Where continent is not null
     Group by continent
      ORDER BY TotalDeathCount desc

-- Global numbers by date

SELECT Date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as DeathPrecentage
  FROM [PortfolioProject].[dbo].[coviddeaths]
   Where continent is not null
	Group by date
     ORDER BY 1,2


--looking at total population vs vaccinated population with a rolling sum of people who have been vaccinated

With PopvsVax (continent, Location, date, population, new_vaccinations, RollingSum)
as 
(
Select Dea.continent, Dea.location, Dea.date, Dea.population, cast(vax.new_vaccinations as float) as new_vaccinations
, SUM(cast(vax.new_vaccinations as float)) OVER (Partition by dea.location Order by dea.location, dea.date) AS RollingSum
 From [PortfolioProject].[dbo].[coviddeaths] Dea
  Join [PortfolioProject].[dbo].[covidvaccinations] vax
   On dea.location = vax.location 
    and dea.date = vax.date
Where Dea.continent is not null 
)
Select *, (RollingSum/Population)*100 as RollingRateOfVax
 From PopvsVax







