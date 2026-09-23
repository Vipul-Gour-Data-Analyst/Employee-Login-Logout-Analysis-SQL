# 📊 Employee Login & Logout SQL Case Study

A practical **MySQL 8.0+ SQL case study** focused on employee login
activity, session analysis, user inactivity, quarterly trends, session
performance, and employee engagement.

This project demonstrates how SQL can be used to transform login/session
data into meaningful business insights.

------------------------------------------------------------------------

# 📌 Project Overview

The **Employee Login & Logout SQL Case Study** is a relational database
project designed to analyze employee login and session activity.

The database contains:

-   Employee/user information
-   Active/inactive user status
-   Login timestamps
-   Session IDs
-   Session scores
-   Historical login activity from 2024 and 2025

The project includes business-oriented SQL questions covering
inactivity, quarterly analysis, month-to-month user comparison, session
growth, daily session scores, and consistent user engagement.

------------------------------------------------------------------------

# 🎯 Business Problem

Organizations need to monitor employee login activity to understand user engagement and identify inactive employees.

This project analyzes employee login and session data to help management:

- Identify employees who have not logged in recently.
- Analyze login frequency and session activity.
- Compare active and inactive employees.
- Identify high and low login activity patterns.
- Analyze session scores and employee engagement.
- Track login trends across different time periods.
- Rank employees based on login activity.

The analysis uses MySQL and SQL to convert raw login data into meaningful insights that can support workforce monitoring and operational decision-making.

------------------------------------------------------------------------

# 🗄️ Database Information

  Component       Details
  --------------- --------------------------------------
  |Database       | `Employee_CaseStudy`
  |DBMS           | MySQL 8.0+
  |Database Type  | Relational Database
  |Tables         | `USERS`, `LOGINS`
  |Primary Keys   | `USERS.USER_ID`, `LOGINS.SESSION_ID`
  |Foreign Key    |`LOGINS.USER_ID`
  |Relationship   | One-to-Many
  |Main Domain    | Employee Login & Session Analysis

------------------------------------------------------------------------

# 🧩 Database Schema

## USERS Table

The `USERS` table stores employee/user information.

  Column          Data Type     Constraint    Description
  --------------- ------------- ------------- ------------------------
  `USER_ID`       INT           PRIMARY KEY   Unique user identifier
  `USER_NAME`     VARCHAR(20)   NOT NULL      User name
  `USER_STATUS`   VARCHAR(20)   NOT NULL      Current user status

### SQL

``` sql
CREATE TABLE IF NOT EXISTS USERS (
    USER_ID INT PRIMARY KEY,
    USER_NAME VARCHAR(20) NOT NULL,
    USER_STATUS VARCHAR(20) NOT NULL
);
```

------------------------------------------------------------------------

## LOGINS Table

The `LOGINS` table stores employee login/session activity.

  Column              Data Type   Constraint              Description
  ------------------- ----------- ----------------------- ---------------------------
  `USER_ID`           INT         NOT NULL, FOREIGN KEY   Identifies the user
  `LOGIN_TIMESTAMP`   DATETIME    NOT NULL                Login date and time
  `SESSION_ID`        INT         PRIMARY KEY             Unique session identifier
  `SESSION_SCORE`     INT         ---                     Session score

### SQL

``` sql
CREATE TABLE IF NOT EXISTS LOGINS (
    USER_ID INT NOT NULL,
    LOGIN_TIMESTAMP DATETIME NOT NULL,
    SESSION_ID INT PRIMARY KEY,
    SESSION_SCORE INT,

    CONSTRAINT FK_LOGINS_USERS
        FOREIGN KEY (USER_ID)
        REFERENCES USERS(USER_ID)
);
```

------------------------------------------------------------------------

# 🔗 Entity Relationship

``` text
┌──────────────────────────┐
│          USERS           │
├──────────────────────────┤
│ PK  USER_ID              │
│     USER_NAME            │
│     USER_STATUS          │
└────────────┬─────────────┘
             │
             │ USER_ID
             │
             │ 1 : Many
             │
┌────────────▼─────────────┐
│          LOGINS          │
├──────────────────────────┤
│ FK  USER_ID              │
│     LOGIN_TIMESTAMP      │
│ PK  SESSION_ID            │
│     SESSION_SCORE        │
└──────────────────────────┘
```

### Relationship

-   One user can have multiple login sessions.
-   Each login record belongs to one user.
-   `USERS.USER_ID` is the primary key.
-   `LOGINS.USER_ID` is the foreign key.
-   `LOGINS.SESSION_ID` uniquely identifies each session.

------------------------------------------------------------------------

# 👥 Sample Users

The database contains 10 users.

