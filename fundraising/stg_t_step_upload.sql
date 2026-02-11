/*****************************************************************************************
Object Name:  STG_T_STEP_UPLOAD
Created By:   Alyssa Tinsley
Create Date:  02/11/2026

Purpose:
    This staging table is used to load fundraiser-submitted step data from Excel
    prior to inserting records into T_STEP.

    Fundraisers complete a standardized Excel template which is imported into
    this table via the SQL Import Wizard or scheduled ETL process.

Usage:
    1. Excel file is saved to shared location.
    2. Data is imported into STG_T_STEP_UPLOAD.
    3. Validation queries are executed.
    4. Approved records are inserted into T_STEP.

Notes:
    - step_no is NOT included here.
    - Audit fields (create_dt, created_by, etc.) are system generated at insert time.
    - Exactly ONE of plan_no, activity_no, or customer_no must be populated.
*****************************************************************************************/
CREATE TABLE STG_T_STEP_UPLOAD (
    plan_no int NULL,
    activity_no int NULL,
    customer_no int NULL,
    step_dt datetime NOT NULL,
    step_type int NOT NULL,
    description varchar(30) NULL,
    notes varchar(max) NULL,
    associate_no int NULL,
    due_dt datetime NULL,
    completed_on_dt datetime NULL,
    warning_days int NULL,
    priority int NOT NULL,
    old_value varchar(30) NULL,
    new_value varchar(30) NULL,
    worker_customer_no int NULL,
    cyclical_ind char(1) NOT NULL DEFAULT 'N'
);
