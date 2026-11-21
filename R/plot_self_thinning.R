# 自疏线图（base R 绘图）。

plot_self_thinning <- function(sp = get_species("chinese_fir"),
                               dg_min = 6, dg_max = 45, n = 200,
                               save_path = NULL, title = NULL) {
  r <- sp[["reineke"]]
  if (is.null(r)) stop(sp$code, " has no self-thinning line (reineke=NULL)")
  dg <- seq(dg_min, dg_max, length.out = n)
  Nmax <- r$k * dg ^ r$b
  has_max <- !is.null(sp[["max_density"]])
  Nmax_density <- if (has_max) sp[["max_density"]]$k * dg ^ sp[["max_density"]]$b else NULL

  .open_graphics(save_path, width = 7, height = 6)

  graphics::plot(dg, Nmax, type = "l", log = "xy",
                 xlab = "quadratic mean diameter dg (cm)",
                 ylab = "maximum stem number Nmax (trees/ha)",
                 main = if (!is.null(title)) title else
                   paste0(sp$name_en, " self-thinning line"))
  if (has_max) {
    graphics::lines(dg, Nmax_density, lty = 2, col = "firebrick")
    graphics::legend("topright", legend = c("self-thinning", "max density"),
                     lty = c(1, 2), col = c("black", "firebrick"), cex = 0.8)
  }
  graphics::grid()

  if (!is.null(save_path)) grDevices::dev.off()
  invisible(NULL)
}
