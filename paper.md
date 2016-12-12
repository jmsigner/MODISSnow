---
title: 'MODISSnow: Download MODIS Snow Cover Data to R'
tags:
 - MODIS
 - R
authors:
- name: Johannes Signer
  orcid: 0000-0002-1771-7775
  affiliation: University of Göttingen, Germany
date: 12 December 2016
bibliography: paper.bib
---

# Summary

MODISSnow is an R [@cran] package that allows downloading MODIS snow cover data directly to R.

For many ecological and environmental application snow cover can be of high interest. For example, snow cover might influence vegetation seasons, movement of animals, or hydrological processes. MODIS provides through two satellite missions (Terra and Aqua) global daily snow cover maps at 500 m spatial resolution [@modis].

The package MODISSnow provides a simple R interface to access MODIS snow cover data (version 6). Given a date and tile number, functions are provided to automatically download the tile, transform the coordinate reference system to latlong (EPSG:4326) and returns the tile as an object of class RasterLayer [@raster], which allow seamless further processing of the downloaded scenes.

# References
