# Week 2 — Customer Data Cleaning Report (Role B)

**Domain:** Customers
**Table:** `customers` (cleaned on a test copy first, then applied to original)
**Author:** Paul Võssotski

---

## Summary

<!-- TODO: 1–2 sentences on the overall state of the customer data and what you fixed. -->

## Before / After

<!-- TODO: replace the dots with your real numbers. Numbers talk — write "412", not "many". -->

| Metric | Before | After |
|--------|-------:|------:|
| Total rows | ... | ... |
| Duplicate emails | ... | 0 |
| Duplicate phones | ... | 0 |
| Missing email | ... | ... |
| Missing phone | ... | ... |
| Distinct city spellings | ... | ... |

## What I found and did

1. **Duplicates** — detected by `email` (`GROUP BY email HAVING COUNT(*) > 1`)
   and by `phone`; used `ROW_NUMBER() OVER (PARTITION BY email)` to flag the
   extra copies (rn > 1). <!-- add how many you found -->
2. **NULL / missing values** — one overview query counting present vs. missing
   `first_name`, `email`, `phone`. <!-- add the counts -->
3. **Format standardization** — cleaned `city` with `TRIM` + `INITCAP`; the
   "original_spellings" count shows how many messy variants collapsed per city.
   <!-- add the worst offenders, e.g. Tallinn had N spellings -->

## Biggest surprise

<!-- TODO: 1–2 sentences. -->

## Recommendation to Toomas

<!-- TODO: 1–2 sentences — priority and next step for the customers domain. -->
