test_that("reservoir", {
  testthat::skip_on_cran()
  
  print(reticulate::py_config())
  
  timesteps <- 2500
  X <- reservoir::generate_data(dataset = "mackey_glass",n_timesteps = timesteps)$mackey_glass
  
  X <- 2 * (X - min(X)) / (max(X) - min(X)) - 1
  source <- reservoir::createNode("Input")
  readout <- reservoir::createNode("Ridge")
  reservoir <- reservoir::createNode("Reservoir", units = 100,  lr=0.2, sr=0.8)
  
  model <- reservoir::link(reservoir, readout)
  
  Xtrain <- as.matrix(X[1:2001])
  Ytrain <- as.matrix(X[10:2010])
  
  model <- reservoir::fit(model, X=Xtrain, Y=Ytrain)
  
  # Classification 
  japanese_vowels <- reservoir::generate_data(
    dataset = "japanese_vowels",
    repeat_targets=TRUE)$japanese_vowels
  
  source <- reservoir::createNode("Input")
  readout <- reservoir::createNode("Ridge",ridge=1e-6)
  reservoir <- reservoir::createNode("Reservoir", 
                                     units = 500,  
                                     lr=0.1, sr=0.9)
  
  
  # Example: [source >> reservoir, source] >> readout
  model <- list(source %>>% reservoir, source) %>>% readout
  
  model_fit <- reservoir::fit(node = model,
                              X = japanese_vowels$X_train, 
                              Y = japanese_vowels$Y_train, 
                              stateful=FALSE,
                              warmup = 2)
  
  Y_pred <- reservoir::predict_seq(node = model_fit, X = japanese_vowels$X_test,stateful = FALSE)
  # formal test
  testthat::expect(class(model)[1] == "reservoirpy.model.Model",
                   failure_message = "Output of fit function is not a reservoirpy.model.Model object")
})