/*#################################################################################
--LECTURE-7*/
/*Practice Solutions 7: Using Conversion Functions and Conditional Expressions
1) Create a report that produces the following for each employee:
<employee last name> earns <salary> monthly but wants <3 times salary.>. Label the
column Dream Salaries.*/

/*2) Display each employee’s last name, hire date, and salary review date, which is the
first Monday after six months of service. Label the column REVIEW. Format the
dates to appear in the format similar to “Monday, the Thirty-First of July, 2000.”*/

/*3) Display the last name, hire date, and day of the week on which the employee started.
Label the column DAY. Order the results by the day of the week, starting with Tuesday.*/

/*4) Create a query that displays the employees’ last names and commission amounts. If
an employee does not earn commission, show “No Commission.” Label the column COMM.*/

select last_name, ifnull(commission_pct, 'No cms') com
from employees;

/*5) Using the CASE function, write a query that displays the grade of all employees
based on the value of the JOB_ID column, using the following data:
Job Grade
AD_PRES A
ST_MAN B
IT_PROG C
SA_REP D
ST_CLERK E
None of the above 0*/

select last_name, job_id, salary,
case job_id when 'AD_PRES' THEN 'a'
when 'ST_MAN' then 'b'
when 'IT_PROG' then 'c'
else 0
end "job_grade"
from employees;

select last_name, 
salary, 
IF(commission_pct IS NULL, salary * 1.3, salary * (1 + commission_pct))
from employees
WHERE salary < 10000;


UPDATE employees 
SET salary = IF(commission_pct IS NULL, salary * 1.3, salary * (1 + commission_pct))
WHERE salary < 10000;

update employees
set salary = if(commission_pct is null, salary * 1.3, salary * (1 + commission_pct))
where salary < 10000;

COMMIT;

select *
from employees
WHERE salary < 12000;

# Q4
UPDATE employees 
SET salary = 
  CASE 
    WHEN commission_pct IS NULL THEN salary * 1.3 
    ELSE salary + (salary * commission_pct) 
  END 
WHERE salary < 10000;

COMMIT;


select avg(salary), max(salary), min(salary)
from employees;

select avg(salary), max(salary), min(salary)
from employees
where job_id like '%rep%';

# count all records with * -- rows 45
select count(*) # null or not null
from employees 
where department_id = 50;

# 
select count(commission_pct)
from employees 
where department_id = 100;

select count(distinct department_id)
from employees;

# nvl -- includes null values as 0 -- ifnull in mySQL
select avg(ifnull(commission_pct, 0))
from employees;

select last_name, salary,
case when department_name = 'IT' then salary * 1.2
when department_name = 'Marketing' then salary * 1.15
when department_name = 'Sales' then salary * 1.1
else salary * 1.05
end 'REVISED SALARY'
from employees e
left outer join departments d
on(e.department_id = d.department_id);

select * 
from employees;
# d.department_name, d.manager_id, e.salary min_salary
select coalesce(d.department_name, 'NULL_Department') 'Department Name', coalesce(d.manager_id, 'NULL_Manager_ID') 'Manager ID', min(e.salary) min_salary
from employees e
left outer join departments d
on(e.department_id = d.department_id)
where e.manager_id is not null
group by d.department_name, d.manager_id
having min_salary > 6000;

select * from employees;

SELECT d.department_name, d.manager_id, MIN(e.salary) AS min_salary
FROM employees e
JOIN departments d 
ON e.department_id = d.department_id
WHERE e.manager_id IS NOT NULL
GROUP BY d.department_name, d.manager_id
HAVING min_salary > 6000
ORDER BY min_salary DESC;

SELECT   job_id, SUM(salary) PAYROLL
FROM     employees
WHERE    job_id NOT LIKE '%REP%'
GROUP BY job_id
HAVING   SUM(salary) > 13000
ORDER BY SUM(salary);

SELECT last_name, salary, 
  CASE 
    WHEN department_name = 'IT' THEN salary * 1.20 
    WHEN department_name = 'Marketing' THEN salary * 1.15 
    WHEN department_name = 'Sales' THEN salary * 1.10 
    ELSE salary * 1.05 
  END AS `REVISED SALARY`
FROM employees
JOIN departments
ON employees.department_id = departments.department_id
ORDER BY department_name ASC;


SELECT last_name, job_id, salary,
       CASE job_id WHEN 'IT_PROG'  THEN  1.10*salary
                   WHEN 'ST_CLERK' THEN  1.15*salary
                   WHEN 'SA_REP'   THEN  1.20*salary
       ELSE      salary END     "REVISED_SALARY"
FROM   employees;

#######

select c.country_name COUNTRY, date_format(min(e.hire_date), '%W %e %M %Y') 'MIN HIRE DATE', date_format(last_day(min(e.hire_date)), '%W %e %M %Y') REVIEW
from employees e
join departments d
on e.department_id = d.department_id
join locations l
on d.location_id = l.location_id
join countries c
on l.country_id = c.country_id
group by COUNTRY;

select c.country_name COUNTRY, date_format(min(e.hire_date), '%W %e %M %Y') 'MIN HIRE DATE', date_format(last_day(min(e.hire_date)), '%W %e %M %Y') REVIEW
from employees e
LEFT OUTER join departments d
on e.department_id = d.department_id
LEFT OUTER join locations l
on d.location_id = l.location_id
LEFT OUTER join countries c
on l.country_id = c.country_id
group by COUNTRY;

select coalesce(d.department_name, 'NULL_Department') 'dept_name', coalesce(d.manager_id, 'NULL_Manager_ID') 'manager_id', min(e.salary) min_salary
from employees e
left outer join departments d
on(e.department_id = d.department_id)
where e.manager_id is not null
group by d.department_name, d.manager_id
having min_salary > 6000
order by min_salary desc;

SELECT c.country_name, 
       DATE_FORMAT(MIN(e.hire_date), '%W %e %M %Y') AS minimum_hire_date, 
       DATE_FORMAT(LAST_DAY(MIN(e.hire_date)), '%W %e %M %Y') AS review
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id
GROUP BY c.country_name;

select * from locations;

select * from countries;

select *  from employees e
WHERE e.hire_date IS NULL; 


select distinct job_id 'Job #', department_id 'Dept #'
from employees
where last_name like '%a%'
or last_name like '%e%'
and salary not in (5000, 6000, 7000)
order by department_id desc;

