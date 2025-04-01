-- ============================================================
-- GENERATE MONTHLY PAYMENT PLAN FOR SUPPLIERS
-- ============================================================
-- This query calculates a monthly payment plan for suppliers,
-- ensuring payment dates are of type DATE and correspond to the last day of the month.

WITH InvoiceData AS (
    -- Step 1: Aggregate invoices per supplier
    -- For each supplier, calculate the total outstanding balance (sum of invoice amounts).
    -- The result will have one row per supplier with their total balance.
    SELECT 
        s.supplier_id,                           -- Unique identifier for the supplier
        s.name AS supplier_name,                 -- Name of the supplier
        SUM(i.invoice_amount) AS total_balance  -- Total outstanding balance for the supplier
    FROM 
        SUPPLIER s
    JOIN 
        INVOICE i ON s.supplier_id = i.supplier_id -- Join to match invoices with their suppliers
    GROUP BY 
        s.supplier_id,                           -- Group by supplier ID
        s.name                                   -- Group by supplier name
),
PaymentSchedule AS (
    -- Step 2: Generate a payment schedule for each supplier
    -- The schedule splits the total balance into monthly installments,
    -- ensuring payments are made on the last day of each month.
    SELECT 
        id.supplier_id,                          -- Supplier ID
        id.supplier_name,                        -- Supplier name
        monthly_index.index AS monthly_index,    -- Payment month index, generated from SEQUENCE
        CASE 
            WHEN monthly_index.index * 1500 >= id.total_balance THEN 
                -- If the cumulative payments reach or exceed the total balance:
                id.total_balance - (monthly_index.index - 1) * 1500 -- Remaining balance as final payment
            ELSE 
                1500.00 -- Standard monthly payment
        END AS payment_amount,                   -- Amount to be paid for this month
        GREATEST(id.total_balance - monthly_index.index * 1500, 0) AS balance_outstanding, 
        -- Calculate the remaining balance after this payment
        -- Ensure the balance does not go negative using GREATEST.

        DATE_ADD('day', -1, 
            DATE_ADD('month', monthly_index.index, DATE_TRUNC('month', DATE('2024-12-31')))
        ) AS payment_date -- Calculate the last day of the payment month
        -- First, move forward by the number of months specified by monthly_index.
        -- Then, subtract one day from the first day of the next month to find the last day of the month.
    FROM 
        InvoiceData id
    CROSS JOIN UNNEST(
        SEQUENCE(1, CAST(CEIL(id.total_balance / 1500) AS BIGINT)) -- Generate a sequence of months needed to pay off the total balance
    ) AS monthly_index(index) -- Assign the sequence an alias (monthly_index) with a column (index)
)
-- Step 3: Output the final payment schedule
SELECT 
    supplier_id,                                 -- Supplier ID
    supplier_name,                               -- Supplier name
    payment_amount,                              -- Payment amount for the month
    balance_outstanding,                         -- Remaining balance after this payment
    payment_date                                 -- Date of the payment (last day of the month)
FROM 
    PaymentSchedule
ORDER BY 
    supplier_id,                                 -- Sort by supplier ID
    payment_date;                                -- Then sort by payment date

-- ============================================================
-- END OF CODE
-- ============================================================
