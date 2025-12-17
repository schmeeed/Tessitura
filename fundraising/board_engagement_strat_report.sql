/*
 * Board Engagement Query
 * Tessitura v16.x
 *
 * Purpose:
 *   Combines engagement activity across Steps, Special Activities, Event Extracts,
 *   and Ticket History for Board members and their associated households.
 *   Date window used throughout the query:
 *     Start: first day of the previous calendar month (inclusive)
 *     End:   first day of the current calendar month (exclusive)
 *   This represents the full previous calendar month only.
 *
 * Author: Brian Ralston
 * Created: 2025-11-25
 *
 * EDITS:
 *   2025-12-02 FOC - Added group_cust_no / group_cust_name using expanded household logic
 *   2025-12-17 BMR - Added in Performances to the report VS_ELEMENTS_TICKET_HISTORY and solidified date-window documentation across all UNION blocks, looks at previous month
 */


WITH ETeam AS (
    SELECT *
    FROM VS_WORKER_LIST
    WHERE worker_customer_no IN (
        900260, 917615, 900573, 1177448, 1365981, 468270, 845135, 652225
    )
),
Names AS (
    SELECT
        customer_no,
        display_name_short
    FROM dbo.FT_CONSTITUENT_DISPLAY_NAME()
),
BoardBase AS (
    SELECT DISTINCT
        customer_no
    FROM VS_ELEMENTS_CONSTITUENCY
    WHERE constituency_no = 1
),
BoardHH AS (
    SELECT a.customer_no,
           b.expanded_customer_no AS BoardHH,
           c.expanded_customer_no AS BoardIndvAffil
    FROM BoardBase a
        LEFT OUTER JOIN V_CUSTOMER_WITH_PRIMARY_AFFILIATES b
            ON a.customer_no = b.customer_no
           AND b.name_ind = -1      -- HH
        LEFT OUTER JOIN V_CUSTOMER_WITH_PRIMARY_AFFILIATES c
            ON c.customer_no = b.expanded_customer_no
           AND c.expanded_customer_no <> a.customer_no  -- not the board member
           AND c.name_ind <> 0      -- not the BRD HH
),

