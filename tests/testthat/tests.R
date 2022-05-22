test_that("reservoir", {
  testthat::skip_on_cran()
  
  print(reticulate::py_config())
  
  timesteps <- 2500
  X <- reservoir::generate_data(timesteps)
  
  X <- 2 * (X - min(X)) / (max(X) - min(X)) - 1
  
  readout <- reservoir::createNode("Ridge")
  reservoir <- reservoir::createNode("Reservoir", units = 100,  lr=0.2, sr=0.8)
  
  model <- reservoir::link(reservoir, readout)
  model
  
  Xtrain <- as.matrix(X[1:2001])
  Ytrain <- as.matrix(X[10:2010])
  
  model = reservoir::fit(model, X=Xtrain, Y=Ytrain)
  
  # formal test
  testthat::expect(class(model)[1] == "reservoirpy.model.Model",
                   failure_message = "Output of fit function is not a reservoirpy.model.Model object")
})