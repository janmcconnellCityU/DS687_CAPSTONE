############################################################
# 06b_data_analytics.r
#
# DS687 Capstone, R Replication Script
#
# Purpose:
# Replicate the primary engagement regressions in R to validate:
# - coefficient stability across environments (Python vs R)
# - model fit consistency (R-squared)
#
# Scope:
# 1) Load modeling-ready dataset exported from Python.
# 2) Validate required columns and derive fields if needed.
# 3) Estimate two OLS specifications:
#    Model A: log_votes ~ genre indicators + genre_count
#    Model B: log_votes ~ genre indicators
# 4) Produce a coefficient comparison plot with 95% confidence intervals.
# 5) Save plot, coefficient tables, and model summaries.
#
# Assumptions:
# - Dataset includes:
#     - tconst (optional, not required for regression)
#     - numVotes or log_votes
#     - genre dummy columns named like: genre_Action, genre_Drama, ...
#     - genre_count (optional, derived if missing)
# - Drama is the omitted reference category.
############################################################

############################
# 0) Configuration
############################

# Set working directory first so relative paths behave as expected
setwd("C:/Users/JanMc/Dropbox/Education/_GitHub_coursework/janmcconnellCityU-coursework/DS687_CAPSTONE/scripts") # nolint

data_path <- "../output/df_modeling_ready.csv"
out_dir <- "../output/r_outputs"
reference_genre <- "Drama"
save_outputs <- TRUE

############################
# 1) Package Setup
############################

required_pkgs <- c("ggplot2")

missing_pkgs <- required_pkgs[
  !vapply(required_pkgs, requireNamespace, FUN.VALUE = logical(1), quietly = TRUE) # nolint
]

if (length(missing_pkgs) > 0) {
  stop(
    paste(
      "Missing required package(s):",
      paste(missing_pkgs, collapse = ", ")
    )
  )
}

library(ggplot2)

############################
# 2) Output Directory
############################

if (!dir.exists(out_dir)) {
  dir.create(out_dir, recursive = TRUE)
}

############################
# 2a) Helper functions for saving outputs
############################

save_plot <- function(plot_obj, filename, w = 7.0, h = 5.5, dpi = 300) {
  if (isTRUE(save_outputs)) {
    out_path <- file.path(out_dir, filename)
    ggsave(out_path, plot = plot_obj, width = w, height = h, dpi = dpi)
    cat("Saved plot:", out_path, "\n")
  }
}

save_csv <- function(df_obj, filename) {
  if (isTRUE(save_outputs)) {
    out_path <- file.path(out_dir, filename)
    write.csv(df_obj, out_path, row.names = FALSE)
    cat("Saved table:", out_path, "\n")
  }
}

save_text <- function(text_vec, filename) {
  if (isTRUE(save_outputs)) {
    out_path <- file.path(out_dir, filename)
    writeLines(text_vec, out_path, useBytes = TRUE)
    cat("Saved text:", out_path, "\n")
  }
}

############################
# 3) Load Dataset
############################

if (!file.exists(data_path)) {
  stop(paste("Dataset not found at:", data_path))
}

df <- read.csv(data_path, stringsAsFactors = FALSE)

cat("Dataset loaded\n")
cat("Working directory:", getwd(), "\n")
cat("Rows:", nrow(df), "\n")
cat("Columns:", ncol(df), "\n\n")

cat("Column names:\n")
print(names(df))
cat("\n")

# ---- CLEANUP: remove accidental duplicate genre_count columns ----
dup_count_cols <- names(df)[grepl("^genre_count\\.", names(df))]

if (length(dup_count_cols) > 0) {
  cat(
    "Removing duplicate genre_count columns:",
    paste(dup_count_cols, collapse = ", "),
    "\n"
  )
  df <- df[, !names(df) %in% dup_count_cols]
  cat("Columns after cleanup:", ncol(df), "\n\n")
}

############################
# 4) Required Columns and Derived Fields
############################

# Ensure log_votes exists
if (!("log_votes" %in% names(df))) {
  if (!("numVotes" %in% names(df))) {
    stop("Dataset must include either log_votes or numVotes.")
  }
  df$log_votes <- log(df$numVotes + 1)
  cat("Derived log_votes from numVotes using log(numVotes + 1)\n\n")
}

# Identify genre dummy columns
# CRITICAL FIX:
# - Exclude genre_count from genre dummy list.
# - genre_count starts with "genre_", so it will be wrongly included unless excluded explicitly. # nolint
genre_cols <- names(df)[grepl("^genre_", names(df))]
genre_cols <- setdiff(genre_cols, "genre_count")

if (length(genre_cols) == 0) {
  stop("No genre dummy columns found, expected columns beginning with 'genre_'.") # nolint
}

