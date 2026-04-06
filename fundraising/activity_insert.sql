use impresario
go

insert into T_SPECIAL_ACTIVITY
(
    customer_no,
    sp_act,
    sp_act_dt,
    solicitor,
    perf,
    status,
    notes,
    num_attendees,
    worker_customer_no
)
select
    customer_no,
    sp_act,
    sp_act_dt,
    solicitor,
    perf,
    status,
    notes,
    num_attendees,
    worker_customer_no
from [FILE NAME]
