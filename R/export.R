# JSON 导出：用于参数归档与交接（零第三方依赖）。

.json_escape <- function(s) {
  s <- gsub("\\\\", "\\\\\\\\", s)
  s <- gsub("\"", "\\\\\"", s)
  s <- gsub("\n", "\\\\n", s)
  s <- gsub("\r", "\\\\r", s)
  s <- gsub("\t", "\\\\t", s)
  s
}

.to_json <- function(x) {
  if (is.null(x)) return("null")
  if (is.list(x)) {
    nms <- names(x)
    if (is.null(nms) || all(nms == "")) {
      return(paste0("[", paste(vapply(x, .to_json, character(1)), collapse = ","), "]"))
    }
    parts <- vapply(seq_along(x), function(i) {
      paste0("\"", nms[i], "\":", .to_json(x[[i]]))
    }, character(1))
    return(paste0("{", paste(parts, collapse = ","), "}"))
  }
  if (is.logical(x)) {
    if (length(x) == 1) return(if (is.na(x)) "null" else if (x) "true" else "false")
    return(paste0("[", paste(vapply(x, function(v) {
      if (is.na(v)) "null" else if (v) "true" else "false"
    }, character(1)), collapse = ","), "]"))
  }
  if (is.numeric(x)) {
    if (length(x) == 1) return(if (is.na(x)) "null" else as.character(x))
    return(paste0("[", paste(vapply(x, function(v) {
      if (is.na(v)) "null" else as.character(v)
    }, character(1)), collapse = ","), "]"))
  }
  if (is.character(x)) {
    if (length(x) == 1) return(if (is.na(x)) "null" else paste0("\"", .json_escape(x), "\""))
    return(paste0("[", paste(vapply(x, function(v) {
      if (is.na(v)) "null" else paste0("\"", .json_escape(v), "\"")
    }, character(1)), collapse = ","), "]"))
  }
  paste0("\"", .json_escape(as.character(x)[1]), "\"")
}

export_species <- function(code, path) {
  sp <- get_species(code)
  writeLines(.to_json(sp), path, useBytes = TRUE)
  invisible(path)
}

export_all <- function(dir) {
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  for (code in list_species()) {
    export_species(code, file.path(dir, paste0(code, ".json")))
  }
  invisible(list.files(dir, full.names = TRUE))
}
