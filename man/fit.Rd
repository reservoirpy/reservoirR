% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/reservoir.R
\name{fit}
\alias{fit}
\title{Offline fitting method of a Node}
\usage{
fit(node, X, Y, warmup = 0, stateful = FALSE)
}
\arguments{
\item{node}{node}

\item{X}{\code{array-like} of shape \code{[n_inputs], [series], timesteps, input_dim)}, optional
Input sequences dataset. If None, the method will try to fit
the parameters of the Node using the precomputed values returned
by previous call of :py:meth:\code{partial_fit}.}

\item{Y}{array-like of shape \code{([series], timesteps, output_dim)}, optional
Teacher signals dataset. If None, the method will try to fit
the parameters of the Node using the precomputed values returned
by previous call of :py:meth: \code{partial_fit}, or to fit the Node in
an unsupervised way, if possible.}

\item{warmup}{: \code{int}, default to 0 
Number of timesteps to consider as warmup and 
discard at the begining of each timeseries before training.}

\item{stateful}{is boolen}
}
\description{
Offline fitting method of a Node
}
