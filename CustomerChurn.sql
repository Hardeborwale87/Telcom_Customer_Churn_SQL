-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
													/* Display table and check for possible data cleaning */
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
															/* Demographics table: */

SELECT TOP 10	
	*
FROM	
	customerChurn..demographics;


/*  Check for data type for each columns: */

USE customerChurn;

SELECT
	COLUMN_NAME,
	DATA_TYPE
FROM
	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_SCHEMA = 'dbo'
	AND TABLE_NAME = 'demographics';


/* Change data type of Count, Age, and Number of Dependemts to INT: */

ALTER TABLE customerChurn..demographics
ALTER COLUMN Count smallint;

ALTER TABLE customerChurn..demographics
ALTER COLUMN Age smallint;

ALTER TABLE customerChurn..demographics
ALTER COLUMN [Number of Dependents] smallint;

/* Change Yes and No in the Under 30 column to Under 30 and Middle Aged respectively: */
Update customerChurn..demographics
SET [Under 30] =
		CASE
			WHEN [Under 30] = 'Under 30' THEN 'Yes'
			ELSE 'No'
		END;

/* Change Yes and No in the Senior Citizen column to Senior Citizen and Middle Aged respectively: */
Update customerChurn..demographics
SET [Senior Citizen] =
		CASE
			WHEN [Senior Citizen] = 'Senior Citizen' THEN 'Yes'
			ELSE 'No'
		END;

/* Create a new column 'Age Group' to segment the customers age into differnet groups: */

ALTER TABLE customerChurn..demographics
ADD [Age Group] VARCHAR(20);

UPDATE customerChurn..demographics
SET [Age Group] = 
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 60 THEN 'Middle Aged'
        ELSE 'Senior Citizen'
    END;

/* Rename 'Married' column to 'Marital Status' then Change 'No' to 'Single' and 'Yes' to 'Married' */

EXEC sp_rename 'customerChurn..demographics.Married', 'Marital Status', 'COLUMN';

UPDATE customerChurn..demographics
SET [Marital Status] = 
    CASE
        WHEN [Marital Status] = 'Yes' THEN 'Married'
        ELSE 'Single'
    END;

/* Drop columns */
ALTER TABLE customerChurn..demographics
DROP COLUMN [Under 30];

ALTER TABLE customerChurn..demographics
DROP COLUMN [Senior Citizen];


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
																		/* Location table: */
SELECT TOP 10
	*
FROM
	customerChurn..location

/* Clean the Lat Long, Latitude, and Longitude columns: */
-- Add new column 'cleaned_latitude'
ALTER TABLE customerChurn..location
ADD cleaned_latitude DECIMAL(8,5);

-- Add a new column 'cleaned_longitude'
ALTER TABLE customerChurn..location
ADD cleaned_longitude DECIMAL(9,5);

-- Update new cleaned_latitude column
UPDATE customerChurn..location
SET cleaned_latitude = SUBSTRING(Longitude, 1, CHARINDEX(',', longitude) - 1);

-- Update new cleaned_longitude column
UPDATE customerChurn..location
SET cleaned_longitude = REPLACE(Latitude, '"', '');


/* Check for data type for each columns: */
USE customerChurn;

SELECT
	COLUMN_NAME,
	DATA_TYPE
FROM
	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_SCHEMA = 'dbo'
	AND TABLE_NAME = 'location';

-- Change Count and Zip Code Data Type to INT:
ALTER TABLE customerChurn..location
ALTER COLUMN Count smallint;

ALTER TABLE customerChurn..location
ALTER COLUMN [Zip Code] int;

-- Remove the " symbol from the latitude column, change datatype to real, and update in a new column:
ALTER TABLE customerChurn..location
DROP COLUMN Latitude;

ALTER TABLE customerChurn..location
DROP COLUMN Longitude;

ALTER TABLE customerChurn..location
DROP COLUMN [Lat Long];

-- Rename 'cleaned_latitude' and 'cleaned_longitude' column to 'Latitude' and 'Longitude' respectively:
EXEC sp_rename 'customerChurn..location.cleaned_latitude', 'Latitude', 'COLUMN';

EXEC sp_rename 'customerChurn..location.cleaned_longitude', 'Longitude', 'COLUMN';



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
																	/* Population Table */
SELECT 
	*
FROM 
	customerChurn..population;


