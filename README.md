<!-- README.md is generated from README.Rmd. Please edit that file -->
MODISSnow
=========

[![Travis-CI Build Status](https://travis-ci.org/jmsigner/MODISSnow.svg?branch=master)](https://travis-ci.org/jmsigner/MODISSnow) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/MODISSnow)](http://cran.r-project.org/package=MODISSnow) ![](https://cranlogs.r-pkg.org/badges/MODISSnow)

`MODISSnow` allows to download MODIS snow data from [The National Snow & Ice Data Center](http://nsidc.org/).

Quick start
===========

Install
-------

Stable version von CRAN.

``` r
install.packages("MODISSnow")
```

Or the dev version from GitHub.

``` r
devtools::install_github("jmsigner/MODISSnow")
```

Authentication
--------------

As of February 1st 2017, authentication via earthdata is requried. Free registration is possible at [the earthdata portal](https://urs.earthdata.nasa.gov/users/new).

Workflow
--------

``` r
library(MODISSnow)
# Download MODIS snow data for a central Europe h = 18 and v = 5 for the 1 of January 2016
dat <- modissnow_get_data(lubridate::ymd("2016-01-01"), h = 18, v = 5, 
                          user = "username", passwd = "password", sat = "MYD10A1")
class(dat)
raster::plot(dat)
```

Meta
====

-   Please report [any issues or bugs](https://github.com/ropensci/gistr/issues).
-   License: GPL v3
-   Get citation information for `MODISSnow` in R typing `citation(package = 'MODISSnow')`.
-   Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
