#' Function to create some node
#'
#'@param nodeType Type of node. Default is \code{"Ridge"}.
#'
#'@param units (int) optional 
#'Number of reservoir units. If None, the number of units will be infered from
#'the \code{W} matrix shape.
#'
#'@param lr (float) default to 1.0
#'Neurons leak rate. Must be in :math:\code{[0, 1]}.
#'
#'@param sr (float) optional
#'Spectral radius of recurrent weight matrix.
#'
#'@param otputDim Output dimension of the Node. Dimension of its state.
#'
#'@param inputDim Input dimension of the Node.
#'
#'@param name Name of the Node. It must be a unique identifier.
#'
#'@param dtype Numerical type for node parameters
#'
#'@param ridge float, default to \code{0.0}. L2 regularization parameter. 
#'
#'@param inputBias bool, default to \code{TRUE}. If \code{TRUE}, then a bias parameter 
#'will be learned along with output weights.
#'
#' @examples
#' \dontrun{
#' readout <- createNode("Ridge")
#' }
#'@export
createNode <- function(nodeType = c("Ridge"), 
                       units = NULL,
                       lr = 1.0,
                       sr = NULL,
                       otputDim = NULL, 
                       inputDim = NULL, 
                       name = NULL,
                       ridge = 0.0,
                       inputBias = TRUE,
                       dtype = "float64") {
  
  stopifnot(!is.null(nodeType))

  if(nodeType == "Ridge"){
    node <- reservoirpy$nodes$Ridge(output_dim = otputDim, 
                                    name = name,
                                    ridge = ridge,
                                    input_bias = inputBias)
  }
  else if(nodeType=="Reservoir"){
    if(!is.null(units))
      #units <- noquote(paste0(as.integer(units),'L'))
      node <- reservoirpy$nodes$Reservoir(units = as.integer(units),
                                        lr = lr,
                                        sr = sr,
                                        name = name,
                                        input_bias = inputBias)
    else
      node <- reservoirpy$nodes$Reservoir(units = units,
                                          lr = lr,
                                          sr = sr,
                                          name = name,
                                          input_bias = inputBias)
  }else{
    NULL
  }
  return(py_to_r(node))
}



#' Link two :py:class:\code{~.Node} instances to form a :py:class:\code{~.Model}
#' instance. \code{node1} output will be used as input for \code{node2} in the
#' created model. This is similar to a function composition operation:
#' 
#'@details Can update the state of the node several times
#'
#'@param node1 (Node) or (list_of_Node)
#'Nodes or lists of nodes to link.
#'
#'@param node2 (Node) or (list_of_Node)
#'Nodes or lists of nodes to link.
#'
#'@param name (str) optional
#'Name for the chaining Model.
#'
#'@export
#'
link <- function(node1, node2, name = NULL){
  
  stopifnot(!is.null(node1) & !is.null(node2))
  
  link <- reservoirpy$link(node1, node2, name)
  return(py_to_r(link))
}



#' Run the node-forward function on a sequence of data
#' 
#'@details Can update the state of the node several times
#'
#'@param node node
#'
#'@param X array-like of shape \code{([n_inputs], timesteps, input_dim)}
#'A sequence of data of shape (timesteps, features).
#'
#'@param formState array of shape \code{(1, output_dim)}, optional 
#'Node state value to use at begining of computation.
#'
#'@param stateful \code{bool}, default to \code{TRUE} 
#'If True, Node state will be updated by this operation.
#'
#'@param reset \code{bool}, default to \code{FALSE}
#'If True, Node state will be reset to zero before this operation.
#'
#'@export
predict_seq <- function(node,X,
                        formState = NULL,
                        stateful = TRUE,
                        reset = FALSE){
  
  stopifnot(!is.null(node))
  stopifnot(is.list(X)| is.array(X))
  stopifnot(is.logical(stateful) & is.logical(reset))
  
  pred <- node$run(X, from_state = formState, 
                   stateful = stateful, 
                   reset=reset)
  return(pred)
}


#' Offline fitting method of a Node
#'
#'@param node node
#'
#'@param X \code{array-like} of shape \code{[n_inputs], [series], timesteps, input_dim)}, optional
#'Input sequences dataset. If None, the method will try to fit
#'the parameters of the Node using the precomputed values returned
#'by previous call of :py:meth:\code{partial_fit}.
#'
#'@param Y array-like of shape \code{([series], timesteps, output_dim)}, optional
#'Teacher signals dataset. If None, the method will try to fit
#'the parameters of the Node using the precomputed values returned
#'by previous call of :py:meth: \code{partial_fit}, or to fit the Node in
#'an unsupervised way, if possible.
#'
#'@param warmup : \code{int}, default to 0 
#'Number of timesteps to consider as warmup and 
#'discard at the begining of each timeseries before training.
#'
#'@export
fit <- function(node, X, Y, warmup = 0){
  
  stopifnot(!is.null(node))
  stopifnot(is.array(X) & is.array(Y))
  
  fit <- node$fit(X, Y, warmup = as.integer(warmup))
  return(py_to_r(fit))
}




#' @title
#' Load data from the Mackey-Glass delayed differential equation
#' 
#' @description
#' Mackey-Glass time series \code{[8]_ [9]_}~, computed from the Mackey-Glass
#' delayed differential equation:
#' 
#' @param n_timesteps (int) Number of time steps to compute.
#' @param tau (int), default to 17 
#' Time delay :math:`\\tau` of Mackey-Glass equation.
#' By defaults, equals to 17. Other values can
#' change the choatic behaviour of the timeseries.
#' @param a (float) default to 0.2
#' :math:`a` parameter of the equation.
#' @param b (float) default to 0.1
#' :math:`b` parameter of the equation.
#' @param n (int) default to 10
#' :math:`n` parameter of the equation.
#' @param x0 (float), optional, default to 1.2
#' Initial condition of the timeseries.
#' @param h (float), default to 1.0
#' Time delta between two discrete timesteps.
#' 
#' @return array of shape (n_timesteps, 1) Mackey-Glass timeseries.
#' 
#' @examples
#' \dontrun{
#' timeSerie <- generate_data(2500)
#' timeSerie
#' }
#' 
#' @export
generate_data <- function(n_timesteps, 
                          tau=17, a = 0.2, b = 0.1, 
                          n = 10, x0 = 1.2, h = 1.0){
  stopifnot(!is.null(n_timesteps))
  timeSerie <- reservoirpy$datasets$mackey_glass(as.integer(n_timesteps),
                                                 as.integer(tau),a,b,
                                                 as.integer(n),x0,h)
  return(as.vector(timeSerie))
}