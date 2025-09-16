-- 1. Build tables to accept data as strings for later reformatting:

USE `Portfolio Project`;
DROP TABLE IF EXISTS covid_deaths; # deaths first
CREATE TABLE covid_deaths (
  iso_code VARCHAR(32),
  continent VARCHAR(64),
  location VARCHAR(128),
  date VARCHAR(20),
  population VARCHAR(64),
  total_cases VARCHAR(64),
  new_cases VARCHAR(64),
  new_cases_smoothed VARCHAR(64),
  total_deaths VARCHAR(64),
  new_deaths VARCHAR(64),
  new_deaths_smoothed VARCHAR(64),
  total_cases_per_million VARCHAR(64),
  new_cases_per_million VARCHAR(64),
  new_cases_smoothed_per_million VARCHAR(64),
  total_deaths_per_million VARCHAR(64),
  new_deaths_per_million VARCHAR(64),
  new_deaths_smoothed_per_million VARCHAR(64),
  reproduction_rate VARCHAR(64),
  icu_patients VARCHAR(64),
  icu_patients_per_million VARCHAR(64),
  hosp_patients VARCHAR(64),
  hosp_patients_per_million VARCHAR(64),
  weekly_icu_admissions VARCHAR(64),
  weekly_icu_admissions_per_million VARCHAR(64),
  weekly_hosp_admissions VARCHAR(64),
  weekly_hosp_admissions_per_million VARCHAR(64)
);


DROP TABLE IF EXISTS covid_vax;
CREATE TABLE covid_vax (
  iso_code VARCHAR(32),
  continent VARCHAR(64),
  location VARCHAR(128),
  date VARCHAR(20),
  total_tests VARCHAR(64),
  total_tests_per_thousand VARCHAR(64),
  new_tests_per_thousand VARCHAR(64),
  new_tests_smoothed VARCHAR(64),
  new_tests_smoothed_per_thousand VARCHAR(64),
  positive_rate VARCHAR(64),
  tests_per_case VARCHAR(64),
  tests_units VARCHAR(64),
  total_vaccinations VARCHAR(64),
  people_vaccinated VARCHAR(64),
  people_fully_vaccinated VARCHAR(64),
  new_vaccinations VARCHAR(64),
  new_vaccinations_smoothed VARCHAR(64),
  total_vaccinations_per_hundred VARCHAR(64),
  people_vaccinated_per_hundred VARCHAR(64),
  people_fully_vaccinated_per_hundred VARCHAR(64),
  new_vaccinations_smoothed_per_million VARCHAR(64),
  stringency_index VARCHAR(64),
  population VARCHAR(64),
  population_density VARCHAR(64),
  median_age VARCHAR(64),
  aged_65_older VARCHAR(64),
  aged_70_older VARCHAR(64),
  gdp_per_capita VARCHAR(64),
  extreme_poverty VARCHAR(64),
  cardiovasc_death_rate VARCHAR(64),
  diabetes_prevalence VARCHAR(64),
  female_smokers VARCHAR(64),
  male_smokers VARCHAR(64),
  handwashing_facilities VARCHAR(64),
  hospital_beds_per_thousand VARCHAR(64),
  life_expectancy VARCHAR(64),
  human_development_index VARCHAR(64)
);





-- 2. Import local data from the two files:

#check that local file uploads are allowed
SHOW VARIABLES LIKE 'local_infile'; 

# deaths
LOAD DATA LOCAL INFILE '/Users/admin/Documents/Data Analyst Course/Projects/Project 1/CovidDeaths.csv'
INTO TABLE covid_deaths
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

# vax
LOAD DATA LOCAL INFILE '/Users/admin/Documents/Data Analyst Course/Projects/Project 1/CovidVaccinations.csv'
INTO TABLE covid_vax
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;




-- 3. Clean it up:



-- 3.1. Before modifying, first disable safe updates so I can modify without keys:
SET SQL_SAFE_UPDATES = 0;


-- 3.2. Turn all blanks to NULL to minimize errors:
 # also making sure to scrub any whitespace, carriage returns 
