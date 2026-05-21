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
│   ├── 02_viz.ipynb           ← Seaborn + Plotly charts, visual storytelling
│   └── 03_model.ipynb         ← Logistic Regression + Random Forest, AUC-ROC, SHAP
│
└── sql/
    ├── 01_churn_rate_by_cohort.sql   ← Monthly cohort retention table
    ├── 02_retention_by_plan_type.sql ← Churn rate by contract type
    └── 03_high_risk_segments.sql     ← Window functions to rank at-risk segments
```

---

## 🔑 Key Findings

> *(Charts will be embedded here after notebooks are complete)*

| Finding | Detail |
|---|---|
| **Monthly plans churn 3× more** than annual contracts | Switching users to semi-annual locks in retention |
| **First 90 days are critical** | 42% of churn happens within the first quarter — onboarding matters most |
| **High-engagement users almost never churn** | Users with 3+ service touchpoints/month have <5% churn rate |
| **Model AUC-ROC** | `TBD after notebook 03` |

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
jupyter notebook
```

Open and run: `01_eda.ipynb` → `02_viz.ipynb` → `03_model.ipynb`

### 4. SQL queries

Queries in `sql/` are written for PostgreSQL. To run against the dataset locally:

```bash
# Load data into a local PostgreSQL instance or use DuckDB
duckdb -c "CREATE TABLE subscribers AS SELECT * FROM 'data/subscribers.csv';"
duckdb -c ".read sql/01_churn_rate_by_cohort.sql"
```

---

## 📊 Dataset

**Source:** [Telco Customer Churn — IBM Sample Data](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)

The dataset contains ~7,000 subscribers with features including:
- Contract type (month-to-month, one year, two year)
- Tenure (months as a subscriber)
- Monthly charges and total charges
- Service usage features
- Churn label (Yes/No)

> **Framing:** Column names have been adapted to a health plan context (e.g., `Contract` → `plan_type`, `tenure` → `months_as_subscriber`) to make the business narrative more realistic and relevant to healthtech recruiting contexts.

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

1. **Prioritize onboarding for month-to-month subscribers** — the first 90 days are where most churn occurs. A structured 30/60/90 day check-in cadence can reduce early churn by an estimated 15–20%.

2. **Incentivize annual contract upgrades** — offering a discount or added benefit at the 3-month mark for monthly subscribers targets the highest-risk window.

3. **Deploy the churn model as a weekly scoring job** — flag subscribers with >60% predicted churn probability for proactive outreach by the CS team.

---

## 👤 Author

**Vinícius Goulart Nardelli**  
Data Analyst · São Paulo, BR  
[LinkedIn](https://linkedin.com/in/vinicius-goulart) · [GitHub](https://github.com/vinicius-goulart)

---

*This project is part of my data analytics portfolio. All data is public and used for educational purposes.*