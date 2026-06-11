library(turf)
data(reach)

# reach is a 3602×12 binary matrix (respondents × items)
dim(reach)

results <- turf(mat = reach, range = 3:5, keep = 10)
head(results)

# res <- list()
# res[["overall"]] <- turf(mat)
# 
# for (i in names(demos)) {
#     res[[i]] <- turf(mat[demos[[i]] == 1, ])
# }
# 
# output <- dplyr::bind_rows(res, .id = "audience")

microbenchmark::microbenchmark(
    `R, 1 core`       = turf(reach, 3:5, n_cores = 1, cpp = FALSE),
    `R, multi-core`   = turf(reach, 3:5, n_cores = 3, cpp = FALSE),
    `C++, 1 core`     = turf(reach, 3:5, n_cores = 1, cpp = TRUE),
    `C++, multi-core` = turf(reach, 3:5, n_cores = 3, cpp = TRUE),
    times = 10
)

microbenchmark::microbenchmark(
    `R, 1 core`       = turf(reach, 6:8, n_cores = 1, cpp = FALSE),
    `R, multi-core`   = turf(reach, 6:8, n_cores = 3, cpp = FALSE),
    `C++, 1 core`     = turf(reach, 6:8, n_cores = 1, cpp = TRUE),
    `C++, multi-core` = turf(reach, 6:8, n_cores = 3, cpp = TRUE),
    times = 10
)
