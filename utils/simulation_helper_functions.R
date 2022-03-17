# We want to combine information about wins/losses and heads/tails into
# two new vectors (staybias and leavebias). This defines the encoding function
WSLS_encoding <- function(random_face, WSLS_face) {
  trials <- length(random_face)  # Get trials for use in loops
  
  # Generate the wins_face vector:
  # if (win & heads) then 1, if (win & tails) then -1, else 0
  wins_face <- rep(NA, trials)
  wins_face[1] <- 0  # the first trial is always 0
  
  # Create utility vectors for wins
  win_vector  <- as.integer(random_face == WSLS_face)
  
  # Loop through and compare wins and WSLS_choices
  for (trial in 2:trials) {
    # Conditional for the encoding value
    if (win_vector[trial-1] == 1 & WSLS_face[trial-1] == 0) {
      encoding <- -1
    } else { encoding <- win_vector[trial-1] }
    
    wins_face[trial] <- encoding
  }
  
  
  # Generate the loss_face vector
  # if (loss & heads) then -1, if (loss & tails) then 1, else 0
  loss_face <- rep(NA, trials)
  loss_face[1] <- 0  # the first trial is always 0
  
  # Create utility vectors for losses
  loss_vector <- 1 - win_vector
  
  # Loop through and compare losses and WSLS_choices
  for (trial in 2:trials) {
    # Conditional for the encoding value
    if (loss_vector[trial-1] == 1 & WSLS_face[trial-1] == 1) {
      encoding <- -1
    } else { encoding <- loss_vector[trial-1] }
    
    loss_face[trial] <- encoding
  }
  
  # Setup a result variable to store the results of the encoding
  result <- list(wins_face, loss_face)
  names(result) <- c("wins_face", "loss_face")
  
  return(result)
}



# Define utility function for setting up a dataframe with all simulation results
simulation_to_df <- function(sim, agent_id=NA) {
  # Then encode results
  sim_encoding <- WSLS_encoding(
    sim$simulation$random_face, sim$simulation$WSLS_face)
  
  # Prepare the dataframe
  sim_df <- as.data.frame(sim$simulation)
  sim_df$wins_face <- sim_encoding$wins_face
  sim_df$loss_face <- sim_encoding$loss_face
  sim_df$trial <- 1:sim$params$trials
  sim_df$random_bias <- sim$params$random_bias
  sim_df$WSLS_staybias <- sim$params$WSLS_staybias
  sim_df$WSLS_leavebias <- sim$params$WSLS_leavebias
  sim_df$agent_id <- agent_id
  
  sim_df <- sim_df[c(9, 5:8, 1:4)]  # reorder columns
  
  return (sim_df)
}