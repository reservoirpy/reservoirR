#' Extract the Last Reservoir State for Each Input Sequence
#'
#' This function computes the reservoir states for a given set of input sequences
#' and extracts the final state of the reservoir for each sequence.
#'
#' @param node A trained reservoir network model (from the `reservoirnet` package).
#' @param X A list of input sequences, where each element is a matrix of input data.
#'
#' @return A list containing the last reservoir state for each input sequence.
#' Each element of the returned list is a matrix representing the final state of the reservoir
#' for a corresponding input sequence in `X`.
#'
#' @examples
#' \dontrun{
#' library(reservoirnet)
#' node <- reservoirnet::createNode("Reservoir", units = 100,
#'                                  lr=0.1, sr=0.9,
#'                                  seed = 1)
#' X <- list(matrix(runif(100), ncol = 1), matrix(runif(200), ncol = 1))  # Example input sequences
#' last_states <- last_reservoir_state(node, X)
#' print(last_states)
#' }
#'
#' @export
last_reservoir_state <- function(node, X){
  ls_res <- lapply(X,
                   function(x){
                     states <- reservoirnet::predict_seq(node = node, X = x,
                                                         reset = TRUE)
                     res <- t(as.matrix(states[nrow(states),]))
                     return(res)
                   })
  return(ls_res)
}

