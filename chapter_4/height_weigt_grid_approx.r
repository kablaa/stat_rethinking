# W_i = b*H_i + U_i
# U_i ~ Normal(0, sd)
# H_i ~ Uniform(130, 170)
sim_weight <- function(H, b, sd) {
  U <- rnorm(length(H), 0, sd)
  W <- b * H + U
  return(W)
}
# create random heights with a uniform distribution
H <- runif(200, min = 130, max = 170)

# simulates weights based on the random heights
W <- sim_weight(H, b = 0.5, sd = 5)
# plot(W ~ H, col = 2, lwd = 3)
library(rethinking)

data(Howell1)
d <- Howell1
d2 <- d[d$age >= 18,]
mu.list <- seq(from = 150, to = 160, length.out = 100)
sigma.list <- seq(from = 7, to = 9, length.out = 100)
post <- expand.grid(mu = mu.list, sigma = sigma.list)
post$mu
# The log likelyhood at each combination of mu and sigma, 
# we have to do everything at log scale otherwise the rounding 
# error will make all of the posterior probabilities 0.
post$LL <- sapply( 1:nrow(post), function(i) sum(
  dnorm(d2$height, post$mu[i], post$sigma[i], log = TRUE)
)) 
# multiply the prior by the likelyhood to get the product that is proportional to 
# the posterior density.
# the priors are on a log scale, so we add them to the log-likelihood, which is 
# equivalent to multiplying the raw densities by the likelihood
post$prod <- post$LL + dnorm(post$mu, 178, 20, TRUE) + dunif(post$sigma, 0, 50, TRUE)
# converting from log probability scale. need to scale all of the log-products by the
# maximum log product
post$prob <- exp(post$prod - max(post$prod))
image_xyz(post$mu, post$sigma, post$prob)

sample.rows <- sample(1:nrow(post), size = 1e4, replace = TRUE, prob = post$prob)
sample.mu <- post$mu[sample.rows]
sample.sigma <- post$sigma[sample.rows]
plot(sample.mu, sample.sigma, cex = 0.5, pch = 16, col = col.alpha(rangi2, 0.1))
dens(sample.mu)
dens(sample.sigma)