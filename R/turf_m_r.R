turf_m_r <- function(mat, m, keep = 10, w = 1) {

    N <- nrow(mat)
    J <- ncol(mat)

    X <- t(combn(J, m))  # all C(J,m) combinations, one per row
    M <- choose(J, m)

    reach <- rep(NA_real_, M)
    freq  <- rep(NA_real_, M)

    for (i in 1:M) {
        y        <- rowSums(mat[, X[i, seq(m)], drop = FALSE])
        reach[i] <- sum(w * (y > 0)) / sum(w)
        freq[i]  <- sum(y * w) / sum(w)
    }

    colnames(X) <- paste0("item", seq(m))
    res <- cbind(
        data.frame(size = m, rank = seq(M)),
        data.frame(reach = reach, freq = freq, X)[order(reach, decreasing = TRUE), ]
    )[seq(min(M, keep)), ]

    return(res)
}