Engagement AS (

    -- get all engagement from the BRD member
    SELECT
        CASE 
            WHEN st.parent_table_name = 'T_PLAN' THEN 'STEP_PLAN'
            WHEN st.parent_table_name = 'T_CUSTOMER' THEN 'STEP_CUSTOMER'
            ELSE 'STEP'
        END AS source_table,
        CASE 
            WHEN st.parent_table_name = 'T_CUSTOMER' THEN s.customer_no
            ELSE p.customer_no
        END AS customer_no,
        cust.display_name_short AS customer,

        CASE 
            WHEN bh.BoardHH IS NOT NULL THEN bh.BoardHH
            WHEN st.parent_table_name = 'T_CUSTOMER' THEN s.customer_no
            ELSE p.customer_no
        END AS group_cust_no,

        CASE 
            WHEN bh.BoardHH IS NOT NULL THEN hhdn.display_name
            ELSE cust.display_name_short
        END AS group_cust_name,

        s.completed_on_dt AS date,
        CAST(s.step_type AS varchar(50)) AS type,
        CASE 
            WHEN s.description IS NULL 
                 OR LTRIM(RTRIM(s.description)) = '' 
                 OR LTRIM(RTRIM(st.description)) = LTRIM(RTRIM(s.description))
                THEN st.description
            ELSE CONCAT(st.description, ' - ', s.description)
        END AS description,
        s.worker_customer_no AS worker_no,
        worker.display_name_short AS worker_name
    FROM T_STEP s
    LEFT JOIN ETeam e
        ON s.worker_customer_no = e.worker_customer_no
    LEFT JOIN T_PLAN p
        ON s.plan_no = p.plan_no
    LEFT JOIN TR_STEP_TYPE st
        ON st.id = s.step_type
    LEFT JOIN Names cust
        ON cust.customer_no = CASE 
            WHEN st.parent_table_name = 'T_CUSTOMER' THEN s.customer_no
            ELSE p.customer_no
        END
    LEFT JOIN Names worker
        ON worker.customer_no = s.worker_customer_no
    INNER JOIN BoardHH bh
        ON bh.customer_no = CASE 
            WHEN st.parent_table_name = 'T_CUSTOMER' THEN s.customer_no
            ELSE p.customer_no
        END
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
        ON hhdn.customer_no = bh.BoardHH       -- HH Display Name
    WHERE
        s.completed_on_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        AND s.completed_on_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND (e.worker_customer_no IS NOT NULL OR s.worker_customer_no IS NULL)

    UNION ALL

    SELECT
        'ACTIVITY' AS source_table,
        sa.customer_no AS customer_no,
        cust.display_name_short AS customer,

        CASE 
                WHEN bh.BoardHH IS NOT NULL THEN bh.BoardHH
                ELSE sa.customer_no
            END AS group_cust_no,

            CASE 
                WHEN bh.BoardHH IS NOT NULL THEN hhdn.display_name
                ELSE cust.display_name_short
            END AS group_cust_name,

        sa.sp_act_dt AS date,
        CAST(sa.sp_act AS varchar(50)) AS type,
        CONCAT(
            CASE 
                WHEN sa_ref.description LIKE 'AICULT%' 
                    THEN SUBSTRING(sa_ref.description, 17, LEN(sa_ref.description)) 
                ELSE sa_ref.description
            END,
            ' - ',
            sas.description,
            ' - ',
            sa.notes
        ) AS description,
        sa.worker_customer_no AS worker_no,
        worker.display_name_short AS worker_name
    FROM T_SPECIAL_ACTIVITY sa
    LEFT JOIN ETeam e
        ON sa.worker_customer_no = e.worker_customer_no
    LEFT JOIN TR_SPECIAL_ACTIVITY sa_ref
        ON sa_ref.id = sa.sp_act
    LEFT JOIN TR_SPECIAL_ACTIVITY_STATUS sas
        ON sas.id = sa.status
    LEFT JOIN Names cust
        ON cust.customer_no = sa.customer_no
    LEFT JOIN Names worker
        ON worker.customer_no = sa.worker_customer_no
    INNER JOIN BoardHH bh
        ON bh.customer_no = sa.customer_no
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
        ON hhdn.customer_no = bh.BoardHH       -- HH Display Name
    WHERE
        sa.sp_act_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        AND sa.sp_act_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND (e.worker_customer_no IS NOT NULL OR sa.worker_customer_no IS NULL)

    UNION ALL

    SELECT
        'EVENT' AS source_table,
        ex.customer_no AS customer_no,
        cust.display_name_short AS customer,

        CASE 
            WHEN bh.BoardHH IS NOT NULL THEN bh.BoardHH
            ELSE ex.customer_no
        END AS group_cust_no,

        CASE 
            WHEN bh.BoardHH IS NOT NULL THEN hhdn.display_name
            ELSE cust.display_name_short
        END AS group_cust_name,

        c.event_dt AS date,
        CAST(ex.evex_no AS varchar(50)) AS type,
        c.description AS description,
        CAST(NULL AS int) AS worker_no,
        CAST(NULL AS varchar(200)) AS worker_name
    FROM TX_EVENT_EXTRACT ex
    LEFT JOIN T_CAMPAIGN c
        ON c.campaign_no = ex.campaign_no
    LEFT JOIN Names cust
        ON cust.customer_no = ex.customer_no
    INNER JOIN BoardHH bh
        ON bh.customer_no = ex.customer_no
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
        ON hhdn.customer_no = bh.BoardHH       -- HH Display Name
    WHERE
        c.event_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        AND c.event_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)

    -- now do all the same stuff, just for the Board HH

    UNION ALL

    SELECT
        CASE 
            WHEN st.parent_table_name = 'T_PLAN' THEN 'STEP_PLAN'
            WHEN st.parent_table_name = 'T_CUSTOMER' THEN 'STEP_CUSTOMER'
            ELSE 'STEP'
        END AS source_table,
        bh.customer_no,
        bmdn.display_name_short AS customer,

        CASE 
            WHEN bh.BoardHH IS NOT NULL THEN bh.BoardHH
            WHEN st.parent_table_name = 'T_CUSTOMER' THEN s.customer_no
            ELSE p.customer_no
        END AS group_cust_no,
        CASE 
            WHEN bh.BoardHH IS NOT NULL THEN hhdn.display_name
            ELSE bmdn.display_name_short
        END AS group_cust_name,

        s.completed_on_dt AS date,
        CAST(s.step_type AS varchar(50)) AS type,
        CASE 
            WHEN s.description IS NULL 
                 OR LTRIM(RTRIM(s.description)) = '' 
                 OR LTRIM(RTRIM(st.description)) = LTRIM(RTRIM(s.description))
                THEN st.description
            ELSE CONCAT(st.description, ' - ', s.description)
        END AS description,
        s.worker_customer_no AS worker_no,
        worker.display_name_short AS worker_name
    FROM T_STEP s
    LEFT JOIN ETeam e
        ON s.worker_customer_no = e.worker_customer_no
    LEFT JOIN T_PLAN p
        ON s.plan_no = p.plan_no
    LEFT JOIN TR_STEP_TYPE st
        ON st.id = s.step_type
    LEFT JOIN Names worker
        ON worker.customer_no = s.worker_customer_no
    INNER JOIN BoardHH bh        
        ON bh.BoardHH = CASE     -- any steps on HHs
            WHEN st.parent_table_name = 'T_CUSTOMER' THEN s.customer_no
            ELSE p.customer_no
        END
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
        ON hhdn.customer_no = bh.BoardHH   -- HH display name
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() bmdn
        ON bmdn.customer_no = bh.customer_no  -- BRD Memb Display Name
    WHERE
        s.completed_on_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        AND s.completed_on_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND (e.worker_customer_no IS NOT NULL OR s.worker_customer_no IS NULL)

    UNION ALL

    SELECT
        'ACTIVITY' AS source_table,
        bh.customer_no AS customer_no,      -- brd mem
        bmdn.display_name_short AS customer,

        CASE 
                WHEN bh.BoardHH IS NOT NULL THEN bh.BoardHH
                ELSE sa.customer_no
            END AS group_cust_no,

            CASE 
                WHEN bh.BoardHH IS NOT NULL THEN hhdn.display_name
                ELSE bmdn.display_name_short
            END AS group_cust_name,

        sa.sp_act_dt AS date,
        CAST(sa.sp_act AS varchar(50)) AS type,
        CONCAT(
            CASE 
                WHEN sa_ref.description LIKE 'AICULT%' 
                    THEN SUBSTRING(sa_ref.description, 17, LEN(sa_ref.description)) 
                ELSE sa_ref.description
            END,
            ' - ',
            sas.description,
            ' - ',
            sa.notes
        ) AS description,
        sa.worker_customer_no AS worker_no,
        worker.display_name_short AS worker_name
    FROM T_SPECIAL_ACTIVITY sa
    LEFT JOIN ETeam e
        ON sa.worker_customer_no = e.worker_customer_no
    LEFT JOIN TR_SPECIAL_ACTIVITY sa_ref
        ON sa_ref.id = sa.sp_act
    LEFT JOIN TR_SPECIAL_ACTIVITY_STATUS sas
        ON sas.id = sa.status
    LEFT JOIN Names worker
        ON worker.customer_no = sa.worker_customer_no
    INNER JOIN BoardHH bh
        ON bh.BoardHH = sa.customer_no       -- any spec activities on HH
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
        ON hhdn.customer_no = bh.BoardHH     -- HH display name
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() bmdn
        ON bmdn.customer_no = bh.customer_no        -- BRD Memb Display Name
    WHERE
        sa.sp_act_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        AND sa.sp_act_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND (e.worker_customer_no IS NOT NULL OR sa.worker_customer_no IS NULL)

    UNION ALL

    SELECT
        'EVENT' AS source_table,
        bh.customer_no AS customer_no,
        bmdn.display_name_short AS customer,

        CASE 
            WHEN bh.BoardHH IS NOT NULL THEN bh.BoardHH
            ELSE ex.customer_no
        END AS group_cust_no,

        CASE 
            WHEN bh.BoardHH IS NOT NULL THEN hhdn.display_name
            ELSE cust.display_name_short
        END AS group_cust_name,

        c.event_dt AS date,
        CAST(ex.evex_no AS varchar(50)) AS type,
        c.description AS description,
        CAST(NULL AS int) AS worker_no,
        CAST(NULL AS varchar(200)) AS worker_name
    FROM TX_EVENT_EXTRACT ex
    LEFT JOIN T_CAMPAIGN c
        ON c.campaign_no = ex.campaign_no
    LEFT JOIN Names cust
        ON cust.customer_no = ex.customer_no
    INNER JOIN BoardHH bh
        ON bh.BoardHH = ex.customer_no
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
        ON hhdn.customer_no = bh.BoardHH   -- HH display name
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() bmdn
        ON bmdn.customer_no = bh.customer_no    -- BRD Memb Display Name
    WHERE
        c.event_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        AND c.event_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)

    UNION ALL 

    -- now do all the same stuff for the BRD Mem HH Affil if exists

    SELECT
        CASE 
            WHEN st.parent_table_name = 'T_PLAN' THEN 'STEP_PLAN'
            WHEN st.parent_table_name = 'T_CUSTOMER' THEN 'STEP_CUSTOMER'
            ELSE 'STEP'
        END AS source_table,
        bh.customer_no,
        bmdn.display_name_short AS customer,

        CASE 
            WHEN bh.BoardHH IS NOT NULL THEN bh.BoardHH
            WHEN st.parent_table_name = 'T_CUSTOMER' THEN s.customer_no
            ELSE p.customer_no
        END AS group_cust_no,
        CASE 
            WHEN bh.BoardHH IS NOT NULL THEN hhdn.display_name
            ELSE bmdn.display_name_short
        END AS group_cust_name,

        s.completed_on_dt AS date,
        CAST(s.step_type AS varchar(50)) AS type,
        CASE 
            WHEN s.description IS NULL 
                 OR LTRIM(RTRIM(s.description)) = '' 
                 OR LTRIM(RTRIM(st.description)) = LTRIM(RTRIM(s.description))
                THEN st.description
            ELSE CONCAT(st.description, ' - ', s.description)
        END AS description,
        s.worker_customer_no AS worker_no,
        worker.display_name_short AS worker_name
    FROM T_STEP s
    LEFT JOIN ETeam e
        ON s.worker_customer_no = e.worker_customer_no
    LEFT JOIN T_PLAN p
        ON s.plan_no = p.plan_no
    LEFT JOIN TR_STEP_TYPE st
        ON st.id = s.step_type
    LEFT JOIN Names worker
        ON worker.customer_no = s.worker_customer_no
    INNER JOIN BoardHH bh        
        ON bh.BoardIndvAffil = CASE   -- any steps on Affils
            WHEN st.parent_table_name = 'T_CUSTOMER' THEN s.customer_no
            ELSE p.customer_no
        END
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
        ON hhdn.customer_no = bh.BoardHH   -- HH display name
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() bmdn
        ON bmdn.customer_no = bh.customer_no        -- BRD Memb Display Name
    WHERE
        s.completed_on_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        AND s.completed_on_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND (e.worker_customer_no IS NOT NULL OR s.worker_customer_no IS NULL)

    UNION ALL

    SELECT
        'ACTIVITY' AS source_table,
        bh.customer_no AS customer_no,      -- brd mem
        bmdn.display_name_short AS customer,

        CASE 
                WHEN bh.BoardHH IS NOT NULL THEN bh.BoardHH
                ELSE sa.customer_no
            END AS group_cust_no,

            CASE 
                WHEN bh.BoardHH IS NOT NULL THEN hhdn.display_name
                ELSE bmdn.display_name_short
            END AS group_cust_name,

        sa.sp_act_dt AS date,
        CAST(sa.sp_act AS varchar(50)) AS type,
        CONCAT(
            CASE 
                WHEN sa_ref.description LIKE 'AICULT%' 
                    THEN SUBSTRING(sa_ref.description, 17, LEN(sa_ref.description)) 
                ELSE sa_ref.description
            END,
            ' - ',
            sas.description,
            ' - ',
            sa.notes
        ) AS description,
        sa.worker_customer_no AS worker_no,
        worker.display_name_short AS worker_name
    FROM T_SPECIAL_ACTIVITY sa
    LEFT JOIN ETeam e
        ON sa.worker_customer_no = e.worker_customer_no
    LEFT JOIN TR_SPECIAL_ACTIVITY sa_ref
        ON sa_ref.id = sa.sp_act
    LEFT JOIN TR_SPECIAL_ACTIVITY_STATUS sas
        ON sas.id = sa.status
    LEFT JOIN Names worker
        ON worker.customer_no = sa.worker_customer_no
    INNER JOIN BoardHH bh
        ON bh.BoardIndvAffil = sa.customer_no       -- any spec activities on Affil
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
        ON hhdn.customer_no = bh.BoardHH   -- HH display name
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() bmdn
        ON bmdn.customer_no = bh.customer_no        -- BRD Memb Display Name
    WHERE
        sa.sp_act_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        AND sa.sp_act_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND (e.worker_customer_no IS NOT NULL OR sa.worker_customer_no IS NULL)

    UNION ALL

    SELECT
        'EVENT' AS source_table,
        bh.customer_no AS customer_no,
        bmdn.display_name_short AS customer,

        CASE 
            WHEN bh.BoardHH IS NOT NULL THEN bh.BoardHH
            ELSE ex.customer_no
        END AS group_cust_no,

        CASE 
            WHEN bh.BoardHH IS NOT NULL THEN hhdn.display_name
            ELSE cust.display_name_short
        END AS group_cust_name,

        c.event_dt AS date,
        CAST(ex.evex_no AS varchar(50)) AS type,
        c.description AS description,
        CAST(NULL AS int) AS worker_no,
        CAST(NULL AS varchar(200)) AS worker_name
    FROM TX_EVENT_EXTRACT ex
    LEFT JOIN T_CAMPAIGN c
        ON c.campaign_no = ex.campaign_no
    LEFT JOIN Names cust
        ON cust.customer_no = ex.customer_no
    INNER JOIN BoardHH bh
        ON bh.BoardIndvAffil = ex.customer_no
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
        ON hhdn.customer_no = bh.BoardHH   -- HH display name
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() bmdn
        ON bmdn.customer_no = bh.customer_no        -- BRD Memb Display Name
    WHERE
        c.event_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        AND c.event_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
