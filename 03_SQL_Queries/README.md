# Employee Login & Logout SQL Case Study --- SQL Queries

A collection of **MySQL 8.0+ analytical SQL queries** built on the
`Employee_CaseStudy` database.

This case study focuses on employee login activity, session analysis,
quarterly trends, user inactivity, and user engagement.

------------------------------------------------------------------------

## 📌 Project Overview

**Database:** `Employee_CaseStudy`\
**DBMS:** MySQL 8.0+\
**Tables:** `USERS`, `LOGINS`\
**Domain:** Employee Login & Session Analysis

### Tables

-   `USERS` --- employee/user details and current status
-   `LOGINS` --- login timestamps, sessions, and session scores

### Key SQL Concepts Used

-   `GROUP BY`
-   `HAVING`
-   `DISTINCT`
-   `NOT IN`
-   Subqueries
-   Common Table Expressions (CTEs)
-   Date and time functions
-   `DATE_SUB()`
-   `DATEDIFF()`
-   `YEAR()`
-   `QUARTER()`
-   `STR_TO_DATE()`
-   `LAG()` window function
-   Conditional logic with `CASE`
-   Percentage calculations
-   Aggregations
-   `COUNT(DISTINCT ...)`

------------------------------------------------------------------------

# 🗂️ Query Index

  -----------------------------------------------------------------------
  \#                      Business Problem        Main SQL Concepts
  ----------------------- ----------------------- -----------------------
  1                       Users inactive for the  `MAX()`, `HAVING`,
                          past 5 months           `DATE_SUB()`

  2                       Quarterly user and      CTE, `YEAR()`,
                          session analysis        `QUARTER()`,
                                                  aggregation

  3                       January users who did   Date filtering,
                          not log in during       `NOT IN`, subquery
                          November                

  4                       Session percentage      CTE, `LAG()`, `CASE`,
                          change by quarter       percentage calculation

  5                       Daily highest session   Daily aggregation,
                          score                   ranking logic

  6                       Users who logged in     `MIN()`, `DATEDIFF()`,
                          every day since first   `COUNT(DISTINCT)`
                          login                   
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 1. Verify Tables

Before running the analytical queries, verify that the tables contain
data.

### View USERS

``` sql
SELECT *
FROM USERS;
```

### View LOGINS

``` sql
SELECT *
FROM LOGINS;
```

------------------------------------------------------------------------

# 2. Users Who Did Not Login in the Past 5 Months

### Business Question

Management wants to identify users who **did not log in during the
previous 5 months**.

**Analysis Date:** `2025-07-11`

**Return:** `USER_ID`

## Approach 1 --- GROUP BY + HAVING

``` sql
SELECT USER_ID
FROM LOGINS
GROUP BY USER_ID
HAVING MAX(LOGIN_TIMESTAMP)
       < DATE_SUB('2025-07-11', INTERVAL 5 MONTH);
```

### Logic

1.  Group login records by user.
2.  Find each user's latest login using `MAX()`.
3.  Compare the latest login with the date 5 months before the analysis
    date.
4.  Return users whose latest login occurred before that date.

------------------------------------------------------------------------

## Approach 2 --- NOT IN Subquery

``` sql
SELECT DISTINCT USER_ID
FROM LOGINS
WHERE USER_ID NOT IN
(
    SELECT USER_ID
    FROM LOGINS
    WHERE LOGIN_TIMESTAMP >
          DATE_SUB('2025-07-11', INTERVAL 5 MONTH)
);
```

### SQL Concepts

-   `GROUP BY`
-   `HAVING`
-   `MAX()`
-   `DATE_SUB()`
-   `NOT IN`
-   Subqueries

------------------------------------------------------------------------

# 3. Quarterly User & Session Analysis

### Business Question

Calculate the following for each quarter:

1.  Number of unique users
2.  Number of sessions

Return the **first day of each quarter** and order results from **newest
to oldest**.

### Expected Output

  Column                 Description
  ---------------------- --------------------------
  `First_Quarter_Date`   First day of the quarter
  `User_Count`           Number of unique users
  `Session_Count`        Number of sessions

## Query

``` sql
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
```

### SQL Concepts

-   CTE
-   `YEAR()`
-   `QUARTER()`
-   `COUNT()`
-   `COUNT(DISTINCT)`
-   Date construction
-   `GROUP BY`
-   `ORDER BY`

------------------------------------------------------------------------

# 4. January 2025 Users Who Did Not Login in November 2025

### Business Question

Identify users who:

-   Logged in during **January 2025**
-   Did **not** log in during **November 2025**

**Return:** `USER_ID`

### Check January Login Records

``` sql
SELECT *
FROM LOGINS
WHERE LOGIN_TIMESTAMP >= '2025-01-01'
  AND LOGIN_TIMESTAMP < '2025-02-01';
```

### Final Query

``` sql
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
```

### SQL Concepts

-   Date range filtering
-   `DISTINCT`
-   `NOT IN`
-   Subqueries

> **Note:** The supplied sample dataset does not contain November 2025
> login records, so this query will treat all January 2025 users as
> having no November 2025 login unless additional November data is
> inserted.

------------------------------------------------------------------------

# 5. Session Percentage Change from Previous Quarter

### Business Question

Calculate the percentage change in the number of sessions compared with
the previous quarter.

### Expected Output

  Column                     Description
  -------------------------- -----------------------------------------
  `First_Quarter_Date`       First day of the quarter
  `Session_Count`            Current quarter sessions
  `Previous_Session_Count`   Previous quarter sessions
  `Percentage_Change`        Percentage change from previous quarter

