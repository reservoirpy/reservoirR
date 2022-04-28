err_reservoirpy <- function(e) {
  message("Error importing reservoirpy")
  message("Check if reservoirpy is installed")
  message("Install by reservoir::install_reservoirpy() and reload library")
}

#' @import reticulate
reservoirpy <- NULL
.onLoad <- function(libname, pkgname) {
  reservoirpy <<- reticulate::import("reservoirpy",convert=FALSE,
                                     delay_load=list(on_error=err_reservoirpy))
}