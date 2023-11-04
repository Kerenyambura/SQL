#checking the auditor report against the employee report
WITH incorrect_records AS(
	SELECT 
		ar.location_id,
		ar.true_water_source_score AS auditor_score,
		wq.subjective_quality_score AS surveyor_score,
		v.record_id,
        ar.statements
	FROM 
		md_water_services.visits v
	JOIN 
		md_water_services.water_quality wq
	ON 
		v.record_id=wq.record_id
	JOIN 
		md_water_services.auditor_report ar
	ON 
		v.location_id=ar.location_id
	WHERE  
		#ar.true_water_source_score = wq.subjective_quality_score #check to see which sites visited have the same value as the ones visited by audotor
		ar.true_water_source_score != wq.subjective_quality_score #check to see which sites visited are not the same as the auditor
		AND v.visit_count = 1),
    

    #check for disparity in the water source
    incorrect_source AS(
	SELECT 
		ar.location_id,
		ar.true_water_source_score AS auditor_score,
		wq.subjective_quality_score AS surveyor_score,
		v.record_id,
		ws.type_of_water_source AS surveyor_source,
		ar.type_of_water_source AS auditor_source
	FROM 
		md_water_services.visits v
	JOIN 
		md_water_services.water_quality wq
	ON 
		v.record_id=wq.record_id
	JOIN 
		md_water_services.auditor_report ar
	ON 
		v.location_id=ar.location_id
	JOIN 
		md_water_services.water_source ws
	ON 
		ws.source_id = v.source_id
	WHERE  
		#ar.true_water_source_score = wq.subjective_quality_score #check to see which sites visited have the same water source as the ones visited by audotor
		ar.true_water_source_score != wq.subjective_quality_score #check to see which sites visited are not the same water source as the auditor
		AND v.visit_count = 1),


#join the auditor report and the visits report to check which employees were making errors
employee_error AS(
	SELECT 
		ar.location_id,
		ar.true_water_source_score AS auditor_score,
		wq.subjective_quality_score AS surveyor_score,
		v.record_id,
		e.employee_name
	FROM 
		md_water_services.visits v
	JOIN 
		md_water_services.employee e
	ON 
		v.assigned_employee_id = e.assigned_employee_id
	JOIN 
		md_water_services.auditor_report ar
	ON 
		v.location_id=ar.location_id
	JOIN 
		md_water_services.water_quality wq
	ON 
		v.record_id=wq.record_id
	WHERE  
		-- ar.true_water_source_score = wq.subjective_quality_score check to see which sites visited have the same water source as the ones visited by audotor
		ar.true_water_source_score != wq.subjective_quality_score #check to see which sites visited are not the same water source as the auditor
        AND v.visit_count = 1),

-- count the number of employees with errors
/*SELECT COUNT(DISTINCT employee_name ) AS number_of_employees_with_errors
FROM employee_error
*/
-- count the mistakes per each employee
error_count AS(
	SELECT 
		employee_name,
		COUNT(*) AS number_of_mistakes
	FROM employee_error
	GROUP BY employee_name),
    
    -- CTE to calculate the average number of mistakes
avg_error_count AS (
    SELECT AVG(number_of_mistakes) AS avg_error_count_per_empl
    FROM error_count)

-- -- Select employees with more mistakes than the average

SELECT
    ec.employee_name,
    ec.number_of_mistakes
FROM
    error_count ec
JOIN
    avg_error_count ae
ON
    ec.number_of_mistakes > ae.avg_error_count_per_empl

-- show the records of the employees with the most mistakes
 -- CTE to calculate the average number of mistakes
 /*
 suspect_list AS 
	(
		SELECT 
			er.employee_name, 
            ir.statements,
            ir.location_id
		FROM 
			incorrect_records ir
		JOIN 
			employee_error er
		JOIN 
			avg_error_count ac
		WHERE 
			employee_name IN ('Zuriel Matembo', 'Malachi Mavuso', 'Lalitha Kaburi', 'Bello Azibo')
		GROUP BY 
			er.employee_name, 
            ir.statements,  ir.location_id)
 SELECT *
FROM suspect_list
WHERE statements LIKE '% cash %' */

/*suspect_list AS (
    SELECT ec1.employee_name, ec1.number_of_mistakes
    FROM error_count ec1
    WHERE ec1.number_of_mistakes >= (
        SELECT AVG(ec2.number_of_mistakes)
        FROM error_count ec2
        WHERE ec2.employee_name = ec1.employee_name))
SELECT *
FROM suspect_list*/
;