/* Remove symbols from population values: */
UPDATE customerChurn..population
SET Population = REPLACE(Population, '"', '');

UPDATE customerChurn..population
SET Population = REPLACE(Population, ',', '');


/* Check for data type for each columns: */
USE customerChurn;

SELECT
	COLUMN_NAME,
	DATA_TYPE
FROM
	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_SCHEMA = 'dbo'
	AND TABLE_NAME = 'population';

-- Convert population column data type to integar
ALTER TABLE population
ALTER COLUMN ID smallint;

ALTER TABLE population
ALTER COLUMN [Zip Code] INT;

ALTER TABLE population
ALTER COLUMN Population INT;



----------------------------------------------------------------------------------------------------------------------------------------------------------------------
																		/* Services Table */
SELECT 
	*
FROM
	customerChurn..services;

-- Create a new column 'Tenure' to segment the 'Tenure in Months' column into different group:
ALTER TABLE customerChurn..services
ADD Tenure varchar(20);

UPDATE customerChurn..services
SET Tenure =
						 CASE
							WHEN [Tenure in Months] BETWEEN 1 AND 6 THEN '6 Months'
							WHEN [Tenure in Months] BETWEEN 7 AND 12 THEN '1 Year'
							WHEN [Tenure in Months] BETWEEN 13 AND 24 THEN '2 Years'
							WHEN [Tenure in Months] BETWEEN 25 AND 36 THEN '3 Years'
							ELSE 'More than 3 Years'
						END;
SELECT DISTINCT
	Tenure
FROM
	customerChurn..services;

-- Check for the columns data type:
USE customerChurn;

SELECT
	COLUMN_NAME,
	DATA_TYPE
FROM
	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_SCHEMA = 'dbo'
	AND TABLE_NAME = 'services';

ALTER TABLE services
ALTER COLUMN [Monthly Charge] REAL;
ALTER TABLE services
ALTER COLUMN [Total Charges] REAL;
ALTER TABLE services
ALTER COLUMN [Total Refunds] REAL;
ALTER TABLE services
ALTER COLUMN [Total Extra Data Charges] REAL;
ALTER TABLE services
ALTER COLUMN [Total Long Distance Charges] REAL;
ALTER TABLE services
ALTER COLUMN [Total Revenue] REAL;
ALTER TABLE services
ALTER COLUMN [Avg Monthly Long Distance Charges] REAL;
ALTER TABLE services
ALTER COLUMN [Count] smallint;
ALTER TABLE services
ALTER COLUMN [Number of Referrals] smallint;
ALTER TABLE services
ALTER COLUMN [Tenure in Months] smallint;
ALTER TABLE services
ALTER COLUMN [Avg Monthly GB Download] smallint;




-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
																		/* Status Table */
/* Display table data: */
SELECT	
	*
FROM
	customerChurn..status

/* Create a new column 'Satisfaction Score Label' and the column where 5 is Very Satisfied, 4 is Satisfied, 3 is Neutral, 2 is Dissatisfied, 1 is Very Dissatisfied: */

ALTER TABLE customerChurn..status
ADD [Satisfaction Score Label] VARCHAR(20);

UPDATE customerChurn..status
SET [Satisfaction Score Label] =	CASE
										WHEN [Satisfaction Score] = 5 THEN 'Very Satisfied'
										WHEN [Satisfaction Score] = 4 THEN 'Satisfied'
										WHEN [Satisfaction Score] = 3 THEN 'Neutral'
										WHEN [Satisfaction Score] = 2 THEN 'Dissatisfied'
										ELSE 'Very Dissatisfied'
									END;

/* Create a new column 'CLTV Category' to segment Customer Life Time Value into different groups: */

ALTER TABLE customerChurn..status
ADD [CLTV Category] VARCHAR(20);

UPDATE customerChurn..status
SET	[CLTV Category] =  CASE
							WHEN [CLTV] >= 2003 AND [CLTV] <= 3000 THEN 'Low'
							WHEN [CLTV] >= 3001 AND [CLTV] <= 4000 THEN 'Medium Low'
							WHEN [CLTV] >= 4001 AND [CLTV] <= 5000 THEN 'Medium'
							WHEN [CLTV] >= 5001 AND [CLTV] <= 6000 THEN 'Medium High'
							WHEN [CLTV] >= 6001 THEN 'High'
						END;


/* Check for the columns data type: */

USE customerChurn;

