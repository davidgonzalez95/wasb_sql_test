-- ============================================================
-- EXPENSE TABLE CREATION
-- ============================================================
-- The EXPENSE table tracks expenses incurred by employees,
-- including item prices and quantities.

CREATE TABLE EXPENSE (
    employee_id TINYINT NOT NULL, -- Unique identifier for the employee incurring the expense
    unit_price DECIMAL(8, 2), -- Cost per unit
    quantity TINYINT -- Number of units purchased
);
-- ============================================================
-- INSERTING DATA INTO THE EXPENSE TABLE
-- ============================================================
-- Insert expense records into the EXPENSE table.

INSERT INTO EXPENSE (employee_id, unit_price, quantity)
VALUES
    -- Alex Jacobson's expenses
    (3, 6.50, 14), -- Drinks, lots of drinks
    (3, 11.00, 20), -- More Drinks
    (3, 22.00, 18), -- So Many Drinks!
    (3, 13.00, 75), -- I bought everyone in the bar a drink!

    -- Andrea Ghibaudi's expense
    (9, 300.00, 1), -- Flights from Mexico back to New York

    -- Darren Poynton's expenses
    (4, 40.00, 9), -- Ubers to get us all home

    -- Umberto Torrielli's expense
    (2, 17.50, 4); -- I had too much fun and needed something to eat

-- ============================================================
-- VALIDATIONS
-- ============================================================

-- Retrieve all data from the EXPENSE table
SELECT * FROM EXPENSE;

-- Query to find employee IDs in EXPENSE that are not present in EMPLOYEE
SELECT e.employee_id
FROM memory.default.EXPENSE e
LEFT JOIN memory.default.EMPLOYEE emp ON e.employee_id = emp.employee_id
WHERE emp.employee_id IS NULL;
