#'Install reservoirpy
#' 
#' @param envname \code{str} name of environment. Default is R-reticulate
#' @param method \code{str} type of environment type \code{(virtualenv, conda)}. 
#' Default is auto \code{(virtualenv is not available on Windows)}
#' 
#' @export
install_reservoirpy <- function(envname='r-reticulate', method='auto') {
  reticulate::py_install("reservoirpy", envname=envname, method=method, pip=T)
}
