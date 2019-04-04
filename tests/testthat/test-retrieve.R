context("Retrieve")

Rinstapkg_test_settings <- readRDS("Rinstapkg_test_settings.rds")

username <- Rinstapkg_test_settings$test_username

password <- Rinstapkg_test_settings$test_password

ig_auth(username = username, password = password)


test_that("ig_get_user_id", {
  expect_true(TRUE)
  user_id <- ig_get_user_id("r4sctest")
  expect_equal(user_id %>% class(), "numeric")
  expect_equal(user_id,10719578450)
})

test_that("ig_get_user_feed", {
  expect_true(TRUE)
  user_feed <- ig_get_user_feed("10719578450")
  expect_equal(class(user_feed),c("tbl_df","tbl","data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", "comment_count", "like_count") %in% names(user_feed)))
})

test_that("ig_get_hashtag_feed", {
  expect_true(TRUE)
  hashtag_feed <- ig_get_hashtag_feed("R4SC4LIFE")
  expect_equal(class(hashtag_feed),c("tbl_df","tbl","data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", "comment_count", "like_count") %in% names(hashtag_feed)))
})

test_that("ig_get_location_feed", {
  location_feed <- ig_get_location_feed("1472678466133411")
  expect_equal(class(location_feed),c("tbl_df","tbl","data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", "comment_count", "like_count") %in% names(location_feed)))
  expect_true(TRUE)
})

test_that("ig_get_popular_feed", {
  expect_true(TRUE)
  popular_feed <- ig_get_popular_feed()
  expect_equal(class(ig_get_popular_feed()),c("tbl_df","tbl","data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", "comment_count", "like_count") %in% names(popular_feed)))
})

test_that("ig_get_liked_feed", {
  expect_true(TRUE)
  liked_feed <- ig_get_liked_feed()
  expect_equal(class(liked_feed),c("tbl_df","tbl","data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", "comment_count", "like_count") %in% names(liked_feed)))
})

test_that("ig_get_saved_feed", {
  expect_true(TRUE)
  saved_feed <- ig_get_saved_feed()
  expect_equal(class(saved_feed),c("tbl_df","tbl","data.frame"))
  #expect_true(all(c("taken_at", "pk", "device_timestamp", "user", "comment_count", "like_count") %in% names(saved_feed)))
})

test_that("ig_get_user_tags", {
  expect_true(TRUE)
  user_tag <- ig_get_user_tags("10719578450")
  expect_equal(class(user_tag),c("tbl_df","tbl","data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", "comment_count", "like_count") %in% names(user_tag)))
})

test_that("ig_get_geomedia", {
  expect_true(TRUE)
})

test_that("ig_get_followers", {
  expect_true(TRUE)
  followers <- ig_get_followers("10719578450")
  expect_equal(class(followers),c("tbl_df","tbl","data.frame"))
  expect_true(all(c("pk", "username", "is_private", "full_name", "is_verified") %in% names(followers)))
})

test_that("ig_get_following", {
  expect_true(TRUE)
  following <- ig_get_following("10719578450")
  expect_equal(class(ig_get_following("10719578450")),c("tbl_df","tbl","data.frame"))
  expect_true(all(c("pk", "username", "is_private", "full_name", "is_verified") %in% names(following)))
})
