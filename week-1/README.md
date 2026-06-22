# Week 1 — SQL Basics

**Status:** 🚧 In progress
**Topic:** First contact with the UrbanStyle database using single-table SQL
(`SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `COUNT`).

---

## Why this exists

UrbanStyle's founder, Kristi, makes most decisions on gut feeling. The first
step toward data-driven decisions is simply *knowing what's in the data*: what
products exist, where sales happen, and who the customers are. This week answers
the most basic question — **"What does UrbanStyle actually sell, and where?"** —
without any joins or cleaning yet.

## What I did

- Loaded the three core tables into Supabase (PostgreSQL):
  `products` (~350 rows), `customers` (~3,150 rows), `sales` (~15,234 rows).
- Wrote single-table queries to explore the catalog, find the highest-value
  sales, and break customers down by loyalty tier.
- Practiced filtering (`WHERE`), sorting (`ORDER BY`), limiting results
  (`LIMIT`), and counting (`COUNT`, `GROUP BY` on one table).

**Tool:** SQL on PostgreSQL via the Supabase SQL Editor.

## What it shows

A first factual picture of the business: product categories, the busiest store
locations, and the loyalty mix of the customer base. These numbers replace
guesswork and set up the next weeks — Week 2 will clean the ~5k duplicate sales
rows this exploration reveals, and Week 3 will join tables to connect customers
to what they bought.

---

## Artifacts

| File | What it answers |
|------|-----------------|
| [`queries/01_browse_catalog.sql`](./queries/01_browse_catalog.sql) | What product categories exist and how many products in each? |
| [`queries/02_top_sales.sql`](./queries/02_top_sales.sql) | What were the highest-value individual sales? |
| [`queries/03_sales_by_store.sql`](./queries/03_sales_by_store.sql) | How do the physical stores compare? |
| [`queries/04_customers_by_tier.sql`](./queries/04_customers_by_tier.sql) | How is the customer base split across loyalty tiers? |

## Key findings

*(Fill in after you run the queries — e.g. "Women's clothing is the largest
category with N products" / "Tallinn accounts for the most sales".)*

## Reflection

- What was hardest about writing my first SQL queries?
- *(your notes)*
