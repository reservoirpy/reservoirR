#' plot_2x2_perf
#'
#' @description Plot 2x2 combinations of the hyperparameters.
#'
#' @param dfPerf The performance dataframe which should have the columns : perf, ridge, input_scaling, leaking_rate, spectral_radius. Where perf is the performance metric
#' @param perf_lab The label of the performance metric.
#' @param legend_position Position of legend passed to ggarrange
#' @param trans The transformation (default is "log10")
#'
#' @return A mutliple 2x2 plots.
#' @export
#' @import ggplot2
#' @importFrom ggpubr ggarrange
#' @importFrom janitor remove_constant
#' @importFrom utils combn
plot_2x2_perf <- function(dfPerf,
                          perf_lab = "Median relative error",
                          legend_position = "bottom",
                          trans = "log10"){
  
  dfPerf <- dfPerf %>%
    janitor::remove_constant()
  
  hp <- colnames(dfPerf)[colnames(dfPerf) != "perf"]
  mat_comb <- utils::combn(hp , 2 )
  
  ls_plot <- apply(mat_comb, 2, function(col_i){
    plot_perf_22(x = col_i[1],
                 y = col_i[2],
                 dfPerf = dfPerf,
                 perf_lab = perf_lab,
                 trans = trans)
  })
  
  ggpubr::ggarrange(plotlist = ls_plot,
                    common.legend = TRUE,
                    legend = legend_position)
}
