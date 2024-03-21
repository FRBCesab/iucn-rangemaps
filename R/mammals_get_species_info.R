#' Extract species information from IUCN spatial data
#'
#' @param data an `sf` object. The output of the function `mammals_read_data()`
#'   or `mammals_rename_subpop()`.
#'
#' @return A `data.frame` with the following columns:
#'   - `iucn_id`: the species IUCN unique identifier,
#'   - `iucn_binomial`: the species binomial name,
#'   - `iucn_order`: the species order,
#'   - `iucn_family`: the species family,
#'   - `iucn_category`, the IUCN category,
#'   - `iucn_presence`, used later to remove polygons where species are extinct.
#' 
#' @export
#'
#' @examples
#' \dontrun{
#' mammals <- mammals_read_data()
#' mammals <- mammals_rename_subpop(mammals)
#' mammals <- mammals_rename_species(mammals)
#' sp_list <- mammals_get_species_info(mammals)
#' }

mammals_get_species_info <- function(data) {
  
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
  
  
  ## Convert to data.frame ----
  
  data <- sf::st_drop_geometry(data)
  
  
  ## Check for possible multiple ID by species ----
  
  check <- tapply(data$"iucn_id", data$"iucn_binomial", 
                  function(x) length(unique(x)))
  
  if (any(check > 1)) {
    stop("Some species have multiple 'iucn_id'.", call. = FALSE)
  }
  
  
  ## Remove duplicated rows (multiple polygons per species) ----
  
  data <- data[!duplicated(data$"iucn_binomial"), ]
  
  
  ## Order rows ----
  
  data <- data[with(data, order(iucn_order, iucn_family, iucn_binomial)), ]
  
  rownames(data) <- NULL
  
  
  ## Clean fields ----
  
  data$"iucn_order"  <- tools::toTitleCase(tolower(data$"iucn_order"))
  data$"iucn_family" <- tools::toTitleCase(tolower(data$"iucn_family"))
  
  data
}
