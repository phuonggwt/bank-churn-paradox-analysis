# ==============================================================================
# PROJECT: BANK CHURN DATA ANALYSIS & STRATEGIC INSIGHTS
# AUTHOR: Nguyen Thu Phuong
# TOOLS: R (ggplot2, dplyr, tidyverse)
# OBJECTIVE: Visualizing customer attrition through behavioral paradoxes
#            to drive retention strategies.
# ==============================================================================
# SETUP & LIBRARIES
library(dplyr)      
library(ggplot2)   
library(scales)     
library(tidyr)
# ==============================================================================
# PART 1: GEOGRAPHIC ANALYSIS --------------------------------------------------
# 1. GGPLOT VISUALIZATION
# 1.1. Setup professional color palette
# Germany (Hotspot) gets a stronger color, others are muted
country_colors <- c(
  "Germany" = "#C688EB", 
  "France"  = "#FBA2D0", 
  "Spain"   = "#FFC4A4"  
)

# 1.2. Get the benchmark value
global_avg_line <- df_overall$overall_churn_rate

# 1.3. Plotting with ggplot2
library(ggplot2)

ggplot(df_geo, aes(x = reorder(country, -churn_rate_percentage), y = churn_rate_percentage, fill = country)) +
  # Draw bars with custom colors
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = country_colors) +
  
  # Add a refined benchmark line
  geom_hline(yintercept = global_avg_line, linetype = "dashed", color = "#6C7EE1", size = 0.7) +
  
  # Add elegant labels
  annotate("text", x = 2.8, y = global_avg_line + 1.5, 
           label = "Global Average", color = "#6C7EE1", fontface = "italic") +
  
  # English Labels for Report
  labs(
    title = "Market Variance: Germany as the Attrition Epicenter",
    subtitle = "Benchmarking regional churn rates against the 20.37% global average",
    x = "Country",
    y = "Churn Rate (%)"
  ) +
  
  # Professional Theme Styling
  theme_minimal(base_family = "Arial") + # Using clean Sans-serif font
  theme(
    plot.title = element_text(face = "bold", size = 18, color = "#1D3557"),
    plot.subtitle = element_text(size = 12, color = "grey40", margin = margin(b = 15)),
    axis.title = element_text(face = "bold", color = "#1D3557"),
    panel.grid.major.x = element_blank(), # Remove vertical grid lines for cleaner look
    panel.grid.minor = element_blank(),
    legend.position = "none" # Hide legend as X-axis already has country names
  )

# ==============================================================================
# PART 2: THE PROFESSIONAL RISK MATRIX 
# ==============================================================================

# 1. Load and Fix Data Ordering
df_part2 <- read.csv("part2_who_analysis.csv")

# Force the order of Age Segments so it makes sense logically
df_part2$age_segment <- factor(df_part2$age_segment, 
                               levels = c("Under 30", "30-50", "Over 50"))

# 2. Create the Heatmap
p2 <- ggplot(df_part2, aes(x = age_segment, y = financial_persona, fill = churn_rate_percentage)) +
  geom_tile(color = "white", size = 0.5) +
  
  # FIX 1: Smaller text inside tiles (size = 2.5)
  geom_text(aes(label = paste0(churn_rate_percentage, "%")), 
            color = ifelse(df_part2$churn_rate_percentage > 40, "white", "black"), 
            fontface = "bold", size = 2.8) +
  
  facet_wrap(~ Gender) +
  scale_fill_gradient(low = "#E1EAF2", high = "#C688EB") +
  
  labs(
    title = "The Vulnerability Matrix: Identifying High-Value Risk Zones",
    subtitle = "Mapping churn probability across demographic segments and financial personas",
    x = "Age Segment",
    y = "Financial Persona",
    fill = "Churn Rate (%)"
  ) +
  
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title = element_text(face = "bold", size = 16, color = "black"),
    strip.background = element_rect(fill = "#FFC4A4"),
    strip.text = element_text(color = "white", face = "bold", size = 10),
    
    # FIX 2: Rotate axis labels and shrink font size
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9), 
    axis.text.y = element_text(size = 9),
    
    panel.grid = element_blank(),
    legend.position = "right"
  ) 
# ==============================================================================
# --- PART 3:  ---
# ==============================================================================
# Part 3.1: LOYALTY SLUMBER (TENURE VS ACTIVITY)
# ==============================================================================

