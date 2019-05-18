context("Search")

# NOTE: the test-media.R file runs first and is where the login occurs

test_that("ig_search_users()", {
  bieber_users <- ig_search_users("justinbieb")
  expect_s3_class(bieber_users, c("tbl_df","tbl","data.frame"))
  expect_true(all(c("pk", "username", "is_private", "full_name", 
                    "is_verified") %in% names(bieber_users)))
})

test_that("ig_search_tags()", {
  belieber_posts <- ig_search_tags("belieber")
  expect_s3_class(belieber_posts, c("tbl_df","tbl","data.frame"))
  expect_true(all(c("id", "name", "media_count", 
                    "search_result_subtitle") %in% names(belieber_posts)))
})
