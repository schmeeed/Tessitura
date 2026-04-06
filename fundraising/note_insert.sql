use impresario
go

insert into T_CONSTITUENT_NOTE
(
    customer_no,
    note_type,
    note
)
select
    customer_no,
    note_type,
    note
from [FILE NAME]
