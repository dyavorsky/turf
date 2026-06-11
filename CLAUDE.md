# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

`turf` is an R package for TURF (Total Unduplicated Reach and Frequency) analysis. Given an N×J binary reach matrix, it exhaustively evaluates all C(J,M) combinations for each bundle size M in a range and returns the top-K combinations ranked by reach (proportion of respondents reached by at least one item in the bundle).

Install from GitHub via `pak::pak("dyavorsky/turf")`.

## Commands

```r
# Standard R package workflow — no Makefile or custom scripts
devtools::load_all()        # Load package interactively during development
devtools::document()        # Regenerate NAMESPACE and man/ from roxygen2 comments
devtools::check()           # Full R CMD check
devtools::build()           # Build .tar.gz

# After any changes to src/turf_m_c.cpp:
Rcpp::compileAttributes()   # Regenerates src/RcppExports.cpp and R/RcppExports.R

# Update pre-built vignette after editing vignettes/turf-benchmarking.qmd:
quarto::quarto_render("vignettes/turf-benchmarking.qmd")
file.copy("vignettes/turf-benchmarking.html", "inst/doc/turf-benchmarking.html", overwrite = TRUE)
file.remove("vignettes/turf-benchmarking.html")
knitr::purl("vignettes/turf-benchmarking.qmd", output = "inst/doc/turf-benchmarking.R", documentation = 0L)
```

There is no test suite in `tests/`. Validation is done manually using the bundled `reach` dataset (3,602×12 binary matrix).

## Architecture

### Dual Implementation

Every computation path has a pure-R fallback (`turf_m_r`) and a C++ optimized version (`turf_m_c`). The top-level `turf()` function selects between them via the `cpp` parameter (default `TRUE`).

```
turf()          ← user-facing entry point; validates inputs, orchestrates parallelism
  ├── turf_m_r()   ← pure R, single bundle size M
  └── turf_m_c()   ← Rcpp, single bundle size M (R/RcppExports.R → src/turf_m_c.cpp)
```

### Parallelism Model

Parallelism is across **bundle sizes**, not within a single bundle size. When `n_cores > 1`, `foreach`/`doParallel` distributes each value of M in `range` to a worker. Within a single M, both implementations loop over all C(J,M) combinations sequentially. This means multi-core only helps when `range` has multiple values (e.g., `3:6`).

### Output Shape

Results are returned as a `data.table` (via `rbindlist`) with columns:
- `size` — bundle size M
- `rank` — rank within bundle size (1 = highest reach)
- `reach` — proportion of respondents reached (weighted if `w` provided)
- `freq` — average number of items reaching each respondent
- `item1` … `itemM` — column indices of the selected items

### Weighted Analysis

Both implementations accept a weight vector `w` (length N). Passing scalar `1` (default) triggers uniform-weight fast paths in both R and C++. The C++ version explicitly checks for `NULL` or scalar `1.0` to skip weight computation.

### Rcpp Boundary

`src/turf_m_c.cpp` calls back into R for two operations: `combn()` (to generate combinations) and `order()` (to rank by reach). These are invoked via `Rcpp::Function`. Everything else — the reach/frequency accumulation loops — runs in C++.
