---
title: 'MODISSnow: Download MODIS Snow Cover Data with R'
tags:
 - MODIS
 - R
authors:
- name: Johannes Signer
  orcid: 0000-0002-1771-7775
<<<<<<< HEAD
  affiliation: 1
affiliations:
  - name: Department of Wildlife Science, University of Göttingen, Germany
    index: 1
=======
  affiliation: University of Göttingen, Germany
>>>>>>> 8f5f5daca3008606f910e1351a351a6b2335faf3
date: 13 December 2016
bibliography: paper.bib
---

# Summary

MODISSnow is an R [@cran] package for downloading Moderate-resolution Imaging Spectroradiometer (MODIS) snow cover data.
For many ecological and environmental application snow cover can be of high interest. For example, snow cover might influence vegetation seasons, movement of animals, or hydrological processes. MODIS provides through two satellite missions (Terra and Aqua) global daily snow cover maps at 500 m spatial resolution [@modis].

The package MODISSnow provides a simple R interface to access MODIS snow cover data (version 6). Given a date and tile number, functions are provided to automatically download the tile, transform the coordinate reference system to latlong (EPSG:4326). Results are returned as an object of class RasterLayer [@raster], which allows seamless further processing of the downloaded scenes with R.

# References
