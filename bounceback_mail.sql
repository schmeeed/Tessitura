WITH addr_updates AS (
    SELECT
        customer_no,
        last_updated_by,
        COUNT(*) AS addr_update_cnt,
        MAX(last_update_dt) AS last_addr_update_dt
    FROM VS_ADDRESS
    WHERE last_updated_by IN ('mmeadow', 'mmorales', 'llanning', 'gparache')
      AND last_update_dt >= '2025-10-01'
    GROUP BY customer_no, last_updated_by
),

dm_data AS (
    SELECT
        p.customer_no,
        COUNT(*) AS dm_promo_cnt,
        MAX(a.start_dt) AS last_appeal_dt
    FROM addr_updates au
    JOIN T_PROMOTION p
        ON p.customer_no = au.customer_no
    JOIN T_APPEAL a
        ON a.appeal_no = p.appeal_no
    WHERE p.media_type = 3
      AND a.start_dt >= '2024-07-01'   -- FY25 start (adjust if needed)
    GROUP BY p.customer_no
),

last_dm_appeal AS (
    SELECT *
    FROM (
        SELECT
            p.customer_no,
            a.description AS last_dm_appeal_desc,
            a.start_dt,
            ROW_NUMBER() OVER (
                PARTITION BY p.customer_no
                ORDER BY a.start_dt DESC
            ) AS rn
        FROM addr_updates au
        JOIN T_PROMOTION p
            ON p.customer_no = au.customer_no
        JOIN T_APPEAL a
            ON a.appeal_no = p.appeal_no
        WHERE p.media_type = 3
    ) x
    WHERE rn = 1
),

giving AS (
    SELECT
        tc.customer_no,
        SUM(ISNULL(tc.cont_amt, 0)) AS lifetime_giving,
        MAX(tc.cont_dt) AS last_gift_dt
    FROM T_CONTRIBUTION tc
    JOIN addr_updates au
        ON au.customer_no = tc.customer_no
    WHERE tc.cancel <> 'Y'
      AND tc.cont_type = 'G'
    GROUP BY tc.customer_no
),

memberships AS (
    SELECT *
    FROM (
        SELECT
            m.customer_no,
            ml.description AS membership_level,
            m.expiration_dt,
            ROW_NUMBER() OVER (
                PARTITION BY m.customer_no
                ORDER BY m.expiration_dt DESC
            ) AS rn
        FROM T_MEMBERSHIP m
        JOIN addr_updates au
            ON au.customer_no = m.customer_no
        LEFT JOIN T_MEMBERSHIP_LEVEL ml
            ON ml.id = m.level_id
    ) x
    WHERE rn = 1
)

SELECT
    au.customer_no,
    c.fname,
    c.lname,

    au.last_updated_by,
    au.addr_update_cnt,
    au.last_addr_update_dt,

    ISNULL(dm.dm_promo_cnt, 0) AS dm_promo_cnt_FY25_plus,
    dm.last_appeal_dt,

    lda.last_dm_appeal_desc,
    lda.start_dt AS last_dm_appeal_start_dt,

    g.lifetime_giving,
    g.last_gift_dt,

    CASE
        WHEN m.customer_no IS NOT NULL THEN 'Y'
        ELSE 'N'
    END AS ever_member,
    m.membership_level,
    m.expiration_dt

FROM addr_updates au
JOIN T_CUSTOMER c
    ON c.customer_no = au.customer_no

LEFT JOIN dm_data dm
    ON dm.customer_no = au.customer_no

LEFT JOIN last_dm_appeal lda
    ON lda.customer_no = au.customer_no

LEFT JOIN giving g
    ON g.customer_no = au.customer_no

LEFT JOIN memberships m
    ON m.customer_no = au.customer_no

ORDER BY
    au.last_updated_by,
    au.addr_update_cnt DESC;
