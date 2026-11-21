# 树高曲线、单木方程、林分四方程与株数反推。

tree_height <- function(sp, d) {
  hd <- sp$hd
  if (is.null(hd)) {
    stop(sp$name_zh, " has no height curve (hd=NULL)")
  }
  if (!is.null(hd$form) && hd$form == "power") {
    return(hd$k * d ^ hd$p)
  }
  1.3 + (d / (hd$a + hd$b * d)) ^ 3
}

tree_biomass <- function(sp, d, h = NULL) {
  if (is.null(sp$tree)) {
    stop(sp$code, " has no single-tree equations (tree=NULL)")
  }
  if (is.null(h)) h <- tree_height(sp, d)
  lapply(sp$tree, function(eq) eq$k * d ^ eq$d_exp * h ^ eq$h_exp)
}

stand_predict <- function(sp, N, Hd) {
  s <- sp$stand
  if (is.null(s)) stop(sp$code, " has no stand equations (stand=NULL)")
  dg <- s$dg$a * N ^ s$dg$N_exp * Hd ^ s$dg$Hd_exp

  pw <- function(e, dg, Hd, N) {
    e$a * dg ^ e$dg_exp * Hd ^ e$Hd_exp * N ^ e$N_exp
  }

  V    <- if (!is.null(s$V)) pw(s$V, dg, Hd, N) else NA_real_
  Bs   <- if (!is.null(s$Bs)) pw(s$Bs, dg, Hd, N) else NA_real_
  Bagb <- if (!is.null(s$Bagb)) pw(s$Bagb, dg, Hd, N) else NA_real_
  BA  <- pi / 4 * dg ^ 2 * N / 10000
  RS  <- sqrt(10000 / N) / Hd * 100
  SC  <- if (!is.null(sp$sc) && identical(sp$sc$form, "linear")) {
    100 * (sp$sc$a_h + sp$sc$b_h * Hd) / (sp$sc$a_d + sp$sc$b_d * dg)
  } else if (!is.null(sp$hd)) {
    100 * tree_height(sp, dg) / dg
  } else {
    100 * Hd / dg
  }

  list(dg = dg, BA = BA, V = V, Bs = Bs, Bagb = Bagb, RS = RS, SC = SC)
}

N_from_dg <- function(sp, dg, Hd) {
  p <- sp$stand$dg
  (p$a * Hd ^ p$Hd_exp / dg) ^ (-1 / p$N_exp)
}
