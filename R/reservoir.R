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
#'@param ridge float, default to \code{0.0}. L2 regularization parameter. 
#'
#'@param inputBias bool, default to \code{TRUE}. If \code{TRUE}, then a bias parameter 
#'will be learned along with output weights.
#'
#'@param input_scaling float or array-like of shapes (features), default to \code{1.0}.
#' Input gain. An array of the same dimension as the inputs can be used to
#' set up different input scaling for each feature.
#'
#'@param dtype Numerical type for node parameters
#'
#'@param ... Others params
#'
#' @param rc_connectivity float, default to 0.1. Connectivity of recurrent weight matrix, i.e. ratio of reservoir neurons connected to other reservoir neurons, including themselves. Must be between 0 and 1. 
#' @param input_connectivity float, default to 0.1. Connectivity of input neurons, i.e. ratio of input neurons connected to reservoir neurons. Must be between 0 and 1.
#' @param activation str 'tanh'. Reservoir units activation function. Should be a activationsfunc function name ('tanh', 'identity', 'sigmoid', 'relu', 'softmax', 'softplus').
#'
#'@examples
#' if(interactive()){
#' readout <- createNode("Ridge")
#' }
#' 
#'@importFrom reticulate py_to_r
#'@import testthat
#'
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
                       input_scaling = TRUE,
                       input_connectivity = 0.1,
                       rc_connectivity = 0.1,
                       activation = "tanh",
                       dtype = "float64",
                       ...) {
  
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
                                          input_bias = inputBias,
                                          input_scaling = input_scaling,
                                          rc_connectivity = rc_connectivity,
                                          input_connectivity = input_connectivity,
                                          activation = activation)
    else
      node <- reservoirpy$nodes$Reservoir(units = units,
                                          lr = lr,
                                          sr = sr,
                                          name = name,
                                          input_bias = inputBias,
                                          input_scaling = input_scaling,
                                          rc_connectivity = rc_connectivity,
                                          input_connectivity = input_connectivity,
                                          activation = activation)
  }
  else if(nodeType=="Input"){
    node <- reservoirpy$nodes$Input(input_dim = inputDim,
                                    name = name,...)
  }
  else if(nodeType=="Output"){
    node <- reservoirpy$nodes$Output(name = name,...)
  }
  else{
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
#'@importFrom reticulate py_to_r
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
  
  res <- reticulate::py_to_r(pred)
  
  class(res) <- c(class(res), "reservoir_predict_seq")
  
  return(res)
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
#'@param stateful is boolen
#'
#'
#' @param reset is boolean. Should the node status be reset before fitting.
#'
#'@importFrom reticulate py_to_r
#' 
#'@export
fit <- function(node, X, Y, warmup = 0, stateful=FALSE, reset = FALSE){
  
  stopifnot(!is.null(node) & !is.null(X) & !is.null(Y))
  
  if (class(node)[1]=="reservoirpy.model.Model")
    fit <- node$fit(X,
                    Y,
                    warmup = as.integer(warmup),
                    stateful = stateful,
                    reset = reset)
  else
    fit <- node$fit(X, Y, warmup = as.integer(warmup))
  
  return(py_to_r(fit))
}




#' @title
#' Load data from the \code{Japanese vowels} or the \code{Mackey-Glass} 
#' 
#' @description
#' Mackey-Glass time series \code{[8]_ [9]_}, computed from the Mackey-Glass
#' delayed differential equation:
#' 
#' @param dataset (String) take value in array \code{[japanese_vowels,mackey_glass]}
#' @param one_hot_encode (bool), default to True. If True, returns class label as a one-hot encoded vector.
#' @param repeat_targets (bool), default to False. If True, repeat the target label or vector along the time axis of the corresponding sample.
#' @param reload (bool), default to False
#' If True, re-download data from remote repository. Else, if a cached version
#' of the dataset exists, use the cached dataset.
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
#' @importFrom reticulate py_to_r
#' 
#' @export
#' 
#' @examples
#' if(interactive()){
#' japanese_vowels <- generate_data(dataset="japanese_vowels")
#' timeSerie <- generate_data(dataset = "mackey_glass",n_timesteps = 2500)
#' res =generate_data(dataset <- "both",n_timesteps = 2500)
#' }
generate_data <- function(dataset = c("japanese_vowels","mackey_glass","both"),
                          one_hot_encode=TRUE, repeat_targets=FALSE, 
                          reload=FALSE,
                          n_timesteps, 
                          tau=17, a = 0.2, b = 0.1, 
                          n = 10, x0 = 1.2, h = 1.0){
  
  if(length(dataset)>1) {
    dataset <- dataset[1]
  }
  stopifnot(dataset %in% c("japanese_vowels", "mackey_glass","both"))
  data_generated <- list()
  if(dataset %in% c("japanese_vowels","both")){
    data_generated[["japanese_vowels"]] <- py_to_r(reservoirpy$datasets$japanese_vowels(one_hot_encode=one_hot_encode, 
                                                                                        repeat_targets=repeat_targets,
                                                                                        reload=reload))
    names(data_generated[["japanese_vowels"]]) <- c("X_train", "Y_train", "X_test", "Y_test")
  }
  if(dataset %in% c("mackey_glass","both")){
    stopifnot(!is.null(n_timesteps))
    data_generated[["mackey_glass"]] <- as.vector(reservoirpy$datasets$mackey_glass(as.integer(n_timesteps),
                                                                                    as.integer(tau),a,b,
                                                                                    as.integer(n),x0,h))
  }
  return(data_generated)
}



#' @name %>>%
#' 
#' @rdname chevron
#' @aliases chevron
#'
#' @title Takes two nodes and applies python operator \code{>>}
#' 
#' @description A port of the \code{>>} "chevron" operator from reservoirpy.
#' 
#' @param node1 a \code{Node} or a list of \code{Nodes}
#' @param node2 a \code{Node} or a list of \code{Nodes}
#' 
#' @return A node or a list of nodes.
#'
#' @export
#' 
#' @examples
#' if(interactive()){
#'   source <- reservoir::createNode("Input")
#'   reservoir <- reservoir::createNode("Reservoir", units = 500, lr=0.1, sr=0.9)
#'   source %>>% reservoir
#' 
#'   readout <- reservoir::createNode("Ridge")
#'   list(source %>>% reservoir, source) %>>% readout
#' }
`%>>%` <- function(node1, node2){
  rp$rshift$operatorRShift(node1, node2)
}
