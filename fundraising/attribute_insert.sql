INSERT INTO tx_cust_keyword
(
    keyword_no,
    customer_no,
    key_value,
    n1n2_ind
)
SELECT
    keyword_no,
    customer_no,
    key_value,
    n1n2_ind
FROM
    [FILE NAME]