SELECT
	COLUMN_NAME,
	DATA_TYPE
FROM
	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_SCHEMA = 'dbo'
	AND TABLE_NAME = 'status';

-- Change columns that contains numerical values from varchar to integar:
ALTER TABLE customerChurn..status
ALTER COLUMN [Count] smallint;
ALTER TABLE customerChurn..status
ALTER COLUMN [Satisfaction Score] smallint;
ALTER TABLE customerChurn..status
ALTER COLUMN [Churn Value] smallint;
ALTER TABLE customerChurn..status
ALTER COLUMN [Churn Score] smallint;
ALTER TABLE customerChurn..status
ALTER COLUMN [CLTV] int;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		/* Check for missing values: */

SELECT
    dem.[Customer ID],
    MAX(dem.[Age]) AS MaxDemographicColumn,
    MIN(loc.[Zip Code]) AS MinLocationColumn,
    AVG(ser.[Monthly Charge]) AS AvgServiceColumn,
    COUNT(sta.[Churn Category]) AS CountStatusColumn
FROM customerChurn..demographics dem
JOIN customerChurn..location loc ON dem.[Customer ID] = loc.[Customer ID]
JOIN customerChurn..services ser ON loc.[Customer ID] = ser.[Customer ID]
JOIN customerChurn..status sta ON ser.[Customer ID] = sta.[Customer ID]
GROUP BY dem.[Customer ID]
HAVING COUNT(dem.[Customer ID]) > 1;

-- No missing values
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

															/* Exploring the data: */

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating total number of customers: */

SELECT	DISTINCT
	COUNT([Customer ID]) AS TotalNumberOfCustomers
FROM 
	customerChurn..status;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating total number of churned customers: */

SELECT	
	COUNT([Customer ID]) AS ChurnedCustomers
FROM	
	customerChurn..status
WHERE	
	[Churn Label] = 'Yes';


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating churned customers churn rate: */

SELECT	
	CAST
	(
		(SELECT	COUNT(*) * 1.0 FROM customerChurn..status WHERE [Customer Status] = 'Churned')
		/
		COUNT(*) * 1.0* 100.0 AS DECIMAL(10,2)
	) AS ChurnRate
FROM	
	customerChurn..status;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Examining total number of customers, total churned customers and the churn rate*/

SELECT	
	CustomerCount,
	ChurnedCustomers,
	CAST((ChurnedCustomers * 1.0 / CustomerCount * 1.0) * 100.0 AS DECIMAL(10,2)) AS ChurnRate
FROM
	(SELECT	COUNT(*) AS CustomerCount FROM	customerChurn..status)	AS Total,
	(SELECT	COUNT(*) AS ChurnedCustomers FROM customerChurn..status WHERE [Customer Status] = 'Churned')AS Churned;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the demographic characteristics of churned customers by gender: */

SELECT 
	d.Gender, 
	AVG(d.Age) AS AverageAge, 
	COUNT(*) AS ChurnedCustomer
FROM 
	customerChurn..demographics d
LEFT JOIN 
	customerChurn..status s ON d.[Customer ID] = s.[Customer ID]
WHERE 
	s.[Churn Label] = 'Yes'
GROUP BY 
	d.Gender;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing churn rate by gender: */

SELECT 
	d.Gender,  
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT d.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT d.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..demographics d
LEFT JOIN 
	customerChurn..status st ON d.[Customer ID] = st.[Customer ID]
GROUP BY 
	d.Gender;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating the average age of churned customers: */

SELECT	
	AVG(d.Age) AS AverageAge
FROM	
	customerChurn..demographics d
WHERE	
	d.[Customer ID] IN 
	(
	SELECT 
		st.[Customer ID] 
	FROM 
		customerChurn..status st
	WHERE
		[Churn Label] = 'Yes');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating churn rate by age group: */

SELECT 
	d.[Age Group],  
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT d.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT d.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..demographics d
LEFT JOIN 
	customerChurn..status st ON d.[Customer ID] = st.[Customer ID]
GROUP BY 
	d.[Age Group];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing churn rate by marraige status: */

SELECT 
	d.[Marital Status],  
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT d.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT d.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..demographics d
LEFT JOIN 
	customerChurn..status st ON d.[Customer ID] = st.[Customer ID]
GROUP BY 
	d.[Marital Status];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing churn rate by dependent: */

