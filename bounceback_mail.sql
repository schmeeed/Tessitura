WITH addr_updates AS (
    SELECT
        customer_no,
        last_updated_by,
        COUNT(*) AS addr_update_cnt,
        MAX(last_update_dt) AS last_addr_update_dt
    FROM VS_ADDRESS
    WHERE last_updated_by IN ('mmeadow', 'mmorales', 'llanning', 'gparache')
      AND last_update_dt >= '2025-10-01'
    GROUP BY
        customer_no,
        last_updated_by
),

dm_promos AS (
    SELECT
        customer_no,
        COUNT(*) AS dm_promo_cnt
    FROM T_PROMOTION
    WHERE promote_dt >= '2025-01-01'
      AND media_type = 3
    GROUP BY customer_no
),

giving AS (
    SELECT
        customer_no,
        SUM(ISNULL(cont_amt, 0)) AS lifetime_giving,
        MAX(cont_dt) AS last_gift_dt
    FROM T_CONTRIBUTION
    WHERE cancel <> 'Y'
      AND cont_type = 'G'
    GROUP BY customer_no
),

memberships AS (
    SELECT
        m.customer_no,
        ml.description AS membership_level,
        m.expiration_dt,
        ROW_NUMBER() OVER (
            PARTITION BY m.customer_no
            ORDER BY m.expiration_dt DESC
        ) AS rn
    FROM T_MEMBERSHIP m
    LEFT JOIN T_MEMBERSHIP_LEVEL ml
        ON ml.id = m.level_id
)

SELECT
    au.customer_no,
    c.fname,
    c.lname,

    au.last_updated_by,
    au.addr_update_cnt,
    au.last_addr_update_dt,

    ISNULL(dm.dm_promo_cnt, 0) AS dm_promos_since_2025,

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

LEFT JOIN dm_promos dm
    ON dm.customer_no = au.customer_no

LEFT JOIN giving g
    ON g.customer_no = au.customer_no

LEFT JOIN memberships m
    ON m.customer_no = au.customer_no
   AND m.rn = 1

ORDER BY
    au.last_updated_by,
    au.addr_update_cnt DESC;
