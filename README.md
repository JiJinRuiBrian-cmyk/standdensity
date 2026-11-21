# standdensity

Parameterized, reusable and transferable stand density management model
（林分密度管理模型）for even-aged stands.

Given a species code, the package returns that species' parameter equations,
self-thinning line, density and stability classification, predicted stand
variables, and the stand density management diagram (SDMD).

## Species library

Seven classic relative-spacing (RS) SDMD species:

| code | species | source |
| --- | --- | --- |
| `chinese_fir` | Chinese fir 杉木 | Tang et al. 2016, *Forestry* 89(1) |
| `pedunculate_oak` | Pedunculate oak 夏栎 | Barrio-Anta & Álvarez-González 2005, *Forestry* 78(3) |
| `radiata_pine` | Radiata pine 辐射松 | Castedo-Dorado et al. 2009, *Forestry* 82(1) |
| `sweet_chestnut` | Sweet chestnut 甜栗 | Patrício et al. 2017, *iForest* 10(6) |
| `betula_alba` | Birch 白桦 | Diéguez-Aranda et al. 2009, Table 3.2 |
| `douglas_fir_spain` | Douglas-fir (Spain) 花旗松 | Diéguez-Aranda et al. 2009, Table 3.4 |
| `chestnut_coppice` | Sweet chestnut coppice 甜栗矮林 | Menéndez-Miguélez et al. 2016, *Bosque* 37(1) |

## What it does

- `list_species()` / `get_species(code)`: species parameter library.
- `stand_predict(sp, N, Hd)`: from stem number and dominant height, predict
  quadratic mean diameter, basal area, volume, stem/aboveground biomass,
  relative spacing (RS) and height-diameter ratio (SC).
- `assess(sp, N, Hd)`: prediction plus density/stability classification.
- `self_thinning_nmax()` / `self_thinning_curve()`: Reineke self-thinning line.
- `plot_self_thinning()`: self-thinning line figure.
- `fit_equations()` / `fit_species_from_data()`: refit from local data or
  register a new species.
- `detect_anomalies()`: residual + range-envelope outlier flagging.
- `draw_sdmd()`: density management diagram.
- `thin_schedule()`: dominant-height growth curve as time axis plus RS-rule
  thinning, returning thinning timing/intensity/residual stem number.
- `report()`: printable parameter equations.
- `export_species()` / `export_all()`: archive parameters as JSON.

## Install

```r
install.packages("devtools")
devtools::install("/path/to/standdensity")
```

Or from a terminal:

```bash
R CMD INSTALL standdensity
```

## Quick start

```r
library(standdensity)
list_species()
sp <- get_species("chinese_fir")
cat(report(sp))
m <- stand_predict(sp, N = 1021, Hd = 12)
print(m)
print(assess(sp, 1021, 12))
draw_sdmd(sp, save_path = "SDMD.png")
```

## Self-check

```bash
cd standdensity
Rscript tests/run_tests.R
```

The self-check verifies the seven classic SDMD species against their published
equations and tables, the Reineke self-thinning line, density/stability
classification, and every figure path.
