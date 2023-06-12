
#####################################################################
# LECTURE-4 SLIDES
#####################################################################

# returns datetime
select sysdate();

desc departments;

select * from departments;

insert into departments(department_id, department_name, manager_id, location_id)
values (280, 'Public Relations', 100, 1700);

insert into departments
values (290, 'Private Relations', NULL, 1700);

select * from employees;

delete from employees
where employee_id = 113;

INSERT INTO employees (employee_id, 
                 first_name, last_name, 
                 email, phone_number,
                 hire_date, job_id, salary, 
                 commission_pct, manager_id,
                 department_id)
VALUES		   (113, 
                 'Louis', 'Popp', 
                 'LPOPP', '515.124.4567', 
                 '1999-01-01', 'AC_ACCOUNT', 6900, 
                 NULL, 205, 110);
                 
## incorrect date value for sysdate() function
## accepts only date not datetime
                 
INSERT INTO employees (employee_id, 
                 first_name, last_name, 
                 email, phone_number,
                 hire_date, job_id, salary, 
                 commission_pct, manager_id,
                 department_id)
VALUES		   (207, 
                 'Ali', 'Erkan', 
                 'AERKAN', '515.124.4567', 
                 sysdate(), 'AC_ACCOUNT', 6900, 
                 NULL, 205, 110);				

update employees
set department_id = 50
where employee_id = 207;

select employee_id, last_name, job_id, salary, commission_pct
from employees
where job_id like '%REP%';

select job_id, salary, commission_pct
from employees
WHERE employee_id in (113, 205);

SELECT commission_pct
FROM employees
WHERE employee_id = 160;

#### Does not allow to update the same table as in the subquery
UPDATE   employees
SET      job_id  = (SELECT  job_id 
                    FROM    employees 
                    WHERE   employee_id = 205), 
         salary  = (SELECT  salary 
                    FROM    employees 
                    WHERE   employee_id = 205),
		commission_pct = (SELECT commission_pct 
        FROM employees
        WHERE employee_id = 160)
WHERE    employee_id    =  113;

### Alternative - run each subquery and replace
UPDATE   employees
SET      job_id  = 'PU_MAN', 
         salary  = 12000,
         department_id = 280
WHERE    employee_id    =  207;

#### Before deletion, look at table

SELECT department_name, department_id
                 FROM   departments
                 WHERE  department_name 
                        LIKE '%Public%';

DELETE FROM employees
WHERE  department_id = 280;



#####################################################################
# LECTURE-4 PRACTICE
#####################################################################

/** MySQL **/
CREATE TABLE my_employee
  (id  INT  NOT NULL,
   last_name VARCHAR(25),
   first_name VARCHAR(25),
   userid  VARCHAR(8),
   salary  DECIMAL(8,2));
   
# deletes table
drop table my_employee;

# Autocommit off for this session
SET autocommit = 0;

select * from my_employee;
/*Create an INSERT statement to add the below row of data to the MY_EMPLOYEE table
from the following sample data. Do not list the columns in the INSERT clause

ID, LAST_NAME, FIRST_NAME, USERID, SALARY
1, PAtel, Ralph, rpatel, 895*/
insert into my_employee
values(1, 'Patel', 'Ralph', 'rpatel', 895);

desc my_employee;

/*Populate the MY_EMPLOYEE table with the below row. 
This time, list the columns explicitly in the INSERT clause.

ID, LAST_NAME, FIRST_NAME, USERID, SALARY
2, Dancs, Betty, bdancs, 860
Confirm your addition to the table.*/
## You can change the place of the columns because specified

insert into my_employee (LAST_NAME, FIRST_NAME, USERID, SALARY, ID)
values ('Dancs', 'Betty', 'bdancs', 860, 2);

select * from my_employee;

/*Populate the MY_EMPLOYEE table with the below row. 
This time, list the columns explicitly in the INSERT clause.

ID, LAST_NAME, FIRST_NAME, USERID, SALARY
3, Biri, Ben, bbiri, 1100

Confirm your addition to the table.*/
insert into my_employee (ID, LAST_NAME, FIRST_NAME, USERID, SALARY)
values (3, 'Biri', 'Ben', 'bbiri', 1100);

