# turf

An R package for TURF (Total Unduplicated Reach and Frequency) analysis.

Given an N×J binary reach matrix, `turf()` exhaustively evaluates all bundles of M items and returns the top-K combinations ranked by reach. It supports both native R and C++ (via Rcpp) implementations, each with optional parallel processing.

## Installation

```r
# install.packages("pak")
pak::pak("dyavorsky/turf")
```

## Usage

```r
library(turf)
data(reach)  # 3602×12 example dataset
turf(mat = reach, range = 3:5, keep = 10) # M=3,4,5 and K=10
```

`turf()` returns a `data.table` with columns `size`, `rank`, `reach`, `freq`, and `item1` through `itemM` (for max M).  For example, `turf(reach, 3:5, 2)` returns:

| size | rank | reach | freq | item1 | item2 | item3 | item4 | item5 |
|-----:|-----:|------:|-----:|------:|------:|------:|------:|------:|
| 3 | 1 | 0.566 | 0.566 | 3 | 7 | 9 | — | — |
| 3 | 2 | 0.546 | 0.546 | 3 | 9 | 10 | — | — |
| 4 | 1 | 0.669 | 0.669 | 3 | 7 | 9 | 10 | — |
| 4 | 2 | 0.667 | 0.667 | 1 | 3 | 7 | 9 | — |
| 5 | 1 | 0.771 | 0.771 | 1 | 3 | 7 | 9 | 10 |
| 5 | 2 | 0.722 | 0.722 | 2 | 3 | 7 | 9 | 10 |
  
## Performance

Four execution modes are available via the `cpp` and `n_cores` arguments. See `vignette("turf-benchmarking")` for a comparison.

| Mode | Arguments |
|------|-----------|
| C++, multi-core (fastest, default) | `cpp = TRUE`, `n_cores = detectCores() - 1` |
| C++, single-core | `cpp = TRUE`, `n_cores = 1` |
| R, multi-core | `cpp = FALSE`, `n_cores = detectCores() - 1` |
| R, single-core (slowest) | `cpp = FALSE`, `n_cores = 1` |

