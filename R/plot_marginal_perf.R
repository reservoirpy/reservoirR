#' plot_marginal_perf
#'
#' @description get marginal performance from dfPerf
#'
#' @param dfPerf The performance dataframe which should have the columns : perf, ridge, input_scaling, leaking_rate, spectral_radius. Where perf is the performance metric
#' @param color_cut The cutting point to highlight best values (default = 10)
#' @param perf_lab The label of the performance metric.
#'
#' @return A plot with 4 facets
#' @export
#' @importFrom dplyr arrange mutate
#' @importFrom magrittr %>%
#' 
#' @examples 
#' dfPerf <-
#' data.frame(
#'   perf = runif(n = 10),
#'   ridge = runif(n = 10),
#'   input_scaling = runif(n = 10),
#'   leaking_rate = runif(n = 10)
#' )
#' reservoirnet::plot_marginal_perf(dfPerf = dfPerf, color_cut = 2)
#' 
plot_marginal_perf <- function(dfPerf,
                               color_cut = 10,
                               perf_lab = "Median relative error"){
  dfPerf <- dfPerf %>%
    janitor::remove_constant()
  
  dfPerf %>%
    dplyr::arrange(.data$perf) %>%
    tibble::rowid_to_column(var = "rank_perf") %>%
    dplyr::mutate(rank_perf = .data$rank_perf <= color_cut) %>%
    tidyr::pivot_longer(cols = -c("perf", "rank_perf"),
                        values_to = "HP_value",
                        names_to = "HP") %>%
    ggplot(mapping = aes_string(x = "HP_value", y = "perf", color = "rank_perf")) +
    geom_point() +
    facet_wrap(. ~ HP, scales = "free") +
    scale_x_log10() +
    scale_y_log10() +
    scale_color_manual(values = c("black", "red")) +
    theme_bw() +
    theme(legend.position = "bottom") +
    labs(x = "Hyperparameter value",
         y = perf_lab,
         color = paste0(color_cut, " best performance")) +
    annotation_logticks()
}