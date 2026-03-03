# Revenue Concentration & Strategic Growth Optimization Analysis

## Project Overview
This project analyzes the **Superstore Sales dataset** to understand which customer segments and product categories generate the highest revenue concentration. The goal is to provide actionable insights for pricing and promotional strategies to maximize growth.  

The analysis uses **Excel** for data exploration and cleaning and **R** for modeling, visualization, and customer segmentation.

---

## Business Problem
Which customer segments and product categories generate the highest revenue concentration, and how should pricing or promotional strategy be adjusted to maximize growth?

---

## Data Description
The dataset was sourced from Kaggle and includes the following columns:

| Column Name       | Description |
|------------------|-------------|
| Row ID            | Unique row identifier |
| Order ID          | Unique order number |
| Order Date        | Date of order |
| Ship Date         | Date of shipment |
| Ship Mode         | Shipping method |
| Customer ID       | Unique customer identifier |
| Customer Name     | Customer full name |
| Segment           | Customer segment (Consumer, Corporate, Home Office) |
| Country           | Country of the customer |
| City              | Customer city |
| State             | Customer state |
| Postal Code       | Customer postal code |
| Region            | Sales region |
| Product ID        | Unique product identifier |
| Category          | Product category |
| Sub-Category      | Product sub-category |
| Product Name      | Name of product |
| Sales             | Revenue from each order |


---

## Methodology

### 1. Data Cleaning & Exploration (Excel)  
- Focused on key columns: `Customer ID`, `Segment`, `Category`, `Sub-Category`, `Sales`.  
- Calculated **total revenue per segment**, **customer counts**, and **average revenue per customer**.  
- Performed **Pareto analysis** to identify top revenue-generating customers.

### 2. Segment & Product Category Analysis (Excel Pivot Tables)
- Pivot tables used to summarize:
  - Revenue by customer  
  - Revenue by customer within segments  
  - Revenue by category within segments
- This identifies **which segments and product categories are driving growth**.

### 3. Customer-Level Revenue Analysis (R)
- Loaded cleaned data into R.  
- Calculated total and cumulative revenue per customer within each segment.  
- Plotted **cumulative revenue curves to visualize revenue distribution** across customers.  

### 4. Customer Clustering (R)
- Used **k-means clustering** to group customers into **Low, Mid, High revenue clusters**.  
- Relabeled clusters based on **actual average revenue** for interpretability.  
- Visualized clusters using a boxplot to understand distribution across segments.

---

## Key Insights

1. **Segment Revenue**
   - Revenue is roughly proportional to segment size: no segment dominates revenue.  
   - Growth strategies should focus on all segments, not just one.

2. **Product Categories**
   - Certain categories generate more revenue within each segment.  
   - Promotions and pricing adjustments should target these categories.

3. **Customer Revenue Distribution**
   - Cumulative revenue curves are **concave down**, showing fairly even revenue distribution.  
   - No extreme concentration: revenue is spread across many customers.  
   - Strategy: focus on broad segment and category-level initiatives.

4. **Customer Clusters**
   - Majority of customers fall into the **Mid revenue cluster**.  
   - High revenue cluster is smaller but represents the top contributors.  
   - Low revenue cluster is very small.  
   - Strategic recommendations:
     - **High revenue customers:** loyalty programs, premium offers  
     - **Mid revenue customers:** upselling, cross-selling, targeted promotions  
     - **Low revenue customers:** broad marketing campaigns, engagement initiatives  

---

## Tools & Libraries
- **Excel:** Pivot tables, data cleaning, Pareto analysis  
- **R Studio:**  
  - `dplyr` – data manipulation  
  - `ggplot2` – visualization  
  - `stats` – k-means clustering  

---

## Key Learnings
- How to properly utilize pivot tables in Excel to fit the desired evaluation.
- K-means clustering practice and adapation to relabeling clusters to create more visual clarity.
- More confidence in Excel and R Studio overall.

---

## How to Use
1. Open the cleaned dataset (unnecessary columns deleted): (`Superstore_Revenue.csv`).
2. Follow the R script (`superstore_modeling.R`) to reproduce:
   - Segment summaries
   - Cumulative revenue curves
   - Customer clustering and visuals
3. Use insights to design targeted pricing or promotional strategies.

---

## Conclusion
This analysis shows that revenue is **evenly distributed across segments and customers**, with certain product categories driving revenue within segments. Strategic growth initiatives should focus on **increasing revenue per customer across all segments** and **leveraging high-performing categories**, rather than targeting only a few high-value customers.

---
