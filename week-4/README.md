# Week 4 — SQL Aggregation

**Status:** ✅ Done
**Topic:** Turning individual rows into board-level summary numbers with
`GROUP BY`, aggregate functions, `HAVING`, CTEs, and window functions.

---

## Why this exists

Kristi (CEO) doesn't want raw transactions — she wants the numbers she can take
to the board: monthly trends, category performance, and how each customer segment
contributes. This week is about summarizing the cleaned data into those answers.

## What I did

Wrote aggregation queries on the UrbanStyle data covering the week's toolkit:

- **`GROUP BY` + aggregates** — monthly sales (orders, revenue, avg order value),
  sales by category, and revenue by loyalty tier
- **`WHERE` vs `HAVING`** — filtering rows before grouping vs. filtering groups
  after
- **CTE (`WITH`)** — month-over-month revenue change using `LAG`
- **Window function** — `RANK` of top products within each category

**Tool:** SQL (PostgreSQL / Supabase).

## Key findings

Based on the main data period (Jan 2023 – Feb 2025; a handful of stray later rows
were ignored):

- **Strong seasonality.** December is the yearly peak — **Dec 2024 hit €170,623**
  (550 orders), the best month overall — and January always falls back
  (Jan 2025 dropped €71,206 after the peak). This is a holiday cycle, not a problem.
- **The business is growing year over year.** Most 2024 months beat their 2023
  counterparts (e.g. June €125.5k → €144.6k).
- **Footwear leads by category** — `jalanõusid` at **€774k**, followed by men's
  (€750k) and women's (€686k). Children's is the smallest at €306k.
- **Biggest hidden segment: non-members.** Customers with no loyalty tier
  (`null`) number **1,024 and drive €1.07M in revenue** — more than any paid
  tier. A loyalty programme is leaving money on the table.

## 🤖 AI usage

Used Claude to review my `WHERE`/`HAVING` example — the first version
(`HAVING COUNT(*) > 5`) passed every category and proved nothing, so I switched
to `HAVING AVG(retail_price) > 50`, which actually filters on an aggregate. I ran
every query and verified the numbers myself.

---

## Artifacts

| File | What it answers |
|------|-----------------|
| [`queries/week4_aggregation.sql`](./queries/week4_aggregation.sql) | Monthly/category/segment summaries, WHERE vs HAVING, CTE trend, product ranking |

## Reflection

The `WHERE` vs `HAVING` distinction finally clicked: `WHERE` filters rows before
grouping, so it can't see aggregates, while `HAVING` filters the groups after —
which is why "categories whose *average* price is above €50" has to be `HAVING`.
The CTE also made the month-over-month query readable: I could compute the monthly
totals once in a `WITH` block, then use `LAG` on top of it instead of nesting
everything into one confusing query.