# 1. Prepare Data 
# Ensure logical order of Tenure Segments
df_paradox1 <- read.csv("paradox1_loyalty_slumber_analysis.csv") %>%
  mutate(tenure_segment = factor(tenure_segment, 
                                 levels = c("1. Newbie (0-2y)", "2. Standard (3-7y)", "3. Veteran (>7y)")))

# Prepare wide format data for the connecting segments
df_paradox1_wide <- df_paradox1 %>%
  pivot_wider(names_from = activity_status, values_from = churn_rate_percentage)

# 2. Create Visualization
p3<- ggplot(df_paradox1, aes(x = churn_rate_percentage, y = tenure_segment)) +
  
  # A. Draw the Connecting Segment (The Risk Gap)
  # Map y and yend to tenure_segment to create horizontal bars
  geom_segment(data = df_paradox1_wide, 
               aes(x = Active, xend = Inactive, 
                   y = tenure_segment, yend = tenure_segment), 
               color = "#E0E0E0", size = 3) +
  
  # B. Plot the Points (Map color to activity_status to create legend)
  # This automatically generates the "Note" for Active vs Inactive
  geom_point(aes(color = activity_status), size = 6) +
  
  # C. Add Data Labels
  # Positioned slightly above the points
  geom_text(aes(label = paste0(churn_rate_percentage, "%")), 
            nudge_y = 0.3, size = 3.5, fontface = "bold", color = "#1D3557") +
  
  # D. Professional English Labels
  labs(
    title = "The Activity Gap: Tenure is No Shield Against Attrition",
    subtitle = "Quantifying the 'Inactivity Tax' for long-term vs. new customers",
    x = "Churn Rate (%)",
    y = "",
    color = "Activity Status" # Label for the legend
  ) +
  
  # E. Set Professional Colors
  # Soft Blue for Active, Peach for Inactive
  scale_color_manual(values = c("Active" = "#C688EB", "Inactive" = "#FFC4A4")) +
  
  # F. Styling & Theme
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title = element_text(face = "bold", size = 18, color = "#1D3557"),
    plot.subtitle = element_text(size = 12, color = "#457B9D", margin = margin(b = 20)),
    panel.grid.major.y = element_blank(), # Cleaner look without horizontal grid lines
    axis.text.y = element_text(face = "bold", size = 11, color = "#1D3557"),
    plot.margin = margin(30, 30, 30, 30),
    legend.position = "bottom" # Position the legend at the bottom
  )


# ==============================================================================
# PART 3.2: - THE CREDIT SCORE TRAP 
# ==============================================================================

# 1. Load and Prepare Data
# Note: Data already has columns 'country' and 'credit_category'
df_paradox2 <- read.csv("paradox2_credit_score_germany.csv")

# Ensure 'credit_category' is ordered logically from Poor to Exceptional
df_paradox2$credit_category <- factor(df_paradox2$credit_category, 
                                      levels = rev(c("1. Exceptional", "2. Very Good", 
                                                     "3. Good", "4. Fair", "5. Poor")))

# 2. Create a Faceted Lollipop Chart for high impact
p4 <- ggplot(df_paradox2, aes(x = churn_rate_percentage, y = credit_category)) +
  
  # A. Faceting by Country to show the contrast
  facet_wrap(~ country) +
  
  # B. Draw the "Stick" (Connecting baseline to points)
  geom_segment(aes(x = 0, xend = churn_rate_percentage, y = credit_category, yend = credit_category), 
               color = "#E0E0E0", size = 1) +
  
  # C. Draw the "Candy" (The points)
  # Color is mapped to country to make Germany stand out
  geom_point(aes(color = country), size = 4) +
  
  # D. Add percentage labels
  geom_text(aes(label = paste0(churn_rate_percentage, "%")), 
            hjust = -0.3, size = 3, fontface = "bold", color = "#1D3557") +
  
  # E. Professional English Labels
  labs(
    title = "The Credit Anchor: Why High-Tier Customers Lack Stickiness",
    subtitle = "Comparing churn rates by credit category across France, Germany, and Spain",
    x = "Churn Rate (%)",
    y = "Credit Category",
    color = "Country"
  ) +
  
  # F. Styling & Professional Theme
  # Germany gets a standout color (Coral), others are softer
  scale_color_manual(values = c("Germany" = "#C688EB", "France" = "#FBA2D0", "Spain" = "#FFC4A4")) +
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title = element_text(face = "bold", size = 16, color = "#1D3557"),
    plot.subtitle = element_text(size = 11, color = "#457B9D", margin = margin(b = 20)),
    strip.background = element_rect(fill = "#F0F0F0", color = NA),
    strip.text = element_text(face = "bold", size = 12, color = "#1D3557"),
    panel.grid.major.y = element_blank(),
    legend.position = "none", # Hide legend since facets already have titles
    plot.margin = margin(30, 40, 30, 30)
  ) +
  
  # Expand X-axis slightly for labels
  xlim(0, max(df_paradox2$churn_rate_percentage) + 12)

