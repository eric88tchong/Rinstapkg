context("Search")

skip("Skipping All Tests for Right Now")

Rinstapkg_test_settings <- readRDS("Rinstapkg_test_settings.rds")
username <- Rinstapkg_test_settings$prod_username
password <- Rinstapkg_test_settings$prod_password
ig_auth(username = username, password = password)

test_that("testing ...", {
  expect_true(TRUE)
})