UPDATE covid_deaths SET
  continent = NULLIF(TRIM(REPLACE(continent, '\r','')), ''), # didn't have this at first, but comes in handy later on
  population = NULLIF(TRIM(REPLACE(population, '\r','')), ''),
  total_cases = NULLIF(TRIM(REPLACE(total_cases, '\r','')), ''),
  new_cases = NULLIF(TRIM(REPLACE(new_cases, '\r','')), ''),
  new_cases_smoothed = NULLIF(TRIM(REPLACE(new_cases_smoothed, '\r','')), ''),
  total_deaths = NULLIF(TRIM(REPLACE(total_deaths, '\r','')), ''),
  new_deaths = NULLIF(TRIM(REPLACE(new_deaths, '\r','')), ''),
  new_deaths_smoothed = NULLIF(TRIM(REPLACE(new_deaths_smoothed, '\r','')), ''),
  total_cases_per_million = NULLIF(TRIM(REPLACE(total_cases_per_million, '\r','')), ''),
  new_cases_per_million = NULLIF(TRIM(REPLACE(new_cases_per_million, '\r','')), ''),
  new_cases_smoothed_per_million = NULLIF(TRIM(REPLACE(new_cases_smoothed_per_million, '\r','')), ''),
  total_deaths_per_million = NULLIF(TRIM(REPLACE(total_deaths_per_million, '\r','')), ''),
  new_deaths_per_million = NULLIF(TRIM(REPLACE(new_deaths_per_million, '\r','')), ''),
  new_deaths_smoothed_per_million = NULLIF(TRIM(REPLACE(new_deaths_smoothed_per_million, '\r','')), ''),
  reproduction_rate = NULLIF(TRIM(REPLACE(reproduction_rate, '\r','')), ''),
  icu_patients = NULLIF(TRIM(REPLACE(icu_patients, '\r','')), ''),
  icu_patients_per_million = NULLIF(TRIM(REPLACE(icu_patients_per_million, '\r','')), ''),
  hosp_patients = NULLIF(TRIM(REPLACE(hosp_patients, '\r','')), ''),
  hosp_patients_per_million = NULLIF(TRIM(REPLACE(hosp_patients_per_million, '\r','')), ''),
  weekly_icu_admissions = NULLIF(TRIM(REPLACE(weekly_icu_admissions, '\r','')), ''),
  weekly_icu_admissions_per_million = NULLIF(TRIM(REPLACE(weekly_icu_admissions_per_million, '\r','')), ''),
  weekly_hosp_admissions = NULLIF(TRIM(REPLACE(weekly_hosp_admissions, '\r','')), ''),
  weekly_hosp_admissions_per_million = NULLIF(TRIM(REPLACE(weekly_hosp_admissions_per_million, '\r','')), '');


