/*****************************************************************************************
Process:      Insert Fundraiser Steps into T_STEP
Created By:   Alyssa Tinsley
Run Type:     Manual / Scheduled Job
Dependencies: STG_T_STEP_UPLOAD, T_NEXT_ID (SB)

Purpose:
    Inserts validated fundraiser-uploaded step records from staging into T_STEP.

Audit Handling:
    - create_loc = 'FR_UPLOAD'
    - created_by = SYSTEM_USER
    - create_dt = GETDATE()
    - last_updated_by = SYSTEM_USER
    - last_update_dt = GETDATE()

Notes:
    This process assumes validation has been completed prior to execution.
*****************************************************************************************/

INSERT INTO T_STEP (
    step_no,
    plan_no,
    activity_no,
    customer_no,
    step_dt,
    step_type,
    description,
    notes,
    associate_no,
    due_dt,
    completed_on_dt,
    warning_days,
    priority,
    old_value,
    new_value,
    worker_customer_no,
    create_loc,
    created_by,
    create_dt,
    last_updated_by,
    last_update_dt
)
SELECT
    NEXT VALUE FOR SB,
    plan_no,
    activity_no,
    customer_no,
    step_dt,
    step_type,
    description,
    notes,
    associate_no,
    due_dt,
    completed_on_dt,
    warning_days,
    priority,
    old_value,
    new_value,
    worker_customer_no,
    'FR_UPLOAD',         -- create_loc
    SYSTEM_USER,         -- created_by
    GETDATE(),
    SYSTEM_USER,
    GETDATE()
FROM STG_T_STEP_UPLOAD
WHERE
(
    (plan_no IS NOT NULL AND activity_no IS NULL AND customer_no IS NULL)
 OR (plan_no IS NULL AND activity_no IS NOT NULL AND customer_no IS NULL)
 OR (plan_no IS NULL AND activity_no IS NULL AND customer_no IS NOT NULL)
);
