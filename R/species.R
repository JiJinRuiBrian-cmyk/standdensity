# -*- coding: utf-8 -*-
# 经典 RS 型 SDMD 树种参数库（7 树种）。

.chinese_fir <- list(
  code = "chinese_fir",
  name_zh = "\u6749\u6728",
  name_en = "Chinese fir",
  latin = "Cunninghamia lanceolata (Lamb.) Hook",
  model_type = "stand",
  source = "Tang et al. 2016, Forestry 89(1): 36-45",
  region = "\u5b89\u5fbd\u77f3\u53f0\u53ca\u7acb\u5730\u76f8\u8fd1\u7684\u6749\u6728\u4eba\u5de5\u6797",
  dbh_min = 10.0,
  hd = list(a = 2.0208, b = 0.3461),
  tree = list(
    stem   = list(k = 0.020232, d_exp = 1.9348, h_exp = 0.9674),
    branch = list(k = 0.011774, d_exp = 3.7416, h_exp = -1.6029),
    leaf   = list(k = 0.031911, d_exp = 3.2070, h_exp = -1.5105),
    volume = list(k = 0.000071, d_exp = 1.7512, h_exp = 1.0417)
  ),
  stand = list(
    dg   = list(a = 3.3739, N_exp = -0.1079, Hd_exp = 0.9023),
    V    = list(a = 0.000063, dg_exp = 2.4941, Hd_exp = 0.1520, N_exp = 1.0214),
    Bs   = list(a = 0.000015, dg_exp = 2.5760, Hd_exp = 0.2230, N_exp = 1.0299),
    Bagb = list(a = 0.000029, dg_exp = 2.5968, Hd_exp = 0.1375, N_exp = 1.0037)
  ),
  reineke = list(k = 288500.0, b = -1.613,
                 note = "Meng et al. 2019, J. Beijing For. Univ. 41(12) (Fujian Chinese fir self-thinning equation)"),
  carbon_factor = 0.5201,
  rs_bands = list(list(0, "\u8fc7\u5bc6"), list(16, "\u9ad8\u5bc6\u5ea6"),
                  list(24, "\u5408\u7406"), list(36, "\u504f\u758f"),
                  list(50, "\u660e\u663e\u7a00\u758f")),
  sc_bands = list(list(60, "\u7a33\u5b9a"), list(90, "\u4e2d\u7b49"))
)

# 夏栎：两方程联立（dg、V），相对间距 RS 表征密度。2005 论文只有 dg 与 V 两式，无生物量方程。
# 系数为 Xunta de Galicia 2009 手册表 3.6 的更新版（对 dg、V 重拟合），已用生产表验证。
.pedunculate_oak <- list(
  code = "pedunculate_oak",
  name_zh = "\u590f\u680e",
  name_en = "Pedunculate oak",
  latin = "Quercus robur L.",
  model_type = "stand",
  source = "Barrio-Anta & Alvarez-Gonzalez 2005, Forestry 78(3): 209-216, DOI 10.1093/forestry/cpi033; updated dg/V in Dieguez-Aranda et al. 2009 'Herramientas selvicola' Table 3.6",
  region = "\u897f\u73ed\u7259\u52a0\u5229\u897f\u4e9a\u590f\u6809\u5929\u7136\u6797",
  dbh_min = 8.0,
  hd = NULL,
  tree = NULL,
  stand = list(
    dg   = list(a = 33.66, N_exp = -0.3307, Hd_exp = 0.6185),
    V    = list(a = 6.733e-05, dg_exp = 1.872, Hd_exp = 0.9039, N_exp = 1.0),
    Bs   = NULL,
    Bagb = NULL
  ),
  reineke = NULL,
  carbon_factor = 0.5,
  rs_bands = list(list(0, "\u8fc7\u5bc6"), list(14, "\u9ad8\u5bc6\u5ea6"),
                  list(24, "\u5408\u7406"), list(36, "\u504f\u758f"),
                  list(50, "\u660e\u663e\u7a00\u758f")),
  sc_bands = NULL
)

