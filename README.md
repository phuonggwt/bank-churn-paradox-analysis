# 🏦 Banking Customer Churn: Behavioral Paradox Analysis
> **An end-to-end data analytics project using SQL and R to uncover the hidden drivers of customer attrition.**
---

### 💵 Project Overview
This project aims to identify the key drivers of customer churn in retail banking and propose actionable strategies to improve customer retention.

Rather than focusing solely on descriptive analytics, the analysis adopts a behavioral perspective, uncovering hidden patterns and paradoxes in customer behavior that challenge traditional assumptions about loyalty.

Business Objective: Reduce customer churn rate by identifying high-risk segments and designing targeted retention strategies within a 6-month horizon.

### 🎯 Problem Statement
Customer churn is a critical issue in retail banking, directly impacting revenue and customer lifetime value.

Traditional assumptions such as: Long tenure = high loyalty, high-value customers = stable retention are tested and challenged using data-driven analysis.

### 🗂️ Dataset
### Source: Kaggle – Bank Customer Churn Dataset
### Size: 10,000 customers
Features include:
* Demographics (age, gender, geography)
* Financial data (balance, credit score)
* Behavioral data (activity status, tenure, product usage)

### 🛠️ Tech Stack
* **Data Warehouse:** Google BigQuery (SQL)
* **Analytics & Viz:** R (Tidyverse, ggplot2) & Tableau
* **Insights Framework:** Behavioral Paradox Discovery
---
### 🖥️ Executive Dashboard Summary
<table style="width: 100%; border-collapse: collapse;">
  <tr>
    <td colspan="2" align="center">
      <b>Interactive Dashboard Overview</b><br>
      <img src="https://raw.githubusercontent.com/phuonggwt/bank-churn-paradox-analysis/main/visualizations:/Dashboard%204.png" width="100%">
    </td>
<tr>
    <td colspan="2" align="center">
      <br>
      <b>📥 Download Interactive Workbook</b><br>
      To explore the full interactivity, click the button below:<br><br>
      <a href="https://github.com/phuonggwt/bank-churn-paradox-analysis/blob/main/visualizations:/Bank%20Churn%20Dashboard.twbx?raw=true">
        <img src="https://img.shields.io/badge/Download-Tableau%20Workbook-blue?style=for-the-badge&logo=tableau" alt="Download">
      </a>
      <br><br>
    </td>
  </tr>
  <tr>
    <td align="center"><b>Market Variance</b><br><img src="https://raw.githubusercontent.com/phuonggwt/bank-churn-paradox-analysis/main/visualizations:/market_variance_germany.png" width="100%"></td>
    <td align="center"><b>The Risk Matrix</b><br><img src="https://raw.githubusercontent.com/phuonggwt/bank-churn-paradox-analysis/main/visualizations:/vulnerability_matrix_heatmap.png" width="100%"></td>
  </tr>
  <tr>
    <td align="center"><b>Loyalty Slumber</b><br><img src="https://raw.githubusercontent.com/phuonggwt/bank-churn-paradox-analysis/main/visualizations:/activity_gap_dumbbell.png" width="100%"></td>
    <td align="center"><b>The Credit Trap</b><br><img src="https://raw.githubusercontent.com/phuonggwt/bank-churn-paradox-analysis/main/visualizations:/credit_anchor_lollipop.png" width="100%"></td>
  </tr>
  <tr>
    <td align="center"><b>Product Overload Cliff</b><br><img src="https://raw.githubusercontent.com/phuonggwt/bank-churn-paradox-analysis/main/visualizations:/product_cliff_paradox.png" width="100%"></td>
    <td align="center"><b>The Attrition Journey</b><br><img src="https://raw.githubusercontent.com/phuonggwt/bank-churn-paradox-analysis/main/visualizations:/leaky_bucket_waterfall.png?v=1" width="100%"></td>
  </tr>
</table>
---

### 🔍 The 4 Strategic Paradoxes

#### **1. The Loyalty Slumber (Tenure vs. Activity)**
**Insight:** Tenure is not a shield. Long-term "Veteran" customers (>7 years) who become inactive carry a high churn risk, even though they maintain balances higher than the global average **Activity status outweighs tenure.**

#### **2. The German Market Anomaly (Credit Score Irrelevance)**
**Insight:** Data reveals that credit scores have almost zero impact on customer retention. Instead, the entire German market exhibits an abnormally high churn rate (~30-35%) across all credit tiers—nearly double that of France and Spain. The root cause is regional market dynamics, not individual credit profiles.

 #### **3. The Wealth Accumulator Leak (Female Retention)** 
 **Insight:** Women over 50, categorized as "Wealth Accumulators," show a staggering churn rate of **63.78%**. This segment feels underserved by traditional digital-only banking models.
 
#### **4. The Product Overload Cliff**
**Insight:** Churn explodes from 7.5% to over 82% once a customer holds more than 2 products. Aggressive cross-selling is currently backfiring.

---

### 💡 Strategic Recommendations
1. Systemic Market Review & Localized Strategy (Germany): Since churn in Germany spans all credit and wealth tiers, credit-based VIP programs will be ineffective. Instead, conduct an immediate competitive analysis of the German retail banking landscape to identify systemic friction points: Are local competitors offering better fee structures, higher interest rates, or a more localized digital banking experience?

2. **Automated Re-activation Triggers:** Pivot loyalty rewards from "Tenure-based" to "Activity-based." Launch automated **"Welcome Back"** incentives immediately after 3 months of inactivity to wake up "Sleeping Giants."
  
3. **Human-Centric Retention for Senior Segments:** Assign dedicated **Relationship Managers** for high-balance female clients (>50 years). Focus on personalized retirement funds and health-insurance bundles instead of generic app notifications.
  
4. **Optimize Product-Mix KPI:** Move away from blind cross-selling. Train sales teams on the **"Golden Ratio" of 2 products** to ensure customer stability and prevent "Product Overload."

---

### 📂 Repository Structure
* `data/`: Raw dataset and source links.
* `sql_queries/`: BigQuery scripts for cleaning & feature engineering.
* `r_scripts/`: R scripts for visualizations.
* `visualizations/`: Exported analytical charts.
