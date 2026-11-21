# 密度与稳定性分级，以及统一预测入口。

classify_density <- function(sp, rs = NULL, sc = NULL) {
  dens <- "\u8fc7\u5bc6"
  for (b in sp$rs_bands) {
    if (rs >= b[[1]]) dens <- b[[2]]
  }
  stab <- if (is.null(sp$sc_bands) || length(sp$sc_bands) == 0) {
    NA_character_
  } else {
    "\u4e0d\u7a33\u5b9a"
  }
  if (!is.null(sp$sc_bands)) {
    for (b in sp$sc_bands) {
      if (sc <= b[[1]]) stab <- b[[2]]
    }
  }
  list(density = dens, stability = stab)
}

predict_stand <- function(sp, N = NULL, Hd = NULL) {
  if (is.null(sp$stand)) stop(sp$code, " has no stand equations")
  if (is.null(N) || is.null(Hd)) stop("both N and Hd are required")
  stand_predict(sp, N, Hd)
}

assess <- function(sp, N, Hd) {
  out <- stand_predict(sp, N, Hd)
  cls <- classify_density(sp, out$RS, out$SC)
  c(out, cls)
}
