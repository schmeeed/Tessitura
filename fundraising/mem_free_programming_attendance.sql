/********************************************************************
Purpose:
Calculate member engagement with free programming.

American Songbook is rolled into the corresponding
Lincoln Center Presents year.

Final reporting groups:

    22/23 Lincoln Center Presents
        prod_no 23959
        prod_no 24621, American Songbook 2023

    Summer for the City 2023
        prod_no 24660

    23/24 Lincoln Center Presents
        prod_no 26138
        prod_no 26898, American Songbook 2024

    Summer for the City 2024
        prod_no 27693

    24/25 Lincoln Center Presents
        prod_no 29169
        prod_no 31800, American Songbook 2025

    Summer for the City 2025
        prod_no 30442

    25/26 Lincoln Center Presents
        prod_no 29887
        prod_no 31801, American Songbook 2026

    Lincoln Center Presents FY27
        season 491

    Summer for the City FY27
        season 487

Active-member definition:
    A member qualifies if their membership overlapped any portion
    of the program's first-to-last-performance window.

Attendance definition:
    A customer qualifies as attending if they either:

        1. Had a ticket where:
               price_type IN (363, 1382)

               OR

               the total ticket amount was $0 with at least
               one seat

        2. Appeared in VS_ELEMENTS_ATTENDANCE for a performance
           included in the program.

American Songbook and Lincoln Center Presents attendance is
deduplicated at the customer level.

FY27:
    Includes completed and future scheduled performances.

    Future attendance is represented through qualifying tickets
    that have already been booked.

    Member-card scans naturally only exist for performances that
    have already occurred.

    Lincoln Center Presents FY27 excludes erroneous season 491
    performances dated before September 10, 2026.
********************************************************************/

SET NOCOUNT ON;


/********************************************************************
0. Remove temporary tables from prior runs
********************************************************************/

DROP TABLE IF EXISTS #Programs;
DROP TABLE IF EXISTS #ProgramSources;
DROP TABLE IF EXISTS #ProgramPerformances;
DROP TABLE IF EXISTS #ProgramDateRanges;
DROP TABLE IF EXISTS #ActiveMembers;
DROP TABLE IF EXISTS #TicketAttendance;
DROP TABLE IF EXISTS #ScanAttendance;
DROP TABLE IF EXISTS #AttendedMembers;


/********************************************************************
1. Define final reporting groups
********************************************************************/

CREATE TABLE #Programs
(
    program_id   INT          NOT NULL PRIMARY KEY,
    program_name VARCHAR(100) NOT NULL
);

INSERT INTO #Programs
(
    program_id,
    program_name
)
VALUES
    (1, '22/23 Lincoln Center Presents'),
    (2, 'Summer for the City 2023'),

    (3, '23/24 Lincoln Center Presents'),
    (4, 'Summer for the City 2024'),

    (5, '24/25 Lincoln Center Presents'),
    (6, 'Summer for the City 2025'),

    (7, '25/26 Lincoln Center Presents'),

    (8, 'Lincoln Center Presents FY27'),
    (9, 'Summer for the City FY27');


/********************************************************************
2. Map productions and seasons into each reporting group

American Songbook is mapped into the corresponding
Lincoln Center Presents group.
********************************************************************/

CREATE TABLE #ProgramSources
(
    program_id  INT         NOT NULL,
    source_type VARCHAR(10) NOT NULL,
    source_id   INT         NOT NULL,

    CONSTRAINT PK_ProgramSources
        PRIMARY KEY
        (
            program_id,
            source_type,
            source_id
        )
);

INSERT INTO #ProgramSources
(
    program_id,
    source_type,
    source_id
)
VALUES
    /* 22/23 LCP and American Songbook 2023 */
    (1, 'PROD', 23959),
    (1, 'PROD', 24621),

    /* Summer for the City 2023 */
    (2, 'PROD', 24660),

    /* 23/24 LCP and American Songbook 2024 */
    (3, 'PROD', 26138),
    (3, 'PROD', 26898),

    /* Summer for the City 2024 */
    (4, 'PROD', 27693),

    /* 24/25 LCP and American Songbook 2025 */
    (5, 'PROD', 29169),
    (5, 'PROD', 31800),

    /* Summer for the City 2025 */
    (6, 'PROD', 30442),

    /* 25/26 LCP and American Songbook 2026 */
    (7, 'PROD', 29887),
    (7, 'PROD', 31801),

    /* Lincoln Center Presents FY27 */
    (8, 'SEASON', 491),

    /* Summer for the City FY27 */
    (9, 'SEASON', 487);


CREATE NONCLUSTERED INDEX IX_ProgramSources_Source
    ON #ProgramSources
    (
        source_type,
        source_id,
        program_id
    );


/********************************************************************
3. Build the performance list

Production-based programming:
    Match on prod_no.

FY27 programming:
    Match on season.

Future FY27 performances are included.

Season 491 records before September 10, 2026 are excluded because
they are erroneous and do not belong to the FY27 LCP period.

Source information is retained on each performance so ticket records
can be matched directly to the correct production or season.
********************************************************************/

