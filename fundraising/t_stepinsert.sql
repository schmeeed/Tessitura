use impresario
go

declare 
    @activity_no int,
	@category varchar(50),
    @activity_type int,
    @customer_no int,
    @contact_type int,
    @inout_ind char(1),
    @doc_no varchar(50),
    @notes varchar(max),
    @issue_dt datetime,
    @urg_ind char(1),
    @origin varchar(50),
    @perf_no int,
    @pkg_no int,
    @closed_ind char(1)

declare tactivity_cursor cursor for
select 
    category,
    activity_type,
    customer_no,
    contact_type,
    inout_ind,
    doc_no,
    notes,
    issue_dt,
    urg_ind,
    origin,
    perf_no,
    pkg_no,
    closed_ind
from amt_csiinsert_20260407

open tactivity_cursor

fetch next from tactivity_cursor into
    @category,
    @activity_type,
    @customer_no,
    @contact_type,
    @inout_ind,
    @doc_no,
    @notes,
    @issue_dt,
    @urg_ind,
    @origin,
    @perf_no,
    @pkg_no,
    @closed_ind

while @@fetch_status = 0
begin

    -- If activity_no should be system-generated, uncomment below
    exec @activity_no = ap_get_nextid_function 'AC', 1  

    insert into T_CUST_ACTIVITY
    (
        activity_no,
		category,
        activity_type,
        customer_no,
        contact_type,
        inout_ind,
        doc_no,
        notes,
        issue_dt,
        urg_ind,
        origin,
        perf_no,
        pkg_no,
        closed_ind
    )
    values
    (
        @activity_no,
		@category,
        @activity_type,
        @customer_no,
        @contact_type,
        @inout_ind,
        @doc_no,
        @notes,
        @issue_dt,
        @urg_ind,
        @origin,
        @perf_no,
        @pkg_no,
        @closed_ind
    )

    fetch next from tactivity_cursor into
        @category,
        @activity_type,
        @customer_no,
        @contact_type,
        @inout_ind,
        @doc_no,
        @notes,
        @issue_dt,
        @urg_ind,
        @origin,
        @perf_no,
        @pkg_no,
        @closed_ind

end

close tactivity_cursor
deallocate tactivity_cursor


-- to double check
select top 10 *
from T_CUST_ACTIVITY
order by activity_no desc;
