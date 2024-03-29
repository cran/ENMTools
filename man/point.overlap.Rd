% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/point.overlap.R
\name{point.overlap}
\alias{point.overlap}
\title{Takes two emtools.species objects with range rasters, calculates overlap between them as in Cardillo and Warren 2016}
\usage{
point.overlap(x, y)
}
\arguments{
\item{x}{An enmtools.species object containing presence points}

\item{y}{An enmtools.species object containing presence points}
}
\value{
A numeric value measuring the overlap between point distributions.
}
\description{
Takes two emtools.species objects with range rasters, calculates overlap between them as in Cardillo and Warren 2016
}
\examples{
\donttest{
cyreni <- iberolacerta.clade$species$cyreni
monticola <- iberolacerta.clade$species$monticola
point.overlap(cyreni, monticola)
}
}
