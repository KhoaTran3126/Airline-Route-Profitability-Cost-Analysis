/*
Phase 1: Exploratory & Descriptive Analysis

Objective:
Identify broad operational and financial patterns across the airline network before investigating the underlying drivers of profitability.
*/


# Get the sorted counts of destinations in the data
SELECT 
  Destination, 
  COUNT(*) AS counts
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Destination
ORDER BY counts DESC;

# Get the sorted counts of aircrafts in the data
SELECT 
  Aircraft_Type, 
  COUNT(*) AS counts
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Aircraft_Type
ORDER BY counts DESC;

# Long & Short hauls have many more High-demand flights
SELECT 
  Route_Category,
  Demand_Level,
  COUNT(*) AS flights
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Route_Category, Demand_Level 
ORDER BY Route_Category, flights DESC;

# High-demand flights generate about 18% in mean profit margin
# Medium-demand flights generate about -9.73% in mean profit margin
SELECT 
  Demand_Level,
  COUNT(*) AS flights,
  ROUND(AVG(Profit_Margin),2) AS mean_profit_margin,
  ROUND(APPROX_QUANTILES(Profit_Margin, 100)[OFFSET(50)],2) AS median_profit_margin
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Demand_Level 
ORDER BY mean_profit_margin DESC; 

# Long-hauls generate the highest average profit margin (22% mean, 29% median)
# Medium-hauls generate modest average profit margin (13% mean, 18% median)
# Short-hauls generate lowest average profit margin (-26% mean, -15% median)
SELECT 
  Route_Category,
  COUNT(*) AS flights,
  ROUND(AVG(Profit_Margin),2) AS mean_profit_margin,
  ROUND(APPROX_QUANTILES(Profit_Margin, 100)[OFFSET(50)],2) AS median_profit_margin
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Route_Category 
ORDER BY mean_profit_margin DESC; 


# High-demand Long-haul flights genrate the HIGHEST average profit margins (32% mean, 37% median)
# Medium-demand Short-haul flights generate the LOWEST average profit margins (-67% mean, -58% median)
# Other flights generate modest (~0%-20% mean/median) profit margins
SELECT 
  Demand_Level,
  Route_Category,
  COUNT(*) AS flights,
  ROUND(AVG(Profit_Margin),2) AS mean_profit_margin,
  ROUND(APPROX_QUANTILES(Profit_Margin, 100)[OFFSET(50)],2) AS median_profit_margin
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Route_Category, Demand_Level 
ORDER BY mean_profit_margin DESC;  


/*
Are profitable routes fuller/have higher load factor?

Mean Load Factor varies only with demand-category and does not correlate with mean profit margin

Interestingly, High-Demand Short-Haul flights have the same mean load factor (85%) as 
High-Demand Long-Haul flights but with a much lower mean profit margin (-0.47% vs 32%)
*/ 
SELECT 
  Demand_Level, Route_Category,
  ROUND(AVG(Load_Factor),2) AS mean_load_factor,
  ROUND(AVG(Profit_Margin),2) AS mean_profit_margin
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Demand_Level, Route_Category 
ORDER BY mean_profit_margin DESC; 


/*
How does the revenue-per-passenger compared to profit margin of flight routes?

1. High-demand flights generate more revenue-per-passenger than Medium-demand (40-100 unit-price diff)
2. Long-haul flights generate the most revenue-per-passenger (above 1500 unit-price per passenger)
3. Short-haul flights generate the least revenue-per-passenger (below 300 unit-price per passenger)

High-demand Long-haul flights generate the most revenue-per-passenger (1850 unit-price per passenger)
Medium-demand Short-haul flights generate the least revenue-per-passenger (248 unit-price per passenger)
*/
SELECT 
  Demand_Level, Route_Category,
  ROUND(AVG(Total_Revenue/Passengers),2) AS mean_rev_per_passenger,
  ROUND(APPROX_QUANTILES(Total_Revenue/Passengers,100)[OFFSET(50)],2) AS median_rev_per_passenger,
  ROUND(AVG(Profit_Margin),2) AS mean_profit_margin
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Demand_Level, Route_Category 
ORDER BY mean_rev_per_passenger DESC; 

/*
Which aircraft generates the most profit margin on average?

Airbus A380 generated the greatest profit margin on average(23% mean, 31% median)

Aircrafts in-between generate modest profit margin on average (1-23% mean/median)

Airbus A320 (-8% mean, 0.34% median) and Boeing 737-800 (-10% mean, -2% median) generated
the least profit margin on average
*/
SELECT 
  Aircraft_Type,
  COUNT(*) AS flights,
  ROUND(AVG(Profit_Margin),2) AS mean_profit_margin,
  APPROX_QUANTILES(Profit_Margin,100)[OFFSET(50)] AS median_profit_margin
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Aircraft_Type
ORDER BY mean_profit_margin DESC;


/*
Summary Observations:
1. Demand is a strong profitability indicator, with substantial impact on financial performance
    High-demand flights   =>  18% mean profit margin
    Medium-demand flights => -10% mean profit margin

2. Distance is a major profitability indicator, with substantial impact on financial performance
    Long-hauls   =>  22% mean profit margin
    Medium-hauls =>  13% mean profit margin
    Short hauls  => -26% mean profit margin (loss-making)

3. Demand and route category interacts strongly
    High-demand Long-haul flights    =>  32% mean profit margin
    Medium-demand Short-haul flights => -67% mean profit margin (loss-making)

4. Revenue-per-passenger increases with profit margin across demands and route categories
    High-demand Long-haul flights generate substantially higher revenue per passenger
    Medium-demand Short-haul flights generate the least revenue per passenger

5. Fleet type may materially influences financial performance
    a.  Airbus A380 generated the greatest profit margin on average(23% mean, 31% median)
    b.  Aircrafts in-between generate modest profit margin on average (1-23% mean/median)
    c.  Airbus A320 (-8% mean, 0.34% median) and Boeing 737-800 (-10% mean, -2% median) generated
    the least profit margin on average

Overall, profitability is substantially driven by the interaction of demand, route distance, passenger yield, and fleet assigment. 



Next Questions:
    1. To what extent does the operating cost structure explain the poor profitability of short-haul flights?
    2. Why do long-haul and high-demand flights generate substantially higher profit margins?
    3. Which aircraft performs best within each route category?
    4. Which individual routes significantly outperform or underperform the average profitability of their route category?
*/
 
