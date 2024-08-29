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
plot(W ~ H, col = 2, lwd = 3)