UNION ALL

SELECT
    'VS_ELEMENTS_TICKET_HISTORY' AS source_table, --Board Individual
    bh.customer_no AS customer_no,
    bmdn.display_name_short AS customer,

    CASE 
        WHEN bh.BoardHH IS NOT NULL THEN bh.BoardHH
        ELSE bh.customer_no
    END AS group_cust_no,

    CASE 
        WHEN bh.BoardHH IS NOT NULL THEN hhdn.display_name
        ELSE bmdn.display_name_short
    END AS group_cust_name,

    th.perf_dt AS date,
    CAST(th.perf_code AS varchar(50)) AS type,
    LTRIM(RTRIM(CONCAT(
        ISNULL(th.perf_name, ''),
        CASE WHEN th.theater_desc IS NULL OR LTRIM(RTRIM(th.theater_desc)) = '' THEN '' ELSE CONCAT(' - ', th.theater_desc) END,
        CASE WHEN th.location    IS NULL OR LTRIM(RTRIM(th.location))    = '' THEN '' ELSE CONCAT(' - ', th.location)    END
    ))) AS description,
    CAST(NULL AS int) AS worker_no,
    CAST(NULL AS varchar(200)) AS worker_name
FROM VS_ELEMENTS_TICKET_HISTORY th
INNER JOIN BoardHH bh
    ON bh.customer_no = th.customer_no
LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() bmdn
    ON bmdn.customer_no = bh.customer_no
LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
    ON hhdn.customer_no = bh.BoardHH
WHERE
    th.perf_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
    AND th.perf_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
UNION ALL

SELECT
    'VS_ELEMENTS_TICKET_HISTORY' AS source_table,--Board Household
    bh.customer_no AS customer_no,
    bmdn.display_name_short AS customer,

    bh.BoardHH AS group_cust_no,
    hhdn.display_name AS group_cust_name,

    th.perf_dt AS date,
    CAST(th.perf_code AS varchar(50)) AS type,
    LTRIM(RTRIM(CONCAT(
        ISNULL(th.perf_name, ''),
        CASE WHEN th.theater_desc IS NULL OR LTRIM(RTRIM(th.theater_desc)) = '' THEN '' ELSE CONCAT(' - ', th.theater_desc) END,
        CASE WHEN th.location    IS NULL OR LTRIM(RTRIM(th.location))    = '' THEN '' ELSE CONCAT(' - ', th.location)    END
    ))) AS description,
    CAST(NULL AS int) AS worker_no,
    CAST(NULL AS varchar(200)) AS worker_name
FROM VS_ELEMENTS_TICKET_HISTORY th
INNER JOIN BoardHH bh
    ON bh.BoardHH = th.customer_no
LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() bmdn
    ON bmdn.customer_no = bh.customer_no
LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
    ON hhdn.customer_no = bh.BoardHH
WHERE
    th.perf_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
    AND th.perf_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
UNION ALL

SELECT
    'VS_ELEMENTS_TICKET_HISTORY' AS source_table, --Board Primary Affiliate
    bh.customer_no AS customer_no,
    bmdn.display_name_short AS customer,

    bh.BoardHH AS group_cust_no,
    hhdn.display_name AS group_cust_name,

    th.perf_dt AS date,
    CAST(th.perf_code AS varchar(50)) AS type,
    LTRIM(RTRIM(CONCAT(
        ISNULL(th.perf_name, ''),
        CASE WHEN th.theater_desc IS NULL OR LTRIM(RTRIM(th.theater_desc)) = '' THEN '' ELSE CONCAT(' - ', th.theater_desc) END,
        CASE WHEN th.location    IS NULL OR LTRIM(RTRIM(th.location))    = '' THEN '' ELSE CONCAT(' - ', th.location)    END
    ))) AS description,
    CAST(NULL AS int) AS worker_no,
    CAST(NULL AS varchar(200)) AS worker_name
FROM VS_ELEMENTS_TICKET_HISTORY th
INNER JOIN BoardHH bh
    ON bh.BoardIndvAffil = th.customer_no
LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() bmdn
    ON bmdn.customer_no = bh.customer_no
LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
    ON hhdn.customer_no = bh.BoardHH
WHERE
    th.perf_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
    AND th.perf_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
)

-- final select: all engagement rows, plus one "NO_RECENT_ACTIVITY" row per board member with no rows above

SELECT *
FROM Engagement

UNION ALL

SELECT
    'NO_RECENT_ACTIVITY' AS source_table,
    bh.customer_no AS customer_no,
    bmdn.display_name_short AS customer,

    CASE 
        WHEN bh.BoardHH IS NOT NULL THEN bh.BoardHH
        ELSE bh.customer_no
    END AS group_cust_no,

    CASE 
        WHEN bh.BoardHH IS NOT NULL THEN hhdn.display_name
        ELSE bmdn.display_name_short
    END AS group_cust_name,

    CAST(NULL AS datetime) AS date,
    CAST(NULL AS varchar(50)) AS type,
    'No activity in the past month with this board member' AS description,
    CAST(NULL AS int) AS worker_no,
    CAST(NULL AS varchar(200)) AS worker_name
FROM BoardHH bh
LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() bmdn
    ON bmdn.customer_no = bh.customer_no
LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
    ON hhdn.customer_no = bh.BoardHH
WHERE NOT EXISTS (
    SELECT 1
    FROM Engagement e
    WHERE e.customer_no = bh.customer_no
)

ORDER BY date;
