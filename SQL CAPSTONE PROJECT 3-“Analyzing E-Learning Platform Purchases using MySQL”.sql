##------CAPSTONE PROJECT 3 -------
##“Analyzing E-Learning Platform Purchases using MySQL”
##----TASKS-1. Create the database and schema. Populate the Schema:
CREATE DATABASE elearning;                       ## Creating database named as elearning
USE elearning;                                   ## Selects a database to work 
CREATE TABLE learners(                           ## Table created as learners with attributes as follows
learner_id INT PRIMARY KEY,                      ## learner_id stored as integer & Primary key values-> used to aloow only unique & not null values. 
full_name varchar(100) NOT NULL,                 ## learner_name is used to store learner name upto 100 variable character and it should not be null.
country varchar(50) NOT NULL                     ## Country is used to store country name and it should not be null
);
CREATE TABLE courses(                            ## courses table is created with the given attribute
course_id INT PRIMARY KEY,                       ## Primary key unique key
course_name varchar(50) NOT NULL,                ##The course name should not be null
category varchar(50) NOT NULL,                   ## It won't allow null values
unit_price DECIMAL(10,2) NOT NULL                ## used to store decimal values upto 8 whole numbers and two decimal digits
);                                               ## ;→ Indicates the end of the SQL statement

CREATE TABLE purchases(                    ## Purchases table is created with 
purchase_id INT PRIMARY KEY,               ## purchase id is declared as INT and Primary key unique idetifier 
learner_id INT,
course_id INT,
quantity INT NOT NULL,
purchase_date DATE NOT NULL,
CONSTRAINT FK_elearning_leaners                                 ##Gives the name to the foreign key constraint
FOREIGN KEY(learner_id)REFERENCES learners(learner_id),         ##Make the leaarner_id as foreign key in the learners table connect to learner_id of purchase table
CONSTRAINT FK_elearning_courses                                 ##Gives the name to foreign key constraint
FOREIGN KEY(course_id)REFERENCES courses(course_id)             ##Make a course_id as foreign key in the course table connect it to purchase table
);
## Inserted Input data
INSERT INTO learners (learner_id, full_name, country)                  ## Inserted dta values of learners table
VALUES                                                                 ## Table where data will be inserted
(1, 'Aarav Sharma', 'India'),            
(2, 'Priya Nair', 'USA'),
(3, 'Rohan Mehta', 'UK'),
(4, 'Sneha Patel', 'Canada'),
(5, 'Vikram Singh', 'Australia');

INSERT INTO courses (course_id, course_name, category, unit_price) VALUES         ## Inserted data values of course table
(101, 'Python Basics', 'Programming', 49.99),
(102, 'Data Science Intro', 'Data Science', 79.99),
(103, 'Web Development', 'Programming', 59.99),
(104, 'Digital Marketing', 'Marketing', 39.99),
(105, 'UI/UX Design', 'Design', 69.99),
(106, 'Machine Learning', 'Data Science', 89.99);

INSERT INTO purchases
(purchase_id, learner_id, course_id, quantity, purchase_date)
VALUES                                                           ## Inserted dta values of purchase table
(1001, 1, 101, 1, '2025-07-01'),
(1002, 2, 102, 1, '2025-07-05'),
(1003, 3, 103, 1, '2025-07-10'),
(1004, 1, 104, 3, '2025-07-15'),
(1005, 4, 105, 1, '2025-07-20'),
(1006, 5, 102, 1, '2025-07-22'),
(1007, 2, 101, 2, '2025-07-25'),
(1008, 3, 104, 1, '2025-07-28');
##----TASK 2. Data Exploration Using Joins------
##----INNER JOIN---
SELECT                                                  ## Specifies which columns we want to display
    l.learner_id,                                       ## l is an alias for the learners table
    l.full_name,
    l.country,
    c.course_name,                                      ## c represents the courses table.
    c.category,                                         ## c is an alias for course table
    p.quantity,                             
    FORMAT(p.quantity * c.unit_price, 2) AS total_amount,
    p.purchase_date
FROM purchases p
INNER JOIN learners l                                   ## INNER JOIN returns only matching records
    ON p.learner_id = l.learner_id
