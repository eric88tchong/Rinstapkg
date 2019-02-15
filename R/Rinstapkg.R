#' \code{Rinstapkg} package\if{html}{\figure{Rinstapkg.png}{options: width="25\%" align="right" alt="Figure: Rinstapkg.png"}}
#'
#' An R package connecting to the Instagram API using tidy principles
#'
#' An implementation of the Instagram API using tidy principles. This 
#' includes functions to get feeds and users, but also perform basic in-app 
#' functionality such as liking, commenting, following, and blocking. Use of this 
#' package means that you will not use it to spam, harass, or perform other nefarious 
#' acts.
#' 
#' Additional material can be found in the 
#' \href{https://github.com/eric88tchong/Rinstapkg}{README} on GitHub
#'
#' @docType package
#' @name Rinstapkg
#' @importFrom dplyr %>%
"_PACKAGE"

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
