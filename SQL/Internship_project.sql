create database project;

use project ;

CREATE TABLE job_market (
    job_id INT,
    job_title VARCHAR(50),
    company VARCHAR(50),
    location VARCHAR(30),
    salary DECIMAL(15,2),
    experience VARCHAR(10),
    skills VARCHAR(255),
    education VARCHAR(20),
    job_type VARCHAR(20),
    posted_days_ago INT,
    applicants INT,
    rating DECIMAL(3,1),
    department VARCHAR(30),
    industry VARCHAR(20),
    status VARCHAR(15)
);

select * from  job_market;
-- Q1 Rename Table name job_market to job 
rename table job_market to job ;

-- Q2 Find total number of jobs.
select count(*) from job ;

-- Q3 Display all records from the jobs table.
select * from job;

-- Q4 Show unique job titles.
select distinct(job_title) from job ;

-- Q5 Show unique locations.
select distinct(location) from job;

-- Q6 Find all jobs located in Delhi.
select job_title from job where location = "Delhi" ;

-- Q7 Find all Fresher jobs.
select * from job where experience = "Fresher" ;

-- Q8 Find jobs with salary greater than 10 lakh.
select job_title , salary from job where Salary > 1000000;

-- Q9 Find jobs where rating is greater than 4.
select job_title , rating from job where rating > 4;

-- Q10 Show top 10 highest salary jobs.
select job_title , salary from job order by salary desc limit 10;

-- Q11 Show top 10 most applied jobs.
select job_title , applicants from job order by applicants desc limit 10;

-- Q12 Find all Remote jobs.
select * from job where job_type = "Remote";

-- Q13 Find all Full Time jobs.
select * from job where job_type = "Full Time";

-- Q14 Find jobs in IT department.
select * from job where department = "IT";

-- Q15 Find jobs in Finance industry.
select * from job where industry = "Finance";

-- Q16 Find jobs posted within last 30 days.
select * from job where posted_days_ago = 30 ;

-- Q17 Find jobs with applicants greater than 300.
select job_title , applicants from job where applicants > 300 ;

-- Q18 Find jobs having SQL skill.
select job_title , skills from job where skills like "%sql%";

-- Q19 Find jobs having Python skill.
select job_title , skills from job where skills like "%Python%";

-- Q20 Find jobs having Power BI skill.
select job_title , skills from job where skills like "%PowerBI%" ;

-- Q21 Find jobs with education requirement B.Tech.
select job_title , education from job where education = "B.Tech";

-- Q22 Find average salary.
select avg(Salary) as Avg_Salary from job ;

-- Q23 Find maximum salary.
select max(Salary) as Max_Salary from job ;

-- Q24 Find minimum salary.
select min(Salary) as Min_Salary from job ;

-- Q25 Find total applicants.
select sum(applicants) as Total_Applicants from job ;

-- Q26 Find average rating.
select avg(Rating) as Avg_rating from job ;

-- Q27 Find total jobs in each location.
select count(job_title) as Total_job , location from job group by location;

-- Q28 Find total jobs in each company.
select count(job_title) as Total_job , Company from job group by company;

-- Q29 Find average salary by experience level.
select avg(salary) as avg_salary , experience from job group by experience;

-- Q30 Find average salary by department.
select avg(salary) as avg_salary , department from job group by department;

-- Q31 Find average rating by industry.
select avg(rating) as Avg_rating , industry from job group by industry ;

-- GROUP BY & HAVING (31-35)
-- Q32 Find companies having more than 100 jobs.
select company , count(job_title) as total_job from job group by  company having total_job > 100 ;

-- Q33 Find locations having more than 200 jobs.
select location , count(job_title) as total_job from job group by location having total_job > 200 ;

-- Q34 Find departments having average salary above 12 lakh.
select avg(salary) as Avg_salary from job group by department having Avg_Salary > 1200000;

-- Q35 Find industries having average rating above 4.
select avg(rating) as Avg_rating , industry from job group by industry having Avg_rating > 4;

-- Q36 Find experience categories having more than 500 jobs.
select count(job_title) as total_job , experience from job group by experience having total_job > 500 ;

-- ORDER BY & LIMIT (36-40)

-- Q37 Find top 5 highest paying companies.
select max(salary) as max_salary, company  from job group by company order by max_salary desc limit 5;

-- Q38 Find top 5 locations with highest average salary.
select avg(salary) as avg_salary, location  from job group by location order by avg_salary desc limit 5;

-- Q39 Find top 10 jobs based on rating.
select job_title , rating from job order by rating desc limit 10 ;

-- Q40 Find bottom 10 jobs based on salary.
select job_title , salary from job order by salary asc limit 10 ;

-- Q41 Find top industries based on applicants.
select industry , applicants from job order by applicants desc limit 1 ;

-- Subqueries (41-45)

-- Q42 Find jobs with salary above overall average salary.
select job_title, salary from job where salary >(select avg(salary) from job );

-- Q43 Find jobs with highest salary.
select job_title , salary from job where salary = (select max(salary) from job ) ;
select job_title ,max(salary) from job group by job_title  ;

-- Q44 Find jobs with lowest salary.
select distinct(job_title) , salary from job where salary = (select min(salary) from job ) ;

-- Q45 Find companies whose average salary is above overall average salary.
select company , avg(salary) as avg_salary from job group by company having avg(salary) > (select avg(salary) from job );

-- Q46 Find jobs in locations having highest number of openings.
select distinct(job_title) , location from job where location = ( select location from job group by location order by count(*) desc limit 1);

select distinct(location) from job ;
SELECT *
FROM job
WHERE location =(
    SELECT location
    FROM job
    GROUP BY location
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- Advanced SQL (46-50)

-- Q47 Create a View for High Salary Jobs.
create view v as select job_title , max(salary) as max_salary from job group by job_title order by max_salary desc ;

select * from v ;

-- Q48 Create a View for Fresher Jobs.
create view vs as select * from job where experience = "Fresher";

select * from vs;

-- Q49 Create a Stored Procedure to get jobs by location.

delimiter // 
create procedure get_() 
begin 
select job_title ,location from job ;
end //
delimiter ;
call get_();

-- Q50 Create a Function to categorize salary as High, Medium, Low.

DELIMITER //

CREATE FUNCTION salary_category(p_salary DECIMAL(15,2))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN

    DECLARE category VARCHAR(10);

    IF p_salary >= 1000000 THEN
        SET category = 'High';

    ELSEIF p_salary >= 500000 THEN
        SET category = 'Medium';

    ELSE
        SET category = 'Low';

    END IF;

    RETURN category;

END //

DELIMITER ;

select job_title ,salary_category(salary) as Salary_lavel from job ;

-- Q51 Create a Trigger that stores inserted records into an audit table.

CREATE TABLE job_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT,
    job_title VARCHAR(100),
    company VARCHAR(100),
    action_type VARCHAR(20),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //

CREATE TRIGGER trg_job_insert
AFTER INSERT
ON job
FOR EACH ROW
BEGIN

    INSERT INTO job_audit
    (
        job_id,
        job_title,
        company,
        action_type
    )
    VALUES
    (
        NEW.job_id,
        NEW.job_title,
        NEW.company,
        'INSERT'
    );

END //

DELIMITER ;

INSERT INTO job
(
    job_id,
    job_title,
    company,
    location,
    salary,
    experience
)
VALUES
(
    99999,
    'Data Analyst',
    'TCS',
    'Bhopal',
    650000,
    'Fresher'
);

SELECT * 
FROM job_audit;



select * from job ;