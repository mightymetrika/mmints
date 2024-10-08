% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/citationModule.R
\name{citationUI}
\alias{citationUI}
\title{UI Function for Citation Module}
\usage{
citationUI(id)
}
\arguments{
\item{id}{A character string that defines the namespace for the module.}
}
\value{
A list containing two elements:
\itemize{
\item \code{button}: An action button to show citations.
\item \code{output}: A tag list containing the citation header and output.
}
}
\description{
This function creates the UI elements for the citation module.
}
\examples{
citationUI("my_citations")

}
