/*
Phase 2: Diagnostic Analysis 

Objective:
Determine the key drivers of airline profitability by evaluating cost efficiency,
revenue generation, and fleet performance across different operational segments.
*/

/*
To what extent does the operating cost structure explain the poor profitability of short-haul flights?
*/

-- Most normalized costs are similar across demand levels and route categories; interestingly, Short-haul flights have slightly higher handling cost per passenger 
-- Fuel, maintenance, crew, depreciation, and insurance costs per hour are naturally higher for longer routes because they scale with flight duration
SELECT 
  Demand_Level, Route_Category,

  ROUND(AVG(Fuel_Cost / Flight_Hours),2) AS fuel_cost_per_hour,
  ROUND(AVG(Maintenance_Cost / Flight_Hours),2) AS maintenance_cost_per_hour,
  ROUND(AVG(Crew_Cost / Flight_Hours),2) AS crew_cost_per_hour,
  ROUND(AVG(Depreciation_Cost / Flight_Hours),2) AS depreciation_cost_per_hour,
  ROUND(AVG(Insurance_Cost / Flight_Hours),2) AS insurance_cost_per_hour,

  ROUND(AVG(Catering_Cost / Passengers),2) AS catering_cost_per_pax,
  ROUND(AVG(Handling_Cost / Passengers),2) AS handling_cost_per_pax,
  ROUND(AVG(Airport_Fees / Passengers),2) AS airport_cost_per_pax,

  ROUND(AVG(Passenger_Service_Cost / Passengers),2) AS passenger_service_cost_per_pax,
  ROUND(AVG(IT_Systems_Cost / Passengers),2) AS it_systems_cost_per_pax

FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Demand_Level, Route_Category
ORDER BY Demand_Level DESC, Route_Category DESC;


-- Short-haul flights have highest cost per seat hour 
SELECT
  Route_Category,
  ROUND(AVG(Total_Cost / (Aircraft_Capacity * Flight_Hours)),2) AS cost_per_seat_hour
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Route_Category
ORDER BY Route_Category DESC;



/*
Why do long-haul and high-demand flights generate substantially higher profit margins?
*/

-- All revenue-per-passenger sources reasonably increase with longer route categories and higher demands
-- Ticket revenue consistently contributes 88% more revenue per passenger than ancillary revenue across all route categories + demand level
-- Load factor is consistently higher in High-demand flights than Medium-demand flights
SELECT
  Demand_Level, Route_Category,
  ROUND(AVG(Ticket_Revenue / Passengers),2) AS ticket_rev_per_pax,
  ROUND(AVG(Ancillary_Revenue / Passengers),2) AS ancillary_rev_per_pax,
  100*ROUND(AVG((Ancillary_Revenue - Ticket_Revenue)/Ticket_Revenue),2) AS ancillary_ticket_rev_pct_diff,
  ROUND(AVG(Load_Factor),2) AS load_factor,
  ROUND(AVG(Total_Revenue / Passengers),2) AS total_rev_per_pax
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Route_Category, Demand_Level
ORDER BY Route_Category DESC, Demand_Level DESC;


-- Medium-demand Short-haul flights generates much more cost than revenue per passenger than other flights, resulting in a profit-per-passenger of -142 unit-price
SELECT
  Demand_Level, Route_Category,
  ROUND(AVG(Total_Revenue / Passengers),2) AS revenue_per_passenger,
  ROUND(AVG(Total_Cost / Passengers),2) AS cost_per_passenger,
  ROUND(AVG((Total_Revenue - Total_Cost) / Passengers),2) AS profit_per_passenger
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Route_Category, Demand_Level
ORDER BY Demand_Level DESC, Route_Category DESC;



/*
Which aircraft performs best within each route category?
*/

/*
1. Long haul: Boeing 787-9 generates highest profit margin (34%) and profit per passenger (689.5)
2. Medium haul: Airbus A320 generates highest profit margin (31.5%) and profit per passenger (233)
3. Short haul: aircrafts generate negative profit margin and negative profit per passenger
*/
SELECT
  Route_Category, Aircraft_Type,
  COUNT(*) AS flights,
  ROUND(AVG(Profit_Margin),2) AS avg_profit_margin,
  ROUND(AVG((Total_Revenue - Total_Cost) / Passengers),2) AS profit_per_passenger
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Route_Category, Aircraft_Type
ORDER BY Route_Category, avg_profit_margin DESC;

-- Longer routes generate more revenue per passenger, and larger load factor positive correlates with higher revenue per passenger
/*
Short haul: Airbus A320 has highest revenue per passenger and highest load factor
Medium haul: Airbus A380 has highest revenue per passenger and highest load factor
Long haul: Boeing 787-9 has highest revenue per passenger and highest load factor
*/
SELECT
  Route_Category, Aircraft_Type,
  ROUND(AVG(Total_Revenue / Passengers),2) AS revenue_per_pax,
  ROUND(AVG(Load_Factor),2) AS load_factor
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Route_Category, Aircraft_Type
ORDER BY Route_Category DESC, revenue_per_pax DESC;


/*
Summary Observations:
1. To what extent does the operating cost structure explain the poor profitability of short-haul flights?
    a. Operating cost structure only partially explains the poor profitability of short-haul flights.
    b. Most passenger-normalized cost components are comparable across demand levels and route categories.
    c. Handling cost per passenger is the only notable cost disadvantage for short-haul flights.
    d. Although short-haul flights exhibit the highest cost per available seat-hour, higher hourly operating costs are naturally associated with longer flights due to greater flight durations.

Overall, cost structure alone is insufficient to explain the substantial profitability gap.


2. Why do long-haul and high-demand flights generate substantially higher profit margins?
    a. Revenue per passenger increases consistently with both route distance and demand level.
    b. Ticket revenue is the dominant revenue source, contributing substantially more revenue per passenger than ancillary services across all route categories.
    c. High-demand flights maintain consistently higher load factors, indicating stronger aircraft utilization.
    d. Medium-demand short-haul flights generate substantially less revenue than cost per passenger, resulting in the lowest profit per passenger among all route-demand combinations.

Overall, profitability differences are driven primarily by stronger passenger revenue generation rather than lower operating costs.


3. Which aircraft performs best within each route category?
    a. Aircraft performance varies considerably by route category.
    b. The Boeing 787-9 achieves the highest profitability on long-haul routes, producing both the highest average profit margin and profit per passenger.
    c. The Airbus A320 performs best on medium-haul routes, generating the highest average profit margin and profit per passenger.
    d. All aircraft operating on short-haul routes exhibit negative average profit margins, suggesting that route economics rather than aircraft selection primarily constrain profitability.
    e. Aircraft with higher revenue per passenger also tend to achieve higher load factors, indicating that fleet performance is closely associated with passenger demand and revenue generation.
*/
