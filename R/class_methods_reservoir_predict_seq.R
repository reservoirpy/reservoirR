#' summary.reservoir_predict_seq
#'
#' @param object A reservoir_predict_seq object
#'
#' @return A dataframe with node activation
#' @export
summary.reservoir_predict_seq <- function(object){
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

#' plot.reservoir_predict_seq
#'
#' @param object A reservoir_predict_seq object
#' @param vec_nodes Number of nodes to plot
#' @param vec_time Time to plot
#'
#' @return A ggplot
#' @export
plot.reservoir_predict_seq <- function(object,
                               vec_nodes = c(1:20),
                               vec_time = NULL){
  dfsummary <- summary.reservoir_predict_seq(object)
  
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
    ggplot2::theme_bw() +
    ggplot2::theme(legend.position = "none") +
    ggplot2::labs(x = "time", y = "Node activation")
  
  return(plot)
}

