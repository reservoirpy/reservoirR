test_that("reservoir", {
  skip_on_cran()
  
  timesteps <- 2500
  X <- generate_data(timesteps)
  
  X <- 2 * (X - min(X)) / (max(X) - min(X)) - 1
  
  readout <- createNode("Ridge")
  reservoir <- createNode("Reservoir", units = 100,  lr=0.2, sr=0.8)
  
  model <- link(reservoir, readout)
  model
  
  Xtrain <- as.matrix(X[1:2001])
  Ytrain <- as.matrix(X[10:2010])
  
  model = fit(model, X=Xtrain, Y=Ytrain)
  class(model)
})