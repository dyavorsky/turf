\name{turf_plot}
\alias{turf_plot}

\title{Plot a TURF reach curve}

\description{
Plots reach (y-axis) against bundle size (x-axis) for the top-\code{k} bundles
at each bundle size. The rank-1 bundle at each size is connected by a line (the
reach curve) and labeled with its item composition. Lower-ranked bundles are
shown as progressively lighter points, conveying how much the choice of bundle
matters at each size.
}

\usage{
turf_plot(results, k = NULL, title = "TURF Reach Curve")
}

\arguments{
    \item{results}{A \code{data.table} returned by \code{\link{turf}}.}
    \item{k}{Number of bundles to display per bundle size. Must not exceed the
      number of bundles retained in \code{results}. Defaults to all retained bundles.}
    \item{title}{Plot title. Defaults to \code{"TURF Reach Curve"}.}
}

\value{
A \code{ggplot} object.
}

\examples{
data(reach)
results <- turf(mat = reach, range = 3:5, keep = 10,
                labels = paste0("Item", 1:12))
turf_plot(results)
turf_plot(results, k = 5, title = "Top 5 Bundles by Size")
}

\author{Dan Yavorsky}
