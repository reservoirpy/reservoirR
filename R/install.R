#'Install reservoirpy
#' 
#' @param envname \code{str} name of environment. Default is R-reticulate
#' @param method \code{str} type of environment type \code{(virtualenv, conda)}. 
#' Default is auto \code{(virtualenv is not available on Windows)}
#' 
#' @importFrom reticulate py_install
#' 
#' @return A NULL object after installing reservoirpy python module.
#' 
#'@examples
#'\dontrun{
#' reservoirnet::install_reservoirpy()
#'}
#'
#' @export
install_reservoirpy <- function(envname='r-reticulate', method='auto') {
  reticulate::py_install("reservoirpy", envname=envname, method=method, pip=TRUE)
}
