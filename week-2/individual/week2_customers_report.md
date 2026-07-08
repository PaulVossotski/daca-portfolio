# Week 2 — Customer Data Quality Report (Role B)

**Domain:** Customers
**Table:** `customers`
**Author:** Paul Võssotski
**Scope:** Data-quality **analysis** (detection & assessment). No rows were
modified — this report identifies the issues; running the actual `UPDATE` /
`DELETE` cleaning is the next step.

---

## Summary

<!-- TODO: 1–2 sentences on the overall state of the customer data — how clean or messy it is. -->

## Findings

<!-- TODO: replace the dots with your real numbers. Numbers talk — write "412", not "many". -->

| Issue | Count found |
|-------|------------:|
| Duplicate emails (same email, >1 row) | ... |
| Duplicate phones | ... |
| Missing first_name | ... |
| Missing email | ... |
| Missing phone | ... |
| Distinct city spellings | ... |
| Cities with more than one spelling | ... |

## What I found

1. **Duplicates** — detected by `email` (`GROUP BY email HAVING COUNT(*) > 1`)
   and by `phone`; used `ROW_NUMBER() OVER (PARTITION BY email)` to flag the
   extra copies (rn > 1). <!-- add how many you found -->
2. **NULL / missing values** — one overview query counting present vs. missing
   `first_name`, `email`, `phone`. <!-- add the counts -->
3. **Format inconsistencies** — compared `TRIM` / `UPPER` / `INITCAP` on `city`;
   the `original_spellings` count shows how many messy variants map to the same
   real city. <!-- add the worst offenders, e.g. Tallinn had N spellings -->

## Biggest surprise

<!-- TODO: 1–2 sentences. -->

## Recommendation to Toomas

<!-- TODO: 1–2 sentences — which issue is most urgent, and the next step (run the cleaning). -->