``` sql
INSERT INTO USERS (USER_ID, USER_NAME, USER_STATUS)
VALUES
(1, 'Alice', 'Active'),
(2, 'Bob', 'Inactive'),
(3, 'Charlie', 'Active'),
(4, 'David', 'Active'),
(5, 'Eve', 'Inactive'),
(6, 'Frank', 'Active'),
(7, 'Grace', 'Inactive'),
(8, 'Heidi', 'Active'),
(9, 'Ivan', 'Inactive'),
(10, 'Judy', 'Active');
```

    USER_ID USER_NAME   USER_STATUS
  --------- ----------- -------------
          1 Alice       Active
          2 Bob         Inactive
          3 Charlie     Active
          4 David       Active
          5 Eve         Inactive
          6 Frank       Active
          7 Grace       Inactive
          8 Heidi       Active
          9 Ivan        Inactive
         10 Judy        Active

------------------------------------------------------------------------

# 🔐 Login & Session Data

The `LOGINS` table contains historical records from 2024 and 2025.

``` sql
INSERT INTO LOGINS
    (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE)
VALUES
    (1, '2024-07-15 09:30:00', 1001, 85),
    (2, '2024-07-22 10:00:00', 1002, 90),
    (3, '2024-08-10 11:15:00', 1003, 75),
    (4, '2024-08-20 14:00:00', 1004, 88),
    (5, '2024-09-05 16:45:00', 1005, 82),
    (6, '2024-10-12 08:30:00', 1006, 77),
    (7, '2024-11-18 09:00:00', 1007, 81),
    (8, '2024-12-01 10:30:00', 1008, 84),
    (9, '2024-12-15 13:15:00', 1009, 79),
    (1, '2025-01-10 07:45:00', 1011, 86),
    (2, '2025-01-25 09:30:00', 1012, 89),
    (3, '2025-02-05 11:00:00', 1013, 78),
    (4, '2025-03-01 14:30:00', 1014, 91),
    (5, '2025-03-15 16:00:00', 1015, 83),
    (6, '2025-04-12 08:00:00', 1016, 80),
    (7, '2025-05-18 09:15:00', 1017, 82),
    (8, '2025-05-28 10:45:00', 1018, 87),
    (9, '2025-06-15 13:30:00', 1019, 76),
    (10, '2025-06-25 15:00:00', 1010, 92),
    (10, '2025-06-26 15:45:00', 1020, 93),
    (10, '2025-06-27 15:00:00', 1021, 92),
    (10, '2025-06-28 15:45:00', 1022, 93),
    (1, '2025-01-10 07:45:00', 1101, 86),
    (3, '2024-01-25 09:30:00', 1102, 89),
    (5, '2024-01-15 11:00:00', 1103, 78),
    (2, '2024-11-10 07:45:00', 1201, 82),
    (4, '2024-11-25 09:30:00', 1202, 84),
    (6, '2024-11-15 11:00:00', 1203, 80);
```

------------------------------------------------------------------------

# 📈 Business Questions & SQL Analysis

## Question 1 --- Users Inactive for the Past 5 Months

**Business requirement:** Identify users who did not log in during the
previous five months.

**Analysis date:** `2025-07-11`

### Approach 1

``` sql
SELECT USER_ID
FROM LOGINS
GROUP BY USER_ID
HAVING MAX(LOGIN_TIMESTAMP)
       < DATE_SUB('2025-07-11', INTERVAL 5 MONTH);
```

### Approach 2

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

### Concepts

`GROUP BY`, `HAVING`, `MAX()`, `DATE_SUB()`, `NOT IN`, subqueries.

------------------------------------------------------------------------

# Question 2 --- Quarterly User & Session Analysis

Calculate:

1.  Number of unique users
2.  Number of sessions

Order quarters from newest to oldest.

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

### Output

  Column                 Description
  ---------------------- ----------------------
  `First_Quarter_Date`   First day of quarter
  `User_Count`           Unique users
  `Session_Count`        Total sessions

------------------------------------------------------------------------

# Question 3 --- January Users Who Did Not Login in November

Identify users who logged in during January 2025 but did not log in
during November 2025.

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

> **Dataset note:** The supplied sample data does not contain November
> 2025 records. If no November records are added, the query will treat
> January 2025 users as having no November login.

------------------------------------------------------------------------

# Question 4 --- Quarterly Session Percentage Change

Calculate session growth or decline compared with the previous quarter.

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

### Formula

``` text
Percentage Change =
(Current Sessions - Previous Sessions)
--------------------------------------- × 100
       Previous Sessions
```

### Concepts

CTEs, `LAG()`, window functions, `CASE`, `ROUND()`, percentage
calculations.

------------------------------------------------------------------------

# Question 5 --- Highest Daily Session Score

The original supplied SQL for Question 5 repeated the quarterly
percentage-change query. The intended business question is to find the
user with the highest total session score for each day.

### Corrected Query

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

### Concepts

