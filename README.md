# turf

An R package for TURF (Total Unduplicated Reach and Frequency) analysis.

Given an N×J binary reach matrix, `turf()` exhaustively evaluates all bundles of M items and returns the top-K combinations ranked by reach. It supports a C++ implementation (via Rcpp) and a pure R fallback, each with optional parallel processing.

## Installation

```r
# install.packages("pak")
pak::pak("dyavorsky/turf")
```

## Usage

```r
library(turf)
data(reach)  # 3602×12 example dataset
turf(mat = reach, range = 3:5, keep = 10)
```

`turf()` returns a `data.table` with columns `size`, `rank`, `reach`, `freq`, and `item1` through `itemM`.

## Performance

Four execution modes are available via the `cpp` and `n_cores` arguments. See `vignette("turf-benchmarking")` for a full comparison.

| Mode | Arguments |
|------|-----------|
| C++, multi-core (fastest, default) | `cpp = TRUE`, `n_cores = detectCores() - 1` |
| C++, single-core | `cpp = TRUE`, `n_cores = 1` |
| R, multi-core | `cpp = FALSE`, `n_cores = detectCores() - 1` |
| R, single-core (slowest) | `cpp = FALSE`, `n_cores = 1` |

