## Data description

### `BIRDS/`

This folder contains the Birds of the World spatial data used to compute metrics for birds (BirdLife International 2023). Due to license restrictions, these data have not been uploaded to GitHub. User needs to request the Birds of the World spatial data at: <https://datazone.birdlife.org/species/requestdis> and download the ZIP file from the link sent by email. The content of the ZIP (folder `BOTW_XXX/`) must be extracted in the folder `data/` and renamed as `BIRDS/`. E.g. `data/BIRDS/BOTW.gdb`.

These data will be read by the function [birds_split_polygons()](https://github.com/FRBCesab/iucn-rangemaps/blob/main/R/birds_split_polygons.R).



### `MAMMALS/`

This folder contains the IUCN Mammals spatial data used to compute metrics for mammals (IUCN 2023). Due to license restrictions, these data have not been uploaded to GitHub. User needs to request the IUCN Mammals spatial data at: <https://www.iucnredlist.org/resources/spatial-data-download> and download the ZIP file from its IUCN account. The content of the ZIP (folder `MAMMALS/`) must be extracted in the folder `data/`. E.g. `data/MAMMALS/MAMMALS.shp`.

These data will be read by the function [mammals_read_data()](https://github.com/FRBCesab/iucn-rangemaps/blob/main/R/mammals_read_data.R).



### `sp_list_aves_final.csv`

A table containing taxonomic information for 11,162 Birds species with the following columns:

- `ref_binomial`: the binomial name of the species in the IUCN database
- `ref_id`: the identifier of the species in the IUCN database
- `ref_kingdom`: the name of the kingdom of the species (e.g. `Animalia`)
- `ref_phylum`: the name of the phylum of the species (e.g. `Chordata`)
- `ref_class`: the name of the class of the species (e.g. `Aves`)
- `ref_order`: the name of the order of the species
- `ref_family`: the name of the family of the species
- `ref_genus`: the name of the genus of the species


To import this dataset, use the following line in R:

```r
bird_species <- read.csv2(here::here("data", "sp_list_aves_final.csv"))
```


### `sp_list_mammalia_final.csv`

A table containing taxonomic information for 5,970 Mammals species with the following columns:

- `ref_binomial`: the binomial name of the species in the IUCN database
- `ref_id`: the identifier of the species in the IUCN database
- `ref_kingdom`: the name of the kingdom of the species (e.g. `Animalia`)
- `ref_phylum`: the name of the phylum of the species (e.g. `Chordata`)
- `ref_class`: the name of the class of the species (e.g. `Mammalia`)
- `ref_order`: the name of the order of the species
- `ref_family`: the name of the family of the species
- `ref_genus`: the name of the genus of the species


To import this dataset, use the following line in R:

```r
mammal_species <- read.csv2(here::here("data", "sp_list_mammalia_final.csv"))
```



### `world_grid.tif`

The raster created by the function [create_grid()](https://github.com/FRBCesab/iucn-rangemaps/blob/main/R/create_grid.R) defining the study area, i.e. a World raster w/ a 0.08333° x 0.08333° resolution and defined in the WGS84 system (`EPSG = 4326`).

To import this layer, use the following line in R:

```r
world_grid <- terra::rast(here::here("data", "world_grid.tif"))
```


### References

BirdLife International and Handbook of the Birds of the World (2023) Bird species distribution maps of the world. Version 2023-1. Available at: <http://datazone.birdlife.org/species/requestdis>. Accessed on [22/03/2024].

IUCN (2023) The IUCN Red List of Threatened Species. Version 2023-1. Available at: <https://www.iucnredlist.org>. Accessed on [22/03/2024].

