/*
=====================================================================
IPL PLAYERS ANALYSIS - SQL WINDOW FUNCTIONS & AGGREGATIONS
=====================================================================

This script performs multiple analytical queries on the IPLPlayers
dataset to extract insights about player spending, ranking, and classification.

---------------------------------------------------------------------
DATASET FIELDS USED:
- Player         : Name of the player
- Team           : Team name
- Price_in_cr    : Player price in Crores
- Role           : Player role (e.g., Batsman, Bowler, All-rounder)
- Type           : Player type (Indian / Overseas)

---------------------------------------------------------------------
ANALYTICAL OBJECTIVES:

Q1: Total Spending per Team
    - Calculates total auction spending per team using SUM + GROUP BY
    - Orders teams by highest spending

Q2: Top 3 Highest Paid All-rounders
    - Filters players with Role = 'All-rounder'
    - Returns top 3 based on Price_in_cr

Q3: Highest Paid Player in Each Team
    - Uses ROW_NUMBER() window function partitioned by Team
    - Selects rank = 1 (most expensive player per team)

Q4: Top 2 Expensive Players per Team
    - Uses ROW_NUMBER() over partition by Team
    - Filters rank 1 and 2 players per team

Q5: Top 2 Most Expensive Players per Team (Pivoted Output)
    - Uses CASE WHEN + aggregation to display top 2 players side by side
    - Groups results by Team

Q6: Player Contribution to Team Spending (%)
    - Uses SUM() OVER (PARTITION BY Team)
    - Calculates each player’s percentage contribution to total team spend
    - Uses ROUND and CAST to format numeric output

Q7: Player Price Classification
    - Classifies players into:
        * High   : Price > 15 Cr
        * Medium : 5 - 15 Cr
        * Low    : < 5 Cr
    - Counts number of players in each category

Q8: Indian vs Overseas Average Price Comparison
    - Uses subqueries inside UNION ALL
    - Computes average price separately for Indian and Overseas players

Q9: Players Paid Above Team Average
    - Uses correlated subquery
    - Returns players whose price is greater than their team’s average

Q10: Most Expensive Player per Role
    - Uses correlated subquery with MAX()
    - Returns highest paid player in each role category

---------------------------------------------------------------------
TECHNIQUES USED:
- Aggregation (SUM, AVG, COUNT)
- Window Functions (ROW_NUMBER, SUM OVER)
- CASE WHEN classification
- Correlated Subqueries
- GROUP BY and HAVING logic
- UNION ALL for comparative analysis

---------------------------------------------------------------------
PURPOSE:
This script demonstrates SQL analytical capabilities commonly used in:
- Sports analytics
- Auction data analysis
- Business intelligence dashboards
- Data engineering pipelines

=====================================================================
*/
--find the total spending on players for each team 
select
Team,
sum(Price_in_cr) as total
from IPLPlayers
group by Team
order by total desc

--Q2 Find the top 3 highest paid all rounders accross all the teams
select TOP 3
Player,
Team,
Price_in_cr
from IPLPlayers
where Role = 'All-rounder'
order by Price_in_cr desc


--Q3 Find the highest paid player in each team
with cte as (
select
Player,
Team,
row_number() over(partition by Team order by Price_in_cr desc ) team_rank,
Price_in_cr
from IPLPlayers
)
select 
Player,
Team,
Price_in_cr
from cte c 
where c.team_rank =1
order by Price_in_cr desc


--Q4 rank players depend o their price and return first two 
with cte as (
select
Player,
Team,
row_number() over(partition by Team order by Price_in_cr desc ) team_rank,
Price_in_cr
from IPLPlayers
)
select 
Player,
Team,
Price_in_cr
from cte c 
where c.team_rank in (1,2)


--Q5 find the most expensive player name along with the second most expensive player name and price in each team
with cte as (
select
Player,
Team,
row_number() over(partition by Team order by Price_in_cr desc ) team_rank,
Price_in_cr
from IPLPlayers
)
select 
Team,
Max(case when team_rank = 1 then Player end) as most_expensive_player,
Max(case when team_rank = 1 then Price_in_cr end) as most_expensive_price,
Max(case when team_rank = 2 then Player end) as second_most_expensive_player,
Max(case when team_rank =2 then Price_in_cr end) as second_most_expensive_price
from cte c 
Group by Team



-- Q6: Determine the percentage of total team spending represented by each player's price
select 
Team,
Player,
Price_in_cr,
Sum(Price_in_cr) over(partition by Team) as total_team_spending,
cast(round(((Price_in_cr)/Sum(Price_in_cr) over(partition by Team))*100,2) as decimal(10,2)) as percentage_of_team_spending
from IPLPlayers

--Q7 Classify players as 'High', 'Medium', or 'Low' priced based on the following rules:
--High: Price > ₹15 crore
--Medium: Price between ₹5 crore and ₹15 crore
--Low: Price < ₹5 crore
--and find out the number of players in each bracket


select 
case when Price_in_cr > 15 then 'High'
	 when Price_in_cr <15 and Price_in_cr > 5  then 'Meduim'
	 else 'Low' end as price_bracket,
count(*) as number_of_players
from IPLPlayers
group by case when Price_in_cr > 15 then 'High'
	 when Price_in_cr <15 and Price_in_cr > 5  then 'Meduim'
	 else 'Low' end


--Q8 Find the average price of Indian players and compare it with overseas players using a subquery:
SELECT
    'Indian' AS PlayerType,
    (SELECT AVG(Price_in_cr)
     FROM IPLPlayers
     WHERE Type LIKE 'Indian%') AS AvgPrice
UNION ALL
SELECT
    'Overseas' AS PlayerType,
    (SELECT AVG(Price_in_cr)
     FROM IPLPlayers
     WHERE Type LIKE 'Overseas%') AS AvgPrice

--q9 return the player that paid more the acerage of their team 
SELECT 
    Player
FROM IPLPlayers
WHERE Price_in_cr > (
    SELECT AVG(Price_in_cr)
    FROM IPLPlayers p2
    WHERE p2.Team = IPLPlayers.Team
);

--Q10 For each role, find the most expensive player and their price using a correlated subquery
select 
Role,
Player
from IPLPlayers p
where price_in_cr =(select max(price_in_cr) from IPLPlayers p2 where p2.Role = p.Role)
group by Role,Player,Price_in_cr