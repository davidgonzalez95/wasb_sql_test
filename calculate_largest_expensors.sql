-- ============================================================
-- REPORTING LARGEST EXPENSORS
-- ============================================================
-- This query identifies employees whose total expenses exceed 1000.
-- It includes employee details, their manager's details, and their total expensed amount.
-- Results are ordered by total_expensed_amount in descending order.

SELECT 
    e.employee_id AS employee_id,  -- Unique identifier for the employee
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,  -- Full name of the employee
    e.manager_id AS manager_id,  -- Unique identifier for the employee's manager
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,  -- Full name of the manager
    SUM(exp.unit_price * exp.quantity) AS total_expensed_amount  -- Total expenses incurred by the employee
FROM 
    EMPLOYEE e  -- Main employee table
LEFT JOIN 
    EXPENSE exp ON e.employee_id = exp.employee_id  -- Join with the expense table to get expense details
LEFT JOIN 
    EMPLOYEE m ON e.manager_id = m.employee_id  -- Self-join to get the manager's details
GROUP BY 
    e.employee_id, e.first_name, e.last_name,  -- Group by employee details
    e.manager_id, m.first_name, m.last_name  -- Group by manager details to ensure aggregation
HAVING 
    SUM(exp.unit_price * exp.quantity) > 1000  -- Filter employees with total expenses greater than 1000
ORDER BY 
    total_expensed_amount DESC;  -- Order the results in descending order based on total expenses

-- ============================================================
-- END OF CODE
-- ============================================================
