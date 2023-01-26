#' rloguniform
#'
#' @description Simulate a log-uniform distribution
#'
#' @param n number of sample
#' @param min minimum of the distribution
#' @param max maximum of the distribution
#'
#' @return A vector of simulated values
#' @export
#'
#' @examples
#' rloguniform(n = 1)
rloguniform <- function(n, min = 10^-1, max = 10^2){
  vec_simu <- runif(n = n,
                    min = log(min, base = 10),
                    max = log(max, base = 10))
  vec_pwr_10 <- 10^vec_simu
  return(vec_pwr_10)
}