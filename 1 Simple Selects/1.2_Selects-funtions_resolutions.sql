
------------------------------------------------------------------------------------------------
-- SELECT WITH FUNCTIONS
------------------------------------------------------------------------------------------------
/* 1
Display the current date in the following format:
Current Date
------------------------------
Saturday, 11 of February of 2017. 16:06:06

The day in words with the first letter capitalised, followed by a comma, the day in numbers,
the word "of," the month in lowercase in words, the word "of," the year in four digits
ending with a period. Then the time in 24h format with minutes and seconds.
And as the field label "Current Date."
*/
select 
    rtrim(to_char(sysdate,'Day'))||', '||
    to_char(sysdate,'dd')||' of '||
    rtrim(to_char(sysdate,'Month'))|| ' of '||
    to_char(sysdate,'yyyy')||'. '||to_char(sysdate,'hh24:mi:ss')  "Current Date"
from dual;
/* 2
Day in words on which you were born
*/
select 
    rtrim(to_char(to_date('12/06/1987','dd/mm/yyyy'), 'Day')) "Birth Day"
from 
    dual;
/* 3
The sum of salaries, what is the minimum, the maximum, and the average salary
*/
select 
    sum(salary), 
    min(salary), 
    max(salary), 
    avg(salary)
from 
    employees;
/* 4
How many employees are there, how many have a salary, and how many have a commission.
*/
select 
    count(*), 
    count(salary), 
    count(commission_pct)
from 
    employees;
/* 5
On one hand, the average between the average salaries and the minimum salary
And on the other hand, the average between the average salaries and the maximum salary
Only the integer part, without decimals or rounding.
*/
select 
    trunc((avg(salary)+min(salary))/2) low_average, 
    trunc((avg(salary)+max(salary))/2) high_average
from 
    employees;
/* 6
List the department number and the maximum salary in each of them.
*/
select 
    department_id, max(salary)
from 
    employees
group by 
    department_id;
/* 7
Show the names of the employees that are repeated indicating how many there are
in descending order.
*/
select 
    first_name, 
    count(first_name)
from 
    employees
group by 
    first_name
having 
    count(first_name) != 1
order by 
    2 desc;
/* 8
Show in one row how many employees are department heads
and in another row how many are heads of other employees.
*/
select count( distinct manager_id) Head_Count, 'DEP' Head_Type from departments
union
select count( distinct manager_id), 'EMP' from employees;
/* 9
List first name, last name of employees whose
first letter of their first name and last name match
*/
select 
    first_name, 
    last_name
from 
    employees
where 
    substr(first_name,1,1) = substr(last_name,1,1);
/* 10
Number of employees hired per day
ordered descending by date
*/
select 
    count(employees.employee_id) count_employees,
    to_char(hire_date,'yyyy-mm-dd') day
from
    employees
group by
    to_char(hire_date,'yyyy-mm-dd')
order by
    day desc;
/* 11
A list by year of the average salaries
of employees who joined that year
ordered descending by year
*/
select
    to_char(hire_date,'yyyy') year,
    avg(salary) avg_salary
from
    employees
group by
    to_char(hire_date,'yyyy') year
order by
    to_char(hire_date,'yyyy') desc;
/* 12
Name of the day on which the most employees
were hired
*/
select to_char(hire_date,'Day') Day
from employees
having count(employee_id) = 
    (select max(count(employee_id))
    from employees
    group by to_char(hire_date,'Day'))
group by to_char(hire_date,'Day');
------------------------------------------------------------------------------------------------