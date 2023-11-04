	#create a email addresses for the employees
SELECT 
	employee_name,
    CONCAT(LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov') AS email_address
 FROM md_water_services.employee;
 
	#create a new column in the table
ALTER TABLE 
	md_water_services.employee
ADD COLUMN 
	email_address VARCHAR(255);

	#update the column with the email_adress
SET SQL_SAFE_UPDATES = 0;
UPDATE md_water_services.employee
SET email_address = CONCAT(LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov');

	#remove the space in the phone number column and update the column
UPDATE md_water_services.employee
SET phone_number = TRIM(phone_number);

	#check to see if it has worked
SELECT 
	LENGTH(phone_number)
FROM md_water_services.employee;

	#where employees live
SELECT 
	town_name,
	COUNT(*) AS num_employees
FROM md_water_services.employee
GROUP BY town_name;

	#employees with the most visits
SELECT 
	assigned_employee_id, 
    COUNT(visit_count) AS num_of_visits
FROM md_water_services.visits
GROUP BY assigned_employee_id
ORDER BY num_of_visits DESC
;

	#employee with the most visists info
SELECT 
	employee_name, 
    email_address,
    phone_number
FROM md_water_services.employee
WHERE assigned_employee_id IN (20, 22);

	#counts the number of records per town
SELECT town_name,
	COUNT(*) AS records_per_town
FROM md_water_services.location
GROUP BY town_name;

	#counts the number of records per province
SELECT province_name,
	COUNT(*) AS records_per_town
FROM md_water_services.location
GROUP BY province_name;

	#make sure that the data was collected from ecah town and province
SELECT province_name,town_name,
	COUNT(town_name) AS records_per_town
FROM md_water_services.location
GROUP BY province_name, town_name
ORDER BY province_name, COUNT(town_name) DESC ;

	#records for each location type
SELECT location_type, COUNT(*) AS num_sources
FROM md_water_services.location
GROUP BY location_type;

	#percentage in rural
SELECT 23740 / (15910 + 23740) * 100 AS rural_percentage;

	#number of people served by water sources
SELECT SUM(number_of_people_served) as total_pop_served
FROM md_water_services.water_source;

	#how many water sources are there
SELECT 
	COUNT(type_of_water_source) AS water_sources ,
    type_of_water_source
FROM md_water_services.water_source
GROUP BY type_of_water_source
ORDER BY water_sources DESC;

	#how many peopla share a water source on average?
SELECT 
	COUNT(type_of_water_source) AS water_sources ,
    type_of_water_source,
    ROUND(AVG(number_of_people_served), 0) AS avg_pple_per_source
FROM md_water_services.water_source
GROUP BY type_of_water_source;

	#pop served by water sources
SELECT type_of_water_source, ROUND(SUM(number_of_people_served)/27628140 *100, 0) as pop_served
FROM md_water_services.water_source
GROUP BY type_of_water_source
ORDER BY SUM(number_of_people_served) desc;

	#query that ranks each type of source basedon how many people in total use it.
SELECT 
	type_of_water_source,
    SUM(number_of_people_served) as pop_served,
    RANK() OVER(ORDER BY SUM(number_of_people_served) DESC) AS source_rank
FROM md_water_services.water_source
GROUP BY type_of_water_source
;

	#which shared taps or wells should be fixed first?
SELECT 
	source_id, type_of_water_source,
    SUM(number_of_people_served) as pop_served,
     RANK() OVER (PARTITION BY type_of_water_source ORDER BY SUM(number_of_people_served)) AS priority_rank
FROM md_water_services.water_source
GROUP BY source_id, type_of_water_source
ORDER BY priority_rank desc
;


	#How long did the survey take?
SELECT 
    MIN(time_of_record) AS start_time,
    MAX(time_of_record) AS end_time,
    TIMEDIFF(MAX(time_of_record), MIN(time_of_record)) AS survey_duration
FROM md_water_services.visits;
	
    #average total queue time for water
SELECT AVG(NULLIF(time_in_queue,0)) AS average_queue_time
FROM md_water_services.visits;

	#average queue time on different days?
SELECT
    DAYNAME(time_of_record) AS day_of_week,
    ROUND(AVG(NULLIF(time_in_queue,0)),0) AS average_queue_time
FROM md_water_services.visits
GROUP BY DAYNAME(time_of_record)
ORDER BY DAYNAME(time_of_record);


SELECT
TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
-- Sunday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
ELSE NULL
END
),0) AS Sunday,
-- Monday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
ELSE NULL
END
),0) AS Monday,
-- Tuesday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
ELSE NULL
END
),0) AS Tuesday,
-- Wednesday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
ELSE NULL
END
),0) AS Wednesday,
-- Thurdsday 
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
ELSE NULL
END
),0) AS Thursday,

-- Friday 
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
ELSE NULL
END
),0) AS Friday,
-- Saturday
ROUND(AVG(
CASE
WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
ELSE NULL
END
),0) AS Saturday
FROM md_water_services.visits
WHERE
time_in_queue != 0 -- this excludes other sources with 0 queue times
GROUP BY
hour_of_day
ORDER BY
hour_of_day;