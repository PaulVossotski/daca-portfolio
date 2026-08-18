# Week 6 — Data Storytelling

**Status:** ✅ Done
**Topic:** Turning a dashboard into a persuasive narrative — annotations, a
reference line, an executive summary, and a data story.
**My role this week:** Role A — Tallinn Store Story.
**Track:** B (Python · Plotly + Streamlit).

---

## Why this exists

Anna's warning this week: investors don't buy numbers, they buy stories. A
dashboard is finished not when the charts are pretty, but when it persuades
someone to act. My job (Role A) was the Tallinn store — the flagship — turned
into a 30-second story Kristi can take to an investor.

## What I did

Built an interactive Tallinn dashboard (filtered to store_location = 'Tallinn')
and wrapped it in narrative:

- **KPI cards** — revenue, orders, average order value, unique customers
- **Monthly trend** (line) with a reference line at the average month and an
  annotation on the December peak
- **Top 5 products** (bar) with an annotation on the best seller
- **Revenue by loyalty tier** (donut)
- An executive summary and a data story, each passing the "So what?" test

**Tools:** Python · pandas · Plotly · Streamlit.

## What it shows

Tallinn is healthy and highly seasonal: revenue peaks at €58,977 in December 2024
(well above the ~€37,835 average month), a few hero products carry the store, and
40% of revenue comes from guests with no loyalty tier — a large, currently
anonymous base to convert.

---

## Artifacts

| File | What it is |
|------|-----------|
| individual/week6_executive_summary.md | Executive summary — "So what?"-tested conclusions |
| individual/week6_tallinn_narrative.md | Data story (setup, data, recommendation) |
| individual/week6_dashboard_top.png | Dashboard — KPIs, trend, top products, loyalty |
| individual/week6_dashboard_bottom.png | Dashboard — executive summary & data story |
| app.py, tallinn_sales.csv, requirements.txt | The dashboard itself (reproducible) |

## AI usage

Used Claude to generate the Plotly annotation and add_hline reference-line code
and to pressure-test my executive summary against the "So what?" rule; the main
message and the numbers are my own, verified against the data.

## Reflection

Before this week I thought a dashboard was finished once the charts were built
and the numbers were correct. Now I see it's only finished when it makes a point
— when someone reading it knows what happened and what to do next. Adding the
annotation on the December peak and the "So what?" summary changed a wall of
charts into an actual recommendation.
