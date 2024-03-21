#' Rename Mammals subpopulations to species level 
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
#' mammals <- mammals_rename_subpop(mammals)
#' }

mammals_rename_subpop <- function(data) {
  
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
  
  
  ## Identify sub-populations ----
  
  pos <- grep("subpopulation$", data[ , "iucn_binomial", drop = TRUE])
  
  if (length(pos) > 0) {
    
    subpop  <- unique(data[pos, "iucn_binomial", drop = TRUE])
    
    
    ## Create binomial names ----
    
    species <- lapply(strsplit(subpop, " "), function(x) paste(x[1], x[2]))
    species <- unlist(species)
    
    
    ## Replace sub-populations by binomial name ----
    
    for (i in 1:length(species)) {
      
      # If binomial exists
      pos <- which(data[ , "iucn_binomial", drop = TRUE] == species[i])
      
      if (length(pos) == 0) {
        # If binomial does not exist
        pos <- which(data[ , "iucn_binomial", drop = TRUE] == subpop[i])
      }
      
      iucn_binomial <- unique(data[pos, "iucn_binomial", drop = TRUE])
      iucn_id       <- unique(data[pos, "iucn_id", drop = TRUE])
      
      if (length(iucn_id) > 1) {
        stop("The species '", iucn_binomial, "' has multiple 'iucn_id'.", 
             call. = FALSE)
      }
      
      to_rename <- grep(species[i], data[ , "iucn_binomial", drop = TRUE])
      
      data[to_rename, "iucn_binomial"] <- iucn_binomial
      data[to_rename, "iucn_id"]       <- iucn_id
    }
  }
  
  data
}
