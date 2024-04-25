birds_range_sizes <- function(raster, n_cores = 1) {
  
  ## Check arg ----
  
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
  
  
  ## CRS for computation -----
  
  eck_proj <- paste0("+proj=eck4 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 ", 
                     "+datum=WGS84 +units=m +no_defs")
  
  
  ## Loop on layers ----
  
  path <- here::here("data", "BIRDS")
  fls  <- list.files(path, pattern = "gpkg$", full.names = TRUE)
  
  birds_rangesize <- data.frame()
  
  for (i in 1:length(fls)) {
    
    data <- sf::st_read(fls[i])
  
    
    ## Project layers in Eckert IV system ----
    
    data   <- sf::st_transform(data, crs = eck_proj)
    raster <- terra::project(raster, eck_proj)
  
    
    ## Get species names ----
    
    species <- sort(unique(data[ , "blife_binomial", drop = TRUE]))
    
    
    ## Get species names ----
    
    data <- data[data$"blife_presence" < 5, ]
    
    
    ## Compute number of raster cells and polygon areas ----
    
    range_sizes <- parallel::mclapply(species, function(x) {
      
      sp_distr <- data[data$"blife_binomial" == x, ]
      
      geom_type <- as.character(sf::st_geometry_type(sp_distr))
      
      if (nrow(sp_distr) > 0 && !("MULTISURFACE" %in% geom_type)) {
      
        ras <- exactextractr::rasterize_polygons(sp_distr, raster, 
                                                 min_coverage = 0)
        
        cells <- which(!is.na(ras[]))
        
        return(
          data.frame(
            "blife_binomial" = x,
            "n_cells"        = length(cells),
            "st_area"        = sum(round(as.numeric(sf::st_area(sp_distr) * 
                                                            0.000001)))
        ))
        
      } else {
        
        return(
          data.frame(
            "blife_binomial" = x,
            "n_cells"        = 0,
            "st_area"        = 0
        ))
      }
      
      
    }, mc.cores = n_cores)
    
    range_sizes <- do.call(rbind.data.frame, range_sizes)
    
    birds_rangesize <- rbind(birds_rangesize, range_sizes)
  }
  
  birds_rangesize
}
