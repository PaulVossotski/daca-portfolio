# Week 3 — SQL JOINs

**Status:** ✅ Done
**Topic:** Connecting UrbanStyle's tables with `INNER JOIN`, `LEFT JOIN`, and
multi-table joins to answer real business questions.

---

## Why this exists

Anna (Marketing) is planning a campaign and needs answers the separate tables
can't give on their own: **Who are our top customers? Who registered but never
bought? What do people actually buy, and in which cities?** Answering these
means joining `sales`, `customers`, and `products` — the core skill of Week 3.

## What I did

First applied the Week 2 cleaning to the **original** tables (Step 0), then
wrote joins to answer Anna's four questions:

- **`INNER JOIN`** — customers with their purchases, best-selling products,
  top spenders, and unit profit per product
- **`LEFT JOIN` + `IS NULL`** — the "missing data" pattern: customers who never
  bought (wasted potential) and products that never sold (dead stock)
- **Three-table joins** — customer + sale + product in one view, plus revenue
  broken down by city × category to find the best campaign segment

**Tool:** SQL (PostgreSQL / Supabase).

## What it shows

The joins turn three disconnected tables into answers Anna can act on: a target
list of top customers, a win-back list of never-purchased customers by city, a
catalog cleanup list of unsold products, and the city/category segment with the
highest revenue.



---

## Artifacts

| File | What it is |
|------|-----------|
| [`individual/week3_step0_apply_cleaning.sql`](./individual/week3_step0_apply_cleaning.sql) | Step 0 — apply Week 2 cleaning to the original tables (DELETE / UPDATE) |
| [`individual/week3_joins.sql`](./individual/week3_joins.sql) | INNER / LEFT / three-table joins answering Anna's questions |


## Reflection

The clearest shift this week was seeing JOIN as a more powerful VLOOKUP. In Excel, VLOOKUP pulls one matching value into a row and quietly breaks or returns an error when there's no match. A SQL JOIN connects whole tables at once, and — more importantly — it lets me choose what happens to the non-matches: INNER JOIN drops them, LEFT JOIN keeps them and marks the gap as NULL.
The most useful surprise was the LEFT JOIN + WHERE ... IS NULL pattern. It felt backwards at first — deliberately looking for the missing side of a join — but it's exactly how you find the interesting negatives: customers who registered and never bought, and products that never sold. Those "empty" rows turned out to be the most actionable output of the whole week.
I also learned to sanity-check row counts. A JOIN can return more rows than the original table (when keys repeat) or fewer (when INNER JOIN silently drops unmatched rows), so I now check the count against what I expect instead of trusting the result blindly.
