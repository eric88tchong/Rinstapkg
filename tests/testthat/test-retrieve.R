context("Retrieve")

# NOTE: the test-media.R file runs first and is where the login occurs

testing_user_id <- 10719578450
testing_location_id <- 213480180

test_that("ig_get_user_id", {
  user_id <- ig_get_user_id("r4sctest")
  expect_is(class(user_id), "character")
  expect_true(grepl("^[0-9]+$", user_id))
  expect_equal(as.numeric(user_id), testing_user_id)
})

test_that("ig_get_user_feed", {
  user_feed <- ig_get_user_feed(testing_user_id)
  expect_s3_class(user_feed, c("tbl_df", "tbl", "data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", 
                    "comment_count", "like_count") %in% names(user_feed)))
})

test_that("ig_get_hashtag_feed", {
  hashtag_feed <- ig_get_hashtag_feed("R4SC4LIFE")
  expect_s3_class(hashtag_feed, c("tbl_df",  "tbl", "data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", 
                    "comment_count", "like_count") %in% names(hashtag_feed)))
})

test_that("ig_get_location_feed", {
  location_feed <- ig_get_location_feed(testing_location_id)
  expect_s3_class(location_feed, c("tbl_df","tbl","data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", 
                    "can_reshare", "can_reply") %in% names(location_feed)))
})

test_that("ig_get_popular_feed", {
  popular_feed <- ig_get_popular_feed()
  expect_s3_class(popular_feed, c("tbl_df","tbl","data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", 
                    "comment_count", "like_count") %in% names(popular_feed)))
})

test_that("ig_get_liked_feed", {
  liked_feed <- ig_get_liked_feed()
  expect_s3_class(liked_feed, c("tbl_df","tbl","data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", 
                    "comment_count", "like_count") %in% names(liked_feed)))
})

test_that("ig_get_saved_feed", {
  saved_feed <- ig_get_saved_feed()
  expect_s3_class(saved_feed, c("tbl_df","tbl","data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", 
                    "comment_count", "like_count") %in% names(saved_feed)))
})

test_that("ig_get_user_tags", {
  user_tag <- ig_get_user_tags(testing_user_id)
  expect_s3_class(user_tag, c("tbl_df","tbl","data.frame"))
  expect_true(all(c("taken_at", "pk", "device_timestamp", "user", 
                    "comment_count", "like_count") %in% names(user_tag)))
})

test_that("ig_get_followers", {
  followers <- ig_get_followers(testing_user_id)
  expect_s3_class(followers, c("tbl_df","tbl","data.frame"))
  expect_true(all(c("pk", "username", "is_private", "full_name", "is_verified") %in% names(followers)))
})

test_that("ig_get_following", {
  following <- ig_get_following(testing_user_id)
  expect_s3_class(following, c("tbl_df","tbl","data.frame"))
  expect_true(all(c("pk", "username", "is_private", "full_name", "is_verified") %in% names(following)))
})
