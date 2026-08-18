"""
UrbanStyle — Company Executive Dashboard (Week 5, Viz Design)
Track B: Plotly + Streamlit. Display language: Estonian.
Run:  streamlit run app.py   (reads company_sales.csv next to this file)
"""

import streamlit as st
import pandas as pd
import plotly.express as px

TEAL = "#009B8D"

st.set_page_config(page_title="UrbanStyle — Ettevõtte ülevaade", layout="wide")

try:
    df = pd.read_csv("company_sales.csv")
except FileNotFoundError:
    st.error("company_sales.csv puudub. Pane see app.py kõrvale.")
    st.stop()

df["sale_date"] = pd.to_datetime(df["sale_date"])

counts = df.set_index("sale_date").resample("MS")["sale_id"].count()
active = counts[counts >= 50].index
if len(active):
    df = df[df["sale_date"] <= active.max() + pd.offsets.MonthEnd(0)]

st.sidebar.header("Filtrid")
df["store_location"] = df["store_location"].fillna("Veebipood")
stores = sorted(df["store_location"].unique())
picked = st.sidebar.multiselect("Kauplus", stores, default=stores)
df = df[df["store_location"].isin(picked)]

if df.empty:
    st.warning("Valitud filtritega andmed puuduvad.")
    st.stop()

st.title("UrbanStyle — Ettevõtte müügiülevaade")
st.caption("Kogu ettevõtte tulemused ühel ekraanil — investorikohtumiseks.")

def yoy_growth(d):
    yr = d.groupby(d["sale_date"].dt.year).agg(
        rev=("total_price", "sum"),
        months=("sale_date", lambda s: s.dt.to_period("M").nunique()),
    )
    full = yr[yr["months"] >= 10]
    if len(full) >= 2:
        latest, prev = full["rev"].iloc[-1], full["rev"].iloc[-2]
        return (latest / prev - 1) * 100, int(full.index[-1]), int(full.index[-2])
    return None, None, None

total_revenue = df["total_price"].sum()
total_orders = df["sale_id"].nunique()
avg_order = df.groupby("sale_id")["total_price"].sum().mean()
yoy, y_new, y_old = yoy_growth(df)

c1, c2, c3, c4 = st.columns(4)
c1.metric("Kogukäive", f"€{total_revenue:,.0f}")
if yoy is not None:
    c2.metric(f"Kasv {y_new} vs {y_old}", f"{yoy:+.1f}%", delta=f"{yoy:+.1f}%")
else:
    c2.metric("Kasv (YoY)", "—")
c3.metric("Tellimused", f"{total_orders:,}")
c4.metric("Keskmine tellimus", f"€{avg_order:,.2f}")

monthly = df.set_index("sale_date").resample("MS")["total_price"].sum().reset_index()
monthly.columns = ["month", "revenue"]
avg_month = monthly["revenue"].mean()

fig = px.line(monthly, x="month", y="revenue", markers=True,
              title="Kuukäibe trend", color_discrete_sequence=[TEAL])
fig.add_hline(y=avg_month, line_dash="dash", line_color="gray",
              annotation_text=f"Keskmine kuu: €{avg_month:,.0f}",
              annotation_position="top left")
fig.update_layout(yaxis_title="Käive (€)", xaxis_title="")
st.plotly_chart(fig, width="stretch")

col_a, col_b = st.columns(2)

cat = (df.groupby("category")["total_price"].sum()
         .sort_values(ascending=False).reset_index())
cat.columns = ["category", "revenue"]
fig_cat = px.bar(cat, x="revenue", y="category", orientation="h",
                 title="Käive kategooria järgi", color_discrete_sequence=[TEAL])
fig_cat.update_layout(yaxis=dict(autorange="reversed"),
                      xaxis_title="Käive (€)", yaxis_title="")
col_a.plotly_chart(fig_cat, width="stretch")

store = (df.groupby("store_location")["total_price"].sum()
           .sort_values(ascending=False).reset_index())
store.columns = ["store", "revenue"]
fig_store = px.bar(store, x="revenue", y="store", orientation="h",
                   title="Käive kaupluse järgi", color_discrete_sequence=[TEAL])
fig_store.update_layout(yaxis=dict(autorange="reversed"),
                        xaxis_title="Käive (€)", yaxis_title="")
col_b.plotly_chart(fig_store, width="stretch")
