create database motor_record;
use motor_record;


-- 1. total number of vehicle stolen
select count(*) from stolen_vehicles;

-- 2. Number of region
select count(distinct region) from locations;


-- Data cleaning
set sql_safe_updates = 0;
alter table stolen_vehicles  add new_date_stolen date;
update stolen_vehicles
set new_date_stolen = str_to_date(date_stolen, "%m/%d/%Y");


-- Analysis
-- 1. stolen vehicle days
select distinct dayname(new_date_stolen) as day, count(ï»¿vehicle_id) as numbers  from stolen_vehicles
group by day
order by numbers desc;

-- 2. types of vehicle based on region
create view data as
(select s.vehicle_type, l.region
from stolen_vehicles s join locations l using (location_id));

select region, vehicle_type, count(vehicle_type),
rank() over ( partition by region order by count(vehicle_type) desc) as numbers
from data
group by region, vehicle_type;

with new_table as
(select region, vehicle_type, count(vehicle_type),
rank() over ( partition by region order by count(vehicle_type) desc) as numbers
from data
group by region, vehicle_type)

select * from new_table where numbers = 1;

-- 3. age of vehicle based on behicle type
select model_year, vehicle_type, count(vehicle_type) as numbers
from stolen_vehicles
group by 1, 2
having numbers> 40
order by numbers desc
;

-- 4. region with high and low vehicle stolen, with density
with data as
(select s.vehicle_type, l.region, l.density
from stolen_vehicles s join locations l using (location_id))

select region, density, count(vehicle_type) as numbers
from data
group by region, density
order by numbers desc;


