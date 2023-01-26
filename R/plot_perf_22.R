#' plot_perf_22
#'
#' @description Unit plot for 2x2 function
#'
#' @param x The x feature
#' @param y The y feature
#' @param dfPerf The performance dataframe which should have the columns : perf, ridge, input_scaling, leaking_rate, spectral_radius. Where perf is the performance metric
#' @param perf_lab The label of the performance metric.
#' @param trans The transformation (default is "log10")
#'
#' @return A 2x2 plot
#' @export
plot_perf_22 <- function(x, y, dfPerf, perf_lab, trans = "log10"){
  dfPerf %>%
    ggplot(mapping = aes_string(x = x, y = y, color = "perf")) +
    geom_point() +
    scale_x_log10() +
    scale_y_log10() +
    scale_color_viridis_c(trans = trans, direction = -1) +
    theme_dark() +
    labs(color = perf_lab) +
    annotation_logticks()
}
