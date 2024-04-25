mammals_occ_on_cells <- function(data, raster, n_cores = 1) {
  
  ## Check arg ----
  
  if (missing(data)) {
    stop("Argument 'data' is required.", call. = FALSE)
  }
  
  if (!inherits(data, "sf")) {
    stop("Argument 'data' must be an 'sf' object.", call. = FALSE)
  }
  
  if (any(!("iucn_binomial" %in% colnames(data)))) {
    stop("Column 'iucn_binomial' is absent from 'data'.", call. = FALSE)
  }
  
  if (missing(raster)) {
    stop("Argument 'raster' is required.", call. = FALSE)
  }
  
  if (!inherits(raster, "SpatRaster")) {
    stop("Argument 'raster' must be a 'SpatRaster' object.", call. = FALSE)
  }
  
  
  ## Disable s2 options ----
  
  o_s2 <- sf::sf_use_s2()
  on.exit(sf::sf_use_s2(o_s2))
  sf::sf_use_s2(FALSE)
  
  
  ## Remove extinct areas ----
  
  data <- data[data$"iucn_presence" != 5, ]
  
  
  ## Get species names ----
  
  species <- sort(unique(data[ , "iucn_binomial", drop = TRUE]))
  
  
  ## Project layers in Eckert IV system ----
  
  eck_proj <- paste0("+proj=eck4 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 ", 
                     "+datum=WGS84 +units=m +no_defs")
  
  data   <- sf::st_transform(data, crs = eck_proj)
  raster <- terra::project(raster, eck_proj)
  
  
  ## Compute number of raster cells and polygon areas ----
  
  occs_by_cells <- parallel::mclapply(species, function(x) {
    
    sp_distr <- data[data$"iucn_binomial" == x, ]
    
    ras <- exactextractr::rasterize_polygons(sp_distr, raster, min_coverage = 0)
    
    which(!is.na(ras[]))
    
  }, mc.cores = n_cores)
  
  names(occs_by_cells) <- species
  
  occs_by_cells
}
