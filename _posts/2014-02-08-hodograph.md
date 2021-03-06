---
layout: post
title: Hodograph drawing
tags: [R, graphics]
category: R
year: 2014
month: 2
day: 8
summary: A draft function for hodograph drawing is provided, and illustrated with the co2 dataset.  A variant of this function is likely to appear soon in the Oce R package.
description: Show the use of a simple hodograph function, perhaps destined for the Oce package.
---

# Introduction

The polar graph known as a hodograph can be useful for vector plots, and also for showing varition within nearly-cyclical time series data.  The Oce R package should have a function to create hodographs, but as usual my first step is to start by writing isolated code, testing to find the right match between the function and real-world needs.

The code chunk given below is such a test, with the build-in dataset named ``co2``, which is a time-series starting in 1959.  The hodograph is for the variation of CO2 from its value in 1959, so the data start at zero radius.  Climatologists will why this makes sense, and climate-change deniars will think it's part of a hoax.

I will leave documentation of the function for a later time, conscious of the fact that the argument list and the aesthtics of the output are likely to change with use.


# Methods

First, define ``hodograph()``, with arguments that suffice for a simple problem of a periodic signal *x=x(t)* to be plotted in polar fashion with radius indicating *x* and angle indicating *t* modulo 1 year.


{% highlight r linenos=table %}
hodograph <- function(x, y, t, rings, ringlabels=TRUE, tcut=c("daily", "yearly"), ...)
{
    tcut <- match.arg(tcut)
    if (missing(t)) {
        stop("x-y method not coded yet\n")
    } else {
        if (!missing(y)) {
            stop("cannot give y if t is given\n")
        }
        if (tcut== "yearly") {
            ## x=x(t)
            t <- as.POSIXlt(t)
            start <- ISOdatetime(1900+as.POSIXlt(t[1])$year, 1, 1, 0, 0, 0,
                                 tz=attr(t, "tzone"))
            day <- as.numeric(julian(t, origin=start))
            xx <- x * cos(day / 365 * 2 * pi)
            yy <- x * sin(day / 365 * 2 * pi)
            ## axes
            if (missing(rings))
                rings <- pretty(sqrt(xx^2 + yy^2))
            rscale <- 1.04 * max(rings)
            theta <- seq(0, 2 * pi, length.out=200)
            plot(xx, yy, asp=1, xlim=rscale*c(-1.1,1.1), ylim=rscale*c(-1.1, 1.1),
                 type='n', xlab="", ylab="", axes=FALSE)
            ## month lines
            month <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
            day <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
            rscale <- max(rings)
            for (m in 1:12) {
                ## boundaries are for non leap years
                phi <- 2 * pi * (sum(day[1:m]) - day[1]) / sum(day)
                lines(rscale*1.1*cos(phi)*c(0,1), rscale*1.1*sin(phi)*c(0,1), col='gray')
                phi <- 2*pi*(0.5/12+(m-1)/12)
                text(1.15*rscale * cos(phi), 1.15*rscale * sin(phi), month[m]) 
            }
            for (r in rings) {
                if (r > 0) {
                    gx <- r * cos(theta)
                    gy <- r * sin(theta)
                    lines(gx, gy, col='gray')
                    if (ringlabels)
                        text(gx[1], 0, format(r))
                }
            }
            points(xx, yy, ...)
        } else {
            stop("only tcut=\"yearly\" works at this time\n")
        }
    }
}
{% endhighlight %}

This may be tested as follows

{% highlight r linenos=table %}
data(co2)
year <- as.numeric(time(co2))
t0 <- as.POSIXlt("1959-01-01 00:00:00", tz="UTC")
t <- t0 + (year - year[1]) *365*86400
par(mar=rep(1, 4))
hodograph(x=co2-co2[1], t=t, tcut="yearly", type="l", ringlabels=FALSE)
{% endhighlight %}

![center](http://dankelley.github.io/figs/2014-02-08-hodograph/hodograph.png) 

# Results

The plot is informative.  I've looked at the ``co2`` data before, without really noticing the interannual variation, which is clearly seen as variation in the spacing of the spiraling data trace.  For comparison, consider a conventional time-series plot.


{% highlight r linenos=table %}
plot(co2)
{% endhighlight %}

![center](http://dankelley.github.io/figs/2014-02-08-hodograph/timeseries.png) 

# Conclusions

The function is useful as it is, but some improvements are indicated.  For example, the ring labels are often over-written by the axes, and the only solution on offer presently is to skip the labels.

# Resources

* Source code: [2014-04-08-hodograph.R]({{ site.url }}/assets/2014-02-08-hodograph.R)
