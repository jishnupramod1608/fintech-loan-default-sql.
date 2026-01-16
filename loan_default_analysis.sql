CREATE DATABASE fintech_loan_risk;
USE fintech_loan_risk;

USE fintech_loan_risk;

DROP TABLE IF EXISTS loans;

CREATE TABLE loans (
    id VARCHAR(20),
    loan_amnt VARCHAR(20),
    term VARCHAR(20),
    int_rate VARCHAR(20),
    grade VARCHAR(5),
    sub_grade VARCHAR(5),
    home_ownership VARCHAR(20),
    annual_inc VARCHAR(20),
    loan_status VARCHAR(50),
    purpose VARCHAR(50),
    addr_state VARCHAR(10)
);

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/loans_final.csv'
INTO TABLE loans
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id, loan_amnt, term, int_rate, grade, sub_grade,
 home_ownership, annual_inc, loan_status, purpose, addr_state);
 
 SELECT COUNT(*) FROM loans;
 
 SELECT DISTINCT loan_status
FROM loans;

#Total Loans vs Defaulted Loans
SELECT
    COUNT(*) AS total_loans,
    SUM(
        CASE
            WHEN loan_status IN ('Charged Off', 'Default', 'Late (31-120 days)')
            THEN 1 ELSE 0
        END
    ) AS defaulted_loans
FROM loans;

#Default Risk by Credit Grade (Core Insight)
SELECT
    grade,
    COUNT(*) AS total_loans,
    SUM(
        CASE
            WHEN loan_status IN ('Charged Off', 'Default', 'Late (31-120 days)')
            THEN 1 ELSE 0
        END
    ) AS defaulted_loans
FROM loans
GROUP BY grade
ORDER BY grade;


#Overall Default Rate (%)
SELECT
    ROUND(
        SUM(
            CASE
                WHEN loan_status IN ('Charged Off', 'Default', 'Late (31-120 days)')
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
    2) AS default_rate_percentage
FROM loans;

#Loan Purpose vs Default Risk
SELECT
    purpose,
    COUNT(*) AS total_loans,
    SUM(
        CASE
            WHEN loan_status IN ('Charged Off', 'Default', 'Late (31-120 days)')
            THEN 1 ELSE 0
        END
    ) AS defaulted_loans
FROM loans
GROUP BY purpose
ORDER BY defaulted_loans DESC;

CREATE OR REPLACE VIEW loan_risk_analysis AS
SELECT
    id,
    grade,
    purpose,
    addr_state,
    CAST(annual_inc AS UNSIGNED) AS annual_income,
    loan_status,
    CASE
        WHEN loan_status IN ('Charged Off', 'Default', 'Late (31-120 days)')
        THEN 'Defaulted'
        ELSE 'Non-Defaulted'
    END AS default_flag
FROM loans;
