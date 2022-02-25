select * from covid_global
limit 10

--top 5 countries with the most no of cases
select country, who_region, total_cases from covid_global
where who_region is not null
order by total_cases desc
limit 5
--Usa, India, Brazil, France, UK

--top 5 countries with the most no of deaths
select country, who_region, total_cases from covid_global
where who_region is not null
order by total_deaths desc
limit 5
--USA, Brazil, India, Russia, Mexico

--USA, Brazil and India are the counties having most no of cases and deaths

--top 5 regions having most no of cases
select who_region, sum(total_cases) as tot_cases
from covid_global
where who_region is not null
group by who_region
order by tot_cases desc
limit 5
--EU, America, South-East Asia, Western pacific, eastern Mediterranean

--top 5 regions having most no of deaths
select who_region, sum(total_deaths) as tot_deaths
from covid_global
where who_region is not null
group by who_region
order by tot_deaths desc
limit 5
--same results

--EU, America, South-East Asia, Western pacific, eastern Mediterranean are the regions having most no of cases and deaths

--countries which had 0 cases and deaths
select country, who_region, total_cases, total_deaths
from covid_global
where cast(total_cases as int) = 0 and cast(total_deaths as int) = 0
--9 countries had 0 cases and deaths

--coutries having highest ratio of death : cases 
select country, who_region, (cast(total_deaths as float)/cast(total_cases as float))*100 as death_prediction
from covid_global
where who_region is not null and total_cases <> 0 and total_deaths <> 0
group by country
order by death_prediction desc
limit 5
--Yemen, Sudan, Peru, Mexico and Syrian Arab republic are the countries having highest death:cases ratio

select * from covid_daily limit 5

--dates on which maximum cases were observed in each country
select date_obs, t1.country, t1.new_cases 
from covid_daily as t1
inner join(
		select country, max(new_cases) as max_new_cases
		from covid_daily 
		where new_cases <> 0
		group by country
	)t2
	on
	t1.country = t2.country and t1.new_cases = t2.max_new_cases 
	
--dates on which maximum deaths were observed in each country
select date_obs, t1.country, t1.new_deaths
from covid_daily as t1
inner join(
		select country, max(new_deaths) as max_new_deaths
		from covid_daily 
		where new_deaths <> 0
		group by country
	)t2
	on
	t1.country = t2.country and t1.new_deaths = t2.max_new_deaths	
		
--month and year having highest cases and deaths
--creating new col
alter table covid_daily
add column year_month text

--filling vaues in new col
update covid_daily
set year_month = to_char(date_obs, 'YYYY-MM')

select year_month, sum(new_cases) as total_new_cases
from covid_daily
group by year_month
order by total_new_cases desc
limit 5
--jan 2022, feb 2022, dec 2021, apr 2021 and may 2021 had the highest no of total_cases

select year_month, sum(new_deaths) as total_new_deaths
from covid_daily
group by year_month
order by total_new_deaths desc
limit 5
-- jan 2021, feb 2021, apr 2021, may 2021 and dec 2020 had the highest no of deaths