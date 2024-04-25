#' iucn-rangemaps: A Research Compendium
#' 
#' @description 
#' A paragraph providing a full description of the project and describing each 
#' step of the workflow.
#' 
#' @author Nicolas Casajus \email{nicolas.casajus@fondationbiodiversite.fr}
#' 
#' @date 2024/03/06



## Install Dependencies (listed in DESCRIPTION) ----

devtools::install_deps(upgrade = "never")


## Load Project Addins (R Functions and Packages) ----

devtools::load_all(here::here())


## Run Project ----

### Create study area grid ----

world_grid <- create_grid()


###
### MAMMALS
### 


### Import Mammals spatial layers ----

mammals <- mammals_read_data()


### Update Mammals taxonomy ----

mammals <- mammals_rename_subpop(mammals)
mammals <- mammals_rename_species(mammals)


### Extract Mammals species info ----

taxonomy <- mammals_get_species_info(mammals)
taxonomy <- mammals_match_taxonomies(taxonomy)

write.csv(taxonomy, here::here("outputs", "mammals_iucn_taxonomy.csv"),
          row.names = FALSE)


### Compute Mammals range sizes (~ 30mins) ----

range_sizes <- mammals_range_sizes(mammals, world_grid, n_cores = 20)

write.csv(range_sizes, here::here("outputs", "mammals_iucn_range_sizes.csv"),
          row.names = FALSE)


### Intersect Mammals polygons with raster (~ 30mins) ----

occs_by_cells <- mammals_occ_on_cells(mammals, world_grid, n_cores = 20)

qs::qsave(occs_by_cells, here::here("outputs", "mammals_iucn_occs_by_cells.qs"))


###
### BIRDS
### 


### Split Birds spatial layers ----

birds_split_polygons()


### Extract Birds species info ----

taxonomy <- birds_get_species_info(n_cores = 10)
taxonomy <- birds_match_taxonomies(taxonomy)

write.csv(taxonomy, here::here("outputs", "birds_birdlife_taxonomy.csv"),
          row.names = FALSE)


### Compute Birds range sizes (~ 30mins) ----

range_sizes <- birds_range_sizes(world_grid, n_cores = 20)

write.csv(range_sizes, here::here("outputs", "birds_birdlife_range_sizes.csv"),
          row.names = FALSE)


### Intersect Birds polygons with raster (~ 30mins) ----

occs_by_cells <- birds_occ_on_cells(world_grid, n_cores = 20)

qs::qsave(occs_by_cells, here::here("outputs", "birds_birdlife_occs_by_cells.qs"))
