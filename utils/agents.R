# Define the random-bias agent
random_agent <- function(bias) {
  # Sample a single choice according to a bias
  choice <- rbinom(1, 1, bias)
  
  return(choice)
}

# Define the imperfect WSLS agent
WSLS_agent <- function(prev_choice, win, staybias, leavebias) {
  # The agent must find out if it should stay or leave according to the
  # staybias and leavebias. A staybias of 1 means that the agent should
  # always stay given a win. A leavebias of 1 means that the agent should always
  # leave given a loss.
  # Sample a binary number (negate) according to win/loss and staybias/leavebias
  if (win) {
    negate <- rbinom(1, 1, 1-staybias)
  } else if (!win) {
    negate <- rbinom(1, 1, leavebias)
  }
  
  # Return previous choice adjusted by negation.
  choice <- abs(prev_choice - negate)
  
  return (choice)
}