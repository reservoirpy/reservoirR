#' summary.reservoir_predict_seq
#'
#' @param object A reservoir_predict_seq object
#' @param ... Additional argument (unused)
#'
#' @return A dataframe with node activation
#' @export
#' 
#'
#'@examples
#' if(reticulate::py_module_available("reservoirpy")){
#' reservoir <- reservoirnet::createNode(nodeType = "Reservoir",
#'                                       seed = 1,
#'                                       units = 500,
#'                                       lr = 0.7,
#'                                       sr = 1,
#'                                       input_scaling = 1)
#' X <- matrix(data = rnorm(100), ncol = 4)
#' reservoir_state_stand <- reservoirnet::predict_seq(node = reservoir, X = X)
#' plot(reservoir_state_stand)
#' summary(reservoir_state_stand)
#' }
#'
summary.reservoir_predict_seq <- function(object, ...){
  object %>%
    unclass() %>%
    as.data.frame() %>%
    tibble::rowid_to_column(var = "time") %>%
    tidyr::pivot_longer(cols = dplyr::starts_with("V"),
                        names_to = "node") %>%
    dplyr::mutate(node = gsub(.data$node, pattern = "V", replacement = ""),
                  node = as.numeric(.data$node)) %>%
    return()
}

#' plot.reservoir_predict_seq
#'
#' @param x A reservoir_predict_seq object
#' @param ... deprecated
#' @param vec_nodes Number of nodes to plot
#' @param vec_time Time to plot
#'
#' @return A ggplot
#' @importFrom rlang .data
#' @export
#' 
#'
#'@examples
#' if(reticulate::py_module_available("reservoirpy")){
#' reservoir <- reservoirnet::createNode(nodeType = "Reservoir",
#'                                       seed = 1,
#'                                       units = 500,
#'                                       lr = 0.7,
#'                                       sr = 1,
#'                                       input_scaling = 1)
#' X <- matrix(data = rnorm(100), ncol = 4)
#' reservoir_state_stand <- reservoirnet::predict_seq(node = reservoir, X = X)
#' plot(reservoir_state_stand)
#' summary(reservoir_state_stand)
#' }
#'
plot.reservoir_predict_seq <- function(x,
                                       ...,
                                       vec_nodes = c(1:20),
                                       vec_time = NULL){
  dfsummary <- summary.reservoir_predict_seq(x)
  
  if(is.null(vec_time)) vec_time <- unique(dfsummary$time)
  
  dfplot <- dfsummary %>%
    dplyr::filter(.data$node %in% vec_nodes,
                  .data$time %in% vec_time) %>%
    dplyr::mutate(node = as.factor(.data$node))
  
  plot <- ggplot2::ggplot(dfplot,
                          mapping = ggplot2::aes(x = .data$time,
                                                 y = .data$value,
                                                 color = .data$node)) +
    ggplot2::geom_line() +
    ggplot2::theme_bw() +
    ggplot2::theme(legend.position = "none") +
    ggplot2::labs(x = "time", y = "Node activation")
  
  return(plot)
}

