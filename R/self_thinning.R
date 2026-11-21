# Reineke 自疏线。

self_thinning_nmax <- function(sp, dg) {
  r <- if (!is.null(sp[["max_density"]])) sp[["max_density"]] else sp[["reineke"]]
  if (is.null(r)) return(NA_real_)
  r$k * dg ^ r$b
}

self_thinning_curve <- function(sp, dg_min = 6, dg_max = 45, n = 200) {
  r <- sp[["reineke"]]
  if (is.null(r)) stop(sp$code, " has no self-thinning line (reineke=NULL)")
  dg <- seq(dg_min, dg_max, length.out = n)
  out <- data.frame(dg = dg, Nmax = r$k * dg ^ r$b)
  if (!is.null(sp[["max_density"]])) {
    out$N_max_density <- sp[["max_density"]]$k * dg ^ sp[["max_density"]]$b
  }
  out
}
