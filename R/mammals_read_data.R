#' Import IUCN range maps for Mammals
#'
#' @description Before using this function, user needs to request the Mammals 
#' IUCN spatial data at:
#' \url{https://www.iucnredlist.org/resources/spatial-data-download} 
#' and download the ZIP file from its IUCN account. The content of the ZIP
#' (folder `MAMMALS/`) must be extracted in the folder `data/`. 
#' This function will then read the file `data/MAMMALS/MAMMALS.shp`.
#'
#' @return A `MULTIPOLYGON` object (package `sf`).
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' mammals <- mammals_read_data()
#' mammals
#' }

mammals_read_data <- function() {
  
  ## Check path ----
  
  path <- here::here("data", "MAMMALS")
  
  if (!dir.exists(path)) {
    stop("The directory '", path, "' does not exist. Did you download the ", 
         "Mammals IUCN spatial data and extract the content of the ZIP file ", 
         "in '", path, "'?", call. = FALSE)
  }
  
  
  ## Import spatial layer ----
  
  if (!file.exists(file.path(path, "MAMMALS.shp"))) {
    stop("The file 'MAMMALS.shp' does not exist in '", path, "/'.", call. = FALSE)
  }
  
  data <- sf::st_read(file.path(path, "MAMMALS.shp"))
  
  
  ## Select columns ----
  
  data <- data[ , c("id_no", "sci_name", "order_", "family", "category", 
                    "presence")]
  
  
  ## Clean data ----
  
  colnames(data)[1:2] <- c("id", "binomial")
  colnames(data) <- gsub("order_", "order", colnames(data))
  
  colnames(data)[-ncol(data)] <- paste0("iucn_", colnames(data)[-ncol(data)])
  
  data
}
