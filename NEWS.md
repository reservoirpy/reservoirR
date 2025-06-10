# reservoirnet 0.3.0

Add function `last_reservoir_state()` which computes the reservoir states for a
given set of input sequences and extracts the final state of the reservoir for
each sequence.

```R
library(reservoirnet)
node <- reservoirnet::createNode("Reservoir", units = 100,
                                lr=0.1, sr=0.9,
                                seed = 1)
# Example input sequences
X <- list(matrix(runif(100), ncol = 1), matrix(runif(200), ncol = 1))  
last_states <- last_reservoir_state(node, X)
print(last_states)
```