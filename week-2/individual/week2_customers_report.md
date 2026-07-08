# Week 2 — Customer Data Quality Report (Role B)

**Domain:** Customers
**Table:** `customers`
**Author:** Paul Võssotski
**Scope:** Data-quality **analysis** (detection & assessment). No rows were
modified — this report identifies the issues; running the actual `UPDATE` /
`DELETE` cleaning is the next step.

---

## Summary

A data-quality analysis of UrbanStyle's customer table surfaced three issues worth attention before the board meeting. Contact data is incomplete — 380 customers have no email on file — and there is meaningful duplication: 130 rows reuse an email that already exists, and 150 share a phone number. City names are also inconsistent, with 54 distinct spellings covering far fewer real cities. First names and phone numbers, by contrast, are fully populated. The data is usable, but these issues would distort any customer count, location report, or email campaign until cleaned.

## Findings



| Issue | Count found |
|-------|------------:|
| Duplicate emails (same email, >1 row) | 130 |
| Duplicate phones | 150 |
| Missing first_name | 0 |
| Missing email | 380 |
| Missing phone | 0 |
| Distinct city spellings | 54 |
| Cities with more than one spelling | 12 |

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

The scale of missing emails: 380 customers have none at all, while phone numbers and first names are 100% complete. That imbalance suggests email was collected inconsistently at signup — a process problem, not just a data problem — and it directly limits how many customers UrbanStyle can actually reach by email.

## Recommendation to Toomas

Priority one is de-duplication before the board numbers are pulled: 130 duplicate emails and 150 duplicate phones inflate the real customer count, so the headline figure is currently overstated. Second, standardize city names (INITCAP(TRIM(city))) — 12 cities are recorded under more than one spelling, which quietly breaks any regional breakdown. The 380 missing emails need a business decision (chase them, or exclude from email campaigns) rather than a quick fix, and are worth flagging to Kristi as a marketing-reach limitation. None of these block the meeting, but the duplicates should be resolved before any customer totals are presented.
