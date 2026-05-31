# 🏏 IPL Players SQL Analytics Project

![SQL](https://img.shields.io/badge/SQL-Advanced-blue)
![Status](https://img.shields.io/badge/Project-Completed-brightgreen)
![Domain](https://img.shields.io/badge/Domain-Sports%20Analytics-orange)
![Level](https://img.shields.io/badge/Level-Portfolio%20Ready-red)

---

## 📊 Project Overview

A **data analytics project on IPL auction data** using SQL to extract business insights such as team spending behavior, player valuation, and performance-based pricing patterns.

This project demonstrates **real-world data analysis skills used in BI and Data Analyst roles**.

---

## 🧠 Key Business Questions Answered

- Which IPL teams have the highest auction spending?
- Who are the most expensive players across teams?
- How is team budget distributed among players?
- Which players perform above their team average price?
- How are players categorized by price tiers?
- What is the difference between Indian vs Overseas player pricing?

---

## 🗂️ Dataset Information

| Column        | Description                          |
|---------------|--------------------------------------|
| Player        | Name of IPL player                  |
| Team          | IPL franchise                       |
| Price_in_cr   | Auction price (Crores)              |
| Role          | Player role                        |
| Type          | Indian / Overseas classification     |

---

## 📈 Key Insights (Business Value)

✔ Teams show strong spending concentration on top 2–3 players  
✔ All-rounders dominate high-value auctions  
✔ Significant pricing gap between top-tier and base players  
✔ Overseas players tend to have higher average valuation in key roles  

---

## 🛠️ SQL Techniques Used

- Aggregations (`SUM`, `AVG`, `COUNT`)
- Window Functions (`ROW_NUMBER`, `SUM OVER`)
- CASE WHEN classification
- Correlated subqueries
- Ranking & partitioning logic
- Data segmentation analysis

---

## 📊 SQL Analysis Highlights

### 🔹 Total Spending per Team
```sql
SELECT Team, SUM(Price_in_cr) AS total_spending
FROM IPLPlayers
GROUP BY Team
ORDER BY total_spending DESC;
```

---

### 🔹 Top 3 Expensive All-Rounders
```sql
SELECT TOP 3 Player, Team, Price_in_cr
FROM IPLPlayers
WHERE Role = 'All-rounder'
ORDER BY Price_in_cr DESC;
```

---

### 🔹 Highest Paid Player per Team
```sql
WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Team ORDER BY Price_in_cr DESC) AS rn
    FROM IPLPlayers
)
SELECT Player, Team, Price_in_cr
FROM cte
WHERE rn = 1;
```

---

### 🔹 Player Contribution to Team Budget (%)
```sql
SELECT
    Team,
    Player,
    Price_in_cr,
    SUM(Price_in_cr) OVER (PARTITION BY Team) AS team_total,
    ROUND((Price_in_cr * 100.0) /
    SUM(Price_in_cr) OVER (PARTITION BY Team), 2) AS contribution_pct
FROM IPLPlayers;
```

---

## 📊 Project Visual Idea (Add Later in Power BI)

You can extend this project with:

📌 Team Spending Bar Chart  
📌 Player Price Distribution Histogram  
📌 Role-wise Average Price Pie Chart  
📌 Top 10 Most Expensive Players Dashboard  

---

## 📌 Project Highlights

- Real-world sports analytics dataset
- Advanced SQL query design
- Business intelligence thinking
- Portfolio-ready structure
- Interview-level problem solving

---

## 🧑‍💻 Author

**Youssif Mossad**  
Aspiring Data Analyst | SQL • BI • Data Engineering  

---

## 🚀 Future Improvements

- Add Power BI dashboard
- Connect to Python for visualization
- Build automated reporting layer
- Deploy as interactive analytics project
