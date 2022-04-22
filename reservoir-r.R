library("reticulate")

use_virtualenv("reservoirpy-r")
# virtualenv_install(envname = "reservoirpy-r", packages = "../reservoirpy", pip_options = "-e")

reservoirpy = import("reservoirpy")
np = import("numpy")

timesteps <- 2500
tau <- 17
X = reservoirpy$datasets$mackey_glass(as.integer(timesteps), tau=as.integer(tau))

X = 2 * (X - min(X)) / (max(X) - min(X)) - 1

reservoir = reservoirpy$nodes$Reservoir(as.integer(100))
readout = reservoirpy$nodes$Ridge()

model = reservoirpy$link(reservoir, readout)
model

Xtrain = as.matrix(X[1:2001,])
Ytrain = as.matrix(X[10:2010,])

Xtrain = array_reshape(Xtrain, c(2001, 1))
Ytrain = array_reshape(Xtrain, c(2001, 1))

model = model$fit(X=Xtrain, Y=Ytrain)
class(model)
model$fit(X = Xtrain, Y = Ytrain, )
