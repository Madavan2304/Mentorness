-- Q1. Write a code to check NULL values

SELECT * FROM CORONA_VIRUS WHERE
    'PROVINCE' IS NULL OR
    'REGION' IS NULL OR
    'LATITUDE' IS NULL OR
    'LONGITUDE' IS NULL OR
    'DATECOL' IS NULL OR
    'CONFIRMED' IS NULL OR
    'DEATHS' IS NULL OR 
    'RECOVERED' IS NULL;

--Q2. If NULL values are present, update them with zeros for all columns. 

UPDATE CORONA_VIRUS
SET 
    PROVINCE = COALESCE(PROVINCE, 'Unknown'),
    REGION = COALESCE(REGION, 'Unknown'),
    LATITUDE = COALESCE(LATITUDE, 0),
    LONGITUDE = COALESCE(LONGITUDE, 0),
    DATECOL = COALESCE(DATECOL, DATE '2000-01-01'), 
    CONFIRMED = COALESCE(Confirmed, 0),
    DEATHS = COALESCE(Deaths, 0),
    RECOVERED = COALESCE(Recovered, 0);
    
-- Q3. check total number of rows

SELECT COUNT(*) AS TOTAL_ROWS FROM CORONA_VIRUS;

-- Q4. Check what is start_date and end_date

SELECT MIN(DATECOL) AS start_date, MAX(DATECOL) AS end_date FROM CORONA_VIRUS;

-- Q5. Number of month present in dataset

SELECT COUNT(DISTINCT EXTRACT(MONTH FROM datecol)) AS Number_Of_Months FROM CORONA_VIRUS;

-- Q6. Find monthly average for confirmed, deaths, recovered

SELECT 
    EXTRACT(MONTH FROM datecol) AS month,
    ROUND(AVG(Confirmed), 0) AS avg_confirmed,
    ROUND(AVG(Deaths), 0) AS avg_deaths,
    ROUND(AVG(Recovered), 0) AS avg_recovered
FROM 
    CORONA_VIRUS
GROUP BY 
    EXTRACT(MONTH FROM datecol);
    
-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

SELECT 'CONFIRMED' AS category, EXTRACT(MONTH FROM datecol) AS month, confirmed AS value, COUNT(*) AS frequency
FROM CORONA_VIRUS
GROUP BY EXTRACT(MONTH FROM datecol), confirmed
HAVING COUNT(*) = (SELECT MAX(cnt)
    FROM (SELECT COUNT(*) AS cnt FROM CORONA_VIRUS GROUP BY EXTRACT(MONTH FROM datecol), confirmed)
)
UNION ALL
SELECT 'DEATHS' AS category, EXTRACT(MONTH FROM datecol) AS month, deaths AS value, COUNT(*) AS frequency
FROM CORONA_VIRUS
GROUP BY EXTRACT(MONTH FROM datecol), deaths
HAVING COUNT(*) = (SELECT MAX(cnt)
    FROM (SELECT COUNT(*) AS cnt FROM CORONA_VIRUS GROUP BY EXTRACT(MONTH FROM datecol), deaths)
)
UNION ALL
SELECT 'RECOVERED' AS category, EXTRACT(MONTH FROM datecol) AS month, recovered AS value, COUNT(*) AS frequency
FROM CORONA_VIRUS
GROUP BY EXTRACT(MONTH FROM datecol), recovered
HAVING COUNT(*) = (SELECT MAX(cnt)
    FROM (SELECT COUNT(*) AS cnt FROM CORONA_VIRUS GROUP BY EXTRACT(MONTH FROM datecol), recovered)
)
ORDER BY month, category;

-- Q8. Find minimum values for confirmed, deaths, recovered per year

SELECT 
    EXTRACT(YEAR from datecol) AS year,
    MIN(Confirmed) AS min_confirmed,
    MIN(Deaths) AS min_deaths,
    MIN(Recovered) AS min_recovered
FROM 
    CORONA_VIRUS
GROUP BY 
    EXTRACT(YEAR from datecol);
    
-- Q9. Find maximum values of confirmed, deaths, recovered per year
    
SELECT 
    EXTRACT(YEAR from datecol) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM 
    CORONA_VIRUS
GROUP BY 
    EXTRACT(YEAR from datecol);
    
-- Q10. The total number of case of confirmed, deaths, recovered each month

SELECT 
    EXTRACT(MONTH FROM DATECOL) AS month,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM 
    CORONA_VIRUS
GROUP BY 
    EXTRACT(MONTH FROM DATECOL);
    
-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    SUM(Confirmed) AS total_records,
    ROUND(AVG(Confirmed), 0) AS avg_confirmed,
    ROUND(VARIANCE(Confirmed), 4) AS variance_confirmed,
    ROUND(STDDEV(Confirmed), 4) AS stddev_confirmed
FROM 
    CORONA_VIRUS;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    EXTRACT(MONTH FROM DATECOL) AS MONTH,
    SUM(Deaths) AS total_records,
    ROUND(AVG(Deaths), 0) AS avg_confirmed,
    ROUND(VARIANCE(Deaths), 4) AS variance_confirmed,
    ROUND(STDDEV(Deaths), 4) AS stddev_confirmed
FROM 
    CORONA_VIRUS
GROUP BY 
    EXTRACT(MONTH FROM DATECOL);
    
-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    SUM(Recovered) AS total_records,
    ROUND(AVG(Recovered), 0) AS avg_confirmed,
    ROUND(VARIANCE(Recovered), 4) AS variance_confirmed,
    ROUND(STDDEV(Recovered), 4) AS stddev_confirmed
FROM 
    CORONA_VIRUS;
    
-- Q14. Find Country having highest number of the Confirmed case

SELECT 
    Region,
    SUM(Confirmed) AS total_confirmed
FROM 
    CORONA_VIRUS
GROUP BY 
    Region
ORDER BY 
    total_confirmed DESC
FETCH FIRST 1 ROWS ONLY;

--Q15. Find Country having lowest number of the death case

SELECT 
    Region,
    SUM(Deaths) AS total_deaths
FROM 
    CORONA_VIRUS
GROUP BY 
    Region
ORDER BY 
    total_deaths ASC
FETCH FIRST 4 ROWS ONLY;

-- Q16. Find top 5 countries having highest recovered case

SELECT 
    Region,
    SUM(Recovered) AS total_recovered
FROM 
    CORONA_VIRUS
GROUP BY 
    Region
ORDER BY 
    total_recovered DESC
FETCH FIRST 5 ROWS ONLY;