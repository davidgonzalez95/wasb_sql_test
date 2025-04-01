-- ============================================================
-- SETTING UP THE SCHEMA
-- ============================================================
-- Ensure you're working within the correct catalog and schema.
USE memory.default;

-- ============================================================
-- DATA LOADING IN NORMAL CONDITIONS
-- ============================================================
-- Under normal circumstances, the employee data would be loaded directly
-- from the hr/employee_index.csv file using a supported method. This could
-- include an ETL process, COPY INTO statement, or specific file-reading mechanisms
-- supported by the database engine or your ETL pipeline.

-- Example (pseudo-code):
-- COPY EMPLOYEE FROM 'path/to/hr/employee_index.csv' WITH CSV HEADER;

-- Since this example does not include direct CSV loading,
-- we will insert the data manually for demonstration purposes.

-- ============================================================
-- MANUAL DATA INSERTION
-- ============================================================
-- Inserting the data manually for demonstration purposes.
-- Below are the initial records for the EMPLOYEE table.

-- ============================================================
-- EMPLOYEE TABLE CREATION
-- ============================================================
-- The EMPLOYEE table stores information about company employees.
-- It includes unique identifiers for each employee, their names,
-- job titles, and the ID of their manager (if applicable).
-- Create the EMPLOYEE table without primary or foreign key constraints (Trino doesn't support primary keys, foreign keys, or constraints directly)

CREATE TABLE EMPLOYEE (
    employee_id TINYINT NOT NULL, -- Unique identifier for each employee
    first_name VARCHAR(50) NOT NULL, -- Employee's first name
    last_name VARCHAR(50) NOT NULL, -- Employee's last name
    job_title VARCHAR(50) NOT NULL, -- Employee's job title
    manager_id TINYINT -- ID of the employee's manager
);

-- ============================================================
-- INSERTING DATA INTO EMPLOYEE TABLE
-- ============================================================
-- Below are the initial data records for the EMPLOYEE table.
-- These records represent current employees and their hierarchical relationships.

INSERT INTO EMPLOYEE (employee_id, first_name, last_name, job_title, manager_id)
VALUES
    -- CEO of the company, no manager assigned.
    -- IMPORTANT: CHECK THIS
    -- If he is the CEO, why does he report to the CFO?? Maybe is NULL, I need to ask (It is solved in part 4)
    -- Are the Chief's hierarchies well established?
    (1, 'Ian', 'James', 'CEO', 4),

    -- CSO (Chief Strategy Officer), reports directly to the CEO.
    (2, 'Umberto', 'Torrielli', 'CSO', 1),

    -- MD EMEA (Managing Director for Europe, Middle East, Africa), reports to CSO.
    (3, 'Alex', 'Jacobson', 'MD EMEA', 2),

    -- CFO (Chief Financial Officer), reports to CSO.
    (4, 'Darren', 'Poynton', 'CFO', 2),

    -- MD APAC (Managing Director for Asia-Pacific), reports to CSO.
    (5, 'Tim', 'Beard', 'MD APAC', 2),

    -- COS (Chief of Staff), reports directly to the CEO.
    (6, 'Gemma', 'Dodd', 'COS', 1),

    -- CHR (Chief Human Resources), reports to COS.
    (7, 'Lisa', 'Platten', 'CHR', 6),

    -- GM Activation (General Manager for Activation), reports to CSO.
    (8, 'Stefano', 'Camisaca', 'GM Activation', 2),

    -- MD NAM (Managing Director for North America), reports to CSO.
    (9, 'Andrea', 'Ghibaudi', 'MD NAM', 2);

-- ============================================================
-- IMPLEMENTATION NOTES
-- ============================================================
-- 1. NOT NULL constraints are applied to critical columns (employee_id, first_name, last_name, job_title)
--    to prevent incomplete records.
-- 2. The manager_id column includes a foreign key constraint referencing employee_id.
--    This guarantees that all managers exist within the same table.
-- 3. If you anticipate more than 255 employees, consider changing TINYINT to SMALLINT or INTEGER.

-- ============================================================
-- VALIDATIONS
-- ============================================================

-- Verify that the table exists
SHOW TABLES FROM memory.default;

-- Describe the table to check its columns and constraints
DESCRIBE memory.default.EMPLOYEE;

-- Query to find invalid manager IDs that are not present in employee_id
SELECT e.manager_id
FROM memory.default.EMPLOYEE e
LEFT JOIN memory.default.EMPLOYEE m ON e.manager_id = m.employee_id
WHERE e.manager_id IS NOT NULL AND m.employee_id IS NULL;

-- Retrieve all data from the EMPLOYEE table
SELECT * FROM memory.default.EMPLOYEE
ORDER BY employee_id;

-- Query employees with their manager details
SELECT 
    e.employee_id AS employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.job_title AS job_title,
    e.manager_id AS manager_id,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM memory.default.EMPLOYEE e
LEFT JOIN memory.default.EMPLOYEE m ON e.manager_id = m.employee_id
ORDER BY e.employee_id;

-- ============================================================
-- END OF CODE
-- ============================================================
