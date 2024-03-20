#' Create a World raster grid
#'
#' @param res a `numeric` of length 1. The grid resolution (in degrees).
#' 
#' @param path a `character` of length 1. Name of the directory to export the
#'   spatial grid. The spatial grid will be saved as a GeoTIFF file (`.tif`)
#'   Default is `data/`.
#'
#' @return An `SpatRaster` object (package `terra`) of `res` x `res` horizontal
#' resolution defined under the `WGS84` coordinate system with an extent of 
#' (-180, 180) in longitude and (-90, 90) in latitude.
#' 
#' The grid contains two values: `0` indicates a cell in Ocean and `1` a cell in
#' Continent (or Island). This information has been added by intersecting the
#' grid with the spatial layer of World continents provided by the package
#' `rnaturalearth`.
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' ## Create world grid ----
#' wrld <- create_grid()
#' 
#' ## Explore grid ----
#' terra::ext(wrld)
#' terra::res(wrld)
#' terra::ncell(wrld)
#' 
#' ## Map grid ----
#' terra::plot(x)
#' }

create_grid <- function(res = 0.08333333, path = here::here("data")) {
  

  ## World Extent ----
  
  world_ext <- c(-180, 180, -90, 90)
  
  ## Create empty grid ----
  
  world_grid <- terra::rast(xmin = world_ext[1], xmax = world_ext[2], 
                            ymin = world_ext[3], ymax = world_ext[4], 
                            res  = res)
  
  terra::ext(world_grid) <- world_ext
  
  
  ## Get World continents ----
  
  ne_contients <- rnaturalearth::ne_countries(scale = "small")
  ne_contients <- terra::vect(ne_contients)
  
  
  ## Add values (0 = Oceans | 1 = Lands) ----

  world_grid <- terra::rasterize(ne_contients, world_grid, background = 0)
  
  
  ## Export file ----
  
  terra::writeRaster(world_grid, file.path(path, "world_grid.tif"), 
                     overwrite = TRUE)
  
  invisible(world_grid)
}