# 辐射松：四方程联立（FIML），含高径比 SC 稳定性判定。
# 参数来源：Castedo-Dorado et al. 2009, Forestry 82(1): 1-16, DOI 10.1093/forestry/cpm032。
.radiata_pine <- list(
  code = "radiata_pine",
  name_zh = "\u8f90\u5c04\u677e",
  name_en = "Radiata pine",
  latin = "Pinus radiata D. Don",
  model_type = "stand",
  source = "Castedo-Dorado et al. 2009, Forestry 82(1): 1-16, DOI 10.1093/forestry/cpm032",
  region = "\u897f\u73ed\u7259\u52a0\u5229\u897f\u4e9a\u8f90\u5c04\u677e\u4eba\u5de5\u6797",
  dbh_min = 8.0,
  hd = NULL,
  tree = NULL,
  stand = list(
    dg   = list(a = 105.2, N_exp = -0.4565, Hd_exp = 0.5091,
                note = "\u7cfb\u6570\u7531 green-OA \u7248 PDF \u8f6c\u7801\uff1bSE(b0,b1,b2)=13.23,0.0111,0.0263"),
    V    = list(a = 0.000035, dg_exp = 2.000, Hd_exp = 0.9569, N_exp = 1.003,
                note = "\u603b\u84c4\u79ef(di=0)\uff1b\u5546\u54c1\u6750\u4e58 exp(-0.2788*di^3.101*dg^-2.708)"),
    Bs   = list(a = 2.3e-05, dg_exp = 1.928, Hd_exp = 0.9210, N_exp = 1.007),
    Bagb = list(a = 1.2e-05, dg_exp = 1.885, Hd_exp = 1.140, N_exp = 0.997)
  ),
  sc = list(form = "linear", a_h = -1.712, b_h = 0.9574,
            a_d = -0.4155, b_d = 0.9761,
            note = "\u539f\u6587\u5f0f(7)(8)\uff1ah_bar=a_h+b_h*Hd; d_bar=a_d+b_d*dg; SC=100*h_bar/d_bar"),
  reineke = NULL,
  carbon_factor = 0.5,
  rs_bands = list(list(0, "\u8fc7\u5bc6"), list(16, "\u9ad8\u5bc6\u5ea6"),
                  list(24, "\u5408\u7406"), list(36, "\u504f\u758f"),
                  list(50, "\u660e\u663e\u7a00\u758f")),
  sc_bands = list(list(90, "\u7a33\u5b9a"))
)

# 甜栗（高林）：四方程联立（FIML）。
# 参数来源：Patricio et al. 2017, iForest 10(6): 865-870, DOI 10.3832/ifor2411-010。
.sweet_chestnut <- list(
  code = "sweet_chestnut",
  name_zh = "\u751c\u6817",
  name_en = "Sweet chestnut",
  latin = "Castanea sativa Mill.",
  model_type = "stand",
  source = "Patricio et al. 2017, iForest 10(6): 865-870, DOI 10.3832/ifor2411-010",
  region = "\u8461\u8404\u7259\u5317\u90e8\u751c\u6817\u7eaf\u6797\uff08\u9ad8\u6797\u4f5c\u4e1a\uff09",
  dbh_min = 1.5,
  hd = NULL,
  tree = NULL,
  stand = list(
    dg   = list(a = 10.26562, N_exp = -0.3082, Hd_exp = 0.973319),
    V    = list(a = 0.000031, dg_exp = 2.146777, Hd_exp = 0.801093, N_exp = 1.018115),
    Bs   = list(a = 0.000019, dg_exp = 2.039638, Hd_exp = 0.855506, N_exp = 1.019766),
    Bagb = list(a = 0.000021, dg_exp = 2.073444, Hd_exp = 0.867747, N_exp = 1.013969)
  ),
  reineke = NULL,
  carbon_factor = 0.5,
  rs_bands = list(list(0, "\u8fc7\u5bc6"), list(16, "\u9ad8\u5bc6\u5ea6"),
                  list(24, "\u5408\u7406"), list(36, "\u504f\u758f"),
                  list(50, "\u660e\u663e\u7a00\u758f")),
  sc_bands = NULL
)

# 白桦：两方程联立（dg、V），相对间距 RS 表征密度。
# 系数为 Xunta de Galicia 2009 手册表 3.2（Dieguez-Aranda et al. 2009），已用生产表验证。
.betula_alba <- list(
  code = "betula_alba",
  name_zh = "\u767d\u6866",
  name_en = "Birch",
  latin = "Betula alba L.",
  model_type = "stand",
  source = "Dieguez-Aranda et al. 2009 'Herramientas selvicola...' Table 3.2 (Galicia static SDMD, two-equation)",
  region = "\u897f\u73ed\u7259\u52a0\u5229\u897f\u4e9a\u767d\u6866\u5929\u7136\u6797",
  dbh_min = 7.0,
  hd = NULL,
  tree = NULL,
  stand = list(
    dg   = list(a = 13.86, N_exp = -0.2721, Hd_exp = 0.7400),
    V    = list(a = 3.898e-05, dg_exp = 2.219, Hd_exp = 0.6523, N_exp = 1.015),
    Bs   = NULL,
    Bagb = NULL
  ),
  reineke = NULL,
  carbon_factor = 0.5,
  rs_bands = list(list(0, "\u8fc7\u5bc6"), list(16, "\u9ad8\u5bc6\u5ea6"),
                  list(24, "\u5408\u7406"), list(36, "\u504f\u758f"),
                  list(50, "\u660e\u663e\u7a00\u758f")),
  sc_bands = NULL
)

