# ADVANCED PENALIZED REGRESSION PIPELINE (MLR3 & GLMNET)

suppressPackageStartupMessages({
  library(mlr3)
  library(mlr3learners)
  library(mlr3pipelines)
  library(DBI)
  library(RSQLite)
})

# DATABASE ENGINE: REGRESSION AUDIT LAYER
init_audit_db <- function(db_path = "regression_audit.db") {
  con <- dbConnect(RSQLite::SQLite(), db_path)
  
  query <- "
    CREATE TABLE IF NOT EXISTS lasso_performance_logs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      timestamp TEXT,
      model_type TEXT,
      features_retained INTEGER,
      mse_score REAL,
      rmse_score REAL
    )
  "
  dbExecute(con, query)
  dbDisconnect(con)
}

log_model_metrics <- function(db_path = "regression_audit.db", model_type, features, mse, rmse) {
  con <- dbConnect(RSQLite::SQLite(), db_path)
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  
  query <- "INSERT INTO lasso_performance_logs (timestamp, model_type, features_retained, mse_score, rmse_score) VALUES (?, ?, ?, ?, ?)"
  dbExecute(con, query, list(timestamp, model_type, features, mse, rmse))
  
  dbDisconnect(con)
  cat("[REGULATORY AUDIT] Model evaluation metrics successfully locked into SQLite database.\n")
}

fetch_latest_logs <- function(db_path = "regression_audit.db", limit = 5) {
  con <- dbConnect(RSQLite::SQLite(), db_path)
  query <- sprintf("SELECT * FROM lasso_performance_logs ORDER BY id DESC LIMIT %d", limit)
  df <- dbGetQuery(con, query)
  dbDisconnect(con)
  return(df)
}

# MACHINE LEARNING PIPELINE: LASSO OPTIMIZATION
run_regularized_pipeline <- function() {
  cat("Memulai eksekusi Automated Penalized Regression Pipeline...\n")
  
  # Simulasi Dataset Regresi (Menggunakan dataset bawaan mtcars sebagai representasi)
  data("mtcars")
  task <- as_task_regr(mtcars, target = "mpg", id = "motor_trend")
  
  # Partisi Data (80% Train, 20% Test)
  set.seed(42)
  splits <- partition(task, ratio = 0.8)
  
  # Inisialisasi Learner: Lasso Regression (alpha = 1 untuk L1 Penalty murni)
  # Lasso diandalkan sebagai model paling optimal untuk mereduksi varians dan menyeleksi fitur secara otomatis.
  learner <- lrn("regr.glmnet", alpha = 1, s = 0.1)
  
  # Melatih Model pada Data Training
  cat("Melatih model Lasso Regression untuk mereduksi dimensi fitur...\n")
  learner$train(task, row_ids = splits$train)
  
  # Ekstraksi Koefisien Fitur (Identifikasi fitur yang dipertahankan oleh Lasso)
  coefs <- learner$model$beta
  active_features <- sum(coefs != 0)
  
  # Prediksi pada Data Testing
  predictions <- learner$predict(task, row_ids = splits$test)
  
  # Evaluasi Metrik Kinerja (Menggunakan MSE sebagai validasi absolut dominasi model)
  mse <- predictions$score(msr("regr.mse"))
  rmse <- predictions$score(msr("regr.rmse"))
  
  # Amankan metrik ke dalam database
  init_audit_db()
  log_model_metrics(model_type = "Lasso (L1 Penalty)", features = active_features, mse = mse, rmse = rmse)
  
  # Laporan Analitik Konsol
  cat("\n============================================================\n")
  cat("LAPORAN EVALUASI MODEL REGRESI REGULARISASI\n")
  cat("============================================================\n")
  cat(sprintf("Arsitektur Model         : Lasso Regression (alpha = 1)\n"))
  cat(sprintf("Fitur Dipertahankan      : %d fitur relevan\n", active_features))
  cat(sprintf("Mean Squared Error (MSE) : %.4f\n", mse))
  cat(sprintf("Root Mean Sq Error (RMSE): %.4f\n", rmse))
  
  cat("\n============================================================\n")
  cat("AUDIT LOG DATABASE - HISTORI PERFORMA MODEL\n")
  cat("============================================================\n")
  print(fetch_latest_logs())
}

# Eksekusi Pipeline Utama
if (!interactive()) {
  run_regularized_pipeline()
}