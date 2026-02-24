use impresario
go

declare 
    @step_no int,
    @plan_no int,
    @step_dt datetime,
    @step_type varchar(10),
    @description varchar(255),
    @notes varchar(255),
    @associate_no int,
    @due_dt datetime,
    @completed_on_dt datetime,
    @warning_days int,
    @priority int,
    @old_value varchar(255),
    @new_value varchar(255),
    @worker_customer_no int,
    @activity_no int,
    @customer_no int,
    @cyclical_ind char(1)

declare tstep_cursor cursor for
select 
    plan_no, step_dt, step_type, description, notes, associate_no, due_dt, completed_on_dt,
    warning_days, priority, old_value, new_value, worker_customer_no, activity_no, customer_no, cyclical_ind
from amt_tstepimport_20260220

open tstep_cursor

fetch next from tstep_cursor into
    @plan_no, @step_dt, @step_type, @description, @notes, @associate_no, @due_dt, @completed_on_dt,
    @warning_days, @priority, @old_value, @new_value, @worker_customer_no, @activity_no, @customer_no, @cyclical_ind

while @@fetch_status = 0
begin

    -- Get next step_no for T_STEP
    exec @step_no = ap_get_nextid_function 'SB', 1  

    insert into T_STEP
    (
        step_no,
        plan_no, step_dt, step_type, description, notes, associate_no, due_dt, completed_on_dt,
        warning_days, priority, old_value, new_value, worker_customer_no, activity_no, customer_no, cyclical_ind
    )
    values
    (
        @step_no,
        @plan_no, @step_dt, @step_type, @description, @notes, @associate_no, @due_dt, @completed_on_dt,
        @warning_days, @priority, @old_value, @new_value, @worker_customer_no, @activity_no, @customer_no, @cyclical_ind
    )

    fetch next from tstep_cursor into
        @plan_no, @step_dt, @step_type, @description, @notes, @associate_no, @due_dt, @completed_on_dt,
        @warning_days, @priority, @old_value, @new_value, @worker_customer_no, @activity_no, @customer_no, @cyclical_ind

end

close tstep_cursor
deallocate tstep_cursor
