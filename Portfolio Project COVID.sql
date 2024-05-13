Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


--Select *
--From PortfolioProject..CovidVaccinations
--order by 3,4


--Select data that we are going to be using 
Select location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
order by 1,2



--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercantage
From PortfolioProject..CovidDeaths
where location like '%states%'
and continent is not null
order by 1,2


--Looking at the Total cases vs Population
--Shows what percanatge of population got Covid
Select location,date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
where location like '%states%'
and continent is not null
order by 1,2 


--Looking at countries with highest infection rate compared to population

Select location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--where location like '%states%'
group by location,population
order by PercentPopulationInfected desc



--Showing Countries with Highest Death Count Per Population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by location
order by  TotalDeathCount desc



--LET'S BREAK THINGS DOWN BY CONTINENT




--Showing the continents with the highest death count per population

Select continent,MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
group by continent
order by  TotalDeathCount desc




--GLOBAL NUMBERS
Select  date, SUM(new_cases) as total_cases, SUM( cast(new_deaths as int)) as total_deaths, SUM( cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercantage
--total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercantage
From PortfolioProject..CovidDeaths
--where location like '%states%'
WHERE continent is not null
Group by date
order by 1,2



--Total cases in the world
Select SUM(new_cases) as total_cases, SUM( cast(new_deaths as int)) as total_deaths, SUM( cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercantage
--total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercantage
From PortfolioProject..CovidDeaths
--where location like '%states%'
WHERE continent is not null
--Group by date
order by 1,2




-- Looking at total population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
  WHERE dea.continent is not null
  order by 2,3



  --USE CTE

  With PopvsVac (Continent, Location, Date, Population, new_vaccinations,RollingPeopleVaccinated)
  as
  (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
  WHERE dea.continent is not null
  -- order by 2,3
  )

  SELECT * ,(RollingPeopleVaccinated/Population)*100
 FROM PopvsVac


 --TEMP TABLE
 -- IF you want to change something you can use
 --DROP Table if exists #PercentPopulationVaccinated


 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(225),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 new_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

 Insert into  #PercentPopulationVaccinated
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
  WHERE dea.continent is not null
  -- order by 2,3

    SELECT * ,(RollingPeopleVaccinated/Population)*100
 FROM #PercentPopulationVaccinated



 --Creating View to store data for later visualizations


 Create View PercentPopulationVaccinated as
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations as int)) Over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--,RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
  WHERE dea.continent is not null
  -- order by 2,3


  SELECT*
  FROM PercentPopulationVaccinated

