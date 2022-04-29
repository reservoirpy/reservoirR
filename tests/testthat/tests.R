test_that("reservoir", {
  timesteps <- 2500
  tau <- 17
  X <- as.vector(reservoirpy$datasets$mackey_glass(as.integer(timesteps), tau=as.integer(tau)))

  X <- 2 * (X - min(X)) / (max(X) - min(X)) - 1

  reservoir <- reservoirpy$nodes$Reservoir(100L)
  readout <- reservoirpy$nodes$Ridge()

  model <- reservoirpy$link(reservoir, readout)
  model

  Xtrain <- as.matrix(X[1:2001,])
  Ytrain <- as.matrix(X[10:2010,])

  Xtrain = array_reshape(Xtrain, c(2001, 1))
  Ytrain = array_reshape(Xtrain, c(2001, 1))

  model = model$fit(X=Xtrain, Y=Ytrain)
  class(model)
  model$fit(X = Xtrain, Y = Ytrain, )
})