INNER JOIN courses c                                    ## Connects purchases with courses
    ON p.course_id = c.course_id                        ## Matches the purchased course ID with the course table
ORDER BY p.purchase_date;                               ## Sorts the result using purchase date
##-----LEFT JOIN-------
SELECT
    l.learner_id,
    l.full_name,
    l.country,                                                 ## Displays learner ID, name and country
    c.course_name,
    c.category,
    p.quantity,                                                ## Displays course name, category and quantity if a purchase exists
    FORMAT(p.quantity * c.unit_price, 2) AS total_amount,      ## Calculates quantity × price
    p.purchase_date
FROM learners l                                                ## The learners table is the main table.
LEFT JOIN purchases p                                          ## LEFT JOIN = Keep everything from the left table
    ON l.learner_id = p.learner_id
LEFT JOIN courses c
    ON p.course_id = c.course_id                               ## Gets course information for the purchase
ORDER BY l.learner_id;                                         ## Sorts learners according to their ID
##----Right Join---------
SELECT
    c.course_id,
    c.course_name,                                            ## Displays course ID, name and category.
    c.category,
    p.purchase_id,
    p.quantity,
    p.purchase_date
FROM purchases p
RIGHT JOIN courses c                                           ## Right join keeps all records from the right table, which is courses.
    ON p.course_id = c.course_id
ORDER BY c.course_id;                                          ## Sorts courses by course ID

##----3. Analytical Queries------
##Q1. Display each learner’s total spending (quantity × unit_price) along with their country.
SELECT
    l.learner_id,
    l.full_name,
    l.country,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_spent        ## Calculates the amount for each purchase calculated column as total_spent
FROM learners l
INNER JOIN purchases p                                              ## Connects learners with their purchases
    ON l.learner_id = p.learner_id
INNER JOIN courses c                                                ## Connects purchases with course prices
    ON p.course_id = c.course_id 
GROUP BY                                                            ## Groups all purchases belonging to the same learner
    l.learner_id,
    l.full_name,
    l.country
ORDER BY total_spent DESC;  ## This calculates how much each learner has spent in total and Descending
##--Q2)Find the top 3 most purchased courses--
SELECT
    c.course_id,
    c.course_name,
    SUM(p.quantity) AS total_quantity_sold          ## SUM(quantity) calculates the total number of units sold for each course
FROM courses c
INNER JOIN purchases p
    ON c.course_id = p.course_id 
GROUP BY
    c.course_id,
    c.course_name
ORDER BY total_quantity_sold DESC                    ## Sorts from highest quantity to lowest
LIMIT 3;                                             ## Shows only the first 3 courses

## Q 3)Category's total revenue and unique learners
SELECT
    c.category,
    FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_revenue,   ##SUM() → calculates total revenue.
    COUNT(DISTINCT p.learner_id) AS unique_learners               ## COUNT(DISTINCT learner_id) → counts unique learners. 
FROM courses c
INNER JOIN purchases p
    ON c.course_id = p.course_id
GROUP BY c.category                                               ## GROUP BY category → gives results category-wise.
ORDER BY total_revenue DESC;                                      ## Shows the category with the highest revenue first.
##--Q 4)Learners who purchased from more than one category--
SELECT
    l.learner_id,
    l.full_name,
    l.country,
    COUNT(DISTINCT c.category) AS category_count       ##COUNT(DISTINCT c.category) counts different categories purchased by each learner.
FROM learners l
INNER JOIN purchases p
    ON l.learner_id = p.learner_id
INNER JOIN courses c
    ON p.course_id = c.course_id
GROUP BY
    l.learner_id,
    l.full_name,
    l.country
HAVING COUNT(DISTINCT c.category) > 1;               ## HAVING > 1 means the learner purchased courses from at least two different categories.

##--Q 5)Identify courses that have not been purchased--
SELECT
    c.course_id,
    c.course_name,
    c.category
FROM courses c
LEFT JOIN purchases p                             ## Left Join keeps all courses
    ON c.course_id = p.course_id
WHERE p.purchase_id IS NULL;                      ## Finds courses that have no matching purchase record.

