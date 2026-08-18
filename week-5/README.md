# Week 5 — Visualization Design

**Status:** ✅ Done
**Topic:** Designing a clear, single-screen executive dashboard — choosing the
right chart per question and applying layout and data-ink principles.
**Track:** B (Python · Plotly + Streamlit).

---

## Why this exists

Kristi (CEO) needs a whole-company view she can put in front of an investor and
read in 30 seconds: *are we growing, and where does the money come from?* Week 5
is about the **design** that makes that possible. (Week 6 zooms into one store;
this is the company-wide picture.)

## The dashboard

A one-screen Streamlit dashboard on all UrbanStyle sales:

- **KPI cards** — total revenue, year-over-year growth, orders, average order value
- **Monthly revenue trend** (line) with an average reference line
- **Revenue by category** and **revenue by store** (horizontal bars)
- **Store filter** in the sidebar for drill-down

## Design decisions (the point of Week 5)

- **Chart type follows the question.** Trend over time -> line; comparing
  categories/stores -> horizontal bar (not a pie — pies fail with 5+ slices);
  single headline numbers -> KPI cards.
- **A metric with context.** The headline isn't just revenue — it's YoY growth %,
  because a number without a comparison tells an investor nothing.
- **Visual hierarchy / F-pattern.** KPIs sit top-left, the main trend chart takes
  the largest central area, supporting bars below, filter in the sidebar.
- **One brand colour** (teal) across every chart — Gestalt similarity, so the eye
  reads it as one coherent dashboard, not a rainbow.
- **High data-ink ratio.** No 3D, no gridline clutter, every chart has a title
  that says what it shows (Tufte: every pixel should carry information).

## What it shows

Company revenue totals **€2.9M** and grew **+19.1% (2024 vs 2023)** — the headline
number for an investor. Footwear is the largest category; **the online store
(Veebipood) is the second-biggest "location" by revenue**, almost level with the
flagship Tallinn store — a strong signal for where growth is coming from.

## Results

An investor-ready one-screen view: the growth number is the first thing you see,
the trend confirms the direction, and the bars answer "where from?" — replacing a
pile of spreadsheets with a 30-second read.

---

## How to run

\`\`\`bash
cd week-5
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
streamlit run app.py
\`\`\`

\`company_sales.csv\` must sit next to \`app.py\`. Export it from Supabase:

\`\`\`sql
SELECT
    s.sale_id, s.sale_date, s.total_price, s.quantity,
    s.store_location, s.channel,
    p.category
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY s.sale_date;
\`\`\`

## Artifacts

| File | What it is |
|------|-----------|
| \`app.py\` | Company executive dashboard (Streamlit + Plotly) |
| \`requirements.txt\` | Python dependencies |
| \`company_sales.csv\` | Company sales export from Supabase |
| \`dashboard_screenshot.png\` | Hero screenshot of the dashboard |

## Reflection

The single-colour rule changed the dashboard the most — once every chart used the
same teal, the whole screen read as one coherent report instead of competing
visuals, and the eye could focus on the numbers rather than decoding colours.