## Query

``` sql
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
```

### Percentage Formula

``` text
Percentage Change =
(Current Quarter Sessions - Previous Quarter Sessions)
------------------------------------------------------ × 100
              Previous Quarter Sessions
```

### SQL Concepts

-   CTEs
-   `LAG()`
-   Window functions
-   `CASE`
-   `ROUND()`
-   Percentage calculations
-   Aggregation

------------------------------------------------------------------------

# 6. Daily Highest Session Score

### Business Question

Display the user who had the **highest total session score for each
day**.

### Expected Output

  Column        Description
  ------------- -----------------------------------------------
  `Date`        Login date
  `User_Name`   User with the highest total score
  `Score`       Total session score for that user on that day

### Important Note

The SQL supplied for Question 5 in the original case study repeats the
**quarterly percentage-change query** instead of solving the stated
daily highest-session-score requirement.

The intended solution should first aggregate `SESSION_SCORE` by user and
date, then rank the users within each date.

A MySQL 8.0+ solution is:

``` sql
WITH Daily_Scores AS
(
    SELECT
        DATE(L.LOGIN_TIMESTAMP) AS Login_Date,
        L.USER_ID,
        U.USER_NAME,
        SUM(L.SESSION_SCORE) AS Total_Score
    FROM LOGINS L
    JOIN USERS U
        ON L.USER_ID = U.USER_ID
    GROUP BY
        DATE(L.LOGIN_TIMESTAMP),
        L.USER_ID,
        U.USER_NAME
),

Ranked_Scores AS
(
    SELECT
        Login_Date,
        USER_NAME,
        Total_Score,
        RANK() OVER (
            PARTITION BY Login_Date
            ORDER BY Total_Score DESC
        ) AS Score_Rank
    FROM Daily_Scores
)

SELECT
    Login_Date AS Date,
    USER_NAME AS User_Name,
    Total_Score AS Score
FROM Ranked_Scores
WHERE Score_Rank = 1
ORDER BY Date;
```

### SQL Concepts

-   `JOIN`
-   `DATE()`
-   `SUM()`
-   CTE
-   `RANK()`
-   `PARTITION BY`
-   Daily aggregation

------------------------------------------------------------------------

# 7. Users Who Logged In Every Day Since Their First Login

### Business Question

Identify users who had a login on **every single day since their first
login**.

**Analysis Date:** `2025-07-28`

### Return

-   `USER_ID`
-   `First_Login`
-   `Date_Difference`
-   `Count_Of_Days`

## Query

``` sql
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
```

### Important Logic

The query calculates:

``` text
Date Difference =
Analysis Date - First Login Date + 1
```

and compares that with:

``` text
Count of distinct login days
```

To identify users who logged in every day, add a `HAVING` condition:

``` sql
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

HAVING COUNT(
    DISTINCT DATE(LOGIN_TIMESTAMP)
) =
DATEDIFF(
    '2025-07-28',
    MIN(DATE(LOGIN_TIMESTAMP))
) + 1

ORDER BY USER_ID;
```

### SQL Concepts

-   `MIN()`
-   `DATE()`
-   `DATEDIFF()`
-   `COUNT(DISTINCT)`
-   `GROUP BY`
-   `HAVING`

------------------------------------------------------------------------

# 🧠 SQL Skills Demonstrated

This case study demonstrates practical SQL skills commonly used in data
analysis:

### Data Filtering

``` sql
WHERE
HAVING
```

### Aggregation

``` sql
COUNT()
COUNT(DISTINCT)
SUM()
MAX()
MIN()
```

### Date Analysis

``` sql
DATE()
DATE_SUB()
DATEDIFF()
YEAR()
QUARTER()
```

### Advanced SQL

``` sql
WITH
LAG()
RANK()
PARTITION BY
```

### Relational Analysis

``` sql
JOIN
Subqueries
Foreign Keys
Primary Keys
```

------------------------------------------------------------------------

# 📁 Recommended Project Structure

``` text
Employee-Login-Logout-SQL-Case-Study/
│
├── README.md
│
├── employee_login_logout_schema.sql
│
├── employee_login_logout_queries.sql
│
└── screenshots/
    ├── database_schema.png
    └── query_results.png
```

------------------------------------------------------------------------

# 🚀 How to Run

### Step 1 --- Create the Database

Run the database schema script:

``` sql
CREATE DATABASE IF NOT EXISTS Employee_CaseStudy;

USE Employee_CaseStudy;
```

### Step 2 --- Create Tables

Create:

-   `USERS`
-   `LOGINS`

### Step 3 --- Insert Sample Data

Insert the users and login/session records.

### Step 4 --- Run Analytical Queries

Execute the queries in this README using **MySQL 8.0+**.

------------------------------------------------------------------------

# 📌 Case Study Summary

The Employee Login & Logout SQL Case Study uses employee login and
session data to solve practical business questions.

The analysis covers:

-   User inactivity
-   Quarterly active users
-   Quarterly session volume
-   User retention between months
-   Session growth/decline
-   Daily session-score analysis
-   Consistent daily engagement

This project demonstrates how SQL can transform raw login data into
useful business insights.

------------------------------------------------------------------------

## 👨‍💻 Portfolio Project

**Employee Login & Logout SQL Case Study**

**Tools:** MySQL 8.0+, SQL

**Focus:** Data Analysis \| SQL Case Study \| Employee Engagement \|
Session Analysis \| Advanced SQL
