---
layout: post
title: Wind and waves during a Nor'Easter storm
tags: [R,weather]
category: R
year: 2016
month: 02
day: 09
summary: Wave and wind conditions are summarized for the Nor'Easter that hit eastern Canada February 8, 2016.
---

# Introduction



Several buoys measure wave conditions off the coast of Nova Scotia. I was
hoping to get data from the nearest one (ID 44258) but it did not have many
non-missing data, so I instead chose one further offshore (ID 44150; see
<http://www.ndbc.noaa.gov/station_page.php?station=44150>).  This is owned and
maintained by Environment Canada, and is located roughly south of Halifax and
east of Cape Cod, near the 1000m isobath, as indicated on the map below.


{% highlight r linenos=table %}
library(oce)
lon <- -64.018
lat <- 42.505
data(coastlineWorldFine, package="ocedata")
plot(coastlineWorldFine, longitudelim=lon+c(-5, 5), latitudelim=lat+c(-7,7))
points(lon, lat, bg='red', cex=2, pch=21)
data(topoWorld) # coarse resolution
contour(topoWorld[["longitude"]], topoWorld[["latitude"]], topoWorld[["z"]],
        levels=-1000, lty=2, drawlabels=FALSE, add=TRUE)
{% endhighlight %}

![center](http://dankelley.github.io/figs/2016-02-09-noreaster/unnamed-chunk-2-1.png) 

# Procedure

## Data source

I first downloaded the data as follows, in R:

{% highlight r linenos=table %}
download.file("http://www.ndbc.noaa.gov/data/realtime2/44150.txt", "44150.txt")
{% endhighlight %}
Since I did this on February 9, I got data for the month prior to the download.
In case any reader wants to try working with those data, I've provided them on
this blog [1].

## Read data


{% highlight r linenos=table %}
d <- readLines("44150.txt")
names <- strsplit(gsub("^#", "", d[1]), " +")[[1]]
d <- gsub("MM", "NA", d) # whacky missing-value code
d <- read.table(text=d, header=FALSE, col.names=names)
t <- ISOdatetime(d$YY, d$MM, d$DD, d$hh, d$mm, 0, tz="UTC")
windDirection <- d$WDIR
windSpeed <- d$WSPD
gust <- d$GST
waveHeight <- d$WVHT
dominantWavePeriod <- d$DPD
apd <- d$APD # ? maybe average wave period?
mwd <- d$MWD # ? 
airPressure <- d$PRES
airTemperature <- d$ATMP
waterTemperature <- d$WTMP
dewPoint <- d$DEWP
visibility <- d$VIS
ptdy <- d$PTDY
tide <- d$TIDE
theta <- 90 - windDirection # convert from CW-from-North to CCW-from-East
## multiply by -1 to convert from "wind from" to "wind to"
windU <- -windSpeed * cos(theta*pi/180)
windV <- -windSpeed * sin(theta*pi/180)
{% endhighlight %}

## Time-series graphs

{% highlight r linenos=table %}
par(mfrow=c(5,1))
oce.plot.ts(t, airPressure/10, ylab="Air press [kPa]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1))
oce.plot.ts(t, windSpeed, ylab="Wind speed [m/s]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1))
oce.plot.ts(t, windDirection, ylab="wind dir", drawTimeRange=FALSE, mar=c(2, 3, 1, 1))
oce.plot.ts(t, waveHeight, ylab="Height [m]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1))
oce.plot.ts(t, dominantWavePeriod, ylab="Period [s]", drawTimeRange=FALSE, mar=c(2, 3, 1, 1))
{% endhighlight %}

![center](http://dankelley.github.io/figs/2016-02-09-noreaster/unnamed-chunk-5-1.png) 

## Wind-rose graph

I like to plot winds in the oceanographic convention, i.e. with dots indicating
the direction in which the air flows. I will colour-code the dots with an
indication of the wave height.


{% highlight r linenos=table %}
cm <- colormap(waveHeight, zlim=c(0, 10), col=oceColorsJet)
par(mar=c(3.5, 3.5, 1.5, 1), mgp=c(2, 0.7, 0))
drawPalette(zlim=cm$zlim, col=cm$col)
plot(windU, windV, asp=1, cex=2, pch=21, bg=cm$zcol,
     xlab="Eastward wind [m/s]", ylab="Northward wind [m/s]")
mtext("Colour indicates wave height [m]", side=3, line=0.25, adj=1)
for (ring in seq(10, 30, 10)) {
    circleX <- ring * cos(seq(0, 2*pi, pi/20))
    circleY <- ring * sin(seq(0, 2*pi, pi/20))
    lines(circleX, circleY, col='lightgray')
}
abline(h=0, col='lightgray')
abline(v=0, col='lightgray')
abline(0, 1, col='lightgray')
abline(0, -1, col='lightgray')
{% endhighlight %}

![center](http://dankelley.github.io/figs/2016-02-09-noreaster/unnamed-chunk-6-1.png) 

# Discussion

Although waves are not entirely related to *local* winds, it is interesting to
compare them. The time-series plots indicate a correspondence of high wind and
large waves. However, the wind-rose plot indicates that this is mainly true for
certain wind directions. The strong winds from February 8 that caused the
largest waves are indicated with the dark-red dot in the lower-left quadrant.
This quadrant corresponds to winds that locals call Nor'Eastly, and those
locals who take to the sea will not be surprised by the wave heights indicated
on the storm, or by their long period as indicated in the time-series plot.

# References and resources

1. [data source](https://raw.github.com/dankelley/dankelley.github.io/master/assets/44150.txt)

2. Jekyll source code for this blog entry: [2016-02-09-noreaster.Rmd](https://raw.github.com/dankelley/dankelley.github.io/master/assets/2016-02-09-noreaster.Rmd)



