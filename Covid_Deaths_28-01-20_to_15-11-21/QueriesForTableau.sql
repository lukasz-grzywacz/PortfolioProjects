/*

Queries used fot Tableau Project

*/

--1.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathsPrecentage
From PorfolioProject..CovidDeaths
Where continent is not null
Order by 1,2

--2.

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths
Where continent is null
and location not in('World', 'European Union', 'International','Upper middle income', 'High income', 'Lower middle income', 'Lower middle income', 'Low income')
Group by location
Order by TotalDeathCount desc

--3.

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PerecentPopulationInfected
From PorfolioProject..CovidDeaths
Group by location, population
Order by PerecentPopulationInfected desc


--4.
Select location, population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PerecentPopulationInfected
From PorfolioProject..CovidDeaths
Group by location, population
Order by PerecentPopulationInfected desc
