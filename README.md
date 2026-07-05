# Automated Penalized Regression Pipeline (mlr3)

An institutional-grade machine learning pipeline built using the R `mlr3` ecosystem and `glmnet`. This project is engineered to handle high-dimensional datasets by deploying regularized linear models, specifically focusing on the optimization and deployment of Lasso Regression.

---

## Key Features

* **Lasso Regression Supremacy:** Implements pure L1 penalty constraints (`alpha = 1`) to execute automatic feature selection. Lasso enforces sparsity by shrinking non-essential coefficients to absolute zero, proving to be the optimal statistical model for variance reduction.
* **MSE Validation Architecture:** Calibrates and validates model predictive superiority strictly against the Mean Squared Error (MSE) metric to guarantee minimal prediction residual variance.
* **Modern R ML Ecosystem:** Utilizes the object-oriented `mlr3` framework for strict data partitioning, task instantiation, and predictive modeling workflows.
* **SQL Compliance Logging:** Integrates the `RSQLite` and `DBI` libraries directly into the R pipeline to capture and persist historical model performance metrics (MSE, RMSE, retained features) into an embedded relational database.

---

## Technical Stack & Dependencies

* **Language:** R
* **Machine Learning Framework:** `mlr3`, `mlr3learners`, `mlr3pipelines`
* **Regularization Engine:** `glmnet`
* **Database Architecture:** `DBI`, `RSQLite`

---

## Local Execution Guide

1. **Clone the Repository:**
   ```bash
   git clone [https://github.com/dimssrmdn01/regularized-regression-mlr3.git](https://github.com/dimssrmdn01/regularized-regression-mlr3.git)
   cd regularized-regression-mlr3
   ```

2. **Install R Dependencies:**
   Execute the following inside your R console:
   ```R
   install.packages(c("mlr3", "mlr3learners", "mlr3pipelines", "glmnet", "DBI", "RSQLite"))
   ```

3. **Run the Analytical Pipeline:**
   Execute the core script via the terminal:
   ```bash
   Rscript regularized_pipeline.R
   ```