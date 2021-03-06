---
layout: post
title: Inserting units in expressions for labels
tags: [oce, R]
category: R
year: 2016
month: 6
day: 11
summary: I show how to construct an expression for e.g. an axis label, if the unit is stored in a variable.
---

**Preface.** This is my shortest blog item ever, showing in a few lines something that took me over an hour to realize: use `[[1]]` in refering expressions stored in variables.


# Introduction

I wanted this for `oce`, which for [issue 981](https://github.com/dankelley/oce/issues/981) required a method of extracting units from objects, and inserting the values into expressions being constructed for the `mtext` calls that write axis labels.

# Methods

The code says it all: use `[[1]]`.


{% highlight r linenos=table %}
par(mar=rep(0, 4))
plot(0:5, 0:5, xlab="", ylab="", axes=FALSE, type='n')

## Simple method
text(1, 1, expression("A ["*m/s^2*"]"))

## Unit stored in an expression: naive approach.
u <- expression(m/s^2)
text(1, 2, bquote("B ["*.(u)*"]"))

## Unit stored in an expression: note the [[1]] selection!
text(1, 3, bquote("C ["*.(u[[1]])*"]"))

## Unit stored in an oce-formatted list
U <- list(unit=expression(m/s^2), scale="")
text(1, 4, bquote("D ["*.(U[[1]][[1]])*"]"))
{% endhighlight %}

![center](http://dankelley.github.io/figs/2016-06-11-unit-expressions/unnamed-chunk-1-1.png)


# Resources

* Jekyll source code for this blog entry: [2016-06-11-flags.Rmd](https://raw.github.com/dankelley/dankelley.github.io/master/assets/2016-06-11-flags.Rmd)


