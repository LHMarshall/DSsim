% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Survey.R
\docType{class}
\name{Survey-class}
\alias{Survey-class}
\title{Virtual Class "Survey"}
\description{
Class \code{"Survey"} is an S4 class containing an instance of a population.
}
\section{Slots}{

\describe{
\item{\code{population}}{Object of class \code{"Population"}; an instance of
a population.}

\item{\code{transect}}{Object of class \code{"Transect"}; the
transects.}
}}

\section{Methods}{

\describe{
 \item{\code{create.region.table}}{\code{signature=(object = "Survey", ...)}:
 creates a region table for \code{dht}.}
 \item{\code{create.sample.table}}{\code{signature=(object = "Survey", ...)}:
 creates a sample table for \code{dht}.}
}
}

\keyword{classes}
