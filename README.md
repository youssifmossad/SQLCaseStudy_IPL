# 🏏 IPL Players SQL Analysis Project

This project performs **data analysis on IPL Players auction data** using SQL.  
It demonstrates the use of **window functions, aggregation, subqueries, and classification techniques** to extract meaningful insights about player pricing and team spending.

---

## 📂 Dataset Overview

The analysis is based on the `IPLPlayers` table containing:

| Column        | Description                          |
|---------------|--------------------------------------|
| Player        | Name of the player                   |
| Team          | Team name                            |
| Price_in_cr   | Player auction price (in Crores)     |
| Role          | Player role (Batsman, Bowler, etc.)  |
| Type          | Indian / Overseas player type        |

---

## 🎯 Project Objectives

The goal is to answer key analytical questions such as:

- Which teams spend the most in auctions?
- Who are the top expensive players?
- How do players compare within their teams?
- What percentage of team budget does each player represent?
- How can players be classified based on price?

---

## 📊 SQL Analysis Breakdown

---

### 1. Total Spending per Team
Calculates total auction spending per team.

```sql
SELECT
    Team,
    SUM(Price_in_cr) AS total
FROM IPLPlayers
GROUP BY Team
ORDER BY total DESC;
