library(rethinking)

sample_size <- 1000

p_grid <- seq( from = 0, to = 1, length.out = 1000)
# assume that all probabilities are equally likely
prob_p <- rep(1, 1000)
# p(x) = choose(9, 6) p^x (1-p)^(9-x)
# we assume that after tossing the globe 9 times we get 6 W.
# for example, .26% of trials are expected to produce 6 Ws
# given p = 0.7 
prob_data <- dbinom(6, size = 9, prob = p_grid)
plot(prob_data)

# P(A|B) =  P(B|A) * P(A) / normalizing constant
posterior <- prob_data * prob_p
print(sum(posterior))
# the sum of all possible probabilities is 1
posterior <- posterior / sum(posterior)
dens(posterior)

# taking a sample of all possible probabilities with the probability of each
# probability being determined by the posterior function generated above.
# So there will more more values around p=.07
samples <- sample(p_grid, prob = posterior, size = sample_size, replace = TRUE)
png('./samples.png')
plot(samples)
dev.off()
png('./sample_density.png')
dens(samples)
dev.off()

# 17% of of the posterior probability is below 0.5
sum(posterior[p_grid < 0.5])
# therefore, about 17% of the samples be < 0.5
sum(samples < 0.5) / sample_size

# most of the samples will fall in this range, since that's how we 
# defined the posterior distribution
sum(samples > 0.5 & samples < 0.75) / sample_size

# with 95% confidence, the true p is within this range
quantile(samples, c(0.05, 0.95))