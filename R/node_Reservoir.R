#' Create a reservoir network
#'
#' @param units Number of reservoir units. If NULL, the number of units will be inferred from the W matrix shape.
#' @param lr Leaking rate (1.0 by default).
#' @param sr Spectral radius of W (optional).
#' @param input_bias If False, no bias is added to inputs.
#' @param ... 
#'
#' @export
#' @examples
#' reservoirpy <- reticulate::import("reservoirpy")
#' node_Reservoir(units = as.integer(100), lr = 1.0, sr = 0.3)
node_Reservoir <- function(units = NULL,
                       lr = 1.0,
                       sr = NULL,
                       input_bias = TRUE,
                       ...){
  
  stopifnot("'units' must be an integer. Try as.integer(units)." = is.integer(units))
  
  node <- reservoirpy$nodes$Reservoir(units = units,
                                      lr = lr,
                                      sr = sr,
                                      input_bias = input_bias,
                                      ...)
  
  return(node)
}
