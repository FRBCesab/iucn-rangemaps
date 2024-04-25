birds_get_species_info <- function(n_cores = 1) {
  
  path <- here::here("data", "BIRDS")
  
  if (!dir.exists(path)) {
    stop("The directory '", path, "' does not exist. Did you download the ", 
         "Birds of the World spatial data and extract the content of the ZIP ", 
         "file in '", path, "'?", call. = FALSE)
  }
  
  if (length(list.files(path, pattern = "gpkg$")) == 0) {
    stop("The directory '", path, "' does not contain gpkg layers. Please run ",
         "'birds_read_data()' first", call. = FALSE)
  }
  
  if (!file.exists(file.path(path, "BOTW.gdb"))) {
    stop("The file 'BOTW.gdb' does not exist in '", path, "/'.", call. = FALSE)
  }
  
  
  ## Get species list ----
  
  splist <- sf::st_read(file.path(path, "BOTW.gdb"), layer = "Checklist_v8_txt")
  splist <- splist[ , c("SISID", "Order_", "FamilyName", 
                        "IUCN_Red_List_Category_2023")]
  
  colnames(splist) <- c("blife_id", "blife_order", "blife_family", 
                        "blife_iucn_status")
  
  splist$"blife_order"  <- tools::toTitleCase(tolower(splist$"blife_order"))
  splist$"blife_family" <- tools::toTitleCase(tolower(splist$"blife_family"))
  
  
  ## Load spatial layers ----
  
  fls <- list.files(path, pattern = "gpkg$", full.names = TRUE)
  
  species_info <- parallel::mclapply(fls, function(x) {
    
    data <- sf::st_read(x)
    data <- sf::st_drop_geometry(data)
    data <- data[!duplicated(data$"blife_binomial"), ]
    data <- data[ , 1:2]
    
    data <- merge(data, splist, by = "blife_id", all.x = TRUE, all.y = FALSE)
  }, mc.cores = n_cores)
  
  do.call(rbind.data.frame, species_info)
}
