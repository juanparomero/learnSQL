
------------------------------------------------------------------------------------------------
-- SELECT with Subqueries and JOINS
------------------------------------------------------------------------------------------------
-- 1
-- First name and last name of the highest earning employee.
select first_name, last_name
from employees
where salary = (
    select max(salary) 
    from employees);
-- 2
-- First name, last name, and salary of employees who earn more than the average salary.
select first_name, last_name, salary
from employees
where salary > (
    select avg(salary) 
    from employees);
-- 3
-- First name and last name of the head of the Marketing department.
select first_name, last_name
from employees
where employee_id = (
    select manager_id 
    from departments 
    where department_name='Marketing');
-- 4
-- First name and last name of the employees in the Marketing department.
select first_name, last_name
from employees
where department_id = (
    select department_id 
    from departments 
    where department_name = 'Marketing');
--
select 
    first_name, 
    last_name
from 
    employees
    join departments on employees.department_id = departments.department_id
where
    department_name = 'Marketing';
-- 5
-- First name, last name, salary, department name, and city
-- of the highest and lowest earning employee.
select 
    first_name, 
    last_name, 
    salary, 
    department_name, 
    city
from 
    employees
    join departments on employees.department_id = departments.department_id
    join locations on departments.location_id = locations.location_id
where 
    salary = (select max(salary) from employees)
    or salary = (select min(salary) from employees);
-- 6
-- Number of employees and number of departments by city (name).
select 
    locations.city,
    count(employee_id) count_employees,
    count(distinct departments.department_id) count_departments
from
    employees
    join departments on employees.department_id = departments.department_id
    join locations on departments.location_id = locations.location_id
group by
    locations.city;
-- 7
-- Number of employees and number of departments in all cities (name)
-- ordered by number of employees in descending order.
select 
    locations.city,
    count(employee_id) count_employees,
    count(distinct departments.department_id) count_departments
from
    employees
    right join departments on employees.department_id = departments.department_id
    right join locations on departments.location_id = locations.location_id
group by
    locations.city
order by
    2 desc;
-- 8
-- Display the employee number, first name, and last name of the employees
-- who are heads both of departments and of other employees
-- indicating in a single column with the literal 'DEP' if they are a department head
-- and 'EMP' if they are a head of another employee. Ordered by employee number.
select employee_id, first_name, last_name,'DEP' "Head"
from employees
where employee_id in (select manager_id from departments)
union
select employee_id, first_name, last_name, 'EMP' "Head"
from employees e
where employee_id in (select manager_id from employees)
order by 1;
-- 9
-- List the first name, last name, and salary of the top three highest earning employees.
select first_name, last_name, salary
from (select first_name, last_name, salary 
    from employees 
    order by salary desc)
where rownum < 4;
-- 10
-- Imagine we want to create usernames for email addresses.
-- The format is the first letter of the first name followed by the last name.
-- We want to know if there are any duplicates in the list of first names and last names.
select 
    employees.first_name, 
    employees.last_name
from 
    employees 
    join 
        (select substr(first_name,1,1) first_letter, last_name
        from employees
        group by substr(first_name,1,1), last_name
        having count(*) > 1) morethanone  
    on(employees.last_name = morethanone.last_name 
        and morethanone.first_letter = substr(first_name,1,1));
-- 11
-- List first name, last name, and a literal indicating the salary.
-- 'LOW' if the salary is less than the lowaverage (average between the minimum salary and the average salary)
-- 'HIGH' if the salary is more than the highaverage (average between the maximum salary and the average salary)
-- 'MEDIUM' if the salary is between lowaverage and highaverage.
select 
    first_name,
    last_name, 
    case  
        when salary < lowaverage then 'LOW'
        when salary between lowaverage and highaverage then 'MEDIUM'
        else 'HIGH'
    end salary
from 
    employees 
    join (
        select department_id, 
            trunc((avg(salary)+min(salary))/2) lowaverage, 
            trunc((avg(salary)+max(salary))/2) highaverage
        from employees
        group by department_id) averages
    on(employees.department_id = averages.department_id);
-- 12
-- Number of employees hired per day
-- between two dates. For example: between 1997-10-10 and 1998-03-07
-- and for one or more cities. For example: Seattle, Rome
-- (Assume this is a query that will be adapted to variables,
-- meaning the cities or date range varies.
-- In the application, drop-down lists are used to select the values,
-- but these are then replaced in the query.)
-- Here, we use fixed example values.
select 
    count(employees.employee_id) count_employees,
    to_char(hire_date,'yyyy-mm-dd') day
from
    employees
    join departments on employees.department_id = departments.department_id
    join locations on departments.location_id = locations.location_id
where
    locations.city in ('Seattle','Rome')
    and hire_date 
        between to_date('1997-10-10','yyyy-mm-dd') 
        and to_date('1998-03-07','yyyy-mm-dd')
group by
    to_char(hire_date,'yyyy-mm-dd')
order by
    day asc;
-- 13
-- A list indicating on separate lines
-- a label that describes the value and the value itself:
-- the number of employees in Seattle, 
-- the number of departments with employees in Seattle
-- the number of departments without employees in Seattle
-- the number of employee managers in Seattle
-- the number of department heads in Seattle
select 
    'count_employees' Label,
    count(employee_id) Value
from
    employees
    join departments on employees.department_id = departments.department_id
    join locations on departments.location_id = locations.location_id
where
    locations.city = 'Seattle'
union
select 
    'count_departments_has_employees' Label,
    count(distinct departments.department_id) Value
from
    employees
    join departments on employees.department_id = departments.department_id
    join locations on departments.location_id = locations.location_id
where
    locations.city = 'Seattle'
union
select 
    'count_departments_hasnot_employees' Label,
    count(departments.department_id) Value
from
    employees
    right join departments on employees.department_id = departments.department_id
    left join locations on departments.location_id = locations.location_id
where
    locations.city = 'Seattle'
    and employees.department_id is null
union
select 
    'count_managers_employees' Label,
    count(distinct employees.manager_id) Value
from
    employees
    join departments on employees.department_id = departments.department_id
    join locations on departments.location_id = locations.location_id
where
    locations.city = 'Seattle'
union
select 
    'count_managers_departments' Label,
    count(distinct departments.manager_id) Value
from
    departments
    join locations on departments.location_id = locations.location_id
where
    locations.city = 'Seattle';
-- 14
-- First name, last name, email, department_name
-- of the employees in the department with the most employees.
select 
    employees.first_name, 
    employees.last_name, 
    employees.email, 
    departments.department_name
from 
    employees
    join departments on employees.department_id = departments.department_id
where
    employees.department_id in (
        select department_id
        from employees
        group by department_id
        having count(employee_id) = (
            select max(count_employees)
            from (
                select count(employee_id) count_employees
                from employees
                group by department_id
                )
            )
        );
--
select 
    employees.first_name, 
    employees.last_name, 
    employees.email, 
    departments.department_name
from 
    employees
    join departments on employees.department_id = departments.department_id
where
    employees.department_id in (
        select department_id
        from employees
        group by department_id
        having count(employee_id) = (
            select max(count(employee_id))
            from employees
            group by department_id
            )
        );
-- 15
-- What is the date on which the most employees
-- were hired?
select to_char(hire_date,'yyyy-mm-dd') day_more_hire
from employees
group by to_char(hire_date,'yyyy-mm-dd')
having count(employee_id) in (
    select max(count(employee_id))
    from employees
    group by to_char(hire_date,'yyyy-mm-dd')
    );
------------------------------------------------------------------------------------------------