# Ensure genre_count exists, derive if missing
if (!("genre_count" %in% names(df))) {

  genre_mat <- df[, genre_cols, drop = FALSE]

  # Convert each genre dummy column to numeric (0/1),
  # tolerating input types like logical, character, or integer.
  for (col in genre_cols) {
    if (is.logical(genre_mat[[col]])) {
      genre_mat[[col]] <- as.numeric(genre_mat[[col]])
    } else if (is.character(genre_mat[[col]])) {
      genre_mat[[col]] <- suppressWarnings(as.numeric(genre_mat[[col]]))
    } else {
      genre_mat[[col]] <- suppressWarnings(as.numeric(genre_mat[[col]]))
    }
  }

  df$genre_count <- rowSums(genre_mat, na.rm = TRUE)
  cat("Derived genre_count as row sum of genre dummies\n\n")
}

############################
# 5) Reference Genre Handling
############################

ref_col <- paste0("genre_", reference_genre)

if (!(ref_col %in% genre_cols)) {
  stop(paste("Reference genre dummy not found:", ref_col))
}

genre_predictors <- setdiff(genre_cols, ref_col)

cat("Reference genre omitted:", ref_col, "\n")
cat("Number of genre predictors used:", length(genre_predictors), "\n\n")

############################
# 6) Model Estimation
############################

# Model A includes genre_count exactly once
formula_a <- as.formula(
  paste(
    "log_votes ~",
    paste(c(genre_predictors, "genre_count"), collapse = " + ")
  )
)

# Model B excludes genre_count
formula_b <- as.formula(
  paste(
    "log_votes ~",
    paste(genre_predictors, collapse = " + ")
  )
)

model_a <- lm(formula_a, data = df)
model_b <- lm(formula_b, data = df)

r2_a <- summary(model_a)$r.squared
r2_b <- summary(model_b)$r.squared

fit_tbl <- data.frame(
  model = c("With genre_count", "Without genre_count"),
  r_squared = c(r2_a, r2_b),
  n = c(nobs(model_a), nobs(model_b)),
  stringsAsFactors = FALSE
)

cat("Model Fit\n")
cat("With genre_count, R-squared:", round(r2_a, 4), "\n")
cat("Without genre_count, R-squared:", round(r2_b, 4), "\n\n")

save_csv(fit_tbl, "model_fit_summary.csv")

############################
# 7) Extract Genre Coefficients and 95% Confidence Intervals
############################

extract_genre_coefs <- function(model) {

  coefs <- coef(model)
  terms <- names(coefs)

  # Keep genre dummies only, explicitly exclude genre_count
  keep <- grepl("^genre_", terms) & terms != "genre_count"

  coefs <- coefs[keep]

  ci <- confint(model)
  ci <- ci[names(coefs), , drop = FALSE]

  data.frame(
    term = names(coefs),
    estimate = as.numeric(coefs),
    conf_low = as.numeric(ci[, 1]),
    conf_high = as.numeric(ci[, 2]),
    stringsAsFactors = FALSE
  )
}

df_a <- extract_genre_coefs(model_a)
df_b <- extract_genre_coefs(model_b)

# Align to common terms to avoid mismatches
common_terms <- intersect(df_a$term, df_b$term)

df_a <- df_a[df_a$term %in% common_terms, ]
df_b <- df_b[df_b$term %in% common_terms, ]

# Clean genre labels
df_a$genre <- sub("^genre_", "", df_a$term)
df_b$genre <- sub("^genre_", "", df_b$term)

df_a$model <- "With genre_count"
df_b$model <- "Without genre_count"

plot_df <- rbind(df_a, df_b)

# Stable plot ordering
plot_df$genre <- factor(plot_df$genre,
                        levels = rev(sort(unique(plot_df$genre))))

# Save coefficient tables for auditing, and for Python alignment checks
save_csv(df_a[order(df_a$genre), ], "coef_table_model_a_with_genre_count.csv")
save_csv(df_b[order(df_b$genre), ], "coef_table_model_b_without_genre_count.csv") # nolint

############################
# 8) Plot: Coefficient Comparison (95% CI)
############################

p <- ggplot(plot_df, aes(x = estimate, y = genre, shape = model)) +
  geom_vline(xintercept = 0, linewidth = 0.4, color = "gray40") +
  geom_errorbarh(
    aes(xmin = conf_low, xmax = conf_high),
    height = 0.15,
    position = position_dodge(width = 0.6),
    linewidth = 0.5
  ) +
  geom_point(
    position = position_dodge(width = 0.6),
    size = 2
  ) +
  labs(
    title = "Genre Coefficients With and Without Genre Count (95% CI)",
    x = "Coefficient on log_votes",
    y = NULL,
    shape = NULL
  ) +
  theme_minimal(base_size = 11) +
  theme(legend.position = "top")

print(p)

save_plot(p, "fig_genre_coefficients_with_without_genre_count.png", w = 7.0, h = 9.5) # nolint

############################
# 9) Save Model Summaries
############################

summary_a_txt <- capture.output(summary(model_a))
summary_b_txt <- capture.output(summary(model_b))

save_text(summary_a_txt, "model_a_with_genre_count_summary.txt")
save_text(summary_b_txt, "model_b_without_genre_count_summary.txt")

############################
# 10) Completion
############################

cat("Outputs written to:", normalizePath(out_dir, winslash = "/", mustWork = FALSE), "\n") # nolint
cat("R replication completed successfully.\n")