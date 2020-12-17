-- 2. Подумать, какие операции являются транзакционными, и написать несколько примеров с транзакционными запросами.

SET AUTOCOMMIT = 0;
 
 BEGIN;
	INSERT INTO employees (emp_no, first_name, last_name, gender, birth_date, hire_date) 
    VALUES (40001345, 'Ant',  'Gru',  'M', '1986-03-10',  CURDATE());
	UPDATE employees 
SET 
    gender = 'F'
WHERE
    emp_no = 40001345;
	UPDATE employees 
SET 
    birth_date = '1970-01-01'
WHERE
    emp_no = 40001345;
    INSERT INTO salaries (emp_no, salary, from_date, to_date) 
    VALUES (40001345, '100', '1996-03-10',  CURDATE());
UPDATE salaries 
SET 
    salary = 150000
WHERE
    emp_no = 40001345; 
    INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date) 
    VALUES (40001345, 'd001',  CURDATE(), '9999-01-01');
 COMMIT;
 
SET AUTOCOMMIT = 1;
 
SELECT 
    *
FROM
    employees
WHERE
    emp_no = 40001345;
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = 40001345;


-- 3. Проанализировать несколько запросов с помощью EXPLAIN.
 
USE employees;

EXPLAIN
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
 
EXPLAIN
SELECT
	dp.dept_name  AS dept_name,
    COUNT(1)      AS emp_number,
	AVG(s.salary) AS avg_salary,
    MAX(s.salary) AS max_salary,
    MIN(s.salary) AS min_salary
FROM departments dp
JOIN dept_emp AS de
	ON dp.dept_no = de.dept_no
JOIN salaries AS s 
	ON de.emp_no = s.emp_no
GROUP BY dp.dept_name;