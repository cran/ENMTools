% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/package.depends.R
\name{check.extras}
\alias{check.extras}
\title{Check that the extra packages needed for an ENMTools function are installed and available}
\usage{
check.extras(funs = NULL)
}
\arguments{
\item{funs}{character vector of ENMTools function names to install extra dependencies for. If `NULL`, extras for all ENMTools functions will be installed.}
}
\value{
Logical, `TRUE` if all required extra packages are available, `FALSE` otherwise
}
\description{
Check that the extra packages needed for an ENMTools function are installed and available
}
\examples{
check.extras("enmtools.gam")
}