SELECT 
	d.[Dependents],  
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT d.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT d.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..demographics d
LEFT JOIN 
	customerChurn..status st ON d.[Customer ID] = st.[Customer ID]
GROUP BY 
	d.[Dependents];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Average number of dependent: */

SELECT
	AVG([Number of Dependents]) AS avg_num_dependent
FROM
	customerChurn..demographics d
WHERE	
	d.[Customer ID] IN 
	(
	SELECT 
		st.[Customer ID] 
	FROM 
		customerChurn..status st
	WHERE
		[Churn Label] = 'Yes');

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating the churn rate for different cities: */

SELECT
	l.City,
	COUNT(*) AS TotalCustomers, 
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomers,
	CASE 
		WHEN COUNT(DISTINCT l.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT l.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..location l
LEFT JOIN 
	customerChurn..status st ON l.[Customer ID] = st.[Customer ID]
GROUP BY 
	l.City
ORDER BY
	ChurnedCustomers DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating the churn rate by latitude and longitude: */

WITH CustomerRegions AS (
    SELECT
        [Customer ID],
        Country,
        State,
        City,
		[Zip Code],
        [Latitude],
        [Longitude],
        CASE
			WHEN Latitude BETWEEN 32.6 AND 37.9 AND Longitude BETWEEN -124.3 AND -118.0 THEN 'North'
			WHEN Latitude BETWEEN 32.6 AND 37.9 AND Longitude BETWEEN -118.0 AND -114.3 THEN 'South'
			ELSE 'Other'
		END AS GeographicRegion
    FROM
        customerChurn..Location		
)
SELECT
    GeographicRegion,
    COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
		CASE 
			WHEN COUNT(DISTINCT cr.[Customer ID]) = 0 THEN 0
			ELSE CAST(SUM(CASE WHEN [Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT cr.[Customer ID]) AS DECIMAL(10, 2))
		END AS ChurnRate
FROM
    CustomerRegions cr
LEFT JOIN
		customerChurn..status st ON cr.[Customer ID] = st.[Customer ID]
GROUP BY
    GeographicRegion;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the relationship between churned customers and population estimates in their respective zip code areas: */

SELECT	
	TOP 10
	l.City,
	p.[Zip Code], 
	p.[Population], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT l.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT l.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..population p
JOIN 
	customerChurn..location l ON p.[Zip Code] = l.[Zip Code]
LEFT JOIN
	customerChurn..status st ON l.[Customer ID] = st.[Customer ID]
GROUP BY 
	l.City,
	p.[Zip Code],
	p.[Population]
ORDER BY
	churnedCustomer DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Churned reason in the above cities: */

SELECT	
	TOP 10
	l.City,
	p.[Zip Code], 
	p.[Population],
	st.[Churn Category],
	st.[Churn Reason]
FROM 
	customerChurn..population p
JOIN 
	customerChurn..location l ON p.[Zip Code] = l.[Zip Code]
LEFT JOIN
	customerChurn..status st ON l.[Customer ID] = st.[Customer ID]
GROUP BY 
	l.City,
	p.[Zip Code],
	p.[Population],
	st.[Churn Category],
	st.[Churn Reason]
ORDER BY
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing if there correlation between Quarter churn rate: */

SELECT
	s.Quarter, 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY
	s.Quarter
ORDER BY
	ChurnedCustomer DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the relationship between churned customers and their referral behavior: */

SELECT	s.[Referred A Friend], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY 
	s.[Referred A Friend];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Average referral number of Churned customers: */

SELECT
	AVG([Number of Referrals]) AS avg_referrals_num
FROM 
	customerChurn..services s
JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
WHERE
	st.[Churn Label] = 'Yes';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the distribution of churned customers based on their tenure in months: */

SELECT
	s.[Tenure], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM	
	customerChurn..Services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY 
	s.[Tenure]
ORDER BY 
	ChurnedCustomer DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating the average tenure of churned customers: */

SELECT 
	AVG(s.[Tenure in Months]) AS AverageTenure
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
WHERE 
	st.[Churn Label] = 'Yes';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the relationship between Offer received by customers and churn rate: */

SELECT 
	s.Offer, 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY
	s.Offer;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analysing phone service relationship with Churn rate: */

SELECT 
	s.[Phone Service], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY
	s.[Phone Service];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the Avg Monthly Long Distance Charges relatioship with churn rate: */

SELECT TOP 10
	s.[Avg Monthly Long Distance Charges], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY
	s.[Avg Monthly Long Distance Charges]
ORDER BY
	ChurnedCustomer DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Average of Average Monthly Long Distance Charges: */

SELECT 
	TOP 10
	ROUND(AVG(s.[Avg Monthly Long Distance Charges]),2) AS avg_monthly_long_distance_charges
FROM 
	customerChurn..services s
JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
WHERE
st.[Churn Label] = 'Yes';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the Avg Monthly GB Download relatioship with churn rate: */

SELECT 
	TOP 10
	s.[Avg Monthly GB Download], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY
	s.[Avg Monthly GB Download]
ORDER BY
	ChurnedCustomer DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the number of lines acquired by churn customer relatioship with churn rate: */

SELECT 
	s.[Multiple Lines], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY
	s.[Multiple Lines]
ORDER BY
	ChurnedCustomer DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing churn rate of churned customer who opted for Internet service and who does not: */

SELECT 
	s.[Internet Service], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY
	s.[Internet Service]
ORDER BY
	ChurnedCustomer DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing churn rate of churned customers Internet Type: */

SELECT 
	s.[Internet Type], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY
	s.[Internet Type]
ORDER BY
	ChurnedCustomer DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the usage of online security plan among churned customers: */

SELECT 
	s.[Online Security], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY	
	s.[Online Security];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the usage of online backup among churned customers: */

SELECT 
	s.[Online Backup],
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY	 
	s.[Online Backup];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the usage of device protection plan among churned customers: */

SELECT 
	s.[Device Protection Plan], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY	 
	s.[Device Protection Plan];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing if churn customer had premium tech support and the relatioship with churn rate: */

SELECT 
	s.[Premium Tech Support], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY
	s.[Premium Tech Support];

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the relationship between streaming TV services and customer churn: */

SELECT  
	s.[Streaming TV],
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY  
	s.[Streaming TV];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the relationship between Streaming movies services and customer churn: */

SELECT 
	s.[Streaming Movies], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY 
	s.[Streaming Movies];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the relationship between Streaming music services and customer churn: */

SELECT 
	s.[Streaming Music], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY 
	s.[Streaming Music];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing churned customers in relation to unlimited data subscription and correlation with churn rate: */

SELECT 
	s.[Unlimited Data], 
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS CustomerCount,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY
	s.[Unlimited Data];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing churn reason of churned customers in relation to churned customers with unlimited data subscription: */

SELECT TOP 10
	st.[Churn Reason]
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
WHERE
	s.[Unlimited Data] = 'Yes' AND st.[Churn Label] = 'Yes'
GROUP BY
    s.[Unlimited Data],
    st.[Churn Reason]
ORDER BY
    SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) DESC;
		

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating the churn rate for each contract type: */

SELECT
	s.Contract, 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY 
	s.Contract;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the churn rate of churned customers that preferred paperless billing and those who don't: */

SELECT	
	s.[Paperless Billing], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY 
	s.[Paperless Billing];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the payment methods preferred by churned customers: */

SELECT	
	s.[Payment Method], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY 
	s.[Payment Method];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Identifying top churned reasons of customers that paid for services with Bank Withdrawal: */

SELECT TOP 10	
	s.[Payment Method],
	st.[Churn Reason]
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
WHERE
	s.[Payment Method] = 'Bank Withdrawal' AND st.[Churn Label] = 'Yes'
GROUP BY
    s.[Payment Method],
    st.[Churn Reason]
ORDER BY
    SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Calculating churned customers total charges by payment methods: */

SELECT DISTINCT
	s.[Payment Method],
    SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	FORMAT(ROUND(SUM([Total Charges]), 2), 'C', 'en-US') AS total_charges
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
WHERE 
	st.[Churn Label] = 'Yes'
GROUP BY
    s.[Payment Method];

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing if there correlation between monthly charge and churn rate: */

SELECT DISTINCT
	s.[Monthly Charge], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY
	s.[Monthly Charge]
ORDER BY
	ChurnedCustomer DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating the average monthly charges and total charges for churned customers: */

SELECT 
	FORMAT(ROUND(MIN([Monthly Charge]), 2), 'C', 'en-US') AS min_monthly_charge,
	FORMAT(ROUND(MAX([Monthly Charge]), 2), 'C', 'en-US') AS max_monthly_charge,
	FORMAT(ROUND(AVG([Monthly Charge]), 2), 'C', 'en-US') AS avg_monthly_charge,
	FORMAT(ROUND(SUM([Monthly Charge]), 2), 'C', 'en-US') AS total_monthly_charge
FROM 
	customerChurn..services s
JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
WHERE 
	st.[Churn Label] = 'Yes';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Calculating and total monthly charges by churned customers: */

SELECT 
	FORMAT(ROUND(MIN([Total Charges]), 2), 'C', 'en-US') AS min_total_charges,
	FORMAT(ROUND(MAX([Total Charges]), 2), 'C', 'en-US') AS max_total_charges,
	FORMAT(ROUND(AVG([Total Charges]), 2), 'C', 'en-US') AS avg_total_charges,
	FORMAT(ROUND(SUM([Monthly Charge]), 2), 'C', 'en-US') AS sum_total_charges
FROM 
	customerChurn..services s
LEFT JOIN 
	customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
WHERE 
	st.[Churn Label] = 'Yes';

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the number of churned customers by refund recieved and the correlation with churn rate: */

SELECT
    Refund,
    COUNT(*) AS TotalCustomer,
    SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
    CASE 
        WHEN COUNT(DISTINCT s.[Customer ID]) = 0 THEN 0
        ELSE CAST(SUM(CASE WHEN st.[Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT s.[Customer ID]) AS DECIMAL(10, 2))
    END AS ChurnRate
FROM 
    (SELECT DISTINCT
        CASE
            WHEN [Total Refunds] = 0 THEN 'No'
            ELSE 'Yes'
        END AS Refund,
        [Customer ID]
    FROM customerChurn..services) s
LEFT JOIN 
    customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
GROUP BY
    s.Refund
ORDER BY
    ChurnedCustomer DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing minimum, maximum, average, and total refunds: */

SELECT
    MIN([Total Refunds]) AS minimum_refund,
	MAX([Total Refunds]) AS maximum_refund,
	ROUND(AVG([Total Refunds]), 2) AS avg_refund,
	ROUND(SUM([Total Refunds]), 2) AS total_refund
FROM 
	customerChurn..services s
LEFT JOIN 
    customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
WHERE
	st.[Churn Label] = 'Yes';

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating average total extra data charges: */

SELECT
	FORMAT(MIN([Total Extra Data Charges]),'C', 'en-US') AS minimum_extra_data_charges,
	FORMAT(MAX([Total Extra Data Charges]),'C', 'en-US') AS maximum_extra_data_charges,
	FORMAT(ROUND(AVG([Total Extra Data Charges]), 2),'C', 'en-US') AS avg_extra_data_charges,
	FORMAT(ROUND(SUM([Total Extra Data Charges]), 2),'C', 'en-US') AS sum_extra_data_charges
FROM 
	customerChurn..services s
LEFT JOIN 
    customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
WHERE
	st.[Churn Label] = 'Yes';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating Minimum, Maximum, Average, and Total Revenue generated from Churned Customers: */

SELECT
	FORMAT(MIN([Total Revenue]), 'C', 'en-US') AS minimum_revenue,
	FORMAT(MAX([Total Revenue]), 'C', 'en-US') AS maximum_revenue,
	FORMAT(ROUND(AVG([Total Revenue]), 2), 'C', 'en-US') AS avg_revenue,
	FORMAT(ROUND(SUM([Total Revenue]), 2), 'C', 'en-US') AS total_revenue
FROM 
	customerChurn..services s
LEFT JOIN 
    customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
WHERE
	st.[Churn Label] = 'Yes';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating Revenue lost(%) due to customer churn: */

WITH CTE AS (
    SELECT
        s.[Customer ID],
        SUM(s.[Total Revenue]) AS cc_total_revenue
    FROM
        customerChurn..services s
    LEFT JOIN 
        customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
    WHERE
        st.[Churn Value] = 1
    GROUP BY
        s.[Customer ID]
)

SELECT
    ROUND(SUM(cte.cc_total_revenue) / SUM(s.[Total Revenue]) * 100, 2) AS revenue_loss_percentage
FROM
    customerChurn..services s
LEFT JOIN
    CTE cte ON s.[Customer ID] = cte.[Customer ID];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the satisfaction scores, satisfaction score labels, and relationship with churn rate of churned customers: */

SELECT 
	[Satisfaction Score Label], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN [Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT [Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN [Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT [Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..status
GROUP BY 
	[Satisfaction Score Label]
ORDER BY
    ChurnedCustomer DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing minimum, maximum, and average satisfaction score: */

SELECT
    MIN([Satisfaction Score]) AS minimum_score,
	MAX([Satisfaction Score]) AS maximum_score,
	ROUND(AVG([Satisfaction Score]), 2) AS avg_score
FROM 
	customerChurn..services s
LEFT JOIN 
    customerChurn..status st ON s.[Customer ID] = st.[Customer ID]
WHERE
	st.[Churn Label] = 'Yes';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Top Churn reasons by satisfaction scores: */

SELECT TOP 10
	[Satisfaction Score Label], 
	[Churn Reason]
FROM 
	customerChurn..status
WHERE
    [Satisfaction Score] IN (1, 2, 3) AND [Churn Reason] != '' AND [Churn Label] = 'Yes'
GROUP BY
    [Satisfaction Score Label], 
	[Churn Reason]
ORDER BY
    SUM(CASE WHEN [Churn Label] = 'Yes' THEN 1 ELSE 0 END) DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analyzing the number of customers that did not churn: */

SELECT 
	[Customer Status],
	COUNT(*) CustomerCount
FROM 
	customerChurn..status
WHERE
	[Churn Label] = 'No'
GROUP BY
	[Customer Status];

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analysing churn rate by churn score group: */

SELECT
    [Score Group],
    COUNT(*) AS TotalCustomer,
    SUM(CASE WHEN [Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
    CASE 
        WHEN COUNT(DISTINCT [Customer ID]) = 0 THEN 0
        ELSE CAST(SUM(CASE WHEN [Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT [Customer ID]) AS DECIMAL(10, 2))
    END AS ChurnRate
FROM (
    SELECT DISTINCT
        CASE
            WHEN [Churn Score] BETWEEN 5 AND 20 THEN 'Low'
            WHEN [Churn Score] BETWEEN 21 AND 40 THEN 'Medium'
            WHEN [Churn Score] BETWEEN 41 AND 60 THEN 'High'
            ELSE 'Very High'
        END AS [Score Group],
        [Customer ID],
        [Churn Label]
    FROM customerChurn..status
) AS Subquery
GROUP BY
    [Score Group]
ORDER BY
    ChurnedCustomer DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating minimum, maximum, and average churn score of churned customers: */

SELECT
    MIN([Churn Score]) AS minimum_score,
	MAX([Churn Score]) AS maximum_score,
	AVG([Churn Score]) AS avg_score
FROM 
	customerChurn..status
WHERE
	[Churn Label] = 'Yes';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Analysing churn rate by the CLTV categories: */

SELECT 
	[CLTV Category], 
	COUNT(*) AS TotalCustomer,
	SUM(CASE WHEN [Churn Label] = 'Yes' THEN 1 ELSE 0 END) AS ChurnedCustomer,
	CASE 
		WHEN COUNT(DISTINCT [Customer ID]) = 0 THEN 0
		ELSE CAST(SUM(CASE WHEN [Churn Label] = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT [Customer ID]) AS DECIMAL(10, 2))
	END AS ChurnRate
FROM 
	customerChurn..status
GROUP BY 
	[CLTV Category]
ORDER BY
	ChurnedCustomer DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Calculating the average Customer Life Time Value for churned customers: */

SELECT
    MIN([CLTV]) AS minimum_CLTV,
	MAX([CLTV]) AS maximum_CLTV,
	AVG(CLTV) AS average_CLTV
FROM 
	customerChurn..status
WHERE 
	[Churn Label] = 'Yes';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Identifying the most common reasons for churn based on service usage: */

SELECT	
	[Churn Category],
	[Churn Reason]
FROM 
	customerChurn..status
WHERE 
	[Churn Label] = 'Yes'
GROUP BY 
	[Churn Category],
	[Churn Reason]
ORDER BY 
	COUNT([Churn Reason]) DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Identifying the main factors influencing customer dissatisfaction leading to churn: */

SELECT	
	[Churn Reason], 
	COUNT(*) AS churnedCustomer
FROM 
	customerChurn..status
WHERE 
	[Churn Label] = 'Yes'
GROUP BY 
	[Churn Reason]
ORDER BY 
	churnedCustomer DESC;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------