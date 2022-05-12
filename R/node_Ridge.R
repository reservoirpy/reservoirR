#' Ridge readout
#'
#' @param ridge float, default to \code{0.0}. L2 regularization parameter. 
#' @param input_bias If True, then a bias parameter will be learned along with output weights.
#' @param ... Additional arguments given to Ridge methods of reservoirpy
#'
#' @export
#' @examples
#' \dontrun{
#' node_Ridge(ridge = 0.5)
#' }
node_Ridge <- function(ridge = 0.0,
                       input_bias = TRUE,
                       ...) {
  
  node <- reservoirpy$nodes$Ridge(ridge = ridge,
                                  input_bias = input_bias,
                                  ...)
  
  return(node)
}

