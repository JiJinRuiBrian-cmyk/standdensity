# 不安装也能跑：先 source 全部 R 源文件，再做一致性自检。
pkg_root <- if (dir.exists("R")) "." else ".."
src <- list.files(file.path(pkg_root, "R"), full.names = TRUE, pattern = "\\.R$")
for (f in src) source(f)

stopifnot(identical(list_species(),
  c("betula_alba", "chestnut_coppice", "chinese_fir",
    "douglas_fir_spain", "pedunculate_oak", "radiata_pine", "sweet_chestnut")))

# 杉木（Tang et al. 2016）——与原文表 3 对照。
sp <- get_species("chinese_fir")
cases <- list(
  c(3000, 7, 8.2, 58),
  c(1736, 10, 12.0, 90),
  c(1027, 13, 16.2, 114),
  c(678, 16, 20.4, 138),
  c(481, 19, 24.7, 161)
)
for (cc in cases) {
  m <- stand_predict(sp, cc[1], cc[2])
  stopifnot(abs(m$dg - cc[3]) < 0.11)
  stopifnot(abs(m$V - cc[4]) < 1.1)
}
stopifnot(abs(self_thinning_nmax(sp, 20) - 288500 * 20 ^ -1.613) < 1e-6)
a <- assess(sp, 1021, 12)
stopifnot(identical(a$density, "\u5408\u7406"))
stopifnot(identical(a$stability, "\u4e2d\u7b49"))
ts <- thin_schedule(sp)
stopifnot(nrow(ts$thinnings) == 3)

# 夏栎（Barrio-Anta & Alvarez-Gonzalez 2005；Xunta 2009 更新版）两方程。
sp_oak <- get_species("pedunculate_oak")
m_oak <- stand_predict(sp_oak, N = 740, Hd = 20)
dg_oak <- 33.66 * 740 ^ -0.3307 * 20 ^ 0.6185
V_oak <- 6.733e-05 * dg_oak ^ 1.872 * 20 ^ 0.9039 * 740
stopifnot(abs(m_oak$dg - dg_oak) < 1e-9)
stopifnot(abs(m_oak$V - V_oak) < 1e-6)
stopifnot(is.na(m_oak$Bs), is.na(m_oak$Bagb))
stopifnot(is.na(assess(sp_oak, N = 740, Hd = 20)$stability))

# 辐射松（Castedo-Dorado et al. 2009）四方程 + SC 稳定性。
sp_rp <- get_species("radiata_pine")
m_rp <- stand_predict(sp_rp, N = 917.94, Hd = 20.61)
stopifnot(abs(m_rp$dg - 105.2 * 917.94 ^ -0.4565 * 20.61 ^ 0.5091) < 1e-6)
V_rp <- 0.000035 * m_rp$dg ^ 2.000 * 20.61 ^ 0.9569 * 917.94 ^ 1.003
stopifnot(abs(m_rp$V - V_rp) < 1e-6)
stopifnot(identical(assess(sp_rp, N = 1000, Hd = 20)$stability, "\u7a33\u5b9a"))

# 甜栗高林（Patricio et al. 2017）四方程。
sp_sc <- get_species("sweet_chestnut")
m_sc <- stand_predict(sp_sc, N = 1000, Hd = 20)
dg_e <- 10.26562 * 1000 ^ -0.3082 * 20 ^ 0.973319
stopifnot(abs(m_sc$dg - dg_e) < 1e-9)
stopifnot(is.finite(m_sc$V), is.finite(m_sc$Bs), is.finite(m_sc$Bagb))
stopifnot(is.na(assess(sp_sc, N = 1000, Hd = 20)$stability))

# 白桦（Dieguez-Aranda et al. 2009 表 3.2）两方程。
sp_ba <- get_species("betula_alba")
m_ba <- stand_predict(sp_ba, N = 1769, Hd = 14.6)
dg_ba <- 13.86 * 1769 ^ -0.2721 * 14.6 ^ 0.7400
V_ba <- 3.898e-05 * dg_ba ^ 2.219 * 14.6 ^ 0.6523 * 1769 ^ 1.015
stopifnot(abs(m_ba$dg - dg_ba) < 1e-9)
stopifnot(abs(m_ba$V - V_ba) < 1e-6)
stopifnot(is.na(m_ba$Bs), is.na(m_ba$Bagb))

# 花旗松西班牙（Dieguez-Aranda et al. 2009 表 3.4）两方程。
sp_df_es <- get_species("douglas_fir_spain")
m_df <- stand_predict(sp_df_es, N = 838, Hd = 19.9)
dg_df <- 22.83 * 838 ^ -0.2915 * 19.9 ^ 0.6720
V_df <- 5.599e-05 * dg_df ^ 2.047 * 19.9 ^ 0.7592 * 838 ^ 1.002
stopifnot(abs(m_df$dg - dg_df) < 1e-9)
stopifnot(abs(m_df$V - V_df) < 1e-6)
stopifnot(is.na(m_df$Bs), is.na(m_df$Bagb))

# 甜栗矮林（Menendez-Miguelez et al. 2016）四方程（V/Bs/Bagb 无 dg 项）。
sp_cc <- get_species("chestnut_coppice")
m_cc <- stand_predict(sp_cc, N = 1230.8, Hd = 20.36)
dg_cc <- exp(2.143) * 1230.8 ^ -0.2291 * 20.36 ^ 0.8327
V_cc <- exp(-5.285) * 1230.8 ^ 0.5220 * 20.36 ^ 2.455
stopifnot(abs(m_cc$dg - dg_cc) < 1e-6)
stopifnot(abs(m_cc$V - V_cc) < 1e-4)
stopifnot(is.finite(m_cc$Bs), is.finite(m_cc$Bagb))

# 每种树出图冒烟测试。
for (code in list_species()) {
  fig <- tempfile(fileext = ".png")
  draw_sdmd(get_species(code), save_path = fig)
  stopifnot(file.exists(fig))
  unlink(fig)
}

cat("R self-check passed: 7 classic RS SDMD species, equations, classification and figures all consistent.\n")
