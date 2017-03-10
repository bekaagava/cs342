-- 1.a
SELECT e.employee_id, e.first_name, e.last_name, j.job_id, end_date 
FROM Employees e JOIN JOB_HISTORY j ON
e.employee_id = j.employee_id
AND end_date IS NOT NULL;

-- 1.b
SELECT e.first_name || ' ' || e.last_name Employee, e.hire_date Employee_HireDate, m.first_name || ' ' || m.last_name Manager, m.hire_date Manager_HireDate
FROM Employees e JOIN Employees m ON e.manager_id = m.employee_id 
AND e.hire_date < m.hire_date
WHERE EXISTS (SELECT * FROM JOB_HISTORY j WHERE e.employee_id = j.employee_id AND j.department_id = m.department_id);

-- 1.c
-- Nested Query
SELECT DISTINCT c.country_name FROM 
COUNTRIES c, LOCATIONS l
WHERE c.country_id = l.country_id
AND EXISTS (SELECT d.department_id FROM DEPARTMENTS d WHERE d.location_id = l.location_id);

-- Join Query 
SELECT DISTINCT c.country_name FROM
COUNTRIES c 
JOIN LOCATIONS l ON c.country_id = l.country_id
JOIN DEPARTMENTS d ON d.location_id = l.location_id;

/* 
The join query is better than the correlated nested sub-query because it is faster. The nested query checks for 
each record that the "where" condition holds whether the condition stipulated in the nested subquery exists - this makes it slower than the join query.
*/