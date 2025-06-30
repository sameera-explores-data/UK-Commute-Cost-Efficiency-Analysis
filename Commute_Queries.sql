--  creating a database
create database commute;
-- import the csv file into the created database
select * from cleaned_commute_costs;
-- 1.	Data Cleaning and Structuring 
-- handling missing values
select * from cleaned_commute_costs where city is null or Commute_Route is null or Commute_Distance_miles is 
null or Commute_Time_mins is null or Mode_of_Commute is null or Daily_Cost is null or Monthly_Cost is null
or Cost_per_Mile is null or Value_Tier is null or Carbon_Impact is null or Best_Value_Rank is null or Worst_Value_Reason
is null or Avg_Delay_mins is null or Commute_Type is null;

-- standardize comute type and route
-- 3. 	Categorize distance and cost ranges
SELECT 
  Commute_Route,
  Commute_Distance_miles,
  Monthly_Cost,

  -- Categorize distance
  CASE 
    WHEN Commute_Distance_miles < 10 THEN 'Short'
    WHEN Commute_Distance_miles BETWEEN 10 AND 25 THEN 'Medium'
    WHEN Commute_Distance_miles > 25 THEN 'Long'
    ELSE 'Unknown'
  END AS Distance_Category,

  -- Categorize monthly cost
  CASE 
    WHEN Monthly_Cost < 150 THEN 'Low'
    WHEN Monthly_Cost BETWEEN 150 AND 350 THEN 'Medium'
    WHEN Monthly_Cost > 350 THEN 'High'
    ELSE 'Unknown'
  END AS Cost_Category

FROM cleaned_commute_costs;

-- Find average cost per mode of transport
SELECT 
  Mode_of_Commute,
  ROUND(AVG(Daily_Cost), 2) AS Avg_Daily_Cost,
  ROUND(AVG(Monthly_Cost), 2) AS Avg_Monthly_Cost,
  ROUND(AVG(Cost_per_Mile), 2) AS Avg_Cost_per_Mile
FROM cleaned_commute_costs
GROUP BY Mode_of_Commute;

-- Identify cities with the highest carbon impact or longest average delays
SELECT 
  City,
  ROUND(AVG(Carbon_Impact), 2) AS Avg_Carbon_Impact,
  ROUND(AVG(Avg_Delay_mins), 2) AS Avg_Delay_Mins
FROM cleaned_commute_costs
GROUP BY City
ORDER BY Avg_Carbon_Impact DESC, Avg_Delay_Mins DESC;

-- 	Determine top 5 routes by best value rank
SELECT 
  Commute_Route,
  City,
  Best_Value_Rank,
  Monthly_Cost,
  Commute_Distance_miles
FROM cleaned_commute_costs
WHERE Best_Value_Rank IS NOT NULL
ORDER BY Best_Value_Rank ASC
LIMIT 5;

-- Compare daily vs monthly commute costs by city
SELECT 
  City,
  ROUND(AVG(Daily_Cost), 2) AS Avg_Daily_Cost,
  ROUND(AVG(Monthly_Cost), 2) AS Avg_Monthly_Cost
FROM cleaned_commute_costs
GROUP BY City
ORDER BY Avg_Monthly_Cost DESC;
