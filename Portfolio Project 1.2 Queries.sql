-- test
Select * 
From `Portfolio Project`.covid_deaths
Order by 3, 4
Limit 200
;

-- Select desired Data 
Select location, date, total_cases, new_cases, total_deaths, population
From `Portfolio Project`.covid_deaths
Order by 1, 2
;

-- Total Cases vs. Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From `Portfolio Project`.covid_deaths
Where location like '%states%'
Order by location, date
;

-- % of people infected in the US
Select location, date, population, total_cases, (total_cases/population)*100 as InfectionRate
From `Portfolio Project`.covid_deaths
Where location like '%states%'
Order by location, date
;

-- Countries with highest infection rate (compared to population)
Select location, population, max(total_cases) as MaxInfections, max((total_cases/population)*100) as InfectionRate
From `Portfolio Project`.covid_deaths
Group by population, location
Order by InfectionRate desc 
Limit 20
;

-- Countries with highest death rate (compared to population)
Select location, max(total_deaths) as MaxDeaths, max((total_deaths/population)*100) as DeathRate
From `Portfolio Project`.covid_deaths
Group by population, location
Order by DeathRate desc 
Limit 20
;



-- continents' death counts worst to best
Select continent,  sum(new_deaths)  as DeathCount #sum of new_deaths works better here than total_deaths since it's easier to add accurately
From `Portfolio Project`.covid_deaths
Group by continent
Order by DeathCount desc 
;

-- Global Numbers by date
Select 
	date, 
    sum(new_cases) as total_cases, 
    sum(new_deaths) as total_deaths, 
    sum(new_deaths) / sum(new_cases)* 100 as death_percentage  
    # sum(population) (used this  along the way to ensure the continent exclusion in "where" (below) was working 
From `Portfolio Project`.covid_deaths
Where continent is not NULL # to avoid adding the contintent aggregates from the original data to the total
Group by date
Order by 1, 2
;

-- total cases, deaths, and deathpercentage
Select 
    sum(new_cases) as total_cases, 
    sum(new_deaths) as total_deaths, 
    sum(new_deaths) / sum(new_cases)* 100 as death_percentage  
From `Portfolio Project`.covid_deaths
Where continent is not NULL 
;