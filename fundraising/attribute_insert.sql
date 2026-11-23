INSERT INTO tx_cust_keyword
(
    keyword_no,
    customer_no,
    key_value,
    n1n2_ind
)
SELECT DISTINCT
    a.keyword_no,
    a.customer_no,
    a.key_value,
    a.n1n2_ind
FROM [FILE NAME] a
WHERE NOT EXISTS
(
    SELECT 1
    FROM tx_cust_keyword k
    WHERE k.keyword_no = a.keyword_no
      AND k.customer_no = a.customer_no
      AND k.key_value = a.key_value
);
