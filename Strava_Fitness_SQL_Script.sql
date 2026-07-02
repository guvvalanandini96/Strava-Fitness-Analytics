
-- ==========================================================
-- STRAVA FITNESS DATA ANALYTICS PROJECT
-- PostgreSQL (pgAdmin)
-- SQL Script
-- ==========================================================

-- ==========================================================
-- DROP TABLES
-- ==========================================================
DROP TABLE IF EXISTS dailyactivity CASCADE;
DROP TABLE IF EXISTS dailycalories CASCADE;
DROP TABLE IF EXISTS dailyintensities CASCADE;
DROP TABLE IF EXISTS dailysteps CASCADE;
DROP TABLE IF EXISTS sleepday CASCADE;
DROP TABLE IF EXISTS weightloginfo CASCADE;

-- ==========================================================
-- CREATE TABLES
-- ==========================================================
CREATE TABLE dailyactivity (
    Id BIGINT,
    ActivityDate TEXT,
    TotalSteps INTEGER,
    TotalDistance DECIMAL(10,2),
    TrackerDistance DECIMAL(10,2),
    LoggedActivitiesDistance DECIMAL(10,2),
    VeryActiveDistance DECIMAL(10,2),
    ModeratelyActiveDistance DECIMAL(10,2),
    LightActiveDistance DECIMAL(10,2),
    SedentaryActiveDistance DECIMAL(10,2),
    VeryActiveMinutes INTEGER,
    FairlyActiveMinutes INTEGER,
    LightlyActiveMinutes INTEGER,
    SedentaryMinutes INTEGER,
    Calories INTEGER
);

CREATE TABLE dailycalories (
    Id BIGINT,
    ActivityDay TEXT,
    Calories INTEGER
);

CREATE TABLE dailyintensities (
    Id BIGINT,
    ActivityDay TEXT,
    SedentaryMinutes INTEGER,
    LightlyActiveMinutes INTEGER,
    FairlyActiveMinutes INTEGER,
    VeryActiveMinutes INTEGER,
    SedentaryActiveDistance DECIMAL(10,2),
    LightActiveDistance DECIMAL(10,2),
    ModeratelyActiveDistance DECIMAL(10,2),
    VeryActiveDistance DECIMAL(10,2)
);

CREATE TABLE dailysteps (
    Id BIGINT,
    ActivityDay TEXT,
    StepTotal INTEGER
);

CREATE TABLE sleepday (
    Id BIGINT,
    SleepDay TEXT,
    TotalSleepRecords INTEGER,
    TotalMinutesAsleep INTEGER,
    TotalTimeInBed INTEGER
);

CREATE TABLE weightloginfo (
    Id BIGINT,
    Date TEXT,
    WeightKg DECIMAL(10,2),
    WeightPounds DECIMAL(10,2),
    Fat DECIMAL(10,2),
    BMI DECIMAL(10,2),
    IsManualReport BOOLEAN,
    LogId BIGINT
);

-- ==========================================================
-- DATA VALIDATION
-- ==========================================================
SELECT COUNT(*) AS total_rows FROM dailyactivity;
SELECT COUNT(*) AS total_rows FROM dailycalories;
SELECT COUNT(*) AS total_rows FROM dailyintensities;
SELECT COUNT(*) AS total_rows FROM dailysteps;
SELECT COUNT(*) AS total_rows FROM sleepday;
SELECT COUNT(*) AS total_rows FROM weightloginfo;

SELECT * FROM dailyactivity LIMIT 5;
SELECT * FROM sleepday LIMIT 5;
SELECT * FROM weightloginfo LIMIT 5;

-- ==========================================================
-- DATA CLEANING
-- ==========================================================

-- Duplicate Check
SELECT Id, ActivityDate, COUNT(*)
FROM dailyactivity
GROUP BY Id, ActivityDate
HAVING COUNT(*) > 1;

SELECT Id, SleepDay, COUNT(*)
FROM sleepday
GROUP BY Id, SleepDay
HAVING COUNT(*) > 1;

