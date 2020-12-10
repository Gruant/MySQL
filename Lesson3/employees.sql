SELECT 
    dept_name, AVG(salary) AS avg_salary
FROM
    departments AS d
        JOIN
    dept_emp AS de ON d.dept_no = de.dept_no
        JOIN
    salaries AS s ON de.emp_no = s.emp_no
GROUP BY dept_name;


SELECT 
    CONCAT(first_name, ' ', last_name) employees,
    MAX(salary) AS max_salary
FROM
    employees AS e
        JOIN
    salaries AS s ON e.emp_no = s.emp_no
GROUP BY employees
ORDER BY max_salary DESC;


DELETE FROM employees AS e
WHERE
    emp_no = (SELECT 
        emp_no
    FROM
        salaries
    ORDER BY salary DESC
    LIMIT 1);


SELECT 
    d.dept_name, COUNT(emp_no) AS emp_count
FROM
    dept_emp
        JOIN
    departments d ON dept_emp.dept_no = d.dept_no
GROUP BY dept_emp.dept_no
ORDER BY emp_count;

SELECT 
    d.dept_name AS department,
    COUNT(DISTINCT de.emp_no) AS emp_count,
    SUM(s.salary) AS salary_sum
FROM
    dept_emp as de
        JOIN
    departments d ON de.dept_no = d.dept_no
        JOIN
    salaries s ON de.emp_no = s.emp_no
GROUP BY department;



