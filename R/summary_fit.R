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
#'@param res	an object of class \code{summary.reservoirR_fit} to print.
#'@param ... further arguments.
#'
#'@return NULL
#'
#'@method print summary.reservoirR_fit
#'@export

print.summary.reservoirR_fit <- function(res, ...){
  cat("Parametrs using to fit:\n warmup:",res$warmup,"; stateful:", res$stateful, "; reset:",res$reset,"\n")
  cat("results of fitting:\n")
  print(res$res_fit)
}