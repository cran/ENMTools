% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/enmtools.aoc.R
\name{enmtools.aoc}
\alias{enmtools.aoc}
\title{Takes an overlap matrix and a tree and runs permutation tests to
determine the statistical significance of the relationship between
overlap and time}
\usage{
enmtools.aoc(
  clade,
  env = NULL,
  overlap.source,
  nreps = 100,
  f = NULL,
  overlap.matrix = NULL,
  metric = "D",
  ...
)
}
\arguments{
\item{clade}{An enmtools.clade object containing species data and a phylogeny}

\item{env}{Environmental layers for use when overlap is calculated using niche models.}

\item{overlap.source}{The source of the overlaps to calculate.  Choices are "bc", "dm", "gam", "glm", "mx", "range", and "point"}

\item{nreps}{A number of reps to do}

\item{f}{The model to be used for GLM and GAM comparisons}

\item{overlap.matrix}{A matrix of overlaps to use, for option overlap.source = "matrix"}

\item{metric}{The overlap metric to use. For ENM sources, this can be any combination of "D", "I", "cor", "env.D", "env.I", and "env.cor".
for range and point overlap this argument is ignored.}

\item{...}{Arguments to be passed to modeling functions for ENM-based overlaps.}
}
\value{
A list containing a data frame of coefficients from the empirical regression of overlap on time along with the coefficients from all Monte Carlo replicates, along with plots and p values for the accompanying statistical tests.
}
\description{
Takes an overlap matrix and a tree and runs permutation tests to
determine the statistical significance of the relationship between
overlap and time
}
