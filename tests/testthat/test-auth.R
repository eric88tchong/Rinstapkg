context("Authorization")

skip("Skipping All Authorization Tests for Right Now")

test_that("testing missing auth", {
  expect_false(token_available())
  expect_null(ig_access_token())
  expect_false(csrf_token_available())
  expect_null(ig_csrf_token())
})

test_that("testing nonsense inputs", {
  expect_error(ig_auth(token = "wrong-path.rds"))
  expect_error(ig_auth(token = letters[1:3]))
})

Rinstapkg_test_settings <- readRDS("Rinstapkg_test_settings.rds")
username <- Rinstapkg_test_settings$dev$username
password <- Rinstapkg_test_settings$dev$password
# we dont have an OAuth2.0 app yet so we cant create tokens to test that
#Rinstapkg_token <- readRDS("Rinstapkg_token.rds")

test_that("testing OAuth passing token as filename", {
  ig_auth(token = "Rinstapkg_token.rds")
  expect_true(token_available())
  expect_true(!is.null(ig_access_token()))
})

test_that("testing OAuth passing actual token", {
  ig_auth(token = Rinstapkg_token)
  expect_true(token_available())
  expect_true(!is.null(ig_access_token()))
})

test_that("testing custom token validation routine", {
  res <- ig_auth_check()
  expect_s3_class(res, "Token2.0")
})

test_that("testing basic auth", {
  
  username <- Rinstapkg_test_settings$dev$username
  password <- Rinstapkg_test_settings$dev$password
  
  session <- ig_auth(username = username, password = password)
  expect_is(session, "list")
  expect_named(session, c("auth_method",
                          "token",
                          "csrf_token",
                          "rank_token",
                          "phone_id",
                          "device_id",
                          "session_guid",
                          "username_id"))
})

test_that("testing token and session availability after basic auth", {
  expect_true(csrf_token_available())
  expect_true(!is.null(ig_csrf_token()))
})