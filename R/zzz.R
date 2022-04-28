#' @importFrom reticulate
.onLoad <- function(libname, pkgname) {
  reservoirpy <<- reticulate::import("reservoirpy")
}