#' Rename Mammals species
#'
#' @description
#' Rename the following species:
#' - `Neomys milleri` in `Neomys anomalus`
#' - `Myotis crypticus` in `Myotis nattereri`
#' - `Crocidura gueldenstaedtii` in `Crocidura suaveolens`
#' - `Talpa talyschensis` in `Talpa levantis`
#' - `Talpa ognevi` in `Talpa caucasica`
#'
#' @param data an `sf` object. The output of the function `mammals_read_data()`.
#'
#' @return A `MULTIPOLYGON` object (package `sf`) with the same dimensions as
#' `data`.
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' mammals <- mammals_read_data()
#' mammals <- mammals_rename_species(mammals)
#' }

mammals_rename_species <- function(data) {
  
  ## Check arg ----
  
  if (missing(data)) {
    stop("Argument 'data' is required.", call. = FALSE)
  }
  
  if (!inherits(data, "data.frame")) {
    stop("Argument 'data' must be a data.frame or an 'sf' object.", 
         call. = FALSE)
  }
  
  if (any(!(c("iucn_id", "iucn_binomial") %in% colnames(data)))) {
    stop("Columns 'iucn_id' and/or 'iucn_binomial' are absent from 'data'.",
         call. = FALSE)
  }
  
  
  ## Species to rename ----
  
  to_rename <- c("Neomys milleri", 
                 "Myotis crypticus",
                 "Crocidura gueldenstaedtii",
                 "Talpa talyschensis",
                 "Talpa ognevi")
  
  rename_in <- c("Neomys anomalus",
                 "Myotis nattereri",
                 "Crocidura suaveolens",
                 "Talpa levantis",
                 "Talpa caucasica")
  
  
  ## Rename binomial ----
  
  for (i in 1:length(to_rename)) {
    
    to_rn <- which(data[ , "iucn_binomial", drop = TRUE] == to_rename[i])
    
    if (length(to_rn) > 0) {
      
      rn_in <- data[which(data[ , "iucn_binomial", drop = TRUE] == 
                            rename_in[i]), ]
      
      
      if (nrow(rn_in) > 0) {
        
        rn_in <- sf::st_drop_geometry(rn_in[1, c("iucn_id", "iucn_binomial", 
                                                 "iucn_order", "iucn_family", 
                                                 "iucn_category")])
        
        data[to_rn, c("iucn_id", "iucn_binomial", 
                      "iucn_order", "iucn_family", 
                      "iucn_category")] <- rn_in
      } else {
        stop("Unable to rename species '", rename_in[i], "'.", call. = FALSE)  
      }
    }
  }
  
  data
}
