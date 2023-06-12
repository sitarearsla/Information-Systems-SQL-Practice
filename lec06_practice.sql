/*#################################################################################
--LECTURE-6 : SINGLE ROW OP
#################################################################################
*/

select concat('$', Format(salary, 0)), salary Salary
from employees where last_name = 'King'; 

# runs for each row - single row operation
# mysql is not case sensitive 
# no need to use upper / lower in the where conds. 
select concat(lower(last_name), ' ', upper(first_name))
from employees;

# instr returns position of alter
# does not contain a returns 0
# substr starts from the 4th character till end

select employee_id, concat(lower(last_name), ' ', upper(first_name)) full_name, 
job_id, length(last_name), instr(last_name, 'a') a
from employees
where substr(job_id, 4) = 'REP';

# date func
select sysdate() from dual;
select now() from dual;
select curdate() from dual;
select curtime() from dual;

#number functions
/*
round - 
truncate -
mod -
ceil -
floor -
*/

#without dual, you can run - dual dummy table

select round(45.923, 2), round(45.923,0), round(45.923, -1)
from dual;

# no rounding in trunc
select truncate(45.923,2), truncate(45.923), truncate(45.923, -1);

select last_name, salary, mod(salary, 5000)
from employees
where job_id = 'SA_REP';

select last_name, hire_date
from employees
where hire_date < '1998-02-01';

select last_name, hire_date
from employees
where YEAR(hire_date) = '1998';

select last_name, year(hire_date)
from employees;

# SQL does not support + - in date operations as sysdate - hiredate
select last_name, datediff(sysdate(), hire_date) / 7 as weeks, datediff(sysdate(), hire_date) as days
from employees
where department_id = 90;

select last_name, datediff(sysdate(), hire_date) as days
from employees
where department_id = 90;

# timestampdiff - difference according to day- , month, year
select timestampdiff(month, '1995-09-01', sysdate())
from dual;

select timestampdiff(day, '1995-09-01', sysdate())
from dual;

select timestampdiff(year, '1995-09-01', sysdate())
from dual;

# update end of month 30-31 accordingly smart func
select date_add('1995-09-01', interval 2 month);
select date_add('1995-09-01', interval 3 year);
select date_add('1995-09-01', interval 2 day);

select last_day('1995-09-01');

# convert 
select last_name, date_format(hire_date, '%Y-%m-%d')
from employees
where hire_date < str_to_date('1990-01-01', '%Y-%m-%d');

select last_name, date_format(hire_date, '%Y-%m-%d')
from employees
where hire_date < convert('1990-01-01', date);


/*1) Write a query to display the system date. Label the column Date.
Note: If your database is remotely located in a different time zone, the output will be
the date for the operating system on which the database resides.*/

select sysdate() 'Date'
from dual;

/*2) The HR department needs a report to display the employee number, last name, salary,
and salary increased by 15.5% (expressed as a whole number) for each employee.
Label the column New Salary. */

# or round 
select employee_id, last_name, salary, truncate(salary*1.115,0) 'New Salary'
from employees;


/*3) Modify previous query to add a column that subtracts the old salary
from the new salary. Label the column Increase. Run the revised query.*/

select employee_id, last_name, salary, truncate(salary*1.115,0) 'New Salary',
truncate(salary*1.115,0) - salary 'Diff Salary'
from employees;


/*4) Write a query that displays the last name and the length of the last name for all employees whose
name starts with the letters “J,” “A,” or “M.” Give each column an appropriate label.
Sort the results by the employees’ last names.*/

select last_name, length(last_name)
from employees
where substr(last_name, 1, 1) in ('J', 'A', 'M');

/*5) The HR department wants to find the duration of employment for each employee. For
each employee, display the last name and calculate the number of months between
today and the date on which the employee was hired. Label the column
MONTHS_WORKED. Order your results by the number of months employed. Round
the number of months up to the closest whole number.
Note: Because this query depends on the date when it was executed, the values in the
MONTHS_WORKED column will differ for you.*/

select last_name, timestampdiff(month, hire_date, now()) months_worked
from employees
order by months_worked;

/*6) Create a query to display the last name and salary for all employees. Format the
salary to be 15 characters long, left-padded with the $ symbol. Label the column
SALARY.*/

/*7) Create a query that displays the first eight characters of the employees’ last names
and indicates the amounts of their salaries with asterisks. Each asterisk signifies a
thousand dollars. Sort the data in descending order of salary. Label the column
EMPLOYEES_AND_THEIR_SALARIES.*/

/*8) Create a query to display the last name and the number of weeks employed for all
employees in department 90. Label the number of weeks column TENURE. Truncate
the number of weeks value to 0 decimal places. Show the records in descending order
of the employee’s tenure.
Note: The TENURE value will differ as it depends on the date when you run the
query.*/

/*#################################################################################
--LECTURE-6 : SAMPLE MDTERM
#################################################################################
*/

CREATE TABLE HR.m_employees
  (employee_id  INT,
   last_name VARCHAR(25),
   first_name VARCHAR(20),
   email  VARCHAR(25),
   phone_number VARCHAR(20),
   hire_date DATE,
   job_id varchar(10),
   salary  DECIMAL(8,2),
   commision_pct DECIMAL(2,2),
   manager_id INT,
   department_id INT
   );


select d.department_name, MIN(e.salary), MAx(e.salary), AVG(e.salary)
from employees e join departments d
on (e.department_id = d.department_id)
group by d.department_name;


select * from employees e, job_history j
where e.employee_id = j.employee_id;

describe employees;

create view dept_sum_view (name, minsal, maxsal, avgsal)
as select d.department_name, MIN(e.salary), MAx(e.salary), AVG(e.salary)
from employees e join departments d
on (e.department_id = d.department_id)
group by d.department_name; 

select * from dept_sum_view;

select last_name, job_id, hire_date
from employees
where last_name in ('matos', 'taylor')
# where last_name = 'matos' or last_name = 'taylor'
order by hire_date asc;

select last_name Employee, salary 'Monthly Salary', department_name
from hr.employees e 
join hr.departments d
using(department_id)
where salary between 5000 and 12000
and d.department_id in (20, 50);

select department_id, job_id, count(employee_id) d20c
from employees
group by department_id, job_id
order by job_id;

select d10.job_id, Shipping, Finance
from 
(select job_id, count(employee_id) shipping
from employees e, departments d
where e.department_id = d.department_id
and d.department_name = 'Shipping'
group by job_id) d10,
(select job_id, count(employee_id) Finance
from employees e, departments d
where e.department_id = d.department_id
and d.department_name = 'Finance'
group by job_id) d20
where d10.job_id = d20.job_id;

select * from employees;

select * from job_history;

select * from departments;

