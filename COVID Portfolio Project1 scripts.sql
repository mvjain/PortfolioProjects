Select *
From [Portfolio Project1]..Covid_death$
where continent is not null
order by 3,4

Select *
From [Portfolio Project1]..Covid_vaccinations$
where continent is not null
order by 3,4

-- select data that we would going to be using

Select Location, date, total_cases, new_cases, total_cases, population
From [Portfolio Project1]..Covid_death$
where continent is not null
order by 1,2

--Looking at Total cases vs Total Deaths
-- shows the likelihood of dying if contracted with covid-19

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [Portfolio Project1]..Covid_death$
where location = 'Canada'
and where continent is not null
order by 1,2


-- Looking at the Total cases and vs Populations
-- Shows what percentage of population got covid

Select Location, date, total_cases, population, (total_cases/ population)*100 as PercentPopulationInfected
From [Portfolio Project1]..Covid_death$
where location = 'Canada'
order by 1,2

--which country has the highest infection rate

Select Location, population, MAX(total_cases) as HighestInfectionCount, max(total_cases/ population)*100 as PercentPopulationInfected
From [Portfolio Project1]..Covid_death$
where continent is not null
Group by location, population
order by PercentPopulationInfected desc

-- Showing the countries with the highest death count per population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project1]..Covid_death$
where continent is not null
Group by location
Order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT
--Showing the continents with highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project1]..Covid_death$
where continent is not null
Group by continent
Order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
From [Portfolio Project1]..Covid_death$
where continent is not null
Group by date
order by 1,2


--Global Death percentage 

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
From [Portfolio Project1]..Covid_death$
where continent is not null
order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From [Portfolio Project1]..Covid_death$ dea
join [Portfolio Project1]..Covid_vaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(float,vac.new_vaccinations)) over (Partition by  dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project1]..Covid_death$ dea
join [Portfolio Project1]..Covid_vaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


-- USING CTE

With PopvsVac(Continent,Location,Date, Population, NewVaccinations, RollingPeopleVaccinated)
as
( 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(float,vac.new_vaccinations)) over (Partition by  dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 From [Portfolio Project1]..Covid_death$ dea
 join [Portfolio Project1]..Covid_vaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
 Where dea.continent is not null
 )
 Select * , (RollingPeopleVaccinated/Population)*100
From PopvsVac



--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(float,vac.new_vaccinations)) over (Partition by  dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project1]..Covid_death$ dea
join [Portfolio Project1]..Covid_vaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3
 Select * , (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




--Creating View to store data for visualizations

Drop View PercentPopulationVaccinated

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(float,vac.new_vaccinations)) over (Partition by  dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project1]..Covid_death$ dea
join [Portfolio Project1]..Covid_vaccinations$ vac
    On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select * 
From PercentPopulationVaccinated


