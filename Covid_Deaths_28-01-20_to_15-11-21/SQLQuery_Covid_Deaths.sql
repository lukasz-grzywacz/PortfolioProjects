--DATA From 28.01.2020 To 15.11.2021 
Select *
From PorfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From PorfolioProject..CovidDeaths
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PorfolioProject..CovidDeaths
order by 1,2

-- Toal Cases vs Total Deaths for Poland

Select location, date, total_cases, total_deaths,  total_deaths/ NULLIF(total_cases,0)*100 as DeathPercentage
From PorfolioProject..CovidDeaths
Where location like 'Poland'
order by 1,2

--Toal Cases vs Total Deaths for Poland

Select location, date, Population, total_cases,  (total_cases/population) *100 as PrecentOfPopulationInfected
From PorfolioProject..CovidDeaths
Where location like 'Poland' 
order by 1,2

-- Countries with highest Infection Rate compared to Population	

Select location, population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PorfolioProject..CovidDeaths
Where continent is not null
Group by location, population
order by PercentPopulationInfected desc

-- DEATHS BY CONTINENT
Select continent,  MAX(cast(total_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

-- GROUP BY DATE
Select date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deats, SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
From PorfolioProject..CovidDeaths
Where continent is not null
Group by date
order by 1,2

-- GROUPED DATES
Select SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deats, SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
From PorfolioProject..CovidDeaths
Where continent is not null
order by 1,2



-- TOTAL POPULATION VS VACCINATIONS

With PopVsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
From PorfolioProject..CovidDeaths dea
Join PorfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population) * 100 as PeopleVaccinatedPerecetange
From PopVsVac



-- TOTAL POPULATION VS VACCINATIONS (TEMP TABLE)
DROP Table if exists #PerecentPopulationVaccinated
Create Table #PerecentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
Nev_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PerecentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
From PorfolioProject..CovidDeaths dea
Join PorfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
Select *, (RollingPeopleVaccinated/Population) * 100 as PeopleVaccinatedPerecetange
From #PerecentPopulationVaccinated


-- Data for Visualisation
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PorfolioProject..CovidDeaths dea
Join PorfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select *
From PerecentPopulationVaccinatedView



