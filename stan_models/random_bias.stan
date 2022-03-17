// The input (data) for the model. n of trails and h of heads
data {
  int<lower=1> n;
  array[n] int h;
  vector<lower=0, upper=1>[n] memory;
}

// The parameters accepted by the model.
parameters {
  real alpha;
  real beta;
}

transformed parameters {
  vector[n] theta;
  theta = alpha + beta * memory;
}

// The model to be estimated.
model {
  // The prior for theta is a uniform distribution between 0 and 1
  target += normal_lpdf(alpha | 0, 1);
  target += normal_lpdf(beta | 0, .3);
  
  // The model consists of a binomial distributions with a rate theta
  target += bernoulli_logit_lpmf(h | theta);
}

generated quantities {
  vector[n] theta_p;
  theta_p = inv_logit(theta);
}