CREATE TABLE #ProgramPerformances
(
    program_id  INT         NOT NULL,
    source_type VARCHAR(10) NOT NULL,
    source_id   INT         NOT NULL,
    perf_no     INT         NOT NULL,
    perf_dt     DATE        NOT NULL
);


/* Production-based performances */

INSERT INTO #ProgramPerformances
(
    program_id,
    source_type,
    source_id,
    perf_no,
    perf_dt
)
SELECT DISTINCT
    ps.program_id,
    ps.source_type,
    ps.source_id,
    th.perf_no,
    CAST(th.perf_dt AS DATE)
FROM #ProgramSources ps

INNER JOIN dbo.vs_ticket_history th WITH (NOLOCK)
    ON ps.source_type = 'PROD'
   AND th.prod_no = ps.source_id

WHERE th.perf_no IS NOT NULL
  AND th.perf_dt IS NOT NULL;


/* FY27 season-based performances, including future performances */

INSERT INTO #ProgramPerformances
(
    program_id,
    source_type,
    source_id,
    perf_no,
    perf_dt
)
SELECT DISTINCT
    ps.program_id,
    ps.source_type,
    ps.source_id,
    th.perf_no,
    CAST(th.perf_dt AS DATE)
FROM #ProgramSources ps

INNER JOIN dbo.vs_ticket_history th WITH (NOLOCK)
    ON ps.source_type = 'SEASON'
   AND th.season = ps.source_id

WHERE th.perf_no IS NOT NULL
  AND th.perf_dt IS NOT NULL

  /* Exclude erroneous pre-season records from LCP FY27 */
  AND
  (
      ps.source_id <> 491
      OR th.perf_dt >= '2026-09-10'
  );


CREATE UNIQUE CLUSTERED INDEX IX_ProgramPerformances
    ON #ProgramPerformances
    (
        program_id,
        source_type,
        source_id,
        perf_no,
        perf_dt
    );


CREATE NONCLUSTERED INDEX IX_ProgramPerformances_Performance
    ON #ProgramPerformances
    (
        perf_no,
        perf_dt,
        program_id
    );


/********************************************************************
4. Determine first and last performance dates

Because American Songbook falls inside the corresponding
Lincoln Center Presents period, the historical LCP ranges should
remain:

    22/23 LCP: 09/16/2022 through 05/23/2023
    23/24 LCP: 09/07/2023 through 06/02/2024
    24/25 LCP: 09/07/2024 through 06/05/2025
    25/26 LCP: 09/05/2025 through 05/29/2026

Lincoln Center Presents FY27 should begin on September 10, 2026.
********************************************************************/

SELECT
    program_id,
    MIN(perf_dt) AS first_performance_date,
    MAX(perf_dt) AS last_performance_date
INTO #ProgramDateRanges
FROM #ProgramPerformances
GROUP BY
    program_id;


CREATE UNIQUE CLUSTERED INDEX IX_ProgramDateRanges
    ON #ProgramDateRanges
    (
        program_id
    );


/********************************************************************
5. Build the active-member denominator

A member qualifies if their membership overlapped any portion of
the overall program window.

Membership start:
    Must be on or before the program's last performance date.

Membership expiration:
    Must be on or after the program's first performance date,
    or expiration_dt must be NULL.

The member does not need to have been active on the exact date they
attended.
********************************************************************/

CREATE TABLE #ActiveMembers
(
    program_id  INT NOT NULL,
    customer_no INT NOT NULL
);


INSERT INTO #ActiveMembers
(
    program_id,
    customer_no
)
SELECT DISTINCT
    pdr.program_id,
    m.customer_no
FROM #ProgramDateRanges pdr

INNER JOIN dbo.T_MEMBERSHIP m WITH (NOLOCK)
    ON m.start_dt < DATEADD
    (
        DAY,
        1,
        pdr.last_performance_date
    )
   AND
   (
       m.expiration_dt IS NULL
       OR m.expiration_dt >= pdr.first_performance_date
   )

INNER JOIN dbo.T_MEMBERSHIP_LEVEL ml WITH (NOLOCK)
    ON ml.id = m.level_id
   AND ml.organization_no IN (1, 66, 65)

INNER JOIN dbo.V_CUSTOMER_WITH_PRIMARY_GROUP c WITH (NOLOCK)
    ON c.customer_no = m.customer_no
   AND c.inactive = 1

WHERE m.customer_no IS NOT NULL;


CREATE UNIQUE CLUSTERED INDEX IX_ActiveMembers
    ON #ActiveMembers
    (
        program_id,
        customer_no
    );


/********************************************************************
6. Identify qualifying ticket attendance

A ticket qualifies if EITHER:

    price_type IN (363, 1382)

OR

    total ticket amount = $0 with at least one seat.

Tickets must belong to a performance in #ProgramPerformances.

Because future FY27 performances appear in #ProgramPerformances,
qualifying tickets already booked for future performances are
included.

The source information stored in #ProgramPerformances ensures that
a ticket matches the correct production or FY27 season.
********************************************************************/

