library(testthat)
suppressWarnings(suppressMessages(library(Rinstapkg)))

if (identical(tolower(Sys.getenv("NOT_CRAN")), "true") & 
    identical(tolower(Sys.getenv("TRAVIS_PULL_REQUEST")), "false")) {

  test_check("Rinstapkg")
}