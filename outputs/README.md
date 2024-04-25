## Output description


### `birds_birdlife_taxonomy.csv`

A table containing taxonomic information for 11,182 birds species with the following columns:

- `blife_id`: the species identifier in the BirdLife International database (spatial data)
- `blife_binomial`: the species binomial name in the BirdLife International database (spatial data)
- `blife_order`: the species order in the BirdLife International database (spatial data)
- `blife_family`: the species family in the BirdLife International database (spatial data)
- `blife_iucn_status`: the species conservation status in the IUCN database (spatial data)
- `ref_binomial`: the species binomial name in the IUCN database
- `ref_order`: the species order in the IUCN database
- `ref_family`: the species family in the IUCN database
- `ref_id`: the species identifier in the IUCN database
- `method`: the method used to merge BirdLife data and the table `data/sp_list_aves_final.csv`:
    - `Match by ID`, (`n = 11,053`) species have been merged by their IUCN identifier
    - `Match by binomial`, (`n = 71`) species have been merged by their binomial name (if the merge by ID has failed)
    - `No match`, (`n = 58`) the species in BirdLife has no match in `data/sp_list_aves_final.csv`

The `ref_*` fields can contain `NA` if the species was not found in `data/sp_list_aves_final.csv`.

This table was produced by the functions  [`birds_get_species_info()`](https://github.com/frbcesab/iucn-rangemaps/blob/main/R/birds_get_species_info.R) and [`birds_match_taxonomies()`](https://github.com/frbcesab/iucn-rangemaps/blob/main/R/birds_match_taxonomies.R).

To import this dataset, use the following line in R:

```r
birds_species <- read.csv(here::here("outputs", "birds_birdlife_taxonomy.csv"))
```


### `mammals_iucn_taxonomy.csv`

A table containing taxonomic information for 5,878 mammals species with the following columns:

- `iucn_id`: the species identifier in the IUCN database (spatial data)
- `iucn_binomial`: the species binomial name in the IUCN database (spatial data)
- `iucn_order`: the species order in the IUCN database (spatial data)
- `iucn_family`: the species family in the IUCN database (spatial data)
- `iucn_category`: the species conservation status in the IUCN database (spatial data)
- `ref_binomial`: the species binomial name in the IUCN database
- `ref_order`: the species order in the IUCN database
- `ref_family`: the species family in the IUCN database
- `ref_id`: the species identifier in the IUCN database
- `method`: the method used to merge spatial layer data and the table `data/sp_list_mammalia_final.csv`:
    - `Match by ID`, (`n = 5,779`) species have been merged by their IUCN identifier
    - `Match by binomial`, (`n = 94`) species have been merged by their binomial name (if the merge by ID has failed)
    - `No match`, (`n = 5`) the species in BirdLife has no match in `data/sp_list_mammalia_final.csv`

The `ref_*` fields can contain `NA` if the species was not found in `data/sp_list_mammalia_final.csv`.

This table was produced by the functions  [`mammals_get_species_info()`](https://github.com/frbcesab/iucn-rangemaps/blob/main/R/mammals_get_species_info.R) and [`mammals_match_taxonomies()`](https://github.com/frbcesab/iucn-rangemaps/blob/main/R/mammals_match_taxonomies.R).

To import this dataset, use the following line in R:

```r
mammals_species <- read.csv(here::here("outputs", "mammals_iucn_taxonomy.csv"))
```



### `birds_birdlife_range_sizes.csv`

A table containing range sizes for 11,182 birds species with the following columns:

- `blife_binomial`: the species binomial name in the BirdLife International database
- `n_cells`: the number of grid cells intersecting species spatial polygons
- `st_area`: the area of species polygons

**Note:** spatial analyses were performed under the Eckert IV projection system.

This table was produced by the function  [`birds_range_sizes()`](https://github.com/frbcesab/iucn-rangemaps/blob/main/R/birds_range_sizes.R).

To import this dataset, use the following line in R:

```r
birds_rangesize <- read.csv(here::here("outputs", "birds_birdlife_range_sizes.csv"))
```



### `mammals_iucn_range_sizes.csv`

A table containing range sizes for 5,865 mammals species with the following columns:

- `iucn_binomial`: the species binomial name in the IUCN database
- `n_cells`: the number of grid cells intersecting species spatial polygons
- `st_area`: the area of species polygons

**Note:** spatial analyses were performed under the Eckert IV projection system.

This table was produced by the function  [`mammals_range_sizes()`](https://github.com/frbcesab/iucn-rangemaps/blob/main/R/mammals_range_sizes.R).

To import this dataset, use the following line in R:

```r
mammals_rangesize <- read.csv(here::here("outputs", "mammals_iucn_range_sizes.csv"))
```



### `birds_birdlife_occs_by_cells.qs`

A list of 11,182 elements (birds species). Each element is a numeric vector containing the identifier of grid cells intersecting species spatial polygons. It represent the species occurrence on the grid.

This table was produced by the function  [`birds_occ_on_cells()`](https://github.com/frbcesab/iucn-rangemaps/blob/main/R/birds_occ_on_cells.R).

To import this dataset, use the following line in R:

```r
birds_occurrences <- qs::qread(here::here("outputs", "birds_birdlife_occs_by_cells.qs"))
```

**Note:** this file was to large to be uploaded to GitHub.



### `mammals_iucn_occs_by_cells.qs`

A list of 5,865 elements (mammals species). Each element is a numeric vector containing the identifier of grid cells intersecting species spatial polygons. It represent the species occurrence on the grid.

This table was produced by the function  [`mammals_occ_on_cells()`](https://github.com/frbcesab/iucn-rangemaps/blob/main/R/mammals_occ_on_cells.R).

To import this dataset, use the following line in R:

```r
mammals_occurrences <- qs::qread(here::here("outputs", "mammals_iucn_occs_by_cells.qs"))
```