# ==============================================================================
# PART 3.3: - THE PRODUCT OVERLOAD CLIFF
# ==============================================================================

# 1. Load Data
# Data uses 'products_number' and 'churn_rate_percentage'
df_p3 <- read.csv("paradox3_product_overload_analysis.csv")

# 2. Create Visualization
p5 <- ggplot(df_p1_final <- df_p3, aes(x = products_number, y = churn_rate_percentage)) +
  
  # A. Draw the main path
  geom_line(color = "#D3D3D3", size = 1.5) +
  
  # B. Add points with conditional coloring
  # Highlight the 'Danger Zone' (3-4 products) in Red
  geom_point(aes(color = products_number >= 3), size = 6) +
  
  # C. Add Data Labels
  geom_text(aes(label = paste0(churn_rate_percentage, "%")), 
            vjust = -2, fontface = "bold", size = 4, color = "#1D3557") +
  
  # D. Professional English Labels
  labs(
    title = "The Paradox of Choice: When More Products Mean Less Loyalty",
    subtitle = "Identifying the 82% churn 'cliff' triggered by excessive cross-selling.",
    x = "Number of Products",
    y = "Churn Rate (%)"
  ) +
  
  # E. Custom Colors and Scales
  scale_color_manual(values = c("FALSE" = "#FFC4A4", "TRUE" = "#E63946"), 
                     labels = c("Safe Zone", "Danger Zone")) +
  scale_x_continuous(breaks = 1:4) +
  
  # F. Styling & Layout
  theme_minimal(base_family = "Arial") +
  theme(
    plot.title = element_text(face = "bold", size = 18, color = "#1D3557"),
    plot.subtitle = element_text(size = 12, color = "#457B9D", margin = margin(b = 25)),
    panel.grid.minor = element_blank(),
    legend.position = "bottom",
    legend.title = element_blank(),
    plot.margin = margin(30, 30, 30, 30)
  ) +
  
  # Expand Y for label space
  ylim(0, 115)

# ==============================================================================
# PART 3.4: CUSTOMER ATTRITION WATERFALL 
# ==============================================================================

# 1. Load Data
df_wf_raw <- read.csv("paradox5_waterfall_attrition.csv") %>%
  arrange(sort_order)

# 2. Calculate Waterfall Coordinates
df_wf_plot <- df_wf_raw %>%
  mutate(
    end = cumsum(customer_count),
    start = lag(end, default = 0),
    type = ifelse(row_number() == 1, "Initial", "Loss")
  )

# 3. Add Final Summary Bar
final_count <- tail(df_wf_plot$end, 1)
final_row <- data.frame(
  category = "Final Active", 
  customer_count = final_count,
  sort_order = 5,
  end = final_count,
  start = 0,
  type = "Final"
)

df_wf_final <- rbind(df_wf_plot, final_row)
df_wf_final$category <- factor(df_wf_final$category, levels = df_wf_final$category)
df_wf_final$id <- as.numeric(df_wf_final$category)

# 4. Create Visualization
p6 <- ggplot(df_wf_final, aes(fill = type)) +
  # Draw the floating bars
  geom_rect(aes(x = category, xmin = id - 0.4, xmax = id + 0.4, 
                ymin = start, ymax = end)) +
  
  # Add labels
  geom_text(aes(x = id, y = end, 
                label = format(customer_count, big.mark = ",")), 
            vjust = ifelse(df_wf_final$customer_count >= 0, -0.6, 1.5), 
            fontface = "bold", size = 3.5) +
  
  labs(
    title = "The Leaky Bucket: Visualizing Cumulative Customer Attrition",
    subtitle = "Tracing the journey from 10,000 onboarded users to the current active basee",
    x = "", y = "Customer Count"
  ) +
  
  scale_fill_manual(values = c("Initial" = "#FBA2D0", "Loss" = "#E63946", "Final" = "#FFc4A4")) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 18, color = "#1D3557"),
    axis.text.x = element_text(face = "bold", size = 10, angle = 15, hjust = 1), # Angle for readability
    legend.position = "none"
  )