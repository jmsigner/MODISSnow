<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/jmsigner/MODISSnow.svg?branch=master)](https://travis-ci.org/jmsigner/MODISSnow)

MODISSnow
=========

Package to download MODIS snow data from [The National Snow & Ice Data Center](http://nsidc.org/).

Install
=======

``` r
devtools::install_github("jmsigner/MODISSnow")
```

Usage
=====

``` r
library(MODISSnow)
# Download MODIS snow data for a central Europe h = 18 and v = 5 for the 1 of January 2016
dat <- download_data(lubridate::ymd("2016-01-01"), h = 18, v = 5)
class(dat)
raster::plot(dat)
```