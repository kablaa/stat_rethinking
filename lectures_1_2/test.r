compute_posterier <- function(sample, poss = c(0, 0.25, 0.5, 0.75, 1)) {
  W <- sum(sample == "W")
  L <- sum(sample == "L")
  print(W)
  print(L)
  ways <- sapply(poss, function(q) (q * 4)^W * ((1 - q) * 4) ^ L)
  post <- ways / sum(ways)
  data.frame(poss, ways, post = round(post, 3))
}

sim_globe <- function(p = 0.7, n = 12) {
  sample(c("W", "L"), size = n, prob = c(p, 1 - p), replace = TRUE)
}


post_samples <- rbeta(1e3, 6 + 1, 3 + 1)
pred_post <- sapply(post_samples, function(p) sum(sim_globe(p, 100) == "W"))
tab_post <- table(pred_post)
plot(tab_post)
# for (i in 0:100) lines(c(i, i), c(0, tab_post[i + 1]), lwd = 4, col = 4)