-- Missing Values
SELECT *
FROM weightloginfo
WHERE WeightKg IS NULL
   OR BMI IS NULL;

-- Unique Users
SELECT COUNT(DISTINCT Id) AS total_users
FROM dailyactivity;

-- Date Range
SELECT MIN(ActivityDate) AS start_date,
       MAX(ActivityDate) AS end_date
FROM dailyactivity;

-- Column Data Types
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name='dailyactivity';

-- Records Per User
SELECT Id, COUNT(*) AS total_days
FROM dailyactivity
GROUP BY Id
ORDER BY total_days DESC;

-- ==========================================================
-- BUSINESS ANALYSIS QUERIES
-- ==========================================================

-- 1
SELECT ROUND(AVG(TotalSteps),2) AS Average_Daily_Steps
FROM dailyactivity;

-- 2
SELECT ROUND(AVG(Calories),2) AS Average_Daily_Calories
FROM dailyactivity;

-- 3
SELECT ROUND(AVG(TotalDistance),2) AS Average_Distance
FROM dailyactivity;

-- 4
SELECT Id,SUM(TotalSteps) AS Total_Steps
FROM dailyactivity
GROUP BY Id
ORDER BY Total_Steps DESC
LIMIT 10;

-- 5
SELECT Id,SUM(TotalSteps) AS Total_Steps
FROM dailyactivity
GROUP BY Id
ORDER BY Total_Steps ASC
LIMIT 10;

-- 6
SELECT Id,SUM(Calories) AS Total_Calories
FROM dailyactivity
GROUP BY Id
ORDER BY Total_Calories DESC
LIMIT 1;

-- 7
SELECT ROUND(AVG(VeryActiveMinutes),2) AS Avg_VeryActive_Minutes
FROM dailyactivity;

-- 8
SELECT ROUND(AVG(SedentaryMinutes),2) AS Avg_Sedentary_Minutes
FROM dailyactivity;

-- 9
SELECT ROUND(AVG(TotalMinutesAsleep),2) AS Avg_Sleep_Minutes
FROM sleepday;

-- 10
SELECT ROUND(AVG(TotalTimeInBed),2) AS Avg_Time_In_Bed
FROM sleepday;

-- 11
SELECT ROUND(AVG((TotalMinutesAsleep*100.0)/NULLIF(TotalTimeInBed,0)),2)
AS Sleep_Efficiency
FROM sleepday;

-- 12
SELECT ROUND(AVG(BMI),2) AS Average_BMI
FROM weightloginfo;

-- 13
SELECT CASE
WHEN BMI < 18.5 THEN 'Underweight'
WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal'
WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight'
ELSE 'Obese'
END AS BMI_Category,
COUNT(*) AS Total_Users
FROM weightloginfo
GROUP BY BMI_Category;

-- 14
SELECT COUNT(*) AS Days_Above_10000_Steps
FROM dailyactivity
WHERE TotalSteps > 10000;

-- 15
SELECT Id,
ROUND(AVG(Calories),2) AS Average_Calories
FROM dailyactivity
GROUP BY Id
ORDER BY Average_Calories DESC;

-- 16
SELECT Id,
ROUND(AVG(TotalSteps),2) AS Average_Steps
FROM dailyactivity
GROUP BY Id
ORDER BY Average_Steps DESC;

-- 17
SELECT Id,ActivityDate,TotalDistance
FROM dailyactivity
ORDER BY TotalDistance DESC
LIMIT 5;

-- 18
SELECT AVG(VeryActiveMinutes),
AVG(FairlyActiveMinutes),
AVG(LightlyActiveMinutes)
FROM dailyactivity;

-- 19
SELECT AVG(WeightKg) AS Average_Weight
FROM weightloginfo;

-- 20
SELECT MAX(BMI) AS Highest_BMI
FROM weightloginfo;

-- ==========================================================
-- END OF SQL SCRIPT
-- ==========================================================
