select * 
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select * 
--from PortfolioProject..CovidVaccinations
--order by 3,4

--select data we going to be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2 

-- looking at the total cases vs total deaths 
-- shows likelihood of dying if you contract covid in your country 
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%Vietnam%'
and continent is not null
order by 1,2 

--looking at total cases vs population 
-- shows what percentage of population got Covid 
select location, date, population, total_cases,  (total_cases/population)*100 as PercentPopulationInfection
from PortfolioProject..CovidDeaths
--where location like '%Vietnam%'
where continent is not null
order by 1,2 

-- looking at countries with highest infection rate compared to population 
select location, population, max(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as PercentPopulationInfection
from PortfolioProject..CovidDeaths
--where location like '%Vietnam%'
where continent is not null
Group by location, population
order by PercentPopulationInfection desc

--break thingsdown by continent 


--showing countries with highest death count per population 
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%Vietnam%'
where continent is not null
Group by continent
order by TotalDeathCount desc


-- showing continent with highest death count per population 
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--where location like '%Vietnam%'
where continent is not null
Group by continent
order by TotalDeathCount desc
-- global numbers 
select date, SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,  sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%Vietnam%'
where continent is not null
--group by date
order by 1,2 

select SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,  sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%Vietnam%'
where continent is not null
--group by date
order by 1,2 

-- looking at total population and vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
--	, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3 

--use CTE 
with PopvsVac(continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
--	, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population) *100
from PopvsVac

--temp table 
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric ,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
--	, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/population) *100
from #PercentPopulationVaccinated

--creating view to store data for later visualization 
Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
--	, (RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * 
from PercentPopulationVaccinated