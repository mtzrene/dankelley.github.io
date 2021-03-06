
## ----error-bars-1, fig.caption="Error bars", dpi=100---------------------
set.seed(123)

n <- 500
result <- vector("double", n)
A <- 1
Au <- 0.1 # uncertainty in A
for (i in 1:n) {
    Ap <- A + Au * rnorm(n=1)
    result[i] = 10 * Ap
}
D <- 0.5 * (1 - 0.68)
r <- quantile(result, probs=c(D, 1-D))
cat("value:", mean(result), "uncertainty:", sd(result), " range:", r[1], "to", r[2], "\n")
hist(result)


## ----error-bars-2, fig.caption="Error bars", dpi=100---------------------
set.seed(123)
n <- 500
result <- vector("double", n)
A <- 1
Au <- 0.1 # uncertainty in A
for (i in 1:n) {
    Ap <- A + Au * rnorm(n=1)
    result[i] = Ap^2
}
D <- 0.5 * (1 - 0.68)
r <- quantile(result, probs=c(D, 1-D))
cat("value:", mean(result), "uncertainty:", sd(result), " range:", r[1], "to", r[2], "\n")
hist(result)


## ----error-bars-3, fig.caption="Error bars", dpi=100---------------------
set.seed(123)
n <- 500
result <- vector("double", n)
A <- 1
Au <- 0.5 # uncertainty in A
for (i in 1:n) {
    Ap <- A + Au * rnorm(n=1)
    result[i] = tanh(Ap)
}
D <- 0.5 * (1 - 0.68)
r <- quantile(result, probs=c(D, 1-D))
cat("value:", mean(result), "uncertainty:", sd(result), " range:", r[1], "to", r[2], "\n")
hist(result)


