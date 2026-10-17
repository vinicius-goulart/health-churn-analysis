# 🏥 Health Plan Churn Analysis

> **Business question:** What drives subscriber churn in health plan services — and what can retention teams do about it?

![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=flat&logo=postgresql&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=flat&logo=pandas&logoColor=white)
![scikit-learn](https://img.shields.io/badge/scikit--learn-F7931E?style=flat&logo=scikit-learn&logoColor=white)
![Plotly](https://img.shields.io/badge/Plotly-3F4F75?style=flat&logo=plotly&logoColor=white)

---

## 📌 Overview

Subscriber churn is one of the highest-cost problems in healthtech services. Acquiring a new client costs 5–7× more than retaining an existing one. This project uses a real-world churn dataset to:

1. **Identify which subscriber segments are most at risk** (EDA + segmentation)
2. **Quantify the behavioral and contractual signals that precede cancellation** (SQL cohort analysis)
3. **Build a classification model that flags high-risk subscribers before they leave** (ML)

The analytical stack mirrors production work at healthtech companies: SQL for cohort logic, Python for modeling, and visual storytelling throughout.

---

## 📂 Project Structure

```
health-churn-analysis/
│
├── README.md                  ← You are here
│
├── data/
│   └── subscribers.csv        ← Public dataset (Telco Churn, reframed as health plan)
│
├── notebooks/
│   ├── 01_eda.ipynb           ← Distributions, null analysis, churn by segment
│   ├── 02_viz.ipynb           ← Interactive Plotly storytelling for stakeholders
│   └── 03_model.ipynb         ← Logistic Regression + Random Forest, ROC-AUC, SHAP
│
└── sql/
    ├── 01_churn_rate_by_cohort.sql   ← Churn rate by tenure cohort
    ├── 02_retention_by_plan_type.sql ← Churn / retention rate by contract type
    └── 03_high_risk_segments.sql     ← Window functions to rank at-risk segments
```

---

## 🔑 Key Findings

> *Interactive charts live in `notebooks/02_viz.ipynb` ([view on nbviewer](https://nbviewer.org/github/vinicius-goulart/health-churn-analysis/blob/master/notebooks/02_viz.ipynb) — GitHub doesn't render Plotly); model diagnostics (ROC, SHAP) in `notebooks/03_model.ipynb`.*

| Finding | Detail |
|---|---|
| **Contract type is the #1 driver** | Month-to-month churns **42.7%** vs **2.8%** for two-year contracts — a ~15× gap. The single highest-leverage retention lever. |
| **The first 6 months are critical** | ~**42% of all churn** happens within the first 6 months; subscribers in their first 3 months churn at **56%**. Onboarding is decisive. |
| **Missing protection add-ons flag risk** | Subscribers without `OnlineSecurity` / `TechSupport` / etc. churn at ~**40%** vs ~**15–22%** for those who have them. |
| **Highest-risk segment** | Month-to-month + electronic check + fiber optic = **60.4% churn** (1,307 subscribers) — the "less-committed" profile. |
| **Model ROC-AUC** | **0.833** (Logistic Regression) vs 0.500 baseline, catching **78%** of churners (recall) at the default 0.5 threshold. |

---

## 🛠️ How to Run

### 1. Clone the repo

```bash
git clone https://github.com/vinicius-goulart/health-churn-analysis.git
cd health-churn-analysis
```

### 2. Install dependencies

```bash
uv sync
```

### 3. Run notebooks in order

```bash
uv run jupyter notebook
```

Open and run: `01_eda.ipynb` → `02_viz.ipynb` → `03_model.ipynb`

### 4. SQL queries

Queries in `sql/` are PostgreSQL-style and run as-is on DuckDB (installed by `uv sync`). To run one against the CSV:

```bash
uv run python -c "import duckdb; duckdb.sql(\"CREATE TABLE subscribers AS FROM 'data/subscribers.csv'\"); duckdb.sql(open('sql/01_churn_rate_by_cohort.sql').read()).show()"
```

> On PostgreSQL, load the CSV with lowercase column names — unquoted identifiers like `Contract` are folded to `contract`.

---

## 📊 Dataset

**Source:** [Telco Customer Churn — IBM Sample Data](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)

The dataset contains ~7,000 subscribers with features including:
- Contract type (month-to-month, one year, two year)
- Tenure (months as a subscriber)
- Monthly charges and total charges
- Service usage features
- Churn label (Yes/No)

> **Framing:** The analysis keeps the original Telco column names (`Contract`, `tenure`, `MonthlyCharges`, …) but interprets them through a health-plan lens — e.g., `Contract` as plan type, `tenure` as months as a subscriber — to make the business narrative relevant to healthtech contexts.

---

## 🧰 Tech Stack

| Layer | Tools |
|---|---|
| Data wrangling | Python, Pandas, NumPy |
| SQL analytics | PostgreSQL / DuckDB |
| Visualization | Seaborn, Plotly |
| ML modeling | scikit-learn (LogisticRegression, RandomForestClassifier) |
| Explainability | SHAP |
| Notebooks | Jupyter |

---

## 🎯 Business Recommendations

Based on the analysis:

1. **Prioritize onboarding for month-to-month subscribers** — ~42% of all churn happens in the first 6 months (56% churn in the first 3). A structured 30/60/90-day check-in cadence targets the window where most cancellations originate.

2. **Incentivize longer contracts** — two-year contracts churn at 2.8% vs 42.7% for month-to-month. A discount or added benefit at the 3-month mark targets the highest-risk window before it cancels.

3. **Deploy the churn model as a weekly scoring job** — at a >60% probability threshold the model flags ~480 subscribers and catches **71% of churners** (55% of those flagged truly churn) for proactive CS outreach. The threshold is a budget dial: lower it to catch more churners at the cost of more false alarms.

---

## 👤 Author

**Vinícius Goulart Nardelli**  
Data Analyst · São Paulo, BR  
[LinkedIn](https://www.linkedin.com/in/vinicius-goulart-nardelli/) · [GitHub](https://github.com/vinicius-goulart)

---

*This project is part of my data analytics portfolio. All data is public and used for educational purposes.*
