# Employee Login & Logout SQL Case Study

A MySQL 8.0+ relational database case study for analyzing employee login
activity, session performance, user status, inactivity, and engagement
patterns.

## 📌 Project Overview

This project contains a simple relational database designed for an
**Employee Login & Logout SQL Case Study**.

The database stores:

-   Employee/user information
-   Login and session activity
-   Login timestamps
-   Session scores
-   Active/inactive user status

The schema is structured to support SQL analysis such as user
inactivity, monthly login comparisons, quarterly session analysis,
session ranking, and user engagement.

### Database Details

  Component       Details
  --------------- --------------------------------------
  Database        `Employee_CaseStudy`
  DBMS            MySQL 8.0+
  Database Type   Relational Database
  Tables          `USERS`, `LOGINS`
  Relationship    One-to-Many
  Primary Keys    `USERS.USER_ID`, `LOGINS.SESSION_ID`
  Foreign Key     `LOGINS.USER_ID`
  Main Domain     Employee Login & Session Analysis

------------------------------------------------------------------------

## 🗂️ Database Structure

The database contains two tables:

1.  **USERS** -- stores employee/user information.
2.  **LOGINS** -- stores employee login and session activity.

### Entity Relationship

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
│ PK  SESSION_ID           │
│     SESSION_SCORE        │
└──────────────────────────┘
```

### Relationship Description

-   One user can have multiple login sessions.
-   Each login record belongs to one user.
-   `USERS.USER_ID` is the primary key.
-   `LOGINS.USER_ID` is the foreign key.
-   `LOGINS.SESSION_ID` uniquely identifies each login session.

------------------------------------------------------------------------

# 🛠️ Database Setup

## 1. Create Database

``` sql
CREATE DATABASE IF NOT EXISTS Employee_CaseStudy;

USE Employee_CaseStudy;
```

------------------------------------------------------------------------

## 2. Create USERS Table

The `USERS` table stores basic employee information.

  Column          Data Type     Constraint    Description
  --------------- ------------- ------------- ---------------------------------
  `USER_ID`       INT           PRIMARY KEY   Unique identifier for each user
  `USER_NAME`     VARCHAR(20)   NOT NULL      Name of the user
  `USER_STATUS`   VARCHAR(20)   NOT NULL      Current status of the user

``` sql
CREATE TABLE IF NOT EXISTS USERS (
    USER_ID INT PRIMARY KEY,
    USER_NAME VARCHAR(20) NOT NULL,
    USER_STATUS VARCHAR(20) NOT NULL
);
```

------------------------------------------------------------------------

## 3. Create LOGINS Table

The `LOGINS` table stores employee login and session information.

  -------------------------------------------------------------------------
  Column              Data Type         Constraint        Description
  ------------------- ----------------- ----------------- -----------------
  `USER_ID`           INT               NOT NULL, FOREIGN Identifies the
                                        KEY               user

  `LOGIN_TIMESTAMP`   DATETIME          NOT NULL          Date and time of
                                                          login

  `SESSION_ID`        INT               PRIMARY KEY       Unique identifier
                                                          for each session

  `SESSION_SCORE`     INT               ---               Score associated
                                                          with the session
  -------------------------------------------------------------------------

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

# 🔑 Keys and Constraints

## Primary Keys

### USERS

``` text
USER_ID INT PRIMARY KEY
```

`USER_ID` uniquely identifies each user.

### LOGINS

``` text
SESSION_ID INT PRIMARY KEY
```

`SESSION_ID` uniquely identifies each login session.

## Foreign Key

The `LOGINS` table references the `USERS` table through `USER_ID`.

``` sql
CONSTRAINT FK_LOGINS_USERS
    FOREIGN KEY (USER_ID)
    REFERENCES USERS(USER_ID)
```

This maintains referential integrity between users and their login
records.

------------------------------------------------------------------------

# 👥 Sample Users

The dataset contains **10 unique users** with active and inactive
statuses.

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

The `LOGINS` table contains historical login records from **2024 and
2025**, including multiple sessions for individual users.

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

# 📊 Data Characteristics

## Users

-   10 unique users
-   User IDs range from 1 to 10
-   Both active and inactive statuses are included

## Login Activity

-   Historical login records from 2024
-   Login records from 2025
-   Multiple sessions for individual users
-   Login timestamps
-   Unique session IDs
-   Session scores

------------------------------------------------------------------------

# 📈 SQL Analysis Scenarios

This dataset can be used to practice and demonstrate:

-   User inactivity analysis
-   Monthly login comparisons
-   Quarterly session analysis
-   Session ranking
-   User engagement analysis
-   Daily login analysis
-   Window functions
-   Ranking functions
-   Date and time functions
-   Aggregations and grouping
-   Common Table Expressions (CTEs)
-   Joins and subqueries

------------------------------------------------------------------------

# 🔎 Data Verification

## Verify USERS

``` sql
SELECT *
FROM USERS;
```

## Verify LOGINS

``` sql
SELECT *
FROM LOGINS
ORDER BY USER_ID, LOGIN_TIMESTAMP;
```

------------------------------------------------------------------------

# 🚀 Complete Schema Script

The complete database setup can be executed in MySQL 8.0+.

``` sql
CREATE DATABASE IF NOT EXISTS Employee_CaseStudy;

USE Employee_CaseStudy;

CREATE TABLE IF NOT EXISTS USERS (
    USER_ID INT PRIMARY KEY,
    USER_NAME VARCHAR(20) NOT NULL,
    USER_STATUS VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS LOGINS (
    USER_ID INT NOT NULL,
    LOGIN_TIMESTAMP DATETIME NOT NULL,
    SESSION_ID INT PRIMARY KEY,
    SESSION_SCORE INT,

    CONSTRAINT FK_LOGINS_USERS
        FOREIGN KEY (USER_ID)
        REFERENCES USERS(USER_ID)
);

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

SELECT *
FROM USERS;

SELECT *
FROM LOGINS
ORDER BY USER_ID, LOGIN_TIMESTAMP;
```

------------------------------------------------------------------------

## 💡 Key Learning Outcomes

This case study provides practical experience with:

-   Relational database design
-   Primary and foreign keys
-   One-to-many relationships
-   SQL joins
-   Aggregations
-   Date/time analysis
-   Window functions
-   Ranking
-   CTEs
-   Employee engagement analysis
-   MySQL 8.0+ syntax

------------------------------------------------------------------------

