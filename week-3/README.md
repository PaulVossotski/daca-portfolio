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

<!-- TODO: add your headline numbers, e.g. "N customers never bought; the
Tallinn × [category] segment leads revenue." -->

---

## Artifacts

| File | What it is |
|------|-----------|
| [`individual/week3_step0_apply_cleaning.sql`](./individual/week3_step0_apply_cleaning.sql) | Step 0 — apply Week 2 cleaning to the original tables (DELETE / UPDATE) |
| [`individual/week3_joins.sql`](./individual/week3_joins.sql) | INNER / LEFT / three-table joins answering Anna's questions |
| [`individual/week3_campaign_report.md`](./individual/week3_campaign_report.md) | Short report answering Anna's four campaign questions |

## Reflection

<!-- TODO: how is JOIN different from Excel VLOOKUP? What surprised you? -->
