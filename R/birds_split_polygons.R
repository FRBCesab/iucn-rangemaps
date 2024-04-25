#' Import IUCN range maps for birds
#'
#' @description Before using this function, user needs to request the Birds 
#' of the World spatial data at:
#' \url{https://datazone.birdlife.org/species/requestdis} 
#' and download the ZIP file from the link sent by email. The content of the ZIP
#' (folder `BOTW_XXX/`) must be extracted in the folder `data/` and renamed as 
#' `BIRDS/`. This function will then read the file `data/BIRDS/BOTW.gdb`.
#'
#' @return A `MULTIPOLYGON` object (package `sf`).
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' birds_split_polygons()
#' }

birds_split_polygons <- function() {
  
  ## Check path ----
  
  path <- here::here("data", "BIRDS")
  
  if (!dir.exists(path)) {
    stop("The directory '", path, "' does not exist. Did you download the ", 
         "Birds of the World spatial data and extract the content of the ZIP ", 
         "file in '", path, "'?", call. = FALSE)
  }
  
  
  ## Import spatial layer ----
  
  if (!file.exists(file.path(path, "BOTW.gdb"))) {
    stop("The file 'BOTW.gdb' does not exist in '", path, "/'.", call. = FALSE)
  }
  
  data <- sf::st_read(file.path(path, "BOTW.gdb"), layer = "All_Species")
  
  
  ## Drop geometry (temporary) ----
  
  geometry <- sf::st_geometry(data)
  data     <- sf::st_drop_geometry(data)
  
  
  ## Select columns ----
  
  data <- data[ , c("sisid", "sci_name", "presence", "origin")]
  
  
  ## Clean data ----
  
  colnames(data)[1:2] <- c("id", "binomial")
  
  colnames(data) <- paste0("blife_", colnames(data))
  
  
  ## Add geometry ----
  
  sf::st_geometry(data) <- geometry
  
  
  ## Get species list ----

  splist <- sf::st_read(file.path(path, "BOTW.gdb"), layer = "Checklist_v8_txt")
  
  
  ## Split layer by order ----
  
  bird_orders <- sort(unique(splist$"Order_"))
  
  for (i in 1:length(bird_orders)) {
    
    species <- splist[splist$"Order_" == bird_orders[i], "SISID"]
    
    batchs <- c(seq(0, length(species), by = 500), length(species))
    batchs <- sort(unique(batchs))

    parts <- format(1:99)
    parts <- gsub("\\s", "0", parts)
    
    for (j in 1:(length(batchs) - 1)) {
    
      sf::st_write(data[data$"blife_id" %in% 
                          species[(batchs[j] + 1):batchs[j + 1]], ], 
                   file.path(path, paste0("BirdLife_", bird_orders[i], "_part", 
                                          parts[j], ".gpkg")))
    }
  }
  
  invisible(NULL)
}
