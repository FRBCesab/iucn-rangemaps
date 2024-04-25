
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Mammals & Birds IUCN Range Maps <img src="https://raw.githubusercontent.com/FRBCesab/templates/main/logos/compendium-sticker.png" align="right" style="float:right; height:120px;"/>

<!-- badges: start -->

[![License: GPL (\>=
2)](https://img.shields.io/badge/License-GPL%20%28%3E%3D%202%29-blue.svg)](https://choosealicense.com/licenses/gpl-2.0/)
<!-- badges: end -->

<p align="left">
• <a href="#overview">Overview</a><br> • <a href="#data-sources">Data
sources</a><br> • <a href="#content">Content</a><br> •
<a href="#installation">Installation</a><br> •
<a href="#usage">Usage</a><br> • <a href="#citation">Citation</a><br> •
<a href="#contributing">Contributing</a><br> •
<a href="#acknowledgments">Acknowledgments</a><br> •
<a href="#references">References</a>
</p>

## Overview

This project is dedicated to compute species range size of all Birds and
Mammals of the World.

## Data sources

This project uses the following databases:

| Database                                    | Usage                          | Reference                     |                                Link                                 |
|:--------------------------------------------|:-------------------------------|:------------------------------|:-------------------------------------------------------------------:|
| IUCN Mammals spatial data                   | Compute mammal species metrics | IUCN (2023)                   | [link](https://www.iucnredlist.org/resources/spatial-data-download) |
| Bird species distribution maps of the world | Compute bird species metrics   | BirdLife International (2023) |      [link](https://datazone.birdlife.org/species/requestdis)       |
| Natural Earth                               | World maps                     | None                          |              [link](https://www.naturalearthdata.com/)              |

A comprehensive description of all these databases is available
[here](https://github.com/frbcesab/iucn-rangemaps/blob/main/data/README.md).

## Workflow

The analysis pipeline follows these steps:

1.  Create study area (raster of 0.08333° x 0.08333° resolution)
2.  Analyses for Mammals species
    - Import IUCN layer
    - Extract species names
    - Check taxonomy
    - Merge subpopulation w/ parent
    - Compute species range size (count grid cells)
    - Compute species range size (polygons area)
    - Intersect polygons on grid cells (occurrences at cell level)
3.  Analyses for Birds species
    - Import BirdLife layers
    - Split spatial layers by Birds family
    - Extract species names
    - Check taxonomy
    - Compute species range size (count grid cells)
    - Compute species range size (polygons area)
    - Intersect polygons on grid cells (occurrences at cell level)

## Content

This repository is structured as follow:

- [`DESCRIPTION`](https://github.com/frbcesab/iucn-rangemaps/blob/main/DESCRIPTION):
  contains project metadata (authors, description, license,
  dependencies, etc.).

- [`make.R`](https://github.com/frbcesab/iucn-rangemaps/blob/main/make.R):
  main R script to set up and run the entire project. Open this file to
  follow the workflow step by step.

- [`R/`](https://github.com/frbcesab/iucn-rangemaps/blob/main/R):
  contains R functions developed especially for this project.

- [`data/`](https://github.com/frbcesab/iucn-rangemaps/blob/main/data):
  contains raw data used in this project. See the
  [`README`](https://github.com/frbcesab/iucn-rangemaps/blob/main/data/README.md)
  for further information.

- [`outputs/`](https://github.com/frbcesab/iucn-rangemaps/blob/main/outputs):
  contains the outputs of the project. See the
  [`README`](https://github.com/frbcesab/iucn-rangemaps/blob/main/outputs/README.md)
  for a complete description of the files.

- [`figures/`](https://github.com/frbcesab/iucn-rangemaps/blob/main/figures):
  contains the figures used to validate et visualize the outputs.

## Installation

To install this compendium:

- [Fork](https://docs.github.com/en/get-started/quickstart/contributing-to-projects)
  this repository using the GitHub interface.
- [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)
  your fork using `git clone fork-url` (replace `fork-url` by the URL of
  your fork). Alternatively, open [RStudio
  IDE](https://posit.co/products/open-source/rstudio/) and create a New
  Project from Version Control.

## Usage

Launch the
[`make.R`](https://github.com/frbcesab/iucn-rangemaps/tree/main/make.R)
file with:

``` r
source("make.R")
```

**Notes**

- All required packages listed in the
  [`DESCRIPTION`](https://github.com/frbcesab/iucn-rangemaps/blob/main/DESCRIPTION)
  file will be installed (if necessary)
- All required packages and R functions will be loaded
- Each script in
  [`analyses/`](https://github.com/frbcesab/iucn-rangemaps/blob/main/analyses)
  can be run independently
- Some steps listed in the
  [`make.R`](https://github.com/frbcesab/iucn-rangemaps/blob/main/make.R)
  might take time (several hours)

## Citation

Please use the following citation:

> Casajus N, Loiseau N & Mouquet N (2024) World mammals and birds
> species richness. URL: <https://github.com/frbcesab/iucn-rangemaps/>.

## Contributing

All types of contributions are encouraged and valued. For more
information, check out our [Contributor
Guidelines](https://github.com/frbcesab/iucn-rangemaps/blob/main/CONTRIBUTING.md).

Please note that this project is released with a [Contributor Code of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## References

BirdLife International and Handbook of the Birds of the World (2023)
Bird species distribution maps of the world. Version 2023-1. Available
at: <http://datazone.birdlife.org/species/requestdis>. Accessed on
\[22/03/2024\].

IUCN (2023) The IUCN Red List of Threatened Species. Version 2023-1.
Available at: <https://www.iucnredlist.org>. Accessed on \[22/03/2024\].
