
/*
To what extent does the operating cost structure explain the poor profitability of short-haul flights?
*/

# Most normalized costs are similar across demand levels and route categories; interestingly, Short-haul flights have slightly higher handling cost per passenger 
# Fuel, maintenance, crew, depreciation, and insurance costs per hour are naturally higher for longer routes because they scale with flight duration
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


# Short-haul flights have highest cost per seat hour 
SELECT
  Route_Category,
  ROUND(AVG(Total_Cost / (Aircraft_Capacity * Flight_Hours)),2) AS cost_per_seat_hour
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Route_Category
ORDER BY Route_Category DESC;



/*
Why do long-haul and high-demand flights generate substantially higher profit margins?
*/

# All revenue-per-passenger sources reasonably increase with longer route categories and higher demands
# Ticket revenue consistently contributes 88% more revenue per passenger than ancillary revenue across all route categories + demand level
# Load factor is consistently higher in High-demand flights than Medium-demand flights
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


# Medium-demand Short-haul flights generates much more cost than revenue per passenger than other flights, resulting in a profit-per-passenger of -142 unit-price
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
SELECT
  Route_Category, Aircraft_Type,
  COUNT(*) AS flights,
  ROUND(AVG(Profit_Margin),2) AS avg_profit_margin,
  ROUND(AVG((Total_Revenue - Total_Cost) / Passengers),2) AS profit_per_passenger
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Route_Category, Aircraft_Type
ORDER BY Route_Category, avg_profit_margin DESC;

SELECT
  Route_Category, Aircraft_Type,
  ROUND(AVG(Total_Revenue / Passengers),2) AS revenue_per_pax,
  ROUND(AVG(Load_Factor),2) AS load_factor
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Route_Category, Aircraft_Type;

SELECT
  Route_Category, Aircraft_Type,
  ROUND(AVG(Total_Cost / Passengers),2) AS cost_per_pax,
  ROUND(AVG(Total_Cost / (Aircraft_Capacity * Flight_Hours)),2) AS cost_per_seat_hour
FROM `airline-analysis-503416.airline_dataset.airline_opeartions_table`
GROUP BY Route_Category, Aircraft_Type;

/*
Summary Observations:
1. To what extent does the operating cost structure explain the poor profitability of short-haul flights?
2. Why do long-haul and high-demand flights generate substantially higher profit margins?
3. Which aircraft performs best within each route category?
4. Which individual routes significantly outperform or underperform the average profitability of their route category?
*/
