use impresario
go

declare 
    @affiliation_no int,
    @individual_customer_no int,
    @group_customer_no int,
    @affiliation_type_id int,
    @is_allowed_to_transact char(1),
    @is_included_in_search_results char(1),
    @title varchar(50),
    @salary money,
    @note varchar(1024),
    @start_dt datetime,
    @end_dt datetime,
    @inactive char(1),
    @primary_ind char(1),
    @name_ind int,
    @affiliated_name varchar(55)

declare taffiliation_cursor cursor for
select 
    individual_customer_no,
    group_customer_no,
    affiliation_type_id,
    is_allowed_to_transact,
    is_included_in_search_results,
    title,
    salary,
    note,
    start_dt,
    end_dt,
    inactive,
    primary_ind,
    name_ind,
    affiliated_name
from amt_affiliationinsert5_20260714

open taffiliation_cursor

fetch next from taffiliation_cursor into
    @individual_customer_no,
    @group_customer_no,
    @affiliation_type_id,
    @is_allowed_to_transact,
    @is_included_in_search_results,
    @title,
    @salary,
    @note,
    @start_dt,
    @end_dt,
    @inactive,
    @primary_ind,
    @name_ind,
    @affiliated_name

while @@fetch_status = 0
begin

    if not exists (
        select 1
        from T_AFFILIATION
        where individual_customer_no = @individual_customer_no
          and group_customer_no = @group_customer_no
          and inactive = 'N'
    )
    begin
        exec @affiliation_no = ap_get_nextid_function 'RP', 1  

        insert into T_AFFILIATION
        (
            affiliation_no,
            individual_customer_no,
            group_customer_no,
            affiliation_type_id,
            is_allowed_to_transact,
            is_included_in_search_results,
            title,
            salary,
            note,
            start_dt,
            end_dt,
            inactive,
            primary_ind,
            name_ind,
            affiliated_name
        )
        values
        (
            @affiliation_no,
            @individual_customer_no,
            @group_customer_no,
            @affiliation_type_id,
            @is_allowed_to_transact,
            @is_included_in_search_results,
            @title,
            @salary,
            @note,
            @start_dt,
            @end_dt,
            @inactive,
            @primary_ind,
            @name_ind,
            @affiliated_name
        )
    end

    fetch next from taffiliation_cursor into
        @individual_customer_no,
        @group_customer_no,
        @affiliation_type_id,
        @is_allowed_to_transact,
        @is_included_in_search_results,
        @title,
        @salary,
        @note,
        @start_dt,
        @end_dt,
        @inactive,
        @primary_ind,
        @name_ind,
        @affiliated_name

end

close taffiliation_cursor
deallocate taffiliation_cursor
