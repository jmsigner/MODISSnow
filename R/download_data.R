#' @title
#' Download MODIS snow cover data (version 6) from the National Snow and Ice Data Center.
#'
#' @description
#' \code{download_data} is the main function to download a scene given the correct tile, date and satellite.
#'
#' \code{get_tile} is a helper function that actually downloads a tile. Supplied with a correct \code{ftp} address and \code{tile} the function downloads the MODIS tile, and transforms the coordinate reference system to latlong (EPSG:4326).
#'
#' @details
#' When downloading the data, the correct tile has to be specified. At the moment there is no automated way to find the tile. This means that the user has to consult the \href{http://landweb.nascom.nasa.gov/developers/is_tiles/is_bound_10deg.txt}{MODIS land grid} to find the correct tile. Alternatively the \href{http://landweb.nascom.nasa.gov/cgi-bin/developer/tilemap.cgi}{MODIS tile calculator} may be used.
#'
#' @param ftp Address of the repository.
#' @param tile Name of the tile.
#' @param progress Indicates whether or not progress is displayed.
#' @param clean Indidcates whether or not temporary files are deleted.
#' @param date Day for which snow data should be downloaded as \code{Date}, \code{POSIXct}, or \code{POSIXlt}.
#' @param sat Satellite mission used. Currently Terra (\code{"MYD10A1"}) and Aqua (\code{"MOD10A1"}) are supported.
#' @param h Horizontal tile number, see also details.
#' @param v Vertical tile number, see also details.
#' @param printFTP If \code{TRUE}, the FTP address where the data are downloaded is printed.
#' @param ... Further arguments passed to \code{get_tile()}.
#'
#' @return
#' The function returns an object of the class \code{RasterLayer} with the following cell values:
#' \itemize{
#'  \item 0-100 NDSI snow cover
#'  \item 200 missing data
#'  \item 201 no decision
#'  \item 211 night
#'  \item 237 inland water
#'  \item 239 ocean
#'  \item 250 cloud
#'  \item 254 detector saturated
#'  \item 255 fill
#' }
#' but see also the documentation for the \emph{NDSI_SNOW_COVER} \href{http://nsidc.org/data/MOD10A1}{here}.
#'
#' @references
#' When using the MODIS snow cover data, please acknowledge the data appropriately by
#' \enumerate{
#'   \item reading the \href{http://nsidc.org/about/use_copyright.html}{use and copyright}
#'   \item citing the original data: \emph{Hall, D. K. and G. A. Riggs. 2016. MODIS/[Terra/Aqua] Snow Cover Daily L3 Global 500m Grid, Version 6. [Indicate subset used]. Boulder, Colorado USA. NASA National Snow and Ice Data Center Distributed Active Archive Center. doi: http://dx.doi.org/10.5067/MODIS/MOD10A1.006. [Date Accessed].}
#' }
#' @export
#' @rdname MODISSnow
#'
#' @examples
#' \dontrun{
#' # Download MODIS snow data for a central europe h = 18 and v = 5 for the 1 of January 2016
#' dat <- download_data(lubridate::ymd("2016-01-01"), h = 18, v = 5)
#' class(dat)
#' raster::plot(dat)
#' }

download_data <- function(date, sat = "MYD10A1", h = 10, v = 10, printFTP = FALSE, ...) {

  # checks
  if (!class(date) %in% c("Date", "POSIXlt", "POSIXct")) {
    stop("MODISSnow: date should be an object of class Date")
  }

  if (!sat %in% c("MYD10A1", "MOD10A1")) {
    stop("MODISSnow: unknown satellite requested")
  }



  folder_date <- base::format(date, "%Y.%m.%d")
  ftp <- if(sat == 'MYD10A1') {
    paste0('ftp://n5eil01u.ecs.nsidc.org/SAN/MOSA/', sat, '.006/', folder_date, '/')
  } else {
    paste0('ftp://n5eil01u.ecs.nsidc.org/SAN/MOST/', sat, '.006/', folder_date, '/')
  }

  if (printFTP)
    print(ftp)

  # use handels: http://stackoverflow.com/questions/37713293/how-to-circumvent-ftp-server-slowdown
  curl <- RCurl::getCurlHandle()
  fls <- RCurl::getURL(ftp, curl = curl, dirlistonly = TRUE)
  rm(curl)
  base::gc()
  base::gc()

  fls <- unlist(strsplit(fls, "\\n"))
  fls <- fls[grepl("hdf$", fls)]
  tile <- fls[grepl(
    paste0(sat, ".A", lubridate::year(date), "[0-9]{3}.h", formatC(h, width = 2, flag = 0), "v", formatC(v, width = 2, flag = 0)),
    fls)]

  if (length(tile) != 1) {
    stop("MODISSnow: requested tile not found")
  }

  get_tile(ftp, tile, ...)
}


#'
#' @rdname  MODISSnow
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

