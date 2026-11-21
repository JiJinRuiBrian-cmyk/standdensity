# SDMD 密度管理图（base R 绘图，统一模板）。

.sdmd_palette <- list(
  structure = "gray35",
  diameter  = "firebrick",
  volume    = "steelblue",
  biomass   = "forestgreen",
  carbon    = "darkorchid",
  trajectory = "red"
)

# macOS 上用系统自带中文字体，避免图例/坐标轴中文显示成方框。
.cjk_family <- function() {
  if (Sys.info()[["sysname"]] == "Darwin") "PingFang SC" else ""
}

.open_graphics <- function(save_path, width = 8, height = 7, res = 150) {
  if (is.null(save_path)) return(invisible(NULL))
  mac <- Sys.info()[["sysname"]] == "Darwin"
  if (grepl("\\.png$", save_path, ignore.case = TRUE)) {
    if (mac) {
      grDevices::png(save_path, width = width, height = height, units = "in",
                     res = res, type = "quartz", family = .cjk_family())
    } else {
      grDevices::png(save_path, width = width, height = height,
                     units = "in", res = res)
    }
  } else {
    if (mac) {
      grDevices::cairo_pdf(save_path, width = width, height = height,
                           family = .cjk_family())
    } else {
      grDevices::pdf(save_path, width = width, height = height)
    }
  }
  invisible(NULL)
}

draw_sdmd <- function(sp = get_species("chinese_fir"),
                      Hd_range = c(6, 24), N_range = c(30, 3000),
                      show_volume = TRUE, show_biomass = TRUE,
                      trajectory = NULL, save_path = NULL, title = NULL, ...) {
  c <- sp$stand
  Hd <- seq(Hd_range[1], Hd_range[2], length.out = 200)

  plot_family <- function(values, solve_N, col, lty, lwd, fmt) {
    for (v in values) {
      N <- solve_N(v, Hd)
      ok <- N >= N_range[1] & N <= N_range[2]
      if (any(ok)) {
        graphics::lines(Hd[ok], N[ok], col = col, lwd = lwd, lty = lty)
        x <- Hd[ok][sum(ok)]
        y <- N[ok][sum(ok)]
        graphics::text(x, y, labels = sprintf(fmt, v), col = col,
                       cex = 0.6, adj = c(1, 0.5))
      }
    }
  }

  .open_graphics(save_path)

  graphics::plot(NA, NA, xlim = Hd_range, ylim = N_range, log = "y",
                 xlab = "Dominant height Hd (m)",
                 ylab = "Stem number N (trees/ha)",
                 main = if (!is.null(title)) title else
                   paste0(sp$name_en, " stand density management diagram"))
  graphics::grid(col = "gray90")

  leg_col <- character(0); leg_lty <- numeric(0); leg_lab <- character(0)

  plot_family(c(8, 12, 16, 24, 36, 50, 70),
              function(rs, h) 10000 / (rs / 100 * h) ^ 2,
              .sdmd_palette$structure, 3, 1, "%s%%")
  leg_col <- c(leg_col, .sdmd_palette$structure); leg_lty <- c(leg_lty, 3)
  leg_lab <- c(leg_lab, "Relative spacing RS")
  plot_family(c(6, 10, 15, 20, 25, 30, 40),
              function(dg, h) (c$dg$a * h ^ c$dg$Hd_exp / dg) ^ (-1 / c$dg$N_exp),
              .sdmd_palette$diameter, 1, 1, "%s cm")
  leg_col <- c(leg_col, .sdmd_palette$diameter); leg_lty <- c(leg_lty, 1)
  leg_lab <- c(leg_lab, "Mean diameter dg")

  if (show_volume && !is.null(c$V)) {
    k  <- c$V$a * c$dg$a ^ c$V$dg_exp
    e1 <- c$dg$N_exp * c$V$dg_exp + c$V$N_exp
    e2 <- c$dg$Hd_exp * c$V$dg_exp + c$V$Hd_exp
    plot_family(c(50, 100, 150, 200, 250, 300),
                function(v, h) (v / (k * h ^ e2)) ^ (1 / e1),
                .sdmd_palette$volume, 1, 1, "%s")
    leg_col <- c(leg_col, .sdmd_palette$volume); leg_lty <- c(leg_lty, 1)
    leg_lab <- c(leg_lab, "Volume V")
  }

  if (show_biomass && !is.null(c$Bagb)) {
    k  <- c$Bagb$a * c$dg$a ^ c$Bagb$dg_exp
    e1 <- c$dg$N_exp * c$Bagb$dg_exp + c$Bagb$N_exp
    e2 <- c$dg$Hd_exp * c$Bagb$dg_exp + c$Bagb$Hd_exp
    plot_family(c(25, 50, 75, 100, 150),
                function(w, h) (w / (k * h ^ e2)) ^ (1 / e1),
                .sdmd_palette$biomass, 2, 1, "%s")
    leg_col <- c(leg_col, .sdmd_palette$biomass); leg_lty <- c(leg_lty, 2)
    leg_lab <- c(leg_lab, "Aboveground biomass")
  }

  if (!is.null(trajectory)) {
    graphics::lines(trajectory[, 1], trajectory[, 2],
                    col = .sdmd_palette$trajectory, lwd = 2)
  }

  graphics::legend("bottomleft", legend = leg_lab, col = leg_col,
                   lty = leg_lty, lwd = 1, cex = 0.75, bg = "white")

  if (!is.null(save_path)) grDevices::dev.off()
  invisible(NULL)
}
