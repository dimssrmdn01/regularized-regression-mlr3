#Load library 
library(ggplot2)
library(dplyr)
library(mlr3)
library(mlr3learners)

# ==========================================
# 1. SIMULASI DATA HASIL BENCHMARK (CONTOH)
# ==========================================
benchmark_results <- data.frame(
  Model = c("Lasso (L1)", "Lasso (L1)", "Lasso (L1)", 
            "Ridge (L2)", "Ridge (L2)", "Ridge (L2)",
            "OLS (Standard)", "OLS (Standard)", "OLS (Standard)"),
  Fold = rep(1:3, 3),
  MSE = c(12.4, 11.8, 12.1,  
          15.2, 14.9, 15.5,  
          22.1, 23.0, 21.5)  
)

#Hitung rata-rata MSE untuk ditarik garis lurus
mean_mse <- benchmark_results %>%
  group_by(Model) %>%
  summarise(Mean_MSE = mean(MSE))

# ==========================================
# 2. PLOT VISUALISASI KELAS KAKAP
# ==========================================
p <- ggplot(benchmark_results, aes(x = Model, y = MSE, fill = Model)) +
  #Bikin boxplot dengan desain minimalis
  geom_boxplot(alpha = 0.8, outlier.shape = NA, width = 0.5) +
  geom_jitter(width = 0.15, size = 2, alpha = 0.6, color = "black") +
  
  #Kustomisasi warna (Lasso dibikin warna biru mencolok sebagai pemenang)
  scale_fill_manual(values = c("Lasso (L1)" = "#00d2ff", 
                               "Ridge (L2)" = "#6c757d", 
                               "OLS (Standard)" = "#343a40")) +
  
  #Judul dan Label 
  labs(
    title = "Model Performance Benchmark",
    subtitle = "Lasso Regression exhibits superior variance reduction (Lowest MSE)",
    x = "Statistical Model",
    y = "Mean Squared Error (MSE)",
    caption = "Evaluated via mlr3 framework"
  ) +
  
  #Tema visual 
  theme_minimal(base_family = "sans") +
  theme(
    plot.title = element_text(face = "bold", size = 16, color = "#212529"),
    plot.subtitle = element_text(size = 12, color = "#495057", margin = margin(b = 15)),
    axis.title.x = element_text(face = "bold", margin = margin(t = 10)),
    axis.title.y = element_text(face = "bold", margin = margin(r = 10)),
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none" 
  )

#Tampilkan Plot
print(p)

#Simpan Plot
ggsave("mse_comparison_plot.png", plot = p, width = 8, height = 5, dpi = 300)