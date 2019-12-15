## ----eval=FALSE---------------------------------------------------------------
## # Not run here, so no graph
## plot(x, y1)
## points(x, y2, col=2)


## -----------------------------------------------------------------------------
palette("R3")


## ----echo=FALSE---------------------------------------------------------------
palette("R4")


## -----------------------------------------------------------------------------
x <- 1:8
palette("R4") # not needed unless R3 was previously selected
plot(x, rep(1, 8), ylim=c(1,2), pch=20, col=1:8)
palette("R3") # for the old scheme
points(x, 1+rep(1, 8), pch=20, col=1:8)