CREATE TABLE #TicketAttendance
(
    program_id  INT NOT NULL,
    customer_no INT NOT NULL
);


INSERT INTO #TicketAttendance
(
    program_id,
    customer_no
)
SELECT DISTINCT
    pp.program_id,
    th.customer_no
FROM #ProgramPerformances pp

INNER JOIN dbo.vs_ticket_history th WITH (NOLOCK)
    ON th.perf_no = pp.perf_no
   AND th.perf_dt >= pp.perf_dt
   AND th.perf_dt < DATEADD(DAY, 1, pp.perf_dt)

   AND
   (
       (
           pp.source_type = 'PROD'
           AND th.prod_no = pp.source_id
       )
       OR
       (
           pp.source_type = 'SEASON'
           AND th.season = pp.source_id
       )
   )

WHERE th.customer_no IS NOT NULL

  AND
  (
      th.price_type IN (363, 1382)

      OR

      (
          th.num_seats > 0
          AND th.tck_amt = 0
      )
  );


CREATE UNIQUE CLUSTERED INDEX IX_TicketAttendance
    ON #TicketAttendance
    (
        program_id,
        customer_no
    );


/********************************************************************
7. Identify member-card scan attendance

Any attendance scan associated with a performance included in
#ProgramPerformances qualifies.

Scans are not restricted by membership dates or membership levels.

Future performances will not have scans yet, so future FY27
engagement is represented by qualifying advance ticket bookings.

Match on both:
    - performance number
    - performance date
********************************************************************/

CREATE TABLE #ScanAttendance
(
    program_id  INT NOT NULL,
    customer_no INT NOT NULL
);


INSERT INTO #ScanAttendance
(
    program_id,
    customer_no
)
SELECT DISTINCT
    pp.program_id,
    ea.customer_no
FROM #ProgramPerformances pp

INNER JOIN dbo.VS_ELEMENTS_ATTENDANCE ea WITH (NOLOCK)
    ON ea.perf_no = pp.perf_no
   AND ea.perf_dt >= pp.perf_dt
   AND ea.perf_dt < DATEADD(DAY, 1, pp.perf_dt)

WHERE ea.customer_no IS NOT NULL;


CREATE UNIQUE CLUSTERED INDEX IX_ScanAttendance
    ON #ScanAttendance
    (
        program_id,
        customer_no
    );


/********************************************************************
8. Combine ticket and scan attendance

UNION ensures each customer only counts once per reporting group.

Examples:

    A customer attends regular LCP and American Songbook:
        Counts once for the combined LCP period.

    A customer has a qualifying ticket and a card scan:
        Counts once.

    A customer books multiple qualifying tickets:
        Counts once.
********************************************************************/

SELECT
    program_id,
    customer_no
INTO #AttendedMembers
FROM #TicketAttendance

UNION

SELECT
    program_id,
    customer_no
FROM #ScanAttendance;


CREATE UNIQUE CLUSTERED INDEX IX_AttendedMembers
    ON #AttendedMembers
    (
        program_id,
        customer_no
    );


/********************************************************************
9. Final output

The attended-member population is intersected with the active-member
population.

Final metric:

    Of members who were active at any point while the program was
    running, what percentage had either:

        - a qualifying ticket booking; or
        - an attendance scan?
********************************************************************/

SELECT
    p.program_name,

    pdr.first_performance_date,

    pdr.last_performance_date,

    COUNT(am.customer_no)
        AS active_member_count,

    COUNT(attended.customer_no)
        AS attended_member_count,

    CAST
    (
        COUNT(attended.customer_no) * 100.0
        /
        NULLIF
        (
            COUNT(am.customer_no),
            0
        )
        AS DECIMAL(6,2)
    ) AS attendance_percentage

FROM #Programs p

LEFT JOIN #ProgramDateRanges pdr
    ON pdr.program_id = p.program_id

LEFT JOIN #ActiveMembers am
    ON am.program_id = p.program_id

LEFT JOIN #AttendedMembers attended
    ON attended.program_id = am.program_id
   AND attended.customer_no = am.customer_no

GROUP BY
    p.program_id,
    p.program_name,
    pdr.first_performance_date,
    pdr.last_performance_date

ORDER BY
    pdr.first_performance_date,
    p.program_id;


/********************************************************************
10. Cleanup
********************************************************************/

DROP TABLE IF EXISTS #AttendedMembers;
DROP TABLE IF EXISTS #ScanAttendance;
DROP TABLE IF EXISTS #TicketAttendance;
DROP TABLE IF EXISTS #ActiveMembers;
DROP TABLE IF EXISTS #ProgramDateRanges;
DROP TABLE IF EXISTS #ProgramPerformances;
DROP TABLE IF EXISTS #ProgramSources;
DROP TABLE IF EXISTS #Programs;
