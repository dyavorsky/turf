\name{reach}
\alias{reach}
\docType{data}

\title{Reach Dataset}

\description{
A \eqn{3602 \times 12} binary matrix included for examples and benchmarking.
Each row is a survey respondent; each column is a binary indicator for whether
that item reaches the respondent.
}

\usage{data("reach")}

\format{
An integer matrix with 3602 rows and 12 columns (\code{V1} through \code{V12}).
}

\examples{
data(reach, package = "turf")
dim(reach)
}

\keyword{datasets}
