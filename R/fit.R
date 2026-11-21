# 用本地样地数据重拟合 + 异常检测。

fit_equations <- function(df) {
  df <- as.data.frame(df)
  df <- df[is.finite(df$N) & is.finite(df$Hd) & df$N > 0 & df$Hd > 0, , drop = FALSE]
  res <- list()

  fit_one <- function(y, xs) {
    sub <- df[stats::complete.cases(df[, c(y, xs), drop = FALSE]), , drop = FALSE]
    sub <- sub[sub[[y]] > 0 & apply(sub[, xs, drop = FALSE] > 0, 1, all), , drop = FALSE]
    if (nrow(sub) < length(xs) + 2) return(NULL)
    X  <- cbind(1, as.matrix(log(sub[, xs, drop = FALSE])))
    if (qr(X)$rank < ncol(X)) {
      warning(y, ": design matrix is rank-deficient (collinear regressors); ",
              "coefficients are not uniquely identifiable", call. = FALSE)
    }
    yv <- log(sub[[y]])
    beta <- stats::lm.fit(X, yv)$coefficients
    pred <- as.numeric(X %*% beta)
    ss_res <- sum((yv - pred) ^ 2)
    ss_tot <- sum((yv - mean(yv)) ^ 2)
    r2 <- if (ss_tot > 0) 1 - ss_res / ss_tot else NA_real_
    rmse <- sqrt(ss_res / length(yv))
    coef <- list(a = exp(beta[1]))
    for (i in seq_along(xs)) coef[[paste0(xs[i], "_exp")]] <- beta[i + 1]
    list(coef = coef, n = nrow(sub), R2 = r2, RMSE_log = rmse)
  }

  if ("dg" %in% names(df)) res$dg <- fit_one("dg", c("N", "Hd"))
  for (y in c("V", "Bs", "Bagb")) {
    if (all(c(y, "dg", "Hd", "N") %in% names(df))) {
      res[[y]] <- fit_one(y, c("dg", "Hd", "N"))
    }
  }
  res
}

fit_species_from_data <- function(code, name_zh, name_en, latin, source, region,
                                  df, dbh_min = 5.0, hd_df = NULL) {
  fitted <- fit_equations(df)
  stand <- list()
  if (is.null(fitted$dg)) stop("cannot fit dg equation: df must contain N, Hd, dg")
  stand$dg <- fitted$dg$coef
  for (v in c("V", "Bs", "Bagb")) {
    if (!is.null(fitted[[v]])) stand[[v]] <- fitted[[v]]$coef
  }

  hd <- NULL
  if (!is.null(hd_df) && nrow(hd_df) >= 3) {
    hd_df <- hd_df[hd_df$d > 0 & hd_df$h > 1.3, , drop = FALSE]
    y <- 1 / (hd_df$h - 1.3) ^ (1 / 3)
    X <- cbind(1 / hd_df$d, 1)
    beta <- stats::lm.fit(X, y)$coefficients
    hd <- list(a = beta[1], b = beta[2])
  }

  k <- if ("dg" %in% names(df)) {
    as.numeric(stats::quantile(df$N * df$dg ^ 1.605, 0.975, na.rm = TRUE))
  } else {
    NULL
  }
  reineke <- if (!is.null(k)) list(k = k, b = -1.605) else NULL

  sp <- list(
    code = code, name_zh = name_zh, name_en = name_en, latin = latin,
    source = source, region = region, dbh_min = dbh_min,
    hd = hd, tree = NULL, stand = stand, reineke = reineke,
    carbon_factor = NULL,
    rs_bands = list(list(0, "\u8fc7\u5bc6"), list(16, "\u9ad8\u5bc6\u5ea6"),
                    list(24, "\u5408\u7406"), list(36, "\u504f\u758f"),
                    list(50, "\u660e\u663e\u7a00\u758f")),
    sc_bands = list(list(60, "\u7a33\u5b9a"), list(90, "\u4e2d\u7b49"))
  )
  add_species(sp)
  sp
}

detect_anomalies <- function(df, sp = get_species("chinese_fir"),
                             z_threshold = 2.0) {
  df <- as.data.frame(df)
  pred <- do.call(rbind, lapply(seq_len(nrow(df)), function(i) {
    p <- stand_predict(sp, df$N[i], df$Hd[i])
    data.frame(V_pred = p$V, RS = p$RS, SC = p$SC, BA_pred = p$BA)
  }))
  out <- cbind(df, pred)

  if ("V" %in% names(df)) {
    resid <- log(out$V) - log(out$V_pred)
    med <- stats::median(resid, na.rm = TRUE)
    mad <- stats::median(abs(resid - med), na.rm = TRUE)
    scale <- 1.4826 * mad
    out$V_resid_z <- if (scale > 1e-12) (resid - med) / scale else rep(0, length(resid))
  } else {
    out$V_resid_z <- NA_real_
  }

  flags <- logical(nrow(out))
  reasons <- character(nrow(out))
  for (i in seq_len(nrow(out))) {
    why <- character(0)
    if (!is.na(out$V_resid_z[i]) && abs(out$V_resid_z[i]) > z_threshold) {
      why <- c(why, sprintf("residual z=%.1f, stand-site mismatch", out$V_resid_z[i]))
    }
    for (col in c("N", "RS", "SC")) {
      if (col %in% names(out) && !is.na(out[[col]][i])) {
        lo <- min(out[[col]], na.rm = TRUE)
        hi <- max(out[[col]], na.rm = TRUE)
        if (!(lo <= out[[col]][i] && out[[col]][i] <= hi)) {
          why <- c(why, sprintf("%s=%.1f outside [%.1f, %.1f]", col, out[[col]][i], lo, hi))
        }
      }
    }
    flags[i] <- length(why) > 0
    reasons[i] <- if (length(why)) paste(why, collapse = "; ") else "normal"
  }
  out$anomaly <- flags
  out$reason <- reasons
  out
}
