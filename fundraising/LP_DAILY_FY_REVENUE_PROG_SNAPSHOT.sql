CREATE OR ALTER PROCEDURE dbo.LP_DAILY_FY_REVENUE_PROG_SNAPSHOT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @rev_prog_dt date = CAST(GETDATE() AS date);

    DECLARE @fiscal smallint =
        CASE 
            WHEN MONTH(GETDATE()) >= 7 THEN YEAR(GETDATE()) + 1
            ELSE YEAR(GETDATE())
        END;

    ;WITH

    /*CONTRIBUTIONS*/
    contributions AS (
        SELECT 
            SUM(ISNULL(a.cont_amt,0)) as cont_total 
        FROM  T_CONTRIBUTION a
        LEFT JOIN T_CAMPAIGN b on a.campaign_no = b.campaign_no
        LEFT JOIN (SELECT a.*,b.description as campaign_desc, b.cat_desc,b.cat_id, ContAppeal_associated_campaign_fyear
                    FROM T_APPEAL a 
                    LEFT JOIN (SELECT aa.*, bb.id as cat_id,bb.description as cat_desc, aa.fyear as ContAppeal_associated_campaign_fyear
                                FROM T_CAMPAIGN aa 
                                LEFT JOIN TR_CAMPAIGN_CATEGORY bb on aa.category = bb.id) b on a.campaign_no = b.campaign_no) h 
                        ON a.appeal_no = h.appeal_no
        WHERE 1=1
            AND ISNULL(a.cont_amt,0) > 0
            --AND b.fyear = 2026--contribution fyear
            AND h.ContAppeal_associated_campaign_fyear = @fiscal --source fyear
            AND h.cat_id IN (41 --Board
                            , 43 --Campus Fund
                            , 42 --Corporate Sponsorships
                            , 48 --Fellows
                            , 34 --Government
                            , 35 --Individual Giving
                            , 36 --Institutional 
                            , 38 --Special Events
                            )
            AND (b.category IS NULL OR b.category NOT IN (52--comprehensive plans
                                                        ,29--capital
                                                        ,46--President's Discretionary
                                                        ,25--Exchanges and Adjustments
                                                        ))
            --AND (a.fund_no IS NULL OR a.fund_no NOT IN (465 --PD-President's Discretionary
            --                    , 763 --Legacies of San Juan Hill
            --                    ))
            AND a.campaign_no NOT IN (4691) --FY26 In Kind - Not Budgeted
    ),

    /*SECURED*/
    secured AS (
        SELECT
            SUM(ISNULL(a.recorded_amt, 0)) AS secured_total
        FROM VS_PLAN_WITH_PRIMARY_WORKER a
        LEFT JOIN T_CAMPAIGN b on a.campaign_no = b.campaign_no
        WHERE 1=1
        AND a.status IN (16 --06a-Verbal Commitment
                        ,27 --06b-Contract Negotiation
                        ,15 --06c-Hard Commitment
                        ,17 --07-Stewardship
                        ,25 --08-Complete
                        )
        AND a.type IN ( 4--Board
                        ,5--Corporate Sponsorships BDI
                        ,7--Campus Fund
                        ,9--Individual Giving
                        ,10--Institutional
                        ,11--Special Events
                        ,12--Government
                        ,14--Fellows
                        )
        AND b.category IN (39--Annual Restricted
                            , 40 --Annual Unrestricted
                            , 41 --Board
                            , 43 --Campus Fund
                            , 42 --Corporate Sponsorships
                            , 44 --Events Corporate Fund
                            , 45 --Events LC
                            , 48 --Fellows
                            , 34 --Government
                            , 49 --In Kind
                            , 35 --Individual Giving
                            , 36 --Institutional 
                            , 22 --Membership
                            , 30 --Prospect Campaign
                            , 38 --Special Events
        )
        AND a.campaign_no NOT IN (4691) --FY26 In Kind - Not Budgeted
        AND (b.fyear IS NULL OR b.fyear IN (1900, @fiscal)) --Campaign Fiscal Year is NULL, 1900, or current FY
    ),

    /*PORTFOLIO*/
    portfolio AS (
        SELECT
            SUM(ISNULL(a.goal_amt, 0) * ISNULL(a.probability, 0)) AS portfolio
        FROM VS_PLAN_WITH_PRIMARY_WORKER a
        LEFT JOIN T_CAMPAIGN b on a.campaign_no = b.campaign_no
        WHERE 1=1
        AND a.status IN (21 --01-Identification
                        ,11 --02-Qualification
                        ,23 --03-Assignment (inactive status, but still including just in case)
                        ,4  --04-Cultivation
                        ,14 --05a-Ask/Proposal Submitted
                        ,24) --05b-Ask Revision
        AND a.type IN ( 4--Board
                        ,5--Corporate Sponsorships BDI
                        ,7--Campus Fund
                        ,9--Individual Giving
                        ,10--Institutional
                        ,11--Special Events
                        ,12--Government
                        ,14--Fellows
                        )
        AND b.category IN (39--Annual Restricted
                            , 40 --Annual Unrestricted
                            , 41 --Board
                            , 43 --Campus Fund
                            , 42 --Corporate Sponsorships
                            , 44 --Events Corporate Fund
                            , 45 --Events LC
                            , 48 --Fellows
                            , 34 --Government
                            , 49 --In Kind
                            , 35 --Individual Giving
                            , 36 --Institutional 
                            , 22 --Membership
                            , 30 --Prospect Campaign
                            , 38 --Special Events
        )
        AND a.campaign_no NOT IN (4691) --FY26 In Kind - Not Budgeted
        AND (b.fyear IS NULL OR b.fyear IN (1900, @fiscal)) --Campaign Fiscal Year is NULL, 1900, or current FY
    ),

    final AS (
        SELECT
            @rev_prog_dt AS rev_prog_dt,
            CAST(ISNULL(contributions.cont_total,0) AS decimal(19,4)) AS cont_total,
            CAST(ISNULL(secured.secured_total,0) AS decimal(19,4)) AS secured_total,
            CAST(ISNULL(secured.secured_total,0) + ISNULL(portfolio.portfolio,0) AS decimal(19,4)) AS projection_FY_end,
            @fiscal AS fiscal
        FROM contributions
        CROSS JOIN secured
        CROSS JOIN portfolio
    )

    MERGE dbo.LT_DAILY_FY_REVENUE_PROG AS tgt
    USING final AS src
        ON tgt.rev_prog_dt = src.rev_prog_dt
       AND tgt.fiscal = src.fiscal
    WHEN MATCHED THEN --Checks if updated today to avoid duplicate values per date
        UPDATE SET
            tgt.cont_total = src.cont_total,
            tgt.secured_total = src.secured_total,
            tgt.projection_FY_end = src.projection_FY_end,
            tgt.last_update_by = SUSER_SNAME(),
            tgt.last_update_dt = SYSDATETIME()
    WHEN NOT MATCHED THEN
        INSERT (rev_prog_dt, cont_total, secured_total, projection_FY_end, fiscal)
        VALUES (src.rev_prog_dt, src.cont_total, src.secured_total, src.projection_FY_end, src.fiscal);

END;
