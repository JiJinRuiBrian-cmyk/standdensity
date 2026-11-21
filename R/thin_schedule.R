# 优势高生长曲线推进时间 + RS 规则间伐，输出间伐方案。

thin_schedule <- function(sp = get_species("chinese_fir"),
                          N0 = 3000, RS_LO = 24, RS_HI = 36,
                          H_min = 7, H_max = 22, max_age = 60, step = 0.25,
                          A = NULL, B = NULL, C = NULL, ...) {
  if (is.null(A)) A <- 23.67023
  if (is.null(B)) B <- 0.05856
  if (is.null(C)) C <- 1.59679
  H_of_t   <- function(t) A * (1 - exp(-B * t)) ^ C
  N_for_RS <- function(rs, Hd) 10000 / (rs / 100 * Hd) ^ 2
  RS       <- function(N, Hd) sqrt(10000 / N) / Hd * 100

  t0 <- 0
  while (H_of_t(t0) < H_min && t0 < max_age) t0 <- t0 + 0.01

  N <- N0
  age <- t0
  managed <- list()
  thinnings <- list()
  traj <- list()

  while (H_of_t(age) < H_max && age < max_age) {
    Hd <- H_of_t(age)
    rs <- RS(N, Hd)
    if (rs <= RS_LO) {
      N_new <- N_for_RS(RS_HI, Hd)
      if (N_new < N - 1) {
        pb <- stand_predict(sp, N, Hd)
        pa <- stand_predict(sp, N_new, Hd)
        thinnings[[length(thinnings) + 1]] <- data.frame(
          age = age, Hd = Hd, N_before = N, N_after = N_new,
          V_removed = pb$V - pa$V
        )
        traj[[length(traj) + 1]] <- data.frame(Hd = Hd, N = N)
        N <- N_new
      }
    }
    m <- stand_predict(sp, N, Hd)
    managed[[length(managed) + 1]] <- data.frame(
      age = age, Hd = Hd, N = N, dg = m$dg, V = m$V,
      Bs = m$Bs, Bagb = m$Bagb, RS = rs
    )
    traj[[length(traj) + 1]] <- data.frame(Hd = Hd, N = N)
    age <- age + step
  }

  managed <- do.call(rbind, managed)
  thinnings <- if (length(thinnings)) do.call(rbind, thinnings) else data.frame()
  trajectory <- do.call(rbind, traj)
  list(managed = managed, thinnings = thinnings,
       trajectory = trajectory)
}
