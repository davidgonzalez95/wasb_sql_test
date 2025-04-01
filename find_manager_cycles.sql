-- ============================================================
-- DETECTING CYCLES IN EMPLOYEE-MANAGER RELATIONSHIPS
-- ============================================================
-- Identifies cycles where employees approve each other's expenses.

WITH RECURSIVE ManagerCycle (employee_id, manager_id, cycle) AS (
    -- Base case: Start with each employee and their direct manager.
    SELECT 
        e.employee_id, 
        e.manager_id,
        CAST(e.employee_id AS VARCHAR) AS cycle  -- Initialize the cycle with the employee's ID
    FROM EMPLOYEE e
    WHERE e.manager_id IS NOT NULL  -- Exclude employees without a manager

    UNION ALL

    -- Recursive case: Traverse the manager hierarchy to detect cycles.
    SELECT 
        e.employee_id, 
        e.manager_id,
        CONCAT(mc.cycle, ',', CAST(e.employee_id AS VARCHAR)) AS cycle  -- Append employee ID to the cycle
    FROM EMPLOYEE e
    JOIN ManagerCycle mc ON e.manager_id = mc.employee_id  -- Follow the management chain
    WHERE mc.cycle NOT LIKE CONCAT('%', CAST(e.employee_id AS VARCHAR), '%')  -- Prevent infinite loops by checking if the employee is already in the cycle
)

SELECT 
    mc.employee_id, 
    mc.cycle
FROM ManagerCycle mc
WHERE mc.employee_id = SPLIT_PART(mc.cycle, ',', 1);  -- Ensure the first employee in the cycle appears in the result

-- ============================================================
-- END OF CODE
-- ============================================================
