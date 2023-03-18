#'reservoirR_fit summary
#'
#'summary S3 method for reservoirR_fit object
#'
#'@param object	an object of class \code{reservoirR_fit} to summarized.
#'@param ... further arguments.
#'
#'@return a \code{list} object
#'
#'@method summary reservoirR_fit
#'@export
#'
#'@examples
#' if(reticulate::py_module_available("reservoirpy")){
# reservoir <- reservoirnet::createNode(nodeType = "Reservoir",
#                                       seed = 1,
#                                       units = 500,
#                                       lr = 0.7,
#                                       sr = 1,
#                                       input_scaling = 1)
# ridge <- reservoirnet::createNode(nodeType = "Ridge", ridge = 0.01)
# model <- reservoirnet::link(node1 = reservoir, node2 = ridge)
# X <- matrix(data = rnorm(100), ncol = 4)
# Y <- as.matrix(X[,1] + 2*X[,2])
# fitted_model <- reservoirnet::reservoirR_fit(node = model, X = X, Y = Y)
# vec_pred <- reservoirnet::predict_seq(node = fitted_model$fit, X = X, reset = TRUE)
# plot(x = as.numeric(vec_pred), y = as.numeric(Y))
# summary(fitted_model)
# print(fitted_model)
#' }
#'

summary.reservoirR_fit <- function(object, ...){
  res <- list()
  res[["res_fit"]] <- object$fit
  res[["warmup"]] <- object$params$warmup
  res[["stateful"]] <- object$params$stateful
  res[["reset"]] <- object$params$reset
  
  class(res) <- "summary.reservoirR_fit"
  
  return(res)
}

#'reservoirR_fit print summary
#'
#'print S3 method for summary.reservoirR_fit object
#'
#'@param x	an object of class \code{summary.reservoirR_fit} to print.
#'@param ... further arguments.
#'
#'@return A NULL object which shows the model setting to perform the reservoir
#' fit.
#'
#'@method print summary.reservoirR_fit
#'@export
#'
#'@examples
#' if(reticulate::py_module_available("reservoirpy")){
# reservoir <- reservoirnet::createNode(nodeType = "Reservoir",
#                                       seed = 1,
#                                       units = 500,
#                                       lr = 0.7,
#                                       sr = 1,
#                                       input_scaling = 1)
# ridge <- reservoirnet::createNode(nodeType = "Ridge", ridge = 0.01)
# model <- reservoirnet::link(node1 = reservoir, node2 = ridge)
# X <- matrix(data = rnorm(100), ncol = 4)
# Y <- as.matrix(X[,1] + 2*X[,2])
# fitted_model <- reservoirnet::reservoirR_fit(node = model, X = X, Y = Y)
# vec_pred <- reservoirnet::predict_seq(node = fitted_model$fit, X = X, reset = TRUE)
# plot(x = as.numeric(vec_pred), y = as.numeric(Y))
# summary(fitted_model)
# print(fitted_model)
#' }
#' 

print.summary.reservoirR_fit <- function(x, ...){
  cat("Parameters using to fit:\n warmup:",x$warmup,"; stateful:", x$stateful, "; reset:",x$reset,"\n")
  cat("results of fitting:\n")
  print(x$res_fit)
  return(NULL)
}