"""
UrbanStyle — Tallinn Store Dashboard (Week 6, Role A)
Track B: Plotly + Streamlit. Display language: Estonian.
Run:  streamlit run app.py   (reads tallinn_sales.csv next to this file)
"""

import streamlit as st
import pandas as pd
import plotly.express as px

TEAL = "#009B8D"

EE_MONTHS = {
    1: "jaanuar", 2: "veebruar", 3: "märts", 4: "aprill",
    5: "mai", 6: "juuni", 7: "juuli", 8: "august",
    9: "september", 10: "oktoober", 11: "november", 12: "detsember",
}

st.set_page_config(page_title="UrbanStyle — Tallinna kauplus", layout="wide")

# ---------- Load data ----------
try:
    df = pd.read_csv("tallinn_sales.csv")
except FileNotFoundError:
    st.error("tallinn_sales.csv puudub. Pane see app.py kõrvale.")
    st.stop()

df["sale_date"] = pd.to_datetime(df["sale_date"])
df["loyalty_tier"] = df["loyalty_tier"].fillna("guest").replace("null", "guest")

# Estonian loyalty labels
tier_ee = {"gold": "Kuld", "silver": "Hõbe", "bronze": "Pronks", "guest": "Külaline"}
df["loyalty_tier"] = df["loyalty_tier"].map(tier_ee).fillna(df["loyalty_tier"])

# Trim the sparse tail so a few stray later sales don't stretch the trend chart
counts = df.set_index("sale_date").resample("MS")["sale_id"].count()
active = counts[counts >= 10].index
if len(active):
    df = df[df["sale_date"] <= active.max() + pd.offsets.MonthEnd(0)]

# ---------- Sidebar filter ----------
st.sidebar.header("Filtrid")
categories = sorted(df["category"].dropna().unique())
picked = st.sidebar.multiselect("Kategooria", categories, default=categories)
df = df[df["category"].isin(picked)]

if df.empty:
    st.warning("Valitud filtritega andmed puuduvad.")
    st.stop()

# ---------- Header ----------
st.title("UrbanStyle — Tallinna kaupluse ülevaade")
st.caption("Tallinn on UrbanStyle'i lipulaev ja suurim kauplus — tugevused ja kasvuvõimalused ühe pilguga.")

# ---------- KPIs ----------
total_revenue = df["total_price"].sum()
total_orders = df["sale_id"].nunique()
avg_order = df.groupby("sale_id")["total_price"].sum().mean()
unique_customers = df["customer_id"].nunique()

c1, c2, c3, c4 = st.columns(4)
c1.metric("Kogukäive", f"€{total_revenue:,.0f}")
c2.metric("Tellimused", f"{total_orders:,}")
c3.metric("Keskmine tellimus", f"€{avg_order:,.2f}")
c4.metric("Unikaalseid kliente", f"{unique_customers:,}")

# ---------- Chart 1: Monthly revenue trend ----------
monthly = df.set_index("sale_date").resample("MS")["total_price"].sum().reset_index()
monthly.columns = ["month", "revenue"]
avg_month = monthly["revenue"].mean()
peak = monthly.loc[monthly["revenue"].idxmax()]
peak_label = f"{EE_MONTHS[peak['month'].month]} {peak['month'].year}"

fig1 = px.line(monthly, x="month", y="revenue", markers=True,
               title="Kuukäibe trend", color_discrete_sequence=[TEAL])
fig1.add_hline(y=avg_month, line_dash="dash", line_color="gray",
               annotation_text=f"Keskmine kuu: €{avg_month:,.0f}", annotation_position="top left")
fig1.add_annotation(x=peak["month"], y=peak["revenue"],
                    text=f"Tipp: €{peak['revenue']:,.0f}", showarrow=True, arrowhead=2, bgcolor="white")
fig1.update_layout(yaxis_title="Käive (€)", xaxis_title="")
st.plotly_chart(fig1, width="stretch")

# ---------- Charts 2 & 3 ----------
col_a, col_b = st.columns(2)

top5 = df.groupby("product_name")["total_price"].sum().sort_values(ascending=False).head(5).reset_index()
top5.columns = ["product_name", "revenue"]
fig2 = px.bar(top5, x="revenue", y="product_name", orientation="h",
              title="TOP 5 toodet käibe järgi", color_discrete_sequence=[TEAL])
fig2.update_layout(yaxis=dict(autorange="reversed"), xaxis_title="Käive (€)", yaxis_title="")
best = top5.iloc[0]
fig2.add_annotation(x=best["revenue"], y=best["product_name"],
                    text="Enimmüüdud", showarrow=True, arrowhead=2, bgcolor="white")
col_a.plotly_chart(fig2, width="stretch")

seg = df.groupby("loyalty_tier")["total_price"].sum().reset_index()
seg.columns = ["loyalty_tier", "revenue"]
fig3 = px.pie(seg, names="loyalty_tier", values="revenue",
              title="Käive kliendi lojaalsustaseme järgi", hole=0.4,
              color_discrete_sequence=px.colors.sequential.Teal)
col_b.plotly_chart(fig3, width="stretch")

# ---------- Executive summary ----------
st.subheader("Juhtkonna kokkuvõte")
st.markdown(f"""
- **Tallinna kogukäive: €{total_revenue:,.0f}** {total_orders:,} tellimuse peale — suurim kõigist UrbanStyle'i kauplustest.
- **Tippkuu ulatus €{peak['revenue']:,.0f}-ni** ({peak_label}), tublisti üle keskmise (€{avg_month:,.0f}).
- **Enimmüüdud toode on "{best['product_name']}"**, tuues üksi sisse €{best['revenue']:,.0f}.
- **Keskmine tellimus on €{avg_order:,.2f}**, {unique_customers:,} unikaalselt kliendilt.
""")

# ---------- Data story ----------
st.subheader("Andmelugu")
st.markdown(f"""
Tallinn on UrbanStyle'i suurim kauplus ja annab tempo kogu ettevõttele.
Kogukäive on **€{total_revenue:,.0f}**, tipnedes **€{peak['revenue']:,.0f}** kuul **{peak_label}** —
selgelt üle keskmise, mis viitab hooaja- või kampaaniaefektile. **Soovitus:** uuri, mis vedas
tippkuud ja enimmüüdud toodet, ning kanna see mudel üle Tartusse ja väiksematesse kauplustesse.
""")
