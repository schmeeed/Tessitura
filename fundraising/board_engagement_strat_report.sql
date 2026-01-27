/*
 * Board Engagement Query
 * Tessitura v16.x
 *
 * Purpose:
 *   Combines engagement activity of Board from
		- Plan & Customer Steps
		- Special Activities
		- Galas (Elevated Events)
		- Ticketed Performances (LCPA and Conciearge Campus Tickets)
 *   for Board members and their associated households.
 *   Date window used throughout the query is mainly based on previous month, but slowly introducing logic for entire Fiscal year.
 *
 * Author: Brian Ralston
 * Created: 2025-11-25
 *
 * EDITS:
 *  2025-12-02 FOC - Added group_cust_no / group_cust_name using expanded household logic
 *  2025-12-17 BMR - Added in Performances to the report VS_ELEMENTS_TICKET_HISTORY and solidified date-window documentation across all UNION blocks, looks at previous month
 *	2025-12-17 BMR - Added Michael Amoroso to list of Strat leaders and listed names next to all strat leader work ID's for easier reading
 *  2026-01-12 BMR - Added Logic to allow special activities with ANY worker, not just STRAT team members, ticketing concierge, Bob, was being tagged as the worker, and data was being surpressed, Also added 'perf' column into concat for SpecAct
 *  2026-01-21 BMR - Added prefeix to 'type' column to include source column name next to the id value for easier post report aggregation. Also creates more of a unique key and avoids potential same ID_no across tables 
 *  2026-01-23 BMR - Added Current FY declare statement, and Expanded Gala Event Attendance for the WHOLE Fiscal year. That data will be filtered out in report to segment gala Attendance for the Whole FY.
 *  2026-01-27 BMR - Added all open board gift asks steps into STEPS WHERE clauses - ALSO added 12 months of special Acitivities for a 12-month total of cultivation events for each board member - ALSO Fixed EVENT description CONCAT and added in 12 months of EVENT instead of only this FY
 */

USE impresario;
GO

DECLARE @CurrentFY int =
    CASE
        WHEN MONTH(GETDATE()) >= 7 THEN YEAR(GETDATE()) + 1  --BMR 2026-01-23
        ELSE YEAR(GETDATE())
    END;



