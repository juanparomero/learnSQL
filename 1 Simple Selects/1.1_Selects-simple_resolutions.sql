------------------------------------------------------------------------------------------------
-- SIMPLE SELECTS
------------------------------------------------------------------------------------------------
/* 1
Describe the employees table
*/
desc employees;
/* 2
Describe the departments table
*/
desc departments;
/* 3
Describe the locations table
*/
desc locations;
/* 4
Data from the regions table
*/
select *
from regions;
/* 5
Data from the countries table
*/
select *
from countries;
/* 6
City and state of the locations
*/
select city, state_province
from locations;
/* 7
First name, last name, salary of the employees
*/
select first_name, last_name, salary
from employees;
/* 8
Department number, name, and manager_id of the departments
*/
select department_id, department_name, manager_id
from departments;
/* 9
Department number and name, also, the chief employee code,
of location 1700.
*/
select department_id, department_name, manager_id
from departments
where location_id = 1700;
/* 10
First name and department number of the employees.
*/
select first_name, department_id
from employees;
/* 11
First name and department number of the employees
ordered by department number ascending.
*/
select first_name, department_id
from employees
order by department_id asc;
/* 12
List the distinct department numbers in which employees work.
*/
select distinct department_id
from employees;
/* 13
List the distinct department numbers in which employees work
ordered descending.
*/
select distinct department_id
from employees
order by department_id desc;
/* 14
First name, last name, and salary ordered by employee id descending
*/
select first_name, last_name, salary
from employees
order by employee_id desc;
/* 15
First name, last name, and salary ordered by last name ascending and salary descending
*/
select first_name, last_name, salary
from employees
order by last_name asc, salary desc;
/* 16
Codes of the distinct jobs that exist in department 30
*/
select distinct job_id
from employees
where department_id = 30;
/* 17
Codes of the distinct jobs that exist in department 60
ordered descending
*/
select distinct job_id
from employees
where department_id = 30
order by job_id desc;
/* 18
First name, last name, and email of the employees in department 30
whose salary is less than 3000
*/
select first_name, last_name, email
from employees
where department_id = 30
    and salary < 3000;
/* 19
First name, last name, and email of the employees in department 30
whose salary is less than 3000
or who are from department 90
*/
select first_name, last_name, email
from employees
where 
    (department_id = 30
        and salary < 3000)
    or department_id = 90;
/* 20
First name, last name, and department number of the employees
who have no commission. Ordered by department number 
from highest to lowest and by last name descending.
*/
select first_name, last_name, department_id
from employees
where commission_pct is not null
order by 3 asc, 2 desc;
/* 21
First name, last name, department number, and salary of the employees
who have no commission or their salary is less than 6000 
and it is fulfilled that they are from department 60 or 90
ordered by department number descending
and by salary ascending.
*/
select 
    first_name, last_name, department_id, salary
from 
    employees
where 
    (commission_pct is not null OR
    salary < 6000)
    and 
    department_id in (60,90)
order by 
    department_id desc, salary asc;
/* 22
Employee number, first name, and last name of the employees
from the last name that starts with L to those whose last name
starts with R, inclusive.
*/
select employee_id, first_name, last_name
from employees
where last_name between 'L' and 'R';
/* 23
List of last names where the second letter is an 'a'
*/
select last_name
from employees
where last_name like '_a%';
/* 24
List of employee last names where the last name starts with a vowel
and their salary is less than 3000 or more than 9000
and it must be fulfilled that their department is 30, 60, or 90.
*/
select last_name
from employees
where 
    (last_name like 'A%' or
    last_name like 'E%' or
    last_name like 'I%' or
    last_name like 'O%' or
    last_name like 'U%')
    and (salary < 3000 or salary > 9000)
    and department_id in (30,60,90);
/* 25
First name, last name, and salary of the employees
but as salary a label indicating 
'LOW' if it is less than 4280, 'HIGH' if it is more than 15230,
and 'MEDIUM' if it is in between
*/
select first_name,last_name, 
    case  
        when salary < 4280 then 'LOW'
        when salary between 4280 and 15230 then 'MEDIUM'
        else 'HIGH'
    end salary
from employees;
/* 26
List of emails concatenated with the text '@company.com'
*/
select email || '@company.com'
from employees;
/* 27
List of city names where their country is 'US'
*/
select city
from locations
where country_id = 'US';
/* 28
List of city names where their country is not the United States
*/
select city
from locations
where country_id != 'US';
/* 29
Department number and name of the departments that have a chief.
*/
select department_id, department_name
from departments
where manager_id is not null;
/* 30
Department number and name of the departments that do not have a chief.
*/
select department_id, department_name
from departments
where manager_id is null;
/* 31
Names of the columns in the 'Employees' table
that do not have an underscore in the name.
*/
select column_name
from user_tab_columns
where table_name = 'EMPLOYEES'
    and column_name not like '%@_%' escape '@';
--
------------------------------------------------------------------------------------------------