\name{turf}
\alias{turf}

\title{TURF: Total Unduplicated Reach and Frequency}

\description{
Exhaustively calculates TURF for an \eqn{N \times J} binary reach matrix \code{mat}
across bundle sizes \eqn{m = \code{min(range)}, \ldots, \code{max(range)}}. For each
bundle size \eqn{m}, all \code{choose(J, m)} combinations are evaluated and the
top-\code{keep} results (ranked by reach) are returned.
}

\usage{
turf(mat, range = 1:min(5, ncol(mat)), keep = 10, w = 1,
     n_cores = parallel::detectCores() - 1, cpp = TRUE)
}

\arguments{
    \item{mat}{An \eqn{N \times J} matrix of binary values. A value of 1 in \code{mat[r, c]} indicates respondent \eqn{r} is reached by item \eqn{c}.}
    \item{range}{A consecutive integer vector specifying the bundle sizes to evaluate. Defaults to \code{1:min(5, ncol(mat))}.}
    \item{keep}{Number of top results to return for each bundle size, ranked by reach.}
    \item{w}{A length-\code{nrow(mat)} vector of non-negative survey weights, or the scalar \code{1} for equal weights (default).}
    \item{n_cores}{Number of cores for parallel processing. Parallelizes across bundle sizes in \code{range}. Defaults to \code{detectCores() - 1}.}
    \item{cpp}{If \code{TRUE} (default), uses the C++ implementation. Set \code{FALSE} for the pure R fallback.}
}

\value{
A \code{data.table} with columns \code{size}, \code{rank}, \code{reach}, \code{freq},
and \code{item1} through \code{item}\eqn{m} (where \eqn{m = \code{max(range)}}),
containing the indices of items in each top-ranked bundle.
}

\examples{
data(reach)

# C++, multi-core (default — fastest)
turf(mat = reach, range = 3:5, keep = 10)

# Pure R, single core
turf(mat = reach, range = 3:5, keep = 10, n_cores = 1, cpp = FALSE)
}

\author{Dan Yavorsky}
