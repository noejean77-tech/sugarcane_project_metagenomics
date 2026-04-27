# ============================================
# QC Analysis - NanoComp Results Visualization
# ============================================

library(ggplot2)
library(tidyverse)
library(RColorBrewer)

# ============================================
# 1. Chargement et préparation des données
# ============================================

data <- data.frame(
  Barcode = c("Barcode75", "Barcode76", "Barcode77", "Barcode78", "Barcode79",
              "Barcode80", "Barcode81", "Barcode82", "Barcode83", "Barcode84", "Barcode85"),
  Mean_read_length = c(1176.3, 1494.6, 1362.6, 1185.5, 1325.1, 1143.9, 1678.7, 969.8, 1034.7, 1099.2, 1038.3),
  Median_read_length = c(542.0, 448.5, 640.0, 495.5, 635.0, 526.0, 827.0, 515.0, 473.0, 493.0, 449.0),
  Mean_read_quality = c(15.9, 15.7, 15.9, 15.9, 16.2, 15.8, 15.2, 16.6, 15.9, 15.9, 16.9),
  Median_read_quality = c(18.0, 17.6, 17.9, 17.9, 18.1, 17.7, 16.8, 18.8, 17.8, 17.9, 19.3),
  Number_of_reads = c(33209, 17276, 27400, 34636, 17553, 28870, 21642, 41208, 51917, 41882, 32856),
  N50 = c(2522, 4646, 2921, 2888, 2712, 2457, 3470, 1777, 2204, 2403, 2271),
  Total_bases_Mb = c(39.06, 25.82, 37.34, 41.06, 23.26, 33.02, 36.33, 39.97, 53.72, 46.04, 34.12),
  Q10_pct = c(99.6, 99.5, 99.5, 99.6, 99.6, 99.6, 99.6, 99.6, 99.6, 99.6, 99.7),
  Q15_pct = c(75.7, 73.6, 76.5, 76.2, 78.0, 74.8, 71.0, 80.9, 75.9, 76.6, 83.4),
  Q20_pct = c(32.9, 28.6, 31.0, 30.6, 33.0, 29.8, 16.7, 40.7, 30.8, 30.9, 43.7)
)
view(data)

# Palette de couleurs
colors <- brewer.pal(11, "Set3")

output_dir <- "QC_plots"
dir.create(output_dir, showWarnings = FALSE)

# ============================================
# 2. Graphique 1 — Nombre de reads par barcode
# ============================================

p1 <- ggplot(data, aes(x = Barcode, y = Number_of_reads, fill = Barcode)) +
  geom_bar(stat = "identity", color = "black", width = 0.7) +
  scale_fill_manual(values = colors) +
  geom_text(aes(label = format(Number_of_reads, big.mark = ",")),
            vjust = -0.5, size = 3.5, fontface = "bold") +
  labs(
       x = "Sample",
       y = "Number of Reads") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        legend.position = "none")
p1



# ============================================
# 3. Graphique 2 — Mean vs Median Read Length
# ============================================

length_data <- data %>%
  select(Barcode, Mean_read_length, Median_read_length) %>%
  pivot_longer(cols = c(Mean_read_length, Median_read_length),
               names_to = "Metric",
               values_to = "Length") %>%
  mutate(Metric = recode(Metric,
                         "Mean_read_length" = "Mean",
                         "Median_read_length" = "Median"))

p2 <- ggplot(length_data, aes(x = Barcode, y = Length, fill = Metric)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", width = 0.7) +
  scale_fill_manual(values = c("Mean" = "#2196F3", "Median" = "#FF9800")) +
  labs(
       x = "Sample",
       y = "Read Length (bp)",
       fill = "Metric") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

p2


# ============================================
  # 4. Graphique 3 — N50 par barcode
  # ============================================

p3 <- ggplot(data, aes(x = Barcode, y = N50, fill = Barcode)) +
  geom_bar(stat = "identity", color = "black", width = 0.7) +
  scale_fill_manual(values = colors) +
  geom_text(aes(label = format(N50, big.mark = " ")),
            vjust = -0.5, size = 3.5, fontface = "bold") +
  labs(,
       x = "Sample",
       y = "N50 (bp)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
        legend.position = "none")
p3

# ============================================
# 6. Graphique 5 — Proportion reads > Q10, Q15, Q20
# ============================================

quality_cutoff <- data %>%
  select(Barcode, Q10_pct, Q15_pct, Q20_pct) %>%
  pivot_longer(cols = c(Q10_pct, Q15_pct, Q20_pct),
               names_to = "Cutoff",
               values_to = "Percentage") %>%
  mutate(Cutoff = recode(Cutoff,
                         "Q10_pct" = ">Q10",
                         "Q15_pct" = ">Q15",
                         "Q20_pct" = ">Q20"))

p5 <- ggplot(quality_cutoff, aes(x = Barcode, y = Percentage, fill = Cutoff)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", width = 0.7) +
  scale_fill_manual(values = c(">Q10" = "#1565C0", ">Q15" = "#43A047", ">Q20" = "#F57F17")) +
  labs(title = "Percentage of Reads above Quality Cutoffs",
       x = "Sample",
       y = "Percentage of Reads (%)",
       fill = "Quality Cutoff") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

p5


# Qualité moyenne des reads par echantillons 

ggplot(data, aes(x = Barcode, y = Mean_read_quality, fill = Barcode)) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = 10, linetype = "dashed", color = "red", size = 0.8) +
  theme_classic() +
  labs(
    x = "Barcode",
    y = "Quality (Phred Score)") +
  coord_cartesian(ylim = c(0, 20)) + # Pour bien voir la différence
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_viridis_d()



#============================================
  # 6. Graphique 5 — Proportion reads > Q10, Q15, Q20
  # ============================================

quality_cutoff <- data %>%
  select(Barcode, Q10_pct, Q15_pct, Q20_pct) %>%
  pivot_longer(cols = c(Q10_pct, Q15_pct, Q20_pct),
               names_to = "Cutoff",
               values_to = "Percentage") %>%
  mutate(Cutoff = recode(Cutoff,
                         "Q10_pct" = ">Q10",
                         "Q15_pct" = ">Q15",
                         "Q20_pct" = ">Q20"))

p5 <- ggplot(quality_cutoff, aes(x = Barcode, y = Percentage, fill = Cutoff)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", width = 0.7) +
  scale_fill_manual(values = c(">Q10" = "#1565C0", ">Q15" = "#43A047", ">Q20" = "#F57F17")) +
  labs(title = "Percentage of Reads above Quality Cutoffs",
       x = "Sample",
       y = "Percentage of Reads (%)",
       fill = "Quality") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
p5
