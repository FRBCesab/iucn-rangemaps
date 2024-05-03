occs_to_raster <- function(data, raster, species) {
  
  ## Check arg ----
  
  if (missing(data)) {
    stop("Argument 'data' is required.", call. = FALSE)
  }
  
  if (!is.list(data)) {
    stop("Argument 'data' must be a 'list' object.", call. = FALSE)
  }
  
  if (any(is.na(names(data)))) {
    stop("Argument 'data' must be a named list.", call. = FALSE)
  }
  
  if (missing(raster)) {
    stop("Argument 'raster' is required.", call. = FALSE)
  }
  
  if (!inherits(raster, "SpatRaster")) {
    stop("Argument 'raster' must be a 'SpatRaster' object.", call. = FALSE)
  }
  
  if (missing(species)) {
    stop("Argument 'species' is required.", call. = FALSE)
  }
  
  if (!is.character(species)) {
    stop("Argument 'species' must be a character.", call. = FALSE)
  }
  
  if (length(species) != 1) {
    stop("Argument 'species' must be a character of length 1.", call. = FALSE)
  }
  
  if (!(species %in% names(data))) {
    stop("Species is absent from 'data'.", call. = FALSE)
  }

  
  ## Check CRS ----
  
  if (length(grep("Eckert IV", sf::st_crs(raster))) == 0) {
    stop("Argument 'raster' must be defined in the Eckert IV projection system.",
         call. = FALSE)
  }
  
  
  ## Prepare raster ----
  
  ras   <- raster
  ras[] <- NA
  
  cells <- data[[species]]
  ras[][cells, 1] <- 1
  
  names(ras) <- gsub("\\s", "_", species)
  
  ras
}