# 花旗松（西班牙）：两方程联立（dg、V），相对间距 RS 表征密度。
# 系数为 Xunta de Galicia 2009 手册表 3.4，已用生产表验证。
.douglas_fir_spain <- list(
  code = "douglas_fir_spain",
  name_zh = "\u82b1\u65d7\u677e\uff08\u897f\u73ed\u7259\uff09",
  name_en = "Douglas-fir (Spain)",
  latin = "Pseudotsuga menziesii (Mirb.) Franco",
  model_type = "stand",
  source = "Dieguez-Aranda et al. 2009 'Herramientas selvicola...' Table 3.4 (Spain static SDMD, two-equation)",
  region = "\u897f\u73ed\u7259\u82b1\u65d7\u677e\u4eba\u5de5\u6797",
  dbh_min = 8.0,
  hd = NULL,
  tree = NULL,
  stand = list(
    dg   = list(a = 22.83, N_exp = -0.2915, Hd_exp = 0.6720),
    V    = list(a = 5.599e-05, dg_exp = 2.047, Hd_exp = 0.7592, N_exp = 1.002),
    Bs   = NULL,
    Bagb = NULL
  ),
  reineke = NULL,
  carbon_factor = 0.5,
  rs_bands = list(list(0, "\u8fc7\u5bc6"), list(16, "\u9ad8\u5bc6\u5ea6"),
                  list(24, "\u5408\u7406"), list(36, "\u504f\u758f"),
                  list(50, "\u660e\u663e\u7a00\u758f")),
  sc_bands = NULL
)

# 甜栗矮林（Castanea sativa 矮林）：四方程，相对间距 RS（三角分布）表征密度。
# 与甜栗高林不同，V/Bs/Bagb 直接由 N、H0 表达（无 dg 中间项，故 dg_exp=0）。
# 参数来源：Menendez-Miguelez et al. 2016, Bosque 37(1): 119-133, DOI 10.4067/S0717-92002016000100012。
.chestnut_coppice <- list(
  code = "chestnut_coppice",
  name_zh = "\u751c\u6817\u77ee\u6797",
  name_en = "Sweet chestnut (coppice)",
  latin = "Castanea sativa Mill.",
  model_type = "stand",
  source = "Menendez-Miguelez et al. 2016, Bosque 37(1): 119-133, DOI 10.4067/S0717-92002016000100012",
  region = "\u897f\u73ed\u7259\u897f\u5317\u90e8\u751c\u6817\u77ee\u6797",
  dbh_min = 9.5,
  hd = NULL,
  tree = NULL,
  stand = list(
    dg   = list(a = 8.524974, N_exp = -0.2291, Hd_exp = 0.8327,
                note = "Ln(dg)=2.143-0.2291*Ln(N)+0.8327*Ln(H0)"),
    V    = list(a = 0.005067032, dg_exp = 0, Hd_exp = 2.455, N_exp = 0.5220,
                note = "Ln(V)=-5.285+0.5220*Ln(N)+2.455*Ln(H0); R2adj=0.61"),
    Bs   = list(a = 0.001188575, dg_exp = 0, Hd_exp = 2.616, N_exp = 0.5386,
                note = "stem biomass; R2adj=0.67"),
    Bagb = list(a = 0.005594339, dg_exp = 0, Hd_exp = 2.229, N_exp = 0.5231,
                note = "total aboveground biomass; R2adj=0.57")
  ),
  reineke = NULL,
  carbon_factor = 0.5,
  rs_bands = list(list(0, "\u8fc7\u5bc6"), list(16, "\u9ad8\u5bc6\u5ea6"),
                  list(24, "\u5408\u7406"), list(36, "\u504f\u758f"),
                  list(50, "\u660e\u663e\u7a00\u758f")),
  sc_bands = NULL
)

.species_db <- list(chinese_fir = .chinese_fir,
                    pedunculate_oak = .pedunculate_oak,
                    radiata_pine = .radiata_pine,
                    sweet_chestnut = .sweet_chestnut,
                    betula_alba = .betula_alba,
                    douglas_fir_spain = .douglas_fir_spain,
                    chestnut_coppice = .chestnut_coppice)

list_species <- function() {
  sort(names(.species_db))
}

get_species <- function(code = "chinese_fir") {
  if (!code %in% names(.species_db)) {
    stop("unknown species: ", code, "; available: ",
         paste(list_species(), collapse = ", "))
  }
  .species_db[[code]]
}

add_species <- function(sp) {
  if (is.null(sp$code)) stop("species record must have a 'code' field")
  .species_db[[sp$code]] <<- sp
  invisible(sp)
}
