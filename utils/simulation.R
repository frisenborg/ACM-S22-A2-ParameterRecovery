# Define a function that runs the simulation
simulation <- function(trials, random_bias, WSLS_staybias, WSLS_leavebias) {
  # Setup vectors for storing data
  WSLS_face   <- rep(NA, trials)
  random_face <- rep(NA, trials)
  
  # The WSLS agent should randomly select a face for the first trial
  WSLS_face[1] <- rbinom(1, 1, .5)
  
  # Generate data for the random agent choices
  for (trial in 1:trials) {
    random_face[trial] <- random_agent(random_bias)
  }
  
  # Generate data for the imperfect WSLS agent
  for (trial in 2:trials) {
    # Define whether the previous trial was won or lost
    if (WSLS_face[trial-1] == random_face[trial-1]) {
      win <- 1
    } else { win <- 0 }
    
    # Now sample the choice according to parameters
    WSLS_face[trial] <- WSLS_agent(
      prev_choice = WSLS_face[trial-1],
      win         = win,
      staybias    = WSLS_staybias,
      leavebias   = WSLS_leavebias)
  }
  
  # Setup a result variable to store the results of the simulation
  # and the parameter values
  params            <- list(trials, random_bias, WSLS_staybias, WSLS_leavebias)
  names(params)     <- c(
    "trials", "random_bias", "WSLS_staybias", "WSLS_leavebias")
  simulation        <- list(random_face, WSLS_face)
  names(simulation) <- c("random_face", "WSLS_face")
  result            <- list(params, simulation)
  names(result)     <- c("params", "simulation")
  
  return (result)
}