SELECT *
FROM md_water_services.employee
WHERE position = 'Civil Engineer' AND (province_name = 'Dahabu' OR address LIKE '%Avenue%'); 

SELECT *
FROM md_water_services.visits;

SELECT *
FROM md_water_services.water_quality
WHERE subjective_quality_score=10 AND visit_count>=2;

SELECT source_id, number_of_people_served
FROM md_water_services.water_source
ORDER BY number_of_people_served DESC;

SELECT position, province_name, address
FROM md_water_services.employee
WHERE position = 'Civil Engineer' AND (province_name = 'Dahabu' OR address LIKE '%Avenue%'); 

SELECT *
FROM md_water_services.employee
WHERE
    (phone_number LIKE '%86%' OR phone_number LIKE '%11%')
    AND
    ((employee_name LIKE 'A%' OR employee_name LIKE 'M%') OR (employee_name LIKE '% A%' OR employee_name LIKE '% M%'))
    AND
    position = 'Field Surveyor';

SELECT name, pop_n
FROM md_water_services.global_water_access
where name = 'Maji Ndogo';

SELECT * 
FROM md_water_services.employee
WHERE position = 'Micro Biologist';

SELECT *
FROM md_water_services.well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01;

SELECT * 
FROM md_water_services.well_pollution
WHERE description
IN ('Parasite: Cryptosporidium', 'biologically contaminated')
OR (results = 'Clean' AND biological > 0.01);

