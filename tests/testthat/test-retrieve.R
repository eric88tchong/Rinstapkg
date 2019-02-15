context("Retrieve")

Rinstapkg_test_settings <- readRDS("Rinstapkg_test_settings.rds")
username <- Rinstapkg_test_settings$prod_username
password <- Rinstapkg_test_settings$prod_password
ig_auth(username = username, password = password)

test_that("ig_get_user_id", {
  expect_true(TRUE)
})

test_that("ig_get_user_feed", {
  expect_true(TRUE)
})

test_that("ig_get_hashtag_feed", {
  expect_true(TRUE)
})

test_that("ig_get_location_feed", {
  expect_true(TRUE)
})

test_that("ig_get_popular_feed", {
  expect_true(TRUE)
})

test_that("ig_get_liked_feed", {
  expect_true(TRUE)
})

test_that("ig_get_saved_feed", {
  expect_true(TRUE)
})

test_that("ig_get_user_tags", {
  expect_true(TRUE)
})

test_that("ig_get_geomedia", {
  expect_true(TRUE)
})

test_that("ig_get_followers", {
  expect_true(TRUE)
})


test_that("ig_get_followings", {
  expect_true(TRUE)
})