WITH ETeam AS (
    SELECT *
    FROM VS_WORKER_LIST
    WHERE worker_customer_no IN (
        900260 --Laura Colony (SVP, A&I)
		, 917615 -- Erica Wolff (SVP, A&I)
		, 900573 --Shanta Thake (EVP, Chief Artistic Officer)
		, 1177448 --Jim O'Hara (EVP, CFO)
		, 1365981 --Mariko Silver (President and CEO)
		, 468270 --Lauren Klein (EVP, General Counsel)
		, 845135 --Melique Jones (EVP, Chief People Officer)
		, 652225 --Leah Johnson (EVP, Chief Communications and Marketing Officer)
		, 1540367 --Michael Amoroso (SVP, Chief Technology & Digital Officer)
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
/*STEPS*/

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
        CONCAT('step_type-',CAST(s.step_type AS varchar(50))) AS type,
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
        (
		s.completed_on_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        AND s.completed_on_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND (e.worker_customer_no IS NOT NULL OR s.worker_customer_no IS NULL)
		)OR(
		p.status IN(14,24)--Ask Statuses(5a and 5b)
		AND s.step_type IN (28,29,34,40)--Ask Step Types
		AND s.step_dt <= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
		)--BMR 2026-01-27 SELECT * FROM TR_PLAN_STATUS

    UNION ALL

/*ACTIVITIES*/

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
        CONCAT('sp_act-',CAST(sa.sp_act AS varchar(50))) AS type,
        CONCAT(
            CASE 
                WHEN sa_ref.description LIKE 'AICULT%' 
                    THEN SUBSTRING(sa_ref.description, 17, LEN(sa_ref.description)) 
                ELSE sa_ref.description
            END,
            ' - ',
			sa.perf,
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
        sa.sp_act_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 12, 0) -- BMR 2026-01-27
        AND sa.sp_act_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        --AND (e.worker_customer_no IS NOT NULL OR sa.worker_customer_no IS NULL) -- 2026-01-12 Removing STRAT team worker requirement for Special Activities. 

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
        CONCAT('evex_no-',CAST(ex.evex_no as varchar(50))) AS type, --BMR 2026-01-23 --BMR 2026-01-27
		CONCAT(c.description, '-' ,es.description) AS description, --BMR 2026-01-27
        CAST(NULL AS int) AS worker_no,
        CAST(NULL AS varchar(200)) AS worker_name
    FROM TX_EVENT_EXTRACT ex
    LEFT JOIN T_CAMPAIGN c
        ON c.campaign_no = ex.campaign_no 
	LEFT JOIN TR_INVITATION_STATUS es 
		on ex.inv_status = es.id --BMR 2026-01-23
    LEFT JOIN Names cust
        ON cust.customer_no = ex.customer_no
    INNER JOIN BoardHH bh
        ON bh.customer_no = ex.customer_no
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
        ON hhdn.customer_no = bh.BoardHH       -- HH Display Name
	WHERE
        c.event_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 12, 0) -- BMR 2026-01-27
        AND c.event_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
		
		--CASE
		--	WHEN MONTH(c.event_dt) >= 7 THEN YEAR(c.event_dt) + 1
		--	ELSE YEAR(c.event_dt)
		--END = @CurrentFY --BMR 2026-01-23 --BMR 2026-01-27 --Removed Current Fiscal Year Logic

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
        CONCAT('step_type-',CAST(s.step_type AS varchar(50))) AS type,
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
        (
		s.completed_on_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        AND s.completed_on_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND (e.worker_customer_no IS NOT NULL OR s.worker_customer_no IS NULL)
		)OR(
		p.status IN(14,24)--Ask Statuses(5a and 5b)
		AND s.step_type IN (28,29,34,40)--Ask Step Types
		AND s.step_dt <= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
		)--BMR 2026-01-27 SELECT * FROM TR_PLAN_STATUS

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
        CONCAT('sp_act-',CAST(sa.sp_act AS varchar(50))) AS type,
        CONCAT(
            CASE 
                WHEN sa_ref.description LIKE 'AICULT%' 
                    THEN SUBSTRING(sa_ref.description, 17, LEN(sa_ref.description)) 
                ELSE sa_ref.description
            END,
            ' - ',
			sa.perf,
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
        sa.sp_act_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 12, 0) -- BMR 2026-01-27
        AND sa.sp_act_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        --AND (e.worker_customer_no IS NOT NULL OR sa.worker_customer_no IS NULL) -- 2026-01-12 Removing STRAT team worker requirement for Special Activities. 

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
        CONCAT('evex_no-',CAST(ex.evex_no as varchar(50))) AS type, --BMR 2026-01-23 --BMR 2026-01-27
		CONCAT(c.description, '-' ,es.description) AS description, --BMR 2026-01-27
        CAST(NULL AS int) AS worker_no,
        CAST(NULL AS varchar(200)) AS worker_name
    FROM TX_EVENT_EXTRACT ex
    LEFT JOIN T_CAMPAIGN c
        ON c.campaign_no = ex.campaign_no
	LEFT JOIN TR_INVITATION_STATUS es 
		on ex.inv_status = es.id --BMR 2026-01-23
    LEFT JOIN Names cust
        ON cust.customer_no = ex.customer_no
    INNER JOIN BoardHH bh
        ON bh.BoardHH = ex.customer_no
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
        ON hhdn.customer_no = bh.BoardHH   -- HH display name
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() bmdn
        ON bmdn.customer_no = bh.customer_no    -- BRD Memb Display Name
	WHERE
        c.event_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 12, 0) -- BMR 2026-01-27
        AND c.event_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
		
		--CASE
		--	WHEN MONTH(c.event_dt) >= 7 THEN YEAR(c.event_dt) + 1
		--	ELSE YEAR(c.event_dt)
		--END = @CurrentFY --BMR 2026-01-23 --BMR 2026-01-27 --Removed Current Fiscal Year Logic

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
        CONCAT('step_type-',CAST(s.step_type AS varchar(50))) AS type,
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
        (
		s.completed_on_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        AND s.completed_on_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        AND (e.worker_customer_no IS NOT NULL OR s.worker_customer_no IS NULL)
		)OR(
		p.status IN(14,24)--Ask Statuses(5a and 5b)
		AND s.step_type IN (28,29,34,40)--Ask Step Types
		AND s.step_dt <= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
		)--BMR 2026-01-27 SELECT * FROM TR_PLAN_STATUS

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
        CONCAT('sp_act-',CAST(sa.sp_act AS varchar(50))) AS type,
        CONCAT(
            CASE 
                WHEN sa_ref.description LIKE 'AICULT%' 
                    THEN SUBSTRING(sa_ref.description, 17, LEN(sa_ref.description)) 
                ELSE sa_ref.description
            END,
            ' - ',
			sa.perf,
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
        sa.sp_act_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 12, 0) -- BMR 2026-01-27
        AND sa.sp_act_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
        --AND (e.worker_customer_no IS NOT NULL OR sa.worker_customer_no IS NULL) -- 2026-01-12 Removing STRAT team worker requirement for Special Activities. 

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
        CONCAT('evex_no-',CAST(ex.evex_no as varchar(50))) AS type, --BMR 2026-01-23 --BMR 2026-01-27
		CONCAT(c.description, '-' ,es.description) AS description, --BMR 2026-01-27
        CAST(NULL AS int) AS worker_no,
        CAST(NULL AS varchar(200)) AS worker_name
    FROM TX_EVENT_EXTRACT ex
    LEFT JOIN T_CAMPAIGN c
        ON c.campaign_no = ex.campaign_no
	LEFT JOIN TR_INVITATION_STATUS es 
		on ex.inv_status = es.id --BMR 2026-01-23
    LEFT JOIN Names cust
        ON cust.customer_no = ex.customer_no
    INNER JOIN BoardHH bh
        ON bh.BoardIndvAffil = ex.customer_no
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() hhdn
        ON hhdn.customer_no = bh.BoardHH   -- HH display name
    LEFT OUTER JOIN FT_CONSTITUENT_DISPLAY_NAME() bmdn
        ON bmdn.customer_no = bh.customer_no        -- BRD Memb Display Name
	WHERE
        c.event_dt >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 12, 0) -- BMR 2026-01-27
        AND c.event_dt <  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
		
		--CASE
		--	WHEN MONTH(c.event_dt) >= 7 THEN YEAR(c.event_dt) + 1
		--	ELSE YEAR(c.event_dt)
		--END = @CurrentFY --BMR 2026-01-23 --BMR 2026-01-27 --Removed Current Fiscal Year Logic
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
    CONCAT('perf_code-',CAST(th.perf_code AS varchar(50))) AS type,
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
    CONCAT('perf_code-',CAST(th.perf_code AS varchar(50))) AS type,
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
    CONCAT('perf_code-',CAST(th.perf_code AS varchar(50))) AS type,
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
