// Single-agent imperfect WSLS with a staybias and leavebias.


// The data block defines the data to input to the model
data {
  // Number of trials
  int<lower=0> trials;
  
  // Array containing the coin face (heads or tails)
  array[trials] int face;
  
  // Vector of wins and heads/tails
  vector<lower=-1, upper=1>[trials] wins_face;
  
  // Vector of losses and heads/tails
  vector<lower=-1, upper=1>[trials] loss_face;
}

// Block to define the parameters to estimate
parameters {
  // General tendency to choose heads
  real alpha;
  
  // Bias for staying when last trial was won
  real staybias;
  
  // Bias for leaving when last trial was won
  real leavebias;
}

// The transformed parameters block further declares parameters
// to estimate.
transformed parameters {
  // Theta is a vector because the tendency towards heads
  // changes from trial to trial
  vector[trials] theta;
  
  // And theta is defined as a linear function
  theta = alpha + staybias*wins_face + leavebias*loss_face;
}

// The model block defines the actual model, including the priors for the
// parameters.
model {
  // We use uninformative priors for alpha, leavebias and staybias
  target += normal_lpdf(alpha | 0, 1);
  target += normal_lpdf(staybias | 0, 1);
  target += normal_lpdf(leavebias | 0, 1);
  
  // The coinface is described according to theta (the linear model)
  target += bernoulli_logit_lpmf(face | theta);
}

// We can convert theta from logodds to probability using the inverse logit.
generated quantities {
  // First declare theta_p as an array
  vector[trials] theta_p;
  real staybias_p;
  real leavebias_p;
  
  // And do the actual conversion
  theta_p = inv_logit(theta);
  staybias_p = inv_logit(staybias);
  leavebias_p = inv_logit(leavebias);
}
