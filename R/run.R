#' Run the Node forward function on a sequence of data. Can update the state
#' of the Node several times.
#'
#'@param node node
#'
#'@param X \code{array-like} of shape \code{[n_inputs], [series], timesteps, input_dim)}, optional
#'Input sequences dataset. If None, the method will try to fit
#'the parameters of the Node using the precomputed values returned
#'by previous call of :py:meth:\code{partial_fit}.
#'
#'@param from_state \code{array-like} of shape \code{(1, output_dim)}, optional
#'Node state value to use at begining of computation
#'
#'@param stateful \code{bool}, default to TRUE
#' If True, Node state will be updated by this operation.
#' 
#'@param reset \code{bool}, default to FALSE
#' If True, Node state will be reset to zero before this operation.
#'
#'@export
run <- function(node,
                X,
                from_state = NULL,
                stateful = TRUE,
                reset = FALSE){
  
  stopifnot(!is.null(node))
  stopifnot(is.array(X) & is.logical(stateful) & is.logical(reset))
  
  run <-
    node$run(
      X = X,
      from_state = from_state,
      stateful = stateful,
      reset = reset
    )
  
  res <- py_to_r(run)
  class(res) <- "reservoir_run"
  return(res)
}

#' summary.reservoir_run
#'
#' @param object A reservoir_run object
#'
#' @return A dataframe with node activation
#' @export
summary.reservoir_run <- function(object){
  object %>%
    unclass() %>%
    as.data.frame() %>%
    tibble::rowid_to_column(var = "time") %>%
    tidyr::pivot_longer(cols = dplyr::starts_with("V"),
                        names_to = "node") %>%
    mutate(node = gsub(node, pattern = "V", replacement = ""),
           node = as.numeric(node)) %>%
    return()
}

#' plot.reservoir_run
#'
#' @param object A reservoir_run object
#' @param vec_nodes Number of nodes to plot
#' @param vec_time Time to plot
#'
#' @return A ggplot
#' @export
plot.reservoir_run <- function(object,
                               vec_nodes = c(1:20),
                               vec_time = NULL){
  dfsummary <- summary.reservoir_run(object)
  
  if(is.null(vec_time)) vec_time <- unique(dfsummary$time)
  
  dfplot <- dfsummary %>%
    dplyr::filter(node %in% vec_nodes,
                  time %in% vec_time) %>%
    dplyr::mutate(node = as.factor(node))
  
  plot <- ggplot2::ggplot(dfplot,
                          mapping = ggplot2::aes(x = time,
                                                 y = value,
                                                 color = node)) +
    ggplot2::geom_line() +
    ggplot2::theme(legend.position = "none")
  
  return(plot)
}

