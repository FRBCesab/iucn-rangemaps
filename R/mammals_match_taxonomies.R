#' Merge IUCN taxonomy from spatial data and IUCN taxonomy from API
#'
#' This function will try to merge information from IUCN spatial data with 
#' information from IUCN API. First by IUCN unique identifier and then, for
#' unmatched species, by binomial name. The method used will be reported in the 
#' output.
#' 
#' @param data a `data.frame`. The output of the function 
#'   `mammals_get_species_info()`.
#'
#' @return A `data.frame` with the following columns:
#'   - `iucn_id`: the species IUCN unique identifier,
#'   - `iucn_binomial`: the species binomial name,
#'   - `iucn_order`: the species order,
#'   - `iucn_family`: the species family,
#'   - `iucn_category`, the IUCN category,
#'   - `iucn_presence`, used later to remove polygons where species are extinct.
#'   - `ref_id`: the species IUCN unique identifier in the API,
#'   - `ref_binomial`: the species binomial name in the API,
#'   - `ref_order`: the species order in the API,
#'   - `ref_family`: the species family in the API,
#'   - `method`: the method used to match rows.
#'   
#' **Note** additional species from the API are not returned. The number of rows
#' in the output is exactly the same as the input (argument `data`).
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' mammals <- mammals_read_data()
#' mammals <- mammals_rename_subpop(mammals)
#' mammals <- mammals_rename_species(mammals)
#' sp_list <- mammals_get_species_info(mammals)
#' sp_list <- mammals_match_taxonomies(sp_list)
#' }

mammals_match_taxonomies <- function(data) {
  
  ## Check arg ----
  
  if (missing(data)) {
    stop("Argument 'data' is required.", call. = FALSE)
  }
  
  if (!inherits(data, "data.frame")) {
    stop("Argument 'data' must be a data.frame or an 'sf' object.", 
         call. = FALSE)
  }
  
  cols <- c("iucn_id", "iucn_binomial", "iucn_order", "iucn_family", 
            "iucn_category", "iucn_presence")
  
  for (col in cols) {
    if (!(col %in% colnames(data))) {
      stop("Columns '", col, "' is absent from 'data'.", call. = FALSE)
    }
  }
  
  
  ## Check path ----
  
  path <- here::here("data")
  
  if (!dir.exists(path)) {
    stop("The directory '", path, "' does not exist.", call. = FALSE)
  }
  
  
  ## Import spatial layer ----
  
  if (!file.exists(file.path(path, "sp_list_mammalia_final.csv"))) {
    stop("The file 'sp_list_mammalia_final.csv' does not exist in '", path, 
         "/'.", call. = FALSE)
  }
  
  ref <- read.csv2(file.path(path, "sp_list_mammalia_final.csv"))
  ref <- ref[ , c("ref_id", "ref_binomial", "ref_order", "ref_family")]
  
  
  ## Match by IUCN ID ----
  
  taxo_1 <- merge(data, ref, by.x = "iucn_id", by.y = "ref_id", all = FALSE)
  
  taxo_1$"ref_id" <- taxo_1$"iucn_id"
  taxo_1$"method" <- "Match by ID"
  
  
  ## Match by binomial ----
  
  spp <- data[which(!(data$iucn_id %in% taxo$iucn_id)), ]
  
  taxo_2 <- merge(spp, ref, by.x = "iucn_binomial", by.y = "ref_binomial", 
                  all.x = TRUE, all.y = FALSE)
  
  taxo_2$"ref_binomial" <- taxo_2$"iucn_binomial"
  taxo_2$"method"       <- "Match by binomial"

  
  ## No match ----
  
  mismatch <- which(is.na(taxo_2$"ref_id"))
  
  if (length(mismatch) > 0) {
    taxo_2[mismatch, "ref_binomial"] <- NA
    taxo_2[mismatch, "method"]       <- "No match"
  }
  
  rbind(taxo_1, taxo_2[ , colnames(taxo_1)])
}
