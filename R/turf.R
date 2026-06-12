turf <- function(mat, range = 1:min(5, ncol(mat)), keep = 10, w = 1,
                 n_cores = 1, cpp = TRUE, labels = NULL) {

    N <- nrow(mat)
    J <- ncol(mat)

    # mat must be a matrix of 0s and 1s
    if (!all(mat == 0 | mat == 1))
        stop("'mat' must be a matrix of only 0s and 1s")

    # range must be a consecutive vector of integers within 1:J
    if (!(all(seq_along(range) == seq(max(range) - min(range) + 1))) ||
        min(range) < 1 || max(range) > J)
        stop("'range' must be a vector of consecutive integers with min(range) >= 1 and max(range) <= ncol(mat)")

    # w must be a length-N weight vector or the scalar 1
    if (length(w) == 1 && w == 1) w <- rep(1, N)
    if (length(w) == 1 && w != 1) stop("w must be a vector of length nrow(mat) or the scalar '1'")
    if (length(w) != N)           stop("w must be a vector of length nrow(mat) or the scalar '1'")
    if (any(w < 0))               stop("weights must be non-negative")
    if (sum(w) == 0)              stop("sum of weights must be positive")
    if (any(!is.finite(w)))       stop("weights must be finite")
    if (any(is.na(w)))            stop("weights must not be NA")

    # labels must be a character vector of length J
    if (!is.null(labels)) {
        if (!is.character(labels) || length(labels) != J)
            stop("'labels' must be a character vector of length ncol(mat)")
    }

    # n_cores must be reasonable
    if (n_cores < 1) stop("'n_cores' must be positive")
    if (n_cores > parallel::detectCores())
        stop(paste("'n_cores' too large: you only have", parallel::detectCores(), "cores"))

    # Single core
    if (n_cores == 1) {
        res_list <- vector(mode = "list", length = length(range))
        if (cpp)  for (i in seq_along(range)) res_list[[i]] <- turf_m_c(mat, range[i], keep, w)
        if (!cpp) for (i in seq_along(range)) res_list[[i]] <- turf_m_r(mat, range[i], keep, w)
    }

    # Multi-core
    if (n_cores > 1) {
        cl <- parallel::makeCluster(n_cores)
        doParallel::registerDoParallel(cl)
        on.exit(parallel::stopCluster(cl))
        if (cpp)  res_list <- foreach(i = seq_along(range), .packages = "turf") %dopar% turf::turf_m_c(mat, range[i], keep, w)
        if (!cpp) res_list <- foreach(i = seq_along(range)) %dopar% turf_m_r(mat, range[i], keep, w)
    }

    result <- data.table::rbindlist(res_list, fill = TRUE)

    if (!is.null(labels)) {
        item_cols <- grep("^item", names(result), value = TRUE)
        for (col in item_cols) {
            idx <- result[[col]]
            result[[col]] <- ifelse(is.na(idx), NA_character_, labels[idx])
        }
    }

    result
}
