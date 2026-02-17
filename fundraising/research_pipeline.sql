SELECT DISTINCT
    c.customer_no,

    -- Customer / Plan On
    CASE 
        WHEN c.fname IS NULL OR c.fname = '' 
            THEN c.lname
        ELSE c.fname + ' ' + c.lname
    END AS customer_name,

    -- Campaign / Fund
    cam.description AS campaign_description,
    f.description AS fund_description,

    -- Status / Type
    ps.description AS plan_status_description,
    pt.description AS plan_type_description,

    -- Plan details
    p.notes,
    p.goal_amt,
    p.ask_amt,
    p.recorded_amt,
    p.cont_amt,
    p.start_dt,
    p.complete_by_dt,
    p.priority,
    p.probability,

    -- Worker info (only non-creator workers)
    w.customer_no AS worker_customer_no,
    CASE 
        WHEN wc.fname IS NULL OR wc.fname = '' 
            THEN wc.lname
        ELSE wc.fname + ' ' + wc.lname
    END AS worker_name,

    -- Audit fields
    p.create_dt,
    p.created_by,
    p.last_update_dt,
    p.last_updated_by

FROM T_PLAN p

-- Who the plan is for
JOIN T_CUSTOMER c 
    ON p.customer_no = c.customer_no

-- Campaign / Fund
LEFT JOIN T_CAMPAIGN cam 
    ON p.campaign_no = cam.campaign_no
LEFT JOIN T_FUND f 
    ON p.fund_no = f.fund_no

-- Status / Type
LEFT JOIN vrs_plan_status ps 
    ON p.status = ps.id
LEFT JOIN vrs_plan_type pt 
    ON p.type = pt.id

-- Workers
JOIN tx_cust_plan w 
    ON p.plan_no = w.plan_no


JOIN T_CUSTOMER wc 
    ON w.customer_no = wc.customer_no

WHERE 
    -- Only plans created by your four users
    p.created_by IN ('ktobaygo','rmeriam','ehensche','jelopez')

    AND (
        -- Updated by someone else
        p.last_updated_by NOT IN ('ktobaygo','rmeriam','ehensche','jelopez')

        -- OR has a worker who is not a creator
        OR w.customer_no NOT IN (1401257,1442925,1446664,1446868)
    )

    -- Only show workers that are not creators in the output
    AND w.customer_no NOT IN (1401257,1442925,1446664,1446868)
