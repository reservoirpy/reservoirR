#' Function to create some node
#'
#'@param nodeType 
#'
#'@param otputDim Output dimension of the Node. Dimension of its state.
#'
#'@param inputDim Input dimension of the Node.
#'
#'@param name Name of the Node. It must be a unique identifier.
#'
#'@param dtype Numerical type for node parameters
#'
#'@param ridge float, default to 0.0 L2 regularization parameter. 
#'
#'@param inputBias bool, default to True If True, then a bias parameter will 
#'be learned along with output weights.

createNode <- function(nodeType=c("Ridge"), 
                       otputDim=NULL, 
                       inputDim=NULL, 
                       name=NULL,
                       ridge=0.0,
                       inputBias=TRUE,
                       dtype="float64") {
  stopifnot(!is.null(nodeType))
  
  if(nodeType == "Ridge"){
    dtype = np$dtype(dtype)
    node <- reservoirpy$nodes$Ridge(output_dim = otputDim, 
                                    input_dim = inputDim, 
                                    name = name,
                                    ridge = ridge,
                                    input_bias = inputBias,
                                    dtype = dtype)
  }
  else if(nodeType=="Reservoir"){
    NULL
  }else{
    NULL
  }
  return(node)
}



#' Run the Node forward function on a sequence of data.
#' Can update the state of the
#' Node several times
#'
#'@param node 
#'
#'@param X array-like of shape \code{([n_inputs], timesteps, input_dim)}
#'A sequence of data of shape (timesteps, features).
#'
#'@param formState array of shape \code{(1, output_dim)}, optional 
#'Node state value to use at begining of computation.
#'
#'@param stateFul \code{bool}, default to \code{True} 
#'If True, Node state will be updated by this operation.
#'
#'@param reset \code{bool}, default to \code{False}
#'If True, Node state will be reset to zero before this operation.


predict_seq(node,X,
            formState = NULL,
            stateFul = TRUE,
            reset = FALSE){
  
  stopifnot(!is.null(node))
  stopifnot(is.list(X)| is.array(X))
  stopifnot(is.logical(stateFul) & is.logical(reset))
  
  pred <- node$run(X, from_state = formState, 
           state_ful = stateFul, 
           reset=reset)
  return(pred)
}


#' Offline fitting method of a Node.
#'
#'@param node 
#'
#'@param X \code{array-like} of shape \code{[n_inputs], [series], timesteps, input_dim)}, optional
#'Input sequences dataset. If None, the method will try to fit
#'the parameters of the Node using the precomputed values returned
#'by previous call of :py:meth:\code{partial_fit}.
#'
#'@paramm Y array-like of shape \code{([series], timesteps, output_dim)}, optional
#'Teacher signals dataset. If None, the method will try to fit
#'the parameters of the Node using the precomputed values returned
#'by previous call of :py:meth: \code{partial_fit}, or to fit the Node in
#'an unsupervised way, if possible.
#'
#'@param warmup : \code{int}, default to 0 
#'Number of timesteps to consider as warmup and 
#'discard at the begining of each timeseries before training.


fit(node,X,Y,warmup = 0){
  
  stopifnot(!is.null(node))
  stopifnot(is.array(X) & is.array(Y))
  
  wramup <- as.integer(wramup)
  fit <- node$fit(X, Y = Y,warmup = warmup)
  return(fit)
}

























