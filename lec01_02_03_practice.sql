#####################################################################
# LECTURE-1
#####################################################################

# There are four coding errors in the following statement. Can you identify them?
SELECT employee_id, last_name, salary * 12 'ANNUAL SALARY'
FROM employees;

# The HR department wants a query to display all unique job IDs from the EMPLOYEES table.
select distinct job_id
from employees;

/*The HR department wants a query to display the last name, job ID, hire date, and
employee ID for each employee, with the employee ID appearing first. Provide an
alias STARTDATE for the HIRE_DATE column.*/
select employee_id, last_name, job_id, hire_date as STARTDATE
from employees;


/*Name the column headings Emp #, Employee, Job, and Hire Date, respectively.
Then run the query again.*/
select employee_id 'Emp #', last_name 'Employee', job_id 'Job' , hire_date as 'Hire Date'
from employees;

/*The HR department has requested a report of all employees and their job IDs. Display
the last name concatenated with the job ID (separated by a comma and space) and
name the column Employee and Title.*/
select concat(last_name,' , ',job_id) 'Employee and Title'
from employees;

select distinct job_id 'Job #', department_id 'Dept #'
from employees
where last_name;

select distinct job_id 'Job #', department_id 'Dept #'
from employees
where last_name like '%a%'
and last_name like '%e%'
and salary not in (5000, 6000, 7000)
order by department_id desc;

SELECT DISTINCT job_id AS 'Job #', department_id AS 'Dept #' 
FROM employees 
WHERE (last_name LIKE '%a%' OR last_name LIKE '%e%') 
AND salary NOT IN (5000, 6000, 7000) 
ORDER BY department_id DESC;


#####################################################################
# LECTURE-2
#####################################################################

use hr;
/*Because of budget issues, the HR department needs a report that displays the last
name and salary of employees who earn more than $12,000.*/
select last_name, salary
from employees
where salary > 12000;

/*Create a report that displays the last name and department number for employee number 176.*/
select last_name, department_id
from employees
where employee_id = 176;

/*The HR department needs to find high-salary and low-salary employees. 
Display the last name and salary for any employee whose salary
is not in the range of $5,000 to $12,000.*/

select last_name, salary
from employees
where salary not between 5000 and 12000;

/*Create a report to display the last name, job ID, and hire date for employees with the
last names of Matos and Taylor. Order the query in ascending order by the hire date.*/

select last_name, job_id, hire_date "hire date"
from employees
where last_name in ('Matos', 'Taylor')
order by "hire_date" desc;

/*Display the last name and department ID of all employees in departments 20 or 50 in
ascending alphabetical order by name.*/

select last_name, department_id
from employees
where department_id in (20,50)
order by last_name;

/*display the last name and salary of employees who earn
between $5,000 and $12,000, and are in department 20 or 50. Label the columns
Employee and Monthly Salary, respectively.*/

select last_name Employee, salary 'Monthly Salary'
from employees
where salary between 5000 and 12000
and department_id in (20,50)
order by 'Monthly Salary', 1;


/*The HR department needs a report that displays the last name and hire date for all
employees who were hired in 1999. YEAR() function */

select last_name, hire_date
from employees
where hire_date between '1999-01-01' and '1999-12-31';

/*Create a report to display the last name and job title of all employees who do not have a manager.*/

Select last_name, job_id
From employees
Where manager_id is null;


/*Create a report to display the last name, salary, and commission of all employees who
earn commissions. Sort data in descending order of salary and commissions.
Use the column’s numeric position in the ORDER BY clause.*/

Select last_name, salary, commission_pct
From employees
Where commission_pct is not null
Order by 2 DESC, 3;

/*Display all employee last names in which the third letter of the name is “a.”*/

Select last_name 
From employees
Where last_name like '__a%';

/*Display the last names of all employees who have both an “a” and an “e” in their last name.*/

Select last_name 
From employees
Where last_name like '%a%'
AND last_name like '%e%';

/*Display the last name, job, and salary for all employees whose jobs are either those of
a sales representative or of a stock clerk, and whose salaries are not equal to $2,500,
$3,500, or $7,000.*/

Select last_name, job_id, salary
From employees
Where job_id in ('ST_CLERK', 'SA_REP')
AND salary not in (2500, 3500, 7000);

/*Display the last name, salary, and commission for all employees whose commission is 20%*/

Select last_name, salary, commission_pct
From employees
Where commission_pct = 0.2;


#####################################################################
# LECTURE-3
#####################################################################

select * from locations;
select * from countries;

/*Write a query for the HR department to produce the addresses of all the departments. 
Use the LOCATIONS and COUNTRIES tables. Show the location ID, street address, 
city, state or province, and country in the output. Use a NATURAL JOIN to produce 
the results. */

Select location_id, street_address, city, state_province, country_id, country_name
From departments
Natural join locations
Natural join countries;


/*The HR department needs a report of all employees. Write a query to display the last 
name, department number, and department name for all the employees. */
# left outer -- employees with no department included

Select last_name, d.department_id, department_name
From employees e
Left outer join departments d
On(e.department_id = d.department_id);

/*The HR department needs a report of employees in Toronto. Display the last name, 
job, department number, and department name for all employees who work in 
Toronto. */