UPDATE covid_vax SET
  continent = NULLIF(TRIM(REPLACE(continent, '\r','')), ''),
  total_tests = NULLIF(TRIM(REPLACE(total_tests, '\r','')), ''),
  total_tests_per_thousand = NULLIF(TRIM(REPLACE(total_tests_per_thousand, '\r','')), ''),
  new_tests_per_thousand = NULLIF(TRIM(REPLACE(new_tests_per_thousand, '\r','')), ''),
  new_tests_smoothed = NULLIF(TRIM(REPLACE(new_tests_smoothed, '\r','')), ''),
  new_tests_smoothed_per_thousand = NULLIF(TRIM(REPLACE(new_tests_smoothed_per_thousand, '\r','')), ''),
  positive_rate = NULLIF(TRIM(REPLACE(positive_rate, '\r','')), ''),
  tests_per_case = NULLIF(TRIM(REPLACE(tests_per_case, '\r','')), ''),
  total_vaccinations = NULLIF(TRIM(REPLACE(total_vaccinations, '\r','')), ''),
  people_vaccinated = NULLIF(TRIM(REPLACE(people_vaccinated, '\r','')), ''),
  people_fully_vaccinated = NULLIF(TRIM(REPLACE(people_fully_vaccinated, '\r','')), ''),
  new_vaccinations = NULLIF(TRIM(REPLACE(new_vaccinations, '\r','')), ''),
  new_vaccinations_smoothed = NULLIF(TRIM(REPLACE(new_vaccinations_smoothed, '\r','')), ''),
  total_vaccinations_per_hundred = NULLIF(TRIM(REPLACE(total_vaccinations_per_hundred, '\r','')), ''),
  people_vaccinated_per_hundred = NULLIF(TRIM(REPLACE(people_vaccinated_per_hundred, '\r','')), ''),
  people_fully_vaccinated_per_hundred = NULLIF(TRIM(REPLACE(people_fully_vaccinated_per_hundred, '\r','')), ''),
  new_vaccinations_smoothed_per_million = NULLIF(TRIM(REPLACE(new_vaccinations_smoothed_per_million, '\r','')), ''),
  stringency_index = NULLIF(TRIM(REPLACE(stringency_index, '\r','')), ''),
  population = NULLIF(TRIM(REPLACE(population, '\r','')), ''),
  population_density = NULLIF(TRIM(REPLACE(population_density, '\r','')), ''),
  median_age = NULLIF(TRIM(REPLACE(median_age, '\r','')), ''),
  aged_65_older = NULLIF(TRIM(REPLACE(aged_65_older, '\r','')), ''),
  aged_70_older = NULLIF(TRIM(REPLACE(aged_70_older, '\r','')), ''),
  gdp_per_capita = NULLIF(TRIM(REPLACE(gdp_per_capita, '\r','')), ''),
  extreme_poverty = NULLIF(TRIM(REPLACE(extreme_poverty, '\r','')), ''),
  cardiovasc_death_rate = NULLIF(TRIM(REPLACE(cardiovasc_death_rate, '\r','')), ''),
  diabetes_prevalence = NULLIF(TRIM(REPLACE(diabetes_prevalence, '\r','')), ''),
  female_smokers = NULLIF(TRIM(REPLACE(female_smokers, '\r','')), ''),
  male_smokers = NULLIF(TRIM(REPLACE(male_smokers, '\r','')), ''),
  handwashing_facilities = NULLIF(TRIM(REPLACE(handwashing_facilities, '\r','')), ''),
  hospital_beds_per_thousand = NULLIF(TRIM(REPLACE(hospital_beds_per_thousand, '\r','')), ''),
  life_expectancy = NULLIF(TRIM(REPLACE(life_expectancy, '\r','')), ''),
  human_development_index = NULLIF(TRIM(REPLACE(human_development_index, '\r','')), '');





-- 3.3. get rid of any lingering headers down low in the data 
DELETE FROM covid_deaths
WHERE iso_code = 'iso_code'
   OR continent = 'continent'
   OR location = 'location'
   OR date = 'date';

DELETE FROM covid_vax
WHERE iso_code = 'iso_code'
   OR continent = 'continent'
   OR location = 'location'
   OR date = 'date';

-- in the end, there were none, though. 




-- 3.4. modify date columns to the proper format:
UPDATE covid_deaths
SET date = date_format(str_to_date(date, '%m/%d/%Y'), '%Y-%m-%d')
WHERE date IS NOT NULL AND date <> '';

UPDATE covid_vax
SET date = date_format(str_to_date(date, '%m/%d/%Y'), '%Y-%m-%d')
WHERE date IS NOT NULL AND date <> '';


-- 3.5 remove some word values that should not be in total_cases_per_million (discovvered when trying to ALTER covid_deaths)
UPDATE covid_deaths
SET total_cases_per_million = NULL
WHERE total_cases_per_million IS NOT NULL
  AND TRIM(total_cases_per_million) <> ''
  AND total_cases_per_million NOT REGEXP '^-?[0-9]+(\\.[0-9]+)?$';


-- 3.6. Re-enable safe updates, just in case
SET SQL_SAFE_UPDATES = 1;





-- 4. Put all columns into the proper data types:

