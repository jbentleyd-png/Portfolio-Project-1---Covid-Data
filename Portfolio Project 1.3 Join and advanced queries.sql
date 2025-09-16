-- inner join
Select *
From `Portfolio Project`.covid_deaths d
Join  `Portfolio Project`.covid_vax v
	on d.location = v.location and 
    d.date = v.date
;

-- Total Population vs. Vaccinations
Select d.location, d.population, max(total_vaccinations) as total_vaccinations
From `Portfolio Project`.covid_deaths d
Join  `Portfolio Project`.covid_vax v
	on d.location = v.location and 
    d.date = v.date
Where d.continent is not NULL
Group by location, population
Order by total_vaccinations desc
;

-- using window function and CTE to create a running total and do some math with it
Select 
	d.continent,
	d.location, 
    d.date, 
    d.population, 
    new_vaccinations, 
    sum(new_vaccinations) OVER (partition by location order by d.location, d.date) as vaccinations_to_date
From `Portfolio Project`.covid_deaths d
Join  `Portfolio Project`.covid_vax v
	on d.location = v.location and 
    d.date = v.date
Where d.continent is not NULL
Group by
	d.continent,
	d.location, 
    d.date, 
    d.population, 
    new_vaccinations
Order by d.location, d.date
;




With PvsV (continent,location, date, population, new_vaccinations, vaccinations_to_date)
as
(
Select 
	d.continent,
	d.location, 
    d.date, 
    d.population, 
    new_vaccinations, 
    sum(new_vaccinations) OVER (partition by location order by d.location, d.date) as vaccinations_to_date
From `Portfolio Project`.covid_deaths d
Join  `Portfolio Project`.covid_vax v
	on d.location = v.location and 
    d.date = v.date
Where d.continent is not NULL
Group by
	d.continent,
	d.location, 
    d.date, 
    d.population, 
    new_vaccinations
)
Select *, vaccinations_to_date/population*100 as `%_of_nation_vaxed`
From PvsV
;

-- temp table 
Drop Table if exists PercentPopulationVaccinated;
Create Table PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date date, 
population numeric, 
new_vaccinations numeric, 
vaccinations_to_date numeric
);

Insert into PercentPopulationVaccinated
Select 
	d.continent,
	d.location, 
    d.date, 
    d.population, 
    new_vaccinations, 
    sum(new_vaccinations) OVER (partition by location order by d.location, d.date) as vaccinations_to_date
From `Portfolio Project`.covid_deaths d
Join  `Portfolio Project`.covid_vax v
	on d.location = v.location and 
    d.date = v.date
Where d.continent is not NULL
Group by
	d.continent,
	d.location, 
    d.date, 
    d.population, 
    new_vaccinations
Order by d.location, d.date
;
