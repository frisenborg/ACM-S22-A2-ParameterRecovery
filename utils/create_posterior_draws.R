# Define function for correctly formatting a dataframe for posterior samples
create_draws_df <- function(samples) {
  # Format posterior sample draws correctly
  draws_df <- as_draws_df(samples$draws()) %>%
    select(matches("staybias_p|leavebias_p")) %>%
    pivot_longer(cols = names(.)) %>%
    mutate(bias = ifelse(grepl("staybias", name), "staybias", "leavebias")) %>%
    mutate(name = str_replace(
      name, "((staybias_p)|(leavebias_p))\\[", "Agent ")) %>%
    mutate(name = str_remove(name, "\\]")) %>%
    mutate(name = as.factor(name))
  
  # Setup proper ordering of factors
  agent_ids <- c()
  n_agents <- length(levels(draws_df$name))
  
  for (agent in seq(agents)) {
    agent_ids[agent] <- paste("Agent", n_agents+1-agent)
  }
  
  levels(draws_df$name) <- agent_ids
  colnames(draws_df) <- c("agent", "posterior_estimate", "bias")
  
  return (draws_df)
}