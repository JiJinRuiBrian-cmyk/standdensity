# 把树种参数格式化为可读文本。

report <- function(sp) {
  L <- c(
    sprintf("species: %s (%s) %s", sp$name_zh, sp$name_en, sp$latin),
    sprintf("source: %s", sp$source),
    sprintf("region: %s; dbh threshold %g cm", sp$region, sp$dbh_min)
  )

  if (!is.null(sp$hd)) {
    if (!is.null(sp$hd$form) && sp$hd$form == "power") {
      L <- c(L, sprintf("height curve: H = %.4f * DBH^%.4f", sp$hd$k, sp$hd$p))
    } else {
      L <- c(L, sprintf("height curve: h = 1.3 + [d / (%.4f + %.4f*d)]^3",
                        sp$hd$a, sp$hd$b))
    }
  } else {
    L <- c(L, "height curve: not provided")
  }

  if (!is.null(sp$sc)) {
    e <- sp$sc
    if (identical(e$form, "linear")) {
      L <- c(L, sprintf("slenderness: h_bar = %.4f %+.4f*Hd; d_bar = %.4f %+.4f*dg; SC = 100*h_bar/d_bar",
                        e$a_h, e$b_h, e$a_d, e$b_d))
      if (!is.null(e$note)) L <- c(L, paste0("  source: ", e$note))
    }
  }

  if (!is.null(sp$tree)) {
    L <- c(L, "single-tree equations (y = k*d^alpha*h^beta):")
    for (nm in names(sp$tree)) {
      e <- sp$tree[[nm]]
      L <- c(L, sprintf("  %s: k=%g, alpha=%.4g, beta=%.4g", nm, e$k, e$d_exp, e$h_exp))
    }
  }

  if (!is.null(sp$stand)) {
    s <- sp$stand
    L <- c(L, sprintf("  dg = %.4f * N^%.4f * Hd^%.4f",
                      s$dg$a, s$dg$N_exp, s$dg$Hd_exp))
    for (nm in c("V", "Bs", "Bagb")) {
      if (!is.null(s[[nm]])) {
        e <- s[[nm]]
        if (!is.null(e$dg_exp) && e$dg_exp == 0) {
          L <- c(L, sprintf("  %s = %g * Hd^%.4f * N^%.4f",
                            nm, e$a, e$Hd_exp, e$N_exp))
        } else {
          L <- c(L, sprintf("  %s = %g * dg^%.4f * Hd^%.4f * N^%.4f",
                            nm, e$a, e$dg_exp, e$Hd_exp, e$N_exp))
        }
      }
    }
  }

  if (!is.null(sp[["reineke"]])) {
    L <- c(L, sprintf("self-thinning (Reineke): Nmax = %.0f * dg^%.3f",
                      sp[["reineke"]]$k, sp[["reineke"]]$b))
    if (!is.null(sp[["reineke"]]$note)) {
      L <- c(L, paste0("  source: ", sp[["reineke"]]$note))
    }
  } else {
    L <- c(L, "self-thinning line: not provided")
  }

  if (!is.null(sp$Hd_age)) {
    e <- sp$Hd_age
    if (identical(e$form, "hann_scrivani1986")) {
      L <- c(L, sprintf("Hd age curve: Hann & Scrivani 1986 polymorphic site-index model (SI %.0f ft, base age 50)",
                        e$SI_ft))
    } else {
      L <- c(L, sprintf("Hd age curve: Hd = %.4f * (1 - exp(-%.4f*t))^%.4f",
                        e$A, e$B, e$C))
    }
  }

  if (!is.null(sp$carbon_factor)) {
    L <- c(L, sprintf("carbon conversion factor: %g", sp$carbon_factor))
  }

  if (length(sp$rs_bands)) {
    rs_parts <- vapply(seq_along(sp$rs_bands), function(i) {
      t <- sp$rs_bands[[i]][[1]]
      lab <- sp$rs_bands[[i]][[2]]
      if (i < length(sp$rs_bands)) {
        sprintf("%s(%g%%-%g%%)", lab, t, sp$rs_bands[[i + 1]][[1]])
      } else {
        sprintf("%s(>%g%%)", lab, t)
      }
    }, character(1))
    L <- c(L, paste0("density bands (RS%): ", paste(rs_parts, collapse = " / ")))
  }
  if (length(sp$sc_bands)) {
    sc_parts <- vapply(seq_along(sp$sc_bands), function(i) {
      sprintf("%s(<=%g)", sp$sc_bands[[i]][[2]], sp$sc_bands[[i]][[1]])
    }, character(1))
    L <- c(L, paste0("stability bands (SC): ", paste(sc_parts, collapse = " / "),
                     " / unstable(>90)"))
  }
  paste(L, collapse = "\n")
}
