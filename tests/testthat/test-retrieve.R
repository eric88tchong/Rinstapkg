context("Retrieve")

# login, then run tests
# TODO: Figure out how to login once to run all tests so we can reduce the 
# total number of logins which might trigger Instagram blocking our account
Rinstapkg_test_settings <- readRDS("Rinstapkg_test_settings.rds")
ig_auth(username = Rinstapkg_test_settings$dev$username, 
        password = Rinstapkg_test_settings$dev$password)

test_that("ig_get_user_id", {
  expect_true(TRUE)
})

test_that("ig_get_user_feed", {
  expect_true(TRUE)
})

test_that("ig_get_hashtag_feed", {
  hashtag_feed <- ig_get_hashtag_feed("R4SC4LIFE")
  expect_s3_class(hashtag_feed, c("tbl_df", "tbl", "data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", 
                    "comment_count", "like_count") %in% names(hashtag_feed)))
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
