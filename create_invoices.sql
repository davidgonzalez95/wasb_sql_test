-- ============================================================
-- SUPPLIER TABLE CREATION
-- ============================================================
-- Stores information about suppliers.

CREATE TABLE SUPPLIER (
    supplier_id TINYINT NOT NULL, -- Unique identifier for each supplier
    name VARCHAR NOT NULL -- Name of the supplier
);

-- Insert suppliers into SUPPLIER table
INSERT INTO SUPPLIER (supplier_id, name)
VALUES
    (1, 'Catering Plus'),
    (2, 'Dave\'s Discos'),
    (3, 'Entertainment Tonight'),
    (4, 'Ice Ice Baby'),
    (5, 'Party Animals');


-- ============================================================
-- INVOICE TABLE CREATION
-- ============================================================
-- Stores information about supplier invoices.

CREATE TABLE INVOICE (
    supplier_id TINYINT NOT NULL, -- Supplier ID (references SUPPLIER)
    invoice_amount DECIMAL(8, 2), -- Invoice amount
    due_date DATE -- Due date (last day of the specified month)
);

-- Insert invoices into INVOICE table
-- Since the invoices are from a Christmas party, I supposed that it was in December 2024, the "months from now" calculations start there.
INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
VALUES
    -- Party Animals invoices
    (5, 6000.00, DATE('2025-03-31')), -- 3 months from December (March 2025)

    -- Catering Plus invoices
    (1, 2000.00, DATE('2025-02-28')), -- 2 months from December (February 2025)
    (1, 1500.00, DATE('2025-03-31')), -- 3 months from December (March 2025)

    -- Dave's Discos invoice
    (2, 500.00, DATE('2025-01-31')), -- 1 month from December (January 2025)

    -- Entertainment Tonight invoice
    (3, 6000.00, DATE('2025-03-31')), -- 3 months from December (March 2025)

    -- Ice Ice Baby invoice
    (4, 4000.00, DATE('2025-06-30')); -- 6 months from December (June 2025)

-- ============================================================
-- VALIDATIONS
-- ============================================================
-- Verify that the tables exists
SELECT * FROM SUPPLIER ORDER BY supplier_id;
SELECT * FROM INVOICE ORDER BY supplier_id, due_date;

-- Ensure all supplier IDs in INVOICE exist in SUPPLIER
SELECT i.supplier_id
FROM INVOICE i
LEFT JOIN SUPPLIER s ON i.supplier_id = s.supplier_id
WHERE s.supplier_id IS NULL;

-- ============================================================
-- END OF CODE
-- ============================================================
