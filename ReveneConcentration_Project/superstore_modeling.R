#Load libraries
library(dplyr)
library(ggplot2)

#Load in the dataset
superstore <- read.csv("Superstore_Revenue.csv")

#First rows
head(superstore)

#Check structure
str(superstore)
summary(superstore)

#Summarize revenue by segment
segment_summary <- superstore %>% group_by(Segment) %>% summarize(
  TotalRevenue = sum(Sales),
  AvgRevenue = mean(Sales),
  NumCustomers = n()
) %>%
  mutate(
    RevenuePct = TotalRevenue / sum(TotalRevenue) * 100,
    CustomerPct = NumCustomers / sum(NumCustomers) * 100
  )
print(segment_summary)

# Sort customers by segment and revenue
superstore <- superstore %>%
  arrange(Segment, desc(Sales)) %>%
  group_by(Segment) %>%
  mutate(
    CumulativeRevenue = cumsum(Sales),
    CumulativeRevenuePct = CumulativeRevenue / sum(Sales) * 100
  )

# Summarize cumulative revenue by percentiles per segment
superstore_pct <- superstore %>%
  group_by(Segment) %>%
  mutate(Customer.ID = row_number(desc(Sales)),
         TotalCustomers = n(),
         CustomerPct = Customer.ID / TotalCustomers * 100) %>%
  select(Segment, CustomerPct, CumulativeRevenuePct)

# Plot
ggplot(superstore_pct, aes(x = CustomerPct, y = CumulativeRevenuePct, color = Segment)) +
  geom_line(size=1.2) +
  labs(title = "Cumulative Revenue by Segment",
       x = "% of Customers (sorted by revenue)",
       y = "Cumulative Revenue %",
       color = "Segment") +
  theme_minimal()

#Add "perfect equality" line
ggplot(superstore_pct, aes(x = CustomerPct, y = CumulativeRevenuePct, color = Segment)) +
  geom_line(size=1.2) +
  geom_abline(slope=1, intercept=0, linetype="dashed", color="grey") + # perfect equality line
  labs(title="Cumulative Revenue by Segment",
       x="% of Customers (sorted by revenue)",
       y="Cumulative Revenue %",
       color="Segment") +
  theme_minimal()

#Sum revenue per customer
customer_revenue <- superstore %>%
  group_by(Customer.ID, Segment) %>%
  summarize(TotalRevenue = sum(Sales), .groups = "drop")

#Scale revenue (standardizes for clustering)
customer_revenue <- customer_revenue %>%
  mutate(RevenueScaled = scale(TotalRevenue))

#Apply k-means clustering (3 clusters: low, mid, high)
set.seed(123) #reproducible
kmeans_result <- kmeans(customer_revenue$RevenueScaled, centers = 3)

#Add cluster labels to the dataset
customer_revenue$Cluster <- kmeans_result$cluster

#Check cluster distribution by segment
table(customer_revenue$Segment, customer_revenue$Cluster)

#Calculate average revenue per cluster
cluster_summary <- customer_revenue %>%
  group_by(Cluster) %>%
  summarize(AvgRevenue = mean(TotalRevenue), .groups = "drop") %>%
  arrange(AvgRevenue)
print(cluster_summary)

#Create new ordered cluster labels
cluster_order <- cluster_summary$Cluster

#Map old clusters to new "Low, Mid, High"
customer_revenue <- customer_revenue %>%
  mutate(ClusterLabel = case_when(
    Cluster == cluster_order[1] ~ "Low",
    Cluster == cluster_order[2] ~ "Mid",
    Cluster == cluster_order[3] ~ "High"
  ))

#Boxplot of revenue by cluster and segment
ggplot(customer_revenue, aes(x = ClusterLabel, y = TotalRevenue, fill = Segment)) +
  geom_boxplot() +
  labs(
    title = "Customer Revenue Clusters by Segment",
    x = "Customer Revenue Cluster",
    y = "Total Revenue",
    fill = "Segment"
  ) +
  theme_minimal()

#Interpretation of Results:
#
# 1. Segment Revenue Analysis:
#     - Total revenue is distributed roughly in proportion to the number of customers in each segment (Consumer, Corporate, Home Office).
#     - No single segment dominates revenue; growth strategies should consider all segments rather than focusing on only one.
#
# 2. Product Category Insights (from Excel pivot analysis):
#     - Technology category generates more revenue within each segment.
#     - Promotions or pricing adjustments should target this category to maximize revenue per segment.
#
# 3. Cumulative Revenue Curves:
#     - Curves show concave-down patterns starting at 0 and and increasing toward 100%.
#     - This shape indicates that the first customers added contribute less revenue than later ones, but overall revenue rises steadily. 
#     - Curves for each segment are very similar, showing revenue is fairly and evenly distributed across customers in all segments.
#     - Strategy implicaiton: focus on broad segment-level initiatives and category-level opportunities rathen than trying to target only a few high-value customers.
#
# 4. Customer Clusters
#     - Customers were grouped into Low, Mid, and High revenue clusters using k-means.
#     - Cluster sizes show:
#       - Majority of customers fall in Mid revenue cluster.
#       - High revenue cluster is smaller but represents the top contributors.
#       - Low revenue cluster is very small.
#     - Strategic insights:
#       - High revenue customers: target with loyalty programs, premium offers.
#       - Mid revenue customers: upselling, cross-selling, targeted promotions.
#       - Low revenue customers: broad marketing campaigns, maintain engagement.
#     - Clustering confirms that revenue is spread fairly evenly, so growth strategy should focus on increasing revenue per customer across all segments, rather than relying on a few high-value customers. 