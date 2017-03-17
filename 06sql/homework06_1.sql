-- Homework 06 

-- Exercise 1.a
SELECT * FROM (
SELECT m.employee_id, m.first_name|| ' ' || m.last_name Full_Name, COUNT(1) "Number_Of_Employees"
FROM EMPLOYEES m JOIN EMPLOYEES e 
ON m.employee_id = e.manager_id
GROUP BY m.employee_id, m.first_name, m.last_name
ORDER BY COUNT(1) DESC)
WHERE ROWNUM <= 10;

-- Exercise 1.b
SELECT d.department_name, COUNT(1) Employee#, SUM(e.salary) Total_Salary
FROM DEPARTMENTS d JOIN LOCATIONS l
ON d.location_id = l.location_id
AND l.country_id <> 'US'
JOIN EMPLOYEES e
ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(1) < 100;

-- Exercise 1.c
SELECT d.department_name Dept_Name, m.first_name || ' ' || m.last_name Full_Name, j.job_title
FROM DEPARTMENTS d
LEFT JOIN EMPLOYEES m ON d.manager_id = m.employee_id
LEFT JOIN JOBS j ON m.job_id = j.job_id;

-- Exercise 1.d
SELECT d.department_name, AVG(e.salary) Average_Salary
FROM DEPARTMENTS d 
LEFT JOIN EMPLOYEES e ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY AVG(e.salary) DESC;