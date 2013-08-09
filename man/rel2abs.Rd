\name{rel2abs}
\alias{rel2abs}
\title{Translate delta-encoded integer coordinates to absolute coordinates}
\usage{
  rel2abs(arc, scale = Null, translate = Null)
}
\arguments{
  \item{arc}{line-string of delta-encoded integer
  coordinates}

  \item{scale}{scaling to apply to x and y}

  \item{translate}{to apply to x and y}
}
\value{
  list of absolute coordinates (often longitude,latitude)
}
\description{
  Translate delta-encoded integer coordinates to absolute
  coordinates
}

