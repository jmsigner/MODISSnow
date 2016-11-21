#' Download MODIS snow data
#'
#' Downloads MODIS snow data and returns a tile as raster tile.
#'
#' @param date Day for which snow data should be downloaded as POSIXct.
#' @param sat Satelite mission used. Currently only "MYD10A1" is supported.
#' @param h horizontal tile number. See also details.
#' @param v vertical tile number. See also details.
#' @param ... further arguments passed to get_tile().
#'
#' @return RasterLayer.
#' @export
#'
#'
download_data <- function(date, sat = "MYD10A1", h = 10, v = 10, ...) {
  folder_date <- format(date, "%Y.%m.%d")
  ftp <- if(sat == 'MYD10A1') {
    paste0('ftp://n5eil01u.ecs.nsidc.org/SAN/MOSA/', sat, '.006/', folder_date, '/')
  } else {
    paste0('ftp://n5eil01u.ecs.nsidc.org/SAN/MOST/', sat, '.006/', folder_date, '/')
  }

  fls <- RCurl::getURL(ftp, dirlistonly = TRUE)
  fls <- unlist(strsplit(fls, "\\n"))
  fls <- fls[grepl("hdf$", fls)]
  tile <- fls[grepl(
    paste0(sat, ".A", lubridate::year(date), "[0-9]{3}.h", formatC(h, width = 2, flag = 0), "v", formatC(v, width = 2, flag = 0)),
    fls)]
  get_tile(ftp, tile, ...)
}


#' Download a MODIS tile
#'
#' @param ftp Address of the repository.
#' @param tile Name of the tile.
#' @param progress Indicates whether or not progress is displayed.
#' @param clean Indidcates whether or not temporary files are deleted.
#'
#' @return RasterLayer
#' @export
#'
get_tile <- function(ftp, tile, progress = FALSE, clean = TRUE){

  out_file <- file.path(tempdir(), tile)
  new_file <- paste0(tools::file_path_sans_ext(out_file), ".tif")
  dst_file <- paste0(tools::file_path_sans_ext(new_file), "_epsg4326.tif")

  if (progress) cat("[", format(Sys.time(), "%H-%M-%S"), "]: Starting download")
  utils::download.file(paste(ftp, tile, sep = "/"), out_file)

  if (progress) cat("[", format(Sys.time(), "%H-%M-%S"), "]: Processing file")
  sds <- gdalUtils::get_subdatasets(out_file)
  gdalUtils::gdal_translate(sds[1], dst_dataset = new_file)
  gdalUtils::gdalwarp(srcfile = new_file,
                      dstfile = dst_file,
                      s_srs = "+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181 +b=6371007.181 +units=m +no_def",
                      t_srs = "EPSG:4326", overwrite = TRUE)

  res <- raster::raster(dst_file)
  res[] <- raster::getValues(res) # to have values in memory

  if (clean) {
    file.remove(c(out_file, new_file))
  }

  # http://nsidc.org/data/MOD10A1
  return(res)

}
