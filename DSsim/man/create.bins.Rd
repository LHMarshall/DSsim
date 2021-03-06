% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create.bins.R
\name{create.bins}
\alias{create.bins}
\title{Create bins from a set of binned distances and a set of cutpoints.}
\usage{
create.bins(data, cutpoints)
}
\arguments{
\item{data}{\code{data.frame} with at least the column \code{distance}.}

\item{cutpoints}{vector of cutpoints for the bins}
}
\value{
data \code{data} with two extra columns \code{distbegin} and
\code{distend}.
}
\description{
This is a service routine and shouldn't be necessary in normal analyses.
}
\author{
David L. Miller
}
