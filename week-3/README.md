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

The joins turned three disconnected tables into answers Anna can act on. In my
Role C analysis this produced a concrete result: **12 products (3.3% of the
362-item catalog) have never sold**, and **5 of those 12 (~42%) are accessories**
— a category that also ranks near the bottom for revenue. That's a specific,
defensible catalog-cleanup list rather than a vague "some products underperform."

---

## Artifacts

| File | What it is |
|------|-----------|
| [`individual/week3_step0_apply_cleaning.sql`](./individual/week3_step0_apply_cleaning.sql) | Step 0 — apply Week 2 cleaning to the original tables (DELETE / UPDATE) |
| [`individual/week3_joins.sql`](./individual/week3_joins.sql) | INNER / LEFT / three-table joins answering Anna's questions |
| [`individual/week3_products_joins.sql`](./individual/week3_products_joins.sql) | **Group work · Role C** — products / dead-stock analysis |
| [`individual/week3_products_screenshot.png`](./individual/week3_products_screenshot.png) | Screenshot of the Role C query results |

---

## Group work — Role C: Dead stock (unsold products)

In this week's team analysis I took **Role C (Products)**: finding items that
have never sold, using the `LEFT JOIN + WHERE IS NULL` pattern.

**What I found**

Of UrbanStyle's **362-product catalog, 12 products have never sold — 3.3%**.
Nearly half (**5 of 12, ~42%**) are **accessories** (`aksessuaarid`), which
stands out as the weakest category for dead stock. The unsold items span a wide
price range (**€24.54–€368.67**) with a combined retail value of roughly
**€2,300**. For contrast, accessories also rank 4th of 5 categories by revenue —
so the category both sells weakly *and* accumulates dead stock.

**Recommendation to Anna & Toomas**

Focus the catalog review on accessories: 5 of the 12 unsold products sit there.
Discount these 12 items to clear them, drop the persistent non-movers from the
catalog, and pause reordering in the accessory subcategories that aren't moving.
At 3.3% of the catalog the problem is small but concentrated — fixing one
category solves most of it.

*Team's combined output:* https://github.com/kolgalys-max/urbanstyle-team-3/tree/main/week-3

## Reflection

The clearest shift this week was seeing JOIN as a more powerful VLOOKUP. In
Excel, VLOOKUP pulls one matching value into a row and quietly breaks or returns
an error when there's no match. A SQL JOIN connects whole tables at once, and —
more importantly — it lets me choose what happens to the non-matches: INNER JOIN
drops them, LEFT JOIN keeps them and marks the gap as NULL.

The most useful surprise was the `LEFT JOIN + WHERE ... IS NULL` pattern. It
felt backwards at first — deliberately looking for the missing side of a join —
but it's exactly how you find the interesting negatives: customers who
registered and never bought, and products that never sold. Those "empty" rows
turned out to be the most actionable output of the whole week.

I also learned to sanity-check row counts. A JOIN can return more rows than the
original table (when keys repeat) or fewer (when INNER JOIN silently drops
unmatched rows), so I now check the count against what I expect instead of
trusting the result blindly.
