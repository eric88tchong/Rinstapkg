context("Media")

# login with this test since alphabetically it is the first to execute
Rinstapkg_test_settings <- readRDS("Rinstapkg_test_settings.rds")
ig_auth(username = Rinstapkg_test_settings$dev$username,
        password = Rinstapkg_test_settings$dev$password)

# test using a post from the R4SCTest account
testing_media_id <- "2024171901831871533_10719578450"

test_that("ig_like", {
  like_result <- ig_like(testing_media_id)
  expect_is(like_result, "list")
  expect_equal(like_result$status, "ok")
})

test_that("ig_unlike", {
  unlike_result <- ig_unlike(testing_media_id)
  expect_is(unlike_result, "list")
  expect_equal(unlike_result$status, "ok")
})

test_that("ig_save", {
  save_result <- ig_save(testing_media_id)
  expect_is(save_result, "list")
  expect_equal(save_result$status, "ok")
})

test_that("ig_unsave", {
  unsave_result <- ig_unsave(testing_media_id)
  expect_is(unsave_result, "list")
  expect_equal(unsave_result$status, "ok")
})

comment_result <- ig_comment(testing_media_id, "test comment2")
test_that("ig_comment", {
  expect_is(comment_result, "list")
  expect_equal(comment_result$status, "ok")
  expect_true(!is.null(comment_result$comment$media_id))
})

comment_media_id <- comment_result$comment$media_id
test_that("ig_comment_delete", {
  comment_delete_result <- ig_comment_delete(testing_media_id, comment_media_id)
  expect_is(comment_delete_result, "list")
  expect_equal(comment_delete_result$status, "ok")
})
# untested: ig_comment_delete_bulk

test_that("ig_get_media_info", {
  media_info <- ig_get_media_info(testing_media_id)
  expect_is(media_info, "list")
  expect_true(all(c("taken_at", "pk", "id", "media_type", "likers", 
                    "caption") %in% names(media_info)))
})

test_that("ig_get_media_comments", {
  comments_feed <- ig_get_media_comments(testing_media_id)
  expect_s3_class(comments_feed, c("tbl_df",  "tbl", "data.frame"))
  expect_true(all(c("pk", "created_at", "user_id", "text", "type") %in% 
                    names(comments_feed)))
})

test_that("ig_get_media_likers", {
  likers_feed <- ig_get_media_likers(testing_media_id)
  expect_s3_class(likers_feed, c("tbl_df",  "tbl", "data.frame"))
  expect_true(all(c("pk", "username", "is_private", "full_name", "is_verified") %in% 
                    names(likers_feed)))
})

test_that("ig_edit_media_caption", {
  caption_edit_result <- ig_edit_media_caption(testing_media_id, 
                                               caption_text = "new test caption")
  expect_is(caption_edit_result, "list")
  expect_equal(caption_edit_result$status, "ok")
  # set back to the original caption
  caption_back <- ig_edit_media_caption(testing_media_id, 
                                        caption_text = "An empty McIntire study room.")
})

# HOLD OFF ON TESTING RIGHT NOW
#test_that("ig_delete_media()", {
# expect_true(TRUE)
#})
