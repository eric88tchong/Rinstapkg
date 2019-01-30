library(testthat)
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(Rinsta)))

if (identical(tolower(Sys.getenv("NOT_CRAN")), "true") & 
    identical(tolower(Sys.getenv("TRAVIS_PULL_REQUEST")), "false")) {

  test_check("Rinsta")
}