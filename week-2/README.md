# Week 2 — SQL Data Cleaning

**Status:** ✅ Done
**Topic:** Cleaning UrbanStyle's messy database with SQL — duplicates, NULLs, and format standardization.
**My role this week:** **Role B — Customer data cleaning.**

---

## Why this exists

Toomas Kask (IT Director) found 847 duplicate orders and suspected the mess ran
deeper across the whole database. Before any real analysis, the data has to be
trustworthy. This week the team cleaned UrbanStyle's data domain by domain — my
part was the **customers** domain.

## What I did

This week's work was **data-quality analysis** — finding and measuring the
problems in the customers table with SELECT-based queries. No rows were changed
yet; the actual `UPDATE` / `DELETE` fix is the next step.

- Detected duplicate customer records by **email** and by **phone**
- Ran a NULL overview across `first_name`, `email`, and `phone` to size the gaps
- Tested city standardization with `TRIM` + `INITCAP`, and measured how many
  different original spellings map to each real city
- Documented every issue with concrete counts

**Tool:** SQL (PostgreSQL / Supabase).

## What it shows

<!-- TODO: one headline sentence with your real numbers, e.g.
"The customers table has N duplicate emails, M missing emails, and K different
spellings of the same cities — all quantified and ready to be cleaned." -->

Full before/after breakdown: [`individual/week2_customers_report.md`](./individual/week2_customers_report.md).

---

## Artifacts

| File | What it is |
|------|-----------|
| [`individual/week2_customers_cleaning.sql`](./individual/week2_customers_cleaning.sql) | My cleaning script for the customers domain (Role B): duplicate emails & phones, NULL overview, city standardization |
| [`individual/week2_cleaning_techniques.sql`](./individual/week2_cleaning_techniques.sql) | Cleaning techniques practiced on sales & products: dedup, date formatting, type casting, price validation, cross-table overview |
| [`individual/week2_customers_report.md`](./individual/week2_customers_report.md) | Before/after data-quality report |
| [`team/week2_team_cleaning_report.md`](./team/week2_team_cleaning_report.md) | Link to the team's combined cleaning report (all domains) |

## Reflection

<!-- TODO: what was hardest about cleaning real, messy data? -->

---

*This README describes only my own part (the customers domain). The team's full
combined work is linked in `team/`.*
