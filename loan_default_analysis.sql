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
