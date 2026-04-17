use impresario
go

declare 
    @plan_no int,
    @campaign_no int,
    @customer_no int,
    @cont_designation int,
    @fund_no int,
    @original_source int,
    @status int,
    @type int,
    @notes varchar(255),
    @goal_amt money,
    @ask_amt money,
    @cont_amt money,
    @recorded_amt money,
    @start_dt datetime,
    @complete_by_dt datetime,
    @priority int,
    @probability decimal(10,4),
    @custom_1 varchar(255),
    @custom_2 varchar(255),
    @custom_3 varchar(255),
    @custom_4 varchar(255),
    @custom_5 varchar(255),
    @custom_6 varchar(255),
    @custom_7 varchar(255),
    @custom_8 varchar(255),
    @custom_9 varchar(255),
    @custom_10 varchar(255)

declare tplan_cursor cursor for
select 
    campaign_no, customer_no, cont_designation, fund_no, original_source,
    status, type, notes, goal_amt, ask_amt, cont_amt, recorded_amt,
    start_dt, complete_by_dt, priority, probability,
    custom_1, custom_2, custom_3, custom_4, custom_5,
    custom_6, custom_7, custom_8, custom_9, custom_10
from [FLAT FILE NAME HERE]

open tplan_cursor

fetch next from tplan_cursor into
    @campaign_no, @customer_no, @cont_designation, @fund_no, @original_source,
    @status, @type, @notes, @goal_amt, @ask_amt, @cont_amt, @recorded_amt,
    @start_dt, @complete_by_dt, @priority, @probability,
    @custom_1, @custom_2, @custom_3, @custom_4, @custom_5,
    @custom_6, @custom_7, @custom_8, @custom_9, @custom_10

while @@fetch_status = 0
begin

    exec @plan_no = AP_GET_NEXTID_function 'SO', 1

    insert into T_PLAN
    (
        plan_no, campaign_no, customer_no, cont_designation, fund_no, original_source,
        status, type, notes, goal_amt, ask_amt, cont_amt, recorded_amt,
        start_dt, complete_by_dt, priority, probability,
        custom_1, custom_2, custom_3, custom_4, custom_5,
        custom_6, custom_7, custom_8, custom_9, custom_10
    )
    values
    (
        @plan_no, @campaign_no, @customer_no, @cont_designation, @fund_no, @original_source,
        @status, @type, @notes, @goal_amt, @ask_amt, @cont_amt, @recorded_amt,
        @start_dt, @complete_by_dt, @priority, @probability,
        @custom_1, @custom_2, @custom_3, @custom_4, @custom_5,
        @custom_6, @custom_7, @custom_8, @custom_9, @custom_10
    )

    fetch next from tplan_cursor into
        @campaign_no, @customer_no, @cont_designation, @fund_no, @original_source,
        @status, @type, @notes, @goal_amt, @ask_amt, @cont_amt, @recorded_amt,
        @start_dt, @complete_by_dt, @priority, @probability,
        @custom_1, @custom_2, @custom_3, @custom_4, @custom_5,
        @custom_6, @custom_7, @custom_8, @custom_9, @custom_10

end

close tplan_cursor
deallocate tplan_cursor