`JOIN`, `DATE()`, `SUM()`, CTE, `RANK()`, `PARTITION BY`.

------------------------------------------------------------------------

# Question 6 --- Users With Daily Login Activity

Identify users who had a login on every day since their first login.

**Analysis date:** `2025-07-28`

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

### Filter for Users Who Logged in Every Day

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

------------------------------------------------------------------------

# 🧠 SQL Concepts Demonstrated

This case study covers both fundamental and advanced SQL concepts.

### Basic SQL

-   `SELECT`
-   `WHERE`
-   `ORDER BY`
-   `GROUP BY`
-   `HAVING`
-   `DISTINCT`

### Aggregations

-   `COUNT()`
-   `COUNT(DISTINCT)`
-   `SUM()`
-   `MAX()`
-   `MIN()`

### Date & Time Analysis

-   `DATE()`
-   `DATE_SUB()`
-   `DATEDIFF()`
-   `YEAR()`
-   `QUARTER()`
-   `STR_TO_DATE()`

### Advanced SQL

-   Common Table Expressions
-   Window functions
-   `LAG()`
-   `RANK()`
-   `PARTITION BY`
-   Subqueries
-   Conditional logic with `CASE`

### Relational Database Concepts

-   Primary keys
-   Foreign keys
-   One-to-many relationships
-   Table joins
-   Referential integrity

------------------------------------------------------------------------

# 🔍 Data Verification

### Verify Users

``` sql
SELECT *
FROM USERS;
```

### Verify Login Records

``` sql
SELECT *
FROM LOGINS
ORDER BY USER_ID, LOGIN_TIMESTAMP;
```

------------------------------------------------------------------------

# 🛠️ Tools & Technologies

  Technology                Usage
  ------------------------- ----------------------------
  **MySQL 8.0+**            Database & SQL analysis
  **SQL**                   Data querying and analysis
  **Relational Database**   Data modeling
  **GitHub**                Project/version management

------------------------------------------------------------------------

# 🚀 How to Run the Project

## Step 1 --- Install MySQL

Use **MySQL 8.0 or later**.

## Step 2 --- Create the Database

``` sql
CREATE DATABASE IF NOT EXISTS Employee_CaseStudy;

USE Employee_CaseStudy;
```

## Step 3 --- Create Tables

Create the `USERS` and `LOGINS` tables using the schema provided above.

## Step 4 --- Insert Data

Insert the sample employee and login/session records.

## Step 5 --- Run the Queries

Execute the six business questions in MySQL Workbench, MySQL CLI, or
another MySQL-compatible SQL environment.

------------------------------------------------------------------------

# 📁 Recommended Repository Structure

``` text
Employee-Login-Logout-SQL-Case-Study/
│
├── README.md
│
├── sql/
│   ├── employee_login_logout_schema.sql
│   └── employee_login_logout_queries.sql
│
├── screenshots/
│   ├── database_schema.png
│   └── query_results.png
│
└── docs/
    └── project_notes.md
```

------------------------------------------------------------------------

# 📊 Project Workflow

``` text
Raw Login Data
      ↓
Database Design
      ↓
USERS + LOGINS Tables
      ↓
Data Validation
      ↓
SQL Business Questions
      ↓
Aggregations & Window Functions
      ↓
User & Session Analysis
      ↓
Business Insights
```

------------------------------------------------------------------------

# 💡 Key Business Use Cases

This project can help analyze:

-   Employee login inactivity
-   User engagement
-   Session volume
-   Quarterly activity trends
-   User retention between periods
-   Session performance
-   Consistent daily activity
-   Employee login behavior

------------------------------------------------------------------------

# 🎯 Learning Outcomes

After completing this case study, you will practice:

-   Designing a relational database
-   Creating primary and foreign keys
-   Building one-to-many relationships
-   Writing analytical SQL queries
-   Working with date/time data
-   Using CTEs
-   Using SQL window functions
-   Comparing periods
-   Calculating percentage changes
-   Ranking records
-   Solving business problems with SQL

------------------------------------------------------------------------

# 👨‍💻 Author

## Vipul Gour

Data Analytics / SQL Portfolio Project

### Connect With Me

-   🌐 Portfolio: `YOUR_PORTFOLIO_URL`
-   💻 GitHub: `YOUR_GITHUB_URL`
-   🔗 LinkedIn: `YOUR_LINKEDIN_URL`

------------------------------------------------------------------------

# ⭐ Project Highlights

**Project:** Employee Login & Logout SQL Case Study\
**Database:** Employee_CaseStudy\
**Technology:** MySQL 8.0+\
**Focus:** SQL Data Analysis\
**Level:** Intermediate / Advanced SQL\
**Domain:** Employee Login & Session Analytics

------------------------------------------------------------------------

## 📜 License

This project is intended for **learning, portfolio, interview
preparation, and SQL practice**.
