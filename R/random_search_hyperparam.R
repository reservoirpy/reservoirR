#' random_search_hyperparam
#'
#' @description Generate a hyperparameter simulation table using functions as input.
#'
#' @param ls_fct A list of functions
#' @param n Number of search
#'
#' @return A dataframe of size n x 4. Each row is a different set of hyperparameters.
#' @export
#'
#' @importFrom methods formalArgs
#' @importFrom stats runif
#'
#' @examples
#' random_search_hyperparam(
#'   n = 100,
#'   ls_fct = list(
#'     ridge = function(n)
#'       1e-5,
#'     input_scaling = function(n)
#'       1,
#'     spectral_radius = function(n)
#'       rloguniform(n = n, min = 1e-2, max = 10),
#'     leaking_rate = function(n)
#'       rloguniform(n = n, min = 1e-3, max = 1)
#'   )
#' )
#'
random_search_hyperparam <- function(n = 100,
                                     ls_fct = list(ridge = function(n) 1e-5,
                                                   input_scaling = function(n) 1,
                                                   spectral_radius = function(n) rloguniform(n = n, min = 1e-2, max = 10),
                                                   leaking_rate = function(n) rloguniform(n = n, min = 1e-3, max = 1),
                                                   input_connectivity= function(n) rloguniform(n = n, min = 1e-2, max = 1),
                                                   rc_connectivity = function(n) rloguniform(n = n, min = 1e-2, max = 1),
                                                   activation = function(n) sample(x = c("tanh", "identity"),
                                                                                   replace = TRUE,
                                                                                   size = n,
                                                                                   prob = c(.5, .5)))){
  
  # check all functions have only the n argument
  bool_n_argument <- lapply(ls_fct,
                            function(fct_i) methods::formalArgs(fct_i) != "n") %>%
    unlist() %>%
    any()
  stopifnot("All functions passed to random_search must have only one argument 'n'" != bool_n_argument)
  
  
  ls_fct %>%
    # generate data
    lapply(FUN = function(fct_i) fct_i(n)) %>%
    # bind and return results
    dplyr::bind_rows() %>%
    tibble::rowid_to_column(var = "search_id") %>%
    return()
}



