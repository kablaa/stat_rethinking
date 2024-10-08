library(rethinking)
data(Howell1)
d <- Howell1
d2 <- d[d$age >= 18,]

f_list <- alist(
    height ~ dnorm(mu, sigma),
    mu ~ dnorm(178, 20),
    sigma ~ dunif(0, 50)
)

m4.1 <- quap(f_list, data = d2)
precis(m4.1)