ALTER TABLE covid_deaths
  MODIFY iso_code VARCHAR(16),
  MODIFY continent VARCHAR(32),
  MODIFY location VARCHAR(128),
  MODIFY date DATE,
  MODIFY population BIGINT,
  MODIFY total_cases INT,
  MODIFY new_cases INT,
  MODIFY new_cases_smoothed DECIMAL(12,3),
  MODIFY total_deaths INT,
  MODIFY new_deaths INT,
  MODIFY new_deaths_smoothed DECIMAL(12,3),
  MODIFY total_cases_per_million DECIMAL(12,3),
  MODIFY new_cases_per_million DECIMAL(12,3),
  MODIFY new_cases_smoothed_per_million DECIMAL(12,3),
  MODIFY total_deaths_per_million DECIMAL(12,3),
  MODIFY new_deaths_per_million DECIMAL(12,3),
  MODIFY new_deaths_smoothed_per_million DECIMAL(12,3),
  MODIFY reproduction_rate DECIMAL(6,3),
  MODIFY icu_patients INT,
  MODIFY icu_patients_per_million DECIMAL(12,3),
  MODIFY hosp_patients INT,
  MODIFY hosp_patients_per_million DECIMAL(12,3),
  MODIFY weekly_icu_admissions INT,
  MODIFY weekly_icu_admissions_per_million DECIMAL(12,3),
  MODIFY weekly_hosp_admissions INT,
  MODIFY weekly_hosp_admissions_per_million DECIMAL(12,3);


ALTER TABLE covid_vax
  MODIFY iso_code VARCHAR(16),
  MODIFY continent VARCHAR(32),
  MODIFY location VARCHAR(128),
  MODIFY date DATE,
  MODIFY total_tests BIGINT,
  MODIFY total_tests_per_thousand DECIMAL(14,3),
  MODIFY new_tests_per_thousand DECIMAL(14,3),
  MODIFY new_tests_smoothed BIGINT,
  MODIFY new_tests_smoothed_per_thousand DECIMAL(14,3),
  MODIFY positive_rate DECIMAL(8,5),
  MODIFY tests_per_case DECIMAL(12,3),
  MODIFY tests_units VARCHAR(64),
  MODIFY total_vaccinations BIGINT,
  MODIFY people_vaccinated BIGINT,
  MODIFY people_fully_vaccinated BIGINT,
  MODIFY new_vaccinations BIGINT,
  MODIFY new_vaccinations_smoothed BIGINT,
  MODIFY total_vaccinations_per_hundred DECIMAL(6,2),
  MODIFY people_vaccinated_per_hundred DECIMAL(6,2),
  MODIFY people_fully_vaccinated_per_hundred DECIMAL(6,2),
  MODIFY new_vaccinations_smoothed_per_million BIGINT,
  MODIFY stringency_index DECIMAL(6,2),
  MODIFY population BIGINT,
  MODIFY population_density DECIMAL(14,4),
  MODIFY median_age DECIMAL(4,1),
  MODIFY aged_65_older DECIMAL(6,3),
  MODIFY aged_70_older DECIMAL(6,3),
  MODIFY gdp_per_capita DECIMAL(16,4), # widened to handle large values safely
  MODIFY extreme_poverty DECIMAL(6,2),
  MODIFY cardiovasc_death_rate DECIMAL(12,5), # widened precision
  MODIFY diabetes_prevalence DECIMAL(6,2),
  MODIFY female_smokers DECIMAL(6,2),
  MODIFY male_smokers DECIMAL(6,2),
  MODIFY handwashing_facilities DECIMAL(12,5), # widened precision
  MODIFY hospital_beds_per_thousand DECIMAL(6,2),
  MODIFY life_expectancy DECIMAL(5,2),
  MODIFY human_development_index DECIMAL(4,3);
# this truncated a lot of decimals, but I'm fine with that


-- 5. test
Select * 
From `Portfolio Project`.covid_deaths
Order by 3, 4
Limit 200
;
# tables now look like the CSVs as displayed in excel, with good data types and the date properly formatted. 
