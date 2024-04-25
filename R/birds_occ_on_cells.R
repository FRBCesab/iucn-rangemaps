birds_occ_on_cells <- function(raster, n_cores = 1) {
  
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
  
  birds_occs_by_cells <- NULL
  
  for (i in 1:length(fls)) {
    
    data <- sf::st_read(fls[i])
    
    ## Get species names ----
    
    data <- data[data$"blife_presence" < 5, ]
    
    
    ## Project layers in Eckert IV system ----
    
    data   <- sf::st_transform(data, crs = eck_proj)
    raster <- terra::project(raster, eck_proj)
    
    
    species <- sort(unique(data[ , "blife_binomial", drop = TRUE]))
    
    
    ## Compute number of raster cells and polygon areas ----
    
    occs_by_cells <- parallel::mclapply(species, function(x) {
      
      sp_distr <- data[data$"blife_binomial" == x, ]
      
      geom_type <- as.character(sf::st_geometry_type(sp_distr))
      
      if (nrow(sp_distr) > 0 && !("MULTISURFACE" %in% geom_type)) {
        
        ras <- exactextractr::rasterize_polygons(sp_distr, raster, min_coverage = 0)
        
        return(which(!is.na(ras[])))
        
      } else {
        
        return(NULL)
      }
    }, mc.cores = n_cores)
    
    names(occs_by_cells) <- species
    
    birds_occs_by_cells <- c(birds_occs_by_cells, occs_by_cells)
  }
  
  birds_occs_by_cells
}
