% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geog.range.overlap.R
\name{geog.range.overlap}
\alias{geog.range.overlap}
\title{Takes two emtools.species objects with range rasters, calculates overlap between them as in Fitzpatrick and Turelli 2006}
\usage{
geog.range.overlap(x, y)
}
\arguments{
\item{x}{An enmtools.species object containing a range raster}

\item{y}{An enmtools.species object containing a range raster}
}
\value{
A numeric value measuring range overlap.
}
\description{
Takes two emtools.species objects with range rasters, calculates overlap between them as in Fitzpatrick and Turelli 2006
}
\examples{
data(iberolacerta.clade)
data(euro.worldclim)
cyreni <- iberolacerta.clade$species$cyreni
monticola <- iberolacerta.clade$species$monticola
cyreni$range <- background.raster.buffer(cyreni$presence.points, 100000, euro.worldclim)
monticola$range <- background.raster.buffer(monticola$presence.points, 100000, euro.worldclim)
geog.range.overlap(cyreni, monticola)
}
