% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check.bg.R
\name{check.bg}
\alias{check.bg}
\title{Takes an emtools.species object and adds background points if they're missing. Looks for range raster first, then goes for environmental layers.}
\usage{
check.bg(
  species,
  env = NA,
  nback = 1000,
  bg.source = "default",
  verbose = FALSE,
  bias = NA
)
}
\arguments{
\item{species}{An enmtools.species object}

\item{env}{A SpatRaster containing environmental data.}

\item{nback}{Number of background points to generate, if any}

\item{bg.source}{Source for drawing background points.  If "points", it just uses the background points that are already in the species object.  If "range", it uses the range raster.  If "env", it draws points at randome from the entire study area outlined by the first environmental layer.}

\item{verbose}{Controls printing of various messages progress reports.  Defaults to FALSE.}

\item{bias}{A SpatRaster representing estimated relative sampling bias.  Used when bg.source is either "range" or "env".}
}
\value{
An enmtools.species object with background points.
}
\description{
Takes an emtools.species object and adds background points if they're missing. Looks for range raster first, then goes for environmental layers.
}
