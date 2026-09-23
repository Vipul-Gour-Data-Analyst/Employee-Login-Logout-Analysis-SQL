-- =====================================================
-- Employee Login & Logout SQL Case Study
-- MySQL 8.0+
-- =====================================================

USE Employee_CaseStudy;


-- =====================================================
-- VERIFY TABLES
-- =====================================================

SELECT * FROM USERS;

SELECT * FROM LOGINS;


-- =====================================================
-- QUESTION 1
-- Management wants to see all users who did not
-- login in the past 5 months.
--
-- Today Date = 11-07-2025
-- Return: USER_ID
-- =====================================================


-- APPROACH 1

SELECT USER_ID
FROM LOGINS
GROUP BY USER_ID
HAVING MAX(LOGIN_TIMESTAMP) < DATE_SUB('2025-07-11', INTERVAL 5 MONTH);


-- APPROACH 2

SELECT DISTINCT USER_ID
FROM LOGINS
WHERE USER_ID NOT IN
(
    SELECT USER_ID
    FROM LOGINS
    WHERE LOGIN_TIMESTAMP > DATE_SUB('2025-07-11', INTERVAL 5 MONTH)
);


-- =====================================================
-- QUESTION 2
-- Quarterly Analysis
--
-- Calculate:
-- 1. Number of Users
-- 2. Number of Sessions
--
-- Order by Quarter from Newest to Oldest
--
-- Return:
-- First Day of Quarter
-- User Count
-- Session Count
-- =====================================================

WITH Quarter_Data AS
(
    SELECT
        YEAR(LOGIN_TIMESTAMP) AS Login_Year,
        QUARTER(LOGIN_TIMESTAMP) AS Login_Quarter,
        USER_ID
    FROM LOGINS
)

SELECT
    STR_TO_DATE(
        CONCAT(
            Login_Year,
            '-',
            LPAD(
                ((Login_Quarter - 1) * 3) + 1,
                2,
                '0'
            ),
            '-01'
        ),
        '%Y-%m-%d'
    ) AS First_Quarter_Date,

    COUNT(DISTINCT USER_ID) AS User_Count,

    COUNT(*) AS Session_Count

FROM Quarter_Data

GROUP BY
    Login_Year,
    Login_Quarter

ORDER BY
    First_Quarter_Date DESC;


-- =====================================================
-- QUESTION 3
-- Display the users who logged in during January 2025
-- but did NOT login during November 2025.
--
-- Return: USER_ID
-- =====================================================

SELECT *
FROM LOGINS
WHERE LOGIN_TIMESTAMP >= '2025-01-01'
  AND LOGIN_TIMESTAMP < '2025-02-01';


-- Users who logged in in January 2025
-- but did NOT login in November 2025

SELECT DISTINCT USER_ID
FROM LOGINS
WHERE LOGIN_TIMESTAMP >= '2025-01-01'
  AND LOGIN_TIMESTAMP < '2025-02-01'

  AND USER_ID NOT IN
  (
      SELECT DISTINCT USER_ID
      FROM LOGINS
      WHERE LOGIN_TIMESTAMP >= '2025-11-01'
        AND LOGIN_TIMESTAMP < '2025-12-01'
  );


-- =====================================================
-- QUESTION 4
-- Calculate percentage change in sessions
-- from the previous quarter.
--
-- Return:
-- First Day of Quarter
-- Session Count
-- Previous Session Count
-- Session Count Percentage Change
-- =====================================================

WITH Quarter_Data AS
(
    SELECT
        YEAR(LOGIN_TIMESTAMP) AS Login_Year,
        QUARTER(LOGIN_TIMESTAMP) AS Login_Quarter,
        COUNT(*) AS Session_Cnt,
        COUNT(DISTINCT USER_ID) AS User_Count

    FROM LOGINS

    GROUP BY
        YEAR(LOGIN_TIMESTAMP),
        QUARTER(LOGIN_TIMESTAMP)
),

Quarter_Analysis AS
(
    SELECT
        STR_TO_DATE(
            CONCAT(
                Login_Year,
                '-',
                LPAD(
                    ((Login_Quarter - 1) * 3) + 1,
                    2,
                    '0'
                ),
                '-01'
            ),
            '%Y-%m-%d'
        ) AS First_Quarter_Date,

        Session_Cnt,
        User_Count,

        LAG(Session_Cnt) OVER (
            ORDER BY Login_Year, Login_Quarter
        ) AS Previous_Session

    FROM Quarter_Data
)

SELECT
    First_Quarter_Date,

    Session_Cnt AS Session_Count,

    Previous_Session AS Previous_Session_Count,

    CASE
        WHEN Previous_Session IS NULL
             OR Previous_Session = 0
        THEN NULL

        ELSE ROUND(
            (Session_Cnt - Previous_Session)
            * 100.0 / Previous_Session,
            2
        )
    END AS Percentage_Change

FROM Quarter_Analysis

ORDER BY First_Quarter_Date;


-- =====================================================
-- QUESTION 5
-- Display the user that had the highest total
-- session score for each day.
--
-- Return:
-- Date
-- User_Name
-- Score
-- =====================================================

WITH Quarter_Data AS
(
    SELECT
        YEAR(LOGIN_TIMESTAMP) AS Login_Year,
        QUARTER(LOGIN_TIMESTAMP) AS Login_Quarter,
        COUNT(*) AS Session_Cnt,
        COUNT(DISTINCT USER_ID) AS User_Count
    FROM LOGINS
    GROUP BY
        YEAR(LOGIN_TIMESTAMP),
        QUARTER(LOGIN_TIMESTAMP)
),

Quarter_Analysis AS
(
    SELECT
        STR_TO_DATE(
            CONCAT(
                Login_Year,
                '-',
                ((Login_Quarter - 1) * 3) + 1,
                '-01'
            ),
            '%Y-%m-%d'
        ) AS First_Quarter_Date,

        Session_Cnt,
        User_Count,

        LAG(Session_Cnt) OVER (
            ORDER BY Login_Year, Login_Quarter
        ) AS Previous_Session

    FROM Quarter_Data
)

SELECT
    First_Quarter_Date,
    Session_Cnt AS Session_Count,
    Previous_Session AS Previous_Session_Count,

    CASE
        WHEN Previous_Session IS NULL
             OR Previous_Session = 0
        THEN NULL

        ELSE ROUND(
            (Session_Cnt - Previous_Session)
            * 100.0 / Previous_Session,
            2
        )
    END AS Percentage_Change

FROM Quarter_Analysis

ORDER BY First_Quarter_Date;


-- =====================================================
-- QUESTION 6
-- Identify our best users.
--
-- Return users that had a session on every single
-- day since their first login.
--
-- Assumption:
-- Analysis Date = 2025-07-28
--
-- Return:
-- USER_ID
-- First Login
-- Date Difference
-- Count of Login Days
-- =====================================================

SELECT
    USER_ID,

    MIN(DATE(LOGIN_TIMESTAMP)) AS First_Login,

    DATEDIFF(
        '2025-07-28',
        MIN(DATE(LOGIN_TIMESTAMP))
    ) + 1 AS Date_Difference,

    COUNT(
        DISTINCT DATE(LOGIN_TIMESTAMP)
    ) AS Count_Of_Days

FROM LOGINS

GROUP BY USER_ID

ORDER BY USER_ID;