# step 1
select * from locations;

# step 2
select * 
from locations
where city = "Toronto";

# step 3 - natural join departments
select * 
from departments
natural join locations
where city = "Toronto";

# step 4 - natural join employees
select * 
from employees
natural join departments
natural join locations
where city = "Toronto";

select * from employees;
select * from departments;
select * from locations;

# step 5 - putting it all together
Select last_name, job_id, department_id, department_name
from employees
natural join departments
natural join locations
where city = "Toronto";

# Alternative 
# step 5 - putting it all together
Select last_name, job_id, department_id, department_name
from employees 
join departments 
using(department_id)
join locations
using(location_id)
where city = "Toronto";

# Alternative 
Select last_name, job_id, e.department_id, department_name
from employees e 
join departments d
on(e.department_id = d.department_id)
join locations l
on(d.location_id = l.location_id)
where city = "Toronto";

# Alternative - without join
Select last_name, job_id, e.department_id, department_name
from employees e, departments d, locations l
where e.department_id = d.department_id
and d.location_id = l.location_id
and city = "Toronto";

/*Create a report to display employees’ last names and employee number along with 
their managers’ last names and manager number. Label the columns Employee, 
Emp#, Manager, and Mgr#, respectively. Run the query. */
# Self - Join

select e.last_name Employee, e.employee_id  "Emp#", m.last_name Manager, m.employee_id "Mgr#"
from employees e
join employees m
on (e.manager_id = m.employee_id);

select e.last_name Employee, e.employee_id  "Emp#", m.last_name Manager, m.employee_id "Mgr#"
from employees e, employees m
where (e.manager_id = m.employee_id);

/*Display all employees including King, who has no 
manager. Order the results by the employee number. */
# Self - Join

select e.last_name Employee, e.employee_id  "Emp#", m.last_name Manager, m.employee_id "Mgr#"
from employees e
left outer join employees m
on (e.manager_id = m.employee_id)
order by 2;

/*Create a report for the HR department that displays employee last names, department 
numbers, and all the employees who work in the same department as a given 
employee. Give each column an appropriate label. */
# Self - Join

select e1.last_name Employee, e1.department_id "Dept#"
from employees e1
join employees e2
on(e1.department_id = e2.department_id)
where e2.employee_id = 101;

# Custom Try
select e1.last_name Employee, e1.department_id "Dept#", e2.last_name Employee, e2.department_id "Dept2#"
from employees e1
join employees e2
on(e1.department_id = e2.department_id)
where e1.last_name = 'Kochhar';

# Custom Try
select * 
from employees
where employee_id = 101;

# two seperate queries
select department_id 
from employees
where employee_id = 101;

select last_name
from employees
where department_id = 90;


/*The HR department needs a report on job grades and salaries. To familiarize yourself 
with the JOB_GRADES table, first show the structure of the JOB_GRADES table. Then 
create a query that displays the name, job, department name, salary, and grade for all 
employees. */


desc JOB_GRADES;

# first join = EQUIJOIN
# second join = NONEQUIJOIN

Select last_name, job_id, department_name, salary, grade
from employees e
left outer join departments d
on(e.department_id = d.department_id)
left outer join job_grades j
on(e.salary between j.lowest_sal and j.highest_sal);

# alternative to between ... and ...
Select last_name, job_id, department_name, salary, grade
from employees e
left outer join departments d
on(e.department_id = d.department_id)
left outer join job_grades j
on(e.salary >= j.lowest_sal and  e.salary <= j.highest_sal);


/*The HR department wants to determine the names of all employees who were hired 
after Davies. Create a query to display the name and hire date of any employee hired 
after employee Davies. */
# SELF JOIN

# step 1
# find Davies
select * from employees
where last_name = 'Davies';

# find empl hired after hire_date of DAvies
select * from employees
where hire_date > '1997-01-29';

# put together
select e2.last_name, e2.hire_date
from employees e1
join employees e2
on(e1.hire_date < e2.hire_date)
where e1.last_name = 'Davies';

/*The HR department needs to find the names and hire dates for all employees who 
were hired before their managers, along with their managers’ names and hire dates. 
Save the script to a file named lab_06_09.sql. */
# SELF JOIN

select e.last_name, e.hire_date, m.last_name, m.hire_date
from employees e
left outer join employees m
on(e.manager_id = m.employee_id)
where (e.hire_date > m.hire_date);

/*
Create a query to display the name and hire date of any employee hired after his/her manager. 
Display the last name concatenated with the first name (separated by a comma and space) and name the column First and Last Name. 
Provide an alias STARTDATE for the hire_date column. 
Sort data in descending order of employee's hire_date. Use the column's numeric position in the ORDER BY clause.

*/

select concat(e.last_name, ', ', e.first_name) 'First and Last Name', e.hire_date STARTDATE
from employees e
left outer join employees m
on(e.manager_id = m.employee_id)
where (e.hire_date > m.hire_date)
order by 2 desc;

SELECT CONCAT(last_name, ', ', first_name) AS 'First and Last Name', hire_date AS STARTDATE
FROM employees e1
WHERE hire_date > (SELECT hire_date FROM employees e2 WHERE e2.employee_id = e1.manager_id)
ORDER BY 2 DESC, 1;