#####################################################################
# TRANSACTION CONTROL  PRACTICE
#####################################################################
SET SQL_SAFE_UPDATES = 0;
SET SESSION autocommit = 0;

# SET SQL_SAFE_UPDATES = 1;

# Make the data addition permanent.
# deletes savepoints
commit;

# Change the last name of employee 3 to Drexler.
select * from my_employee;

update my_employee
set last_name = 'Drexler'
where id = 3;

rollback;

update my_employee set last_name = 'Veli' where id = 2;

#Change the salary to $1,000 for all employees who have a salary less than $900.

update my_employee 
set salary = 1000 
where salary < 900;

#Verify your changes to the table.

/*Delete Betty Dancs from the MY_EMPLOYEE table.
Confirm your changes to the table.*/
delete from my_employee
where first_name = 'Betty' 
and last_name = 'Dancs';
#where id = 2

/*Delete all the rows from the MY_EMPLOYEE table.
Confirm that the table is empty.*/
delete from my_employee;

rollback;

## truncate example

truncate table my_employee;

## checkpoint

savepoint insert_to_table;

rollback to insert_to_table;

#Discard the DELETE operations without discarding the earlier INSERT operation.

#####################################################################
# LECTURE-5 SLIDES
#####################################################################
# no need to use INT(7) for INT

create table hr.EMP(
ID INT unsigned primary key,
LAST_NAME VARCHAR(25) not null,
FIRST_NAME VARCHAR(25),
salary int unsigned check(salary > 1000),
DEPT_ID INT unsigned,
constraint foreign key (dept_id) references departments (department_id)
);

# remove table

drop table emp;

insert into emp values(1, 'Erkan', 'Ali', 12000, 10);

# employee_id not PK in this table
create table dept50
as
select employee_id, last_name, first_name, salary*12 annsal, hire_date
from employees
where department_id = 50;

# Create the EMPLOYEES2 table based on the structure of the EMPLOYEES table, including records. 
# Include only the EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, and DEPARTMENT_ID columns. 
# Name the columns in your new table ID, FIRST_NAME, LAST_NAME, SALARY, and DEPT_ID, respectively.

create table EMPLOYEES2
as
select employee_id ID, first_name FIRST_NAME, last_name LAST_NAME, salary SALARY, department_id DEPT_ID
from employees;

select * from EMPLOYEES2;

drop table EMPLOYEES2;

CREATE TABLE EMPLOYEES2 AS
SELECT employee_id AS ID, first_name AS FIRST_NAME, last_name AS LAST_NAME, salary AS SALARY, department_id AS DEPT_ID
FROM employees;


insert into dept50 
select employee_id, last_name, first_name, salary*12 annsal, hire_date
from employees
where department_id = 80;

alter table dept50 add birthdate date;

alter table dept50 add email VARCHAR(25);

alter table dept50 modify email VARCHAR(50);

alter table dept50 add phone INT(10);

alter table dept50 modify phone VARCHAR(10);

alter table dept50 alter phone set default '+90';

select * from dept50;

insert into dept50
values(999, 'Dimitri', 'Duman', 12000, '1999-01-01', null, null, null);

insert into dept50(employee_id, last_name, first_name, annsal, hire_date)
values(1000, 'DD', 'AA', 12000, '1999-01-01');

alter table dept50 drop column birthdate;

alter table dept50 rename column email to e_mail;

alter table dept50 add primary key (employee_id);

alter table dept50 add unique (e_mail);

desc dept50;

create table emp1 as select * from employees;

select * from emp1;

# assigns as MUL to key in table emp1
alter table emp1 add foreign key
(department_id) references departments (department_id);

alter table emp1 add primary key (employee_id);

alter table emp1 drop primary key;

# alter table emp1 drop foreign key department_id);

#rename table
alter table emp1 rename to emp_test;

desc emp_test;

show create table emp1;








