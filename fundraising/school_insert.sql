insert into tx_cust_school
(
    customer_no,
    school,
    major,
    degree,
    start_year,
    end_year,
    n1n2_ind
)
select
    customer_no,
    school,
    major,
    degree,
    start_year,
    end_year,
    n1n2_ind
from amt_schoolinsert_20260728
