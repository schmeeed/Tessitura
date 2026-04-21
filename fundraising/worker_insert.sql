INSERT INTO tx_cust_plan
(
    plan_no,
    customer_no,
    role_no,
    primary_ind,
    show_in_portfolio
)
SELECT
    f.plan_no,
    f.customer_no,
    f.role_no,
    f.primary_ind,
    f.show_in_portfolio
FROM
    [FILE NAME] f
WHERE NOT EXISTS
(
    SELECT 1
    FROM tx_cust_plan t
    WHERE t.plan_no = f.plan_no
      AND t.customer_no = f.customer_no
      AND t.role_no = f.role_no
);
