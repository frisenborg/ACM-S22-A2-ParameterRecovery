// Multi-agent imperfect WSLS with a staybias and leavebias.


data {
  // Number of trials
  int<lower=1> trials;
  
  // Number of agents
  int<lower = 1> agents;
  
  // Array containing the coin face (heads or tails)
  array[trials, agents] int face;
  
  // Vector of wins and heads/tails
  array[trials, agents] int wins_face;
  
  // Vector of losses and heads/tails
  array[trials, agents] int loss_face;
}

parameters {
  // General tendency to choose heads
  array[agents] real alpha;
  
  // Bias for staying when the last trial was won
  array[agents] real staybias;
  
  // Bias for leaving when the last trial was lost
  array[agents] real leavebias;
}

model {
  // We loop through all agents to set up seperate priors.
  for (agent in 1:agents) {
    // We use uninformative priors for alpha, leavebias and staybias.
    // The priors are not bounded and are centered around 0 to match the 
    // stay- and leavebias.
    target += normal_lpdf(alpha[agent] | 0, 1);
    target += normal_lpdf(staybias[agent] | 0, 1);
    target += normal_lpdf(leavebias[agent] | 0, 1);
    
    // We specify the rate according to a linear model.
    target += bernoulli_logit_lpmf(
      face[,agent] | alpha[agent] + 
      staybias[agent] * to_vector(wins_face[,agent]) +
      leavebias[agent] * to_vector(loss_face[,agent])
    );
  }
}

generated quantities {
  // We want to get the probability values for the parameters.
  // First we declare the values we need (a value for each agent).
  array[agents] real alpha_p;
  array[agents] real staybias_p;
  array[agents] real leavebias_p;
  
  // And do the actual conversion to probabilities.
  alpha_p = inv_logit(alpha);
  staybias_p = inv_logit(staybias);
  leavebias_p = inv_logit(leavebias);
}
