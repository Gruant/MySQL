-- Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3.

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `emp_count_by_dept` AS
    SELECT 
        `d`.`dept_name` AS `dept_name`,
        COUNT(`dept_emp`.`emp_no`) AS `emp_count`
    FROM
        (`dept_emp`
        JOIN `departments` `d` ON ((`dept_emp`.`dept_no` = `d`.`dept_no`)))
    GROUP BY `dept_emp`.`dept_no`
    ORDER BY `emp_count`;
    
-- Создать функцию, которая найдет менеджера по имени и фамилии.

USE `employees`;
DROP function IF EXISTS `employees`.`get_Manager`;
;

DELIMITER $$
USE `employees`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_Manager`(firstName VARCHAR(64) CHARACTER SET utf8, lastName VARCHAR(64) CHARACTER SET utf8) RETURNS int
    DETERMINISTIC
BEGIN
DECLARE emp_no INT;
SELECT 
    employees.emp_no
INTO emp_no FROM
    employees AS e
WHERE
    e.first_name = firstName
        AND e.last_name = lastName;
RETURN emp_no;
END$$

DELIMITER ;
;

-- Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.

DROP TRIGGER IF EXISTS `employees`.`salaries_BEFORE_INSERT`;

DELIMITER $$
USE `employees`$$
CREATE DEFINER = CURRENT_USER TRIGGER `employees`.`salaries_BEFORE_INSERT` BEFORE INSERT ON `salaries` FOR EACH ROW
BEGIN
INSERT INTO salaries SET emp_no=new.emp_no, salary=45000, from_date=now(), to_date=now();
END$$
DELIMITER ;
