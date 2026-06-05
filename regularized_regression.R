library(mlr3)
library(mlr3learners)
library(data.table)

set.seed(42)
n <- 300
p <- 8

X <- matrix(rnorm(n * p), n, p)
for (j in 2:p) {
  X[, j] <- X[, 1] * 0.95 + rnorm(n, sd = 0.1)
}

y <- X[, 1] * 3 + X[, 2] * 2 + rnorm(n)
data <- as.data.frame(cbind(y, X))
colnames(data) <- c("y", paste0("x", 1:p))

task <- as_task_regr(data, target = "y", id = "analisis_ekonomi")

learner_lasso <- lrn("regr.glmnet", alpha = 1, id = "Lasso")
learner_ridge <- lrn("regr.glmnet", alpha = 0, id = "Ridge")

resampling <- rsmp("cv", folds = 5)

design <- benchmark_grid(
  tasks = task,
  learners = list(learner_lasso, learner_ridge),
  resamplings = resampling
)

cat("===  REGULARIZED REGRESSION ENGINE (mlr3) ===\n")
cat("Berhasil menginisialisasi task dengan kondisi multikolinearitas tinggi.\n\n")

bmr <- benchmark(design)
laporan_performa <- bmr$aggregate(msr("regr.mse"))

cat("---  LAPORAN EVALUASI PERFORMA VALIDASI (MSE) ---\n")
print(laporan_performa[, .(learner_id, regr.mse)])