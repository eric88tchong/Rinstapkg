#' Get a User Id
#' 
#' This function accepts a Instagram username and returns their \code{user_id}, 
#' which is needed for other functions
#' 
#' @template username
#' @template verbose
#' @examples \donttest{
#' ig_get_user_id("justinbieber")
#' }
#' @export
ig_get_user_id <- function(username, verbose = FALSE) {
  as.double(ig_get_user_profile(username, verbose = verbose)$pk)
}

#' Get a User's Profile
#' 
#' This function returns the details of a user's profile based on the supplied 
#' username (omitting the @@ symbol)
#' 
#' @template username
#' @template verbose
#' @examples \donttest{
#' # get Jusin Bieber's profile and to see how many followers he has
#' bieber_follower_cnt <- ig_get_user_profile("justinbieber")$follower_count
#' }
#' @export
ig_get_user_profile <- function(username, verbose = FALSE) {
  ig_generic_GET(relative_endpoint = sprintf("users/%s/usernameinfo/", username), 
                 item_accessor = function(x) x[["user"]],
                 return_df = FALSE,
                 verbose = verbose)
}

#' Instagram Feeds
#'
#' The arguments available to all functions that return feed data from Instagram
#'
#' @template max_id
#' @template return_df
#' @template paginate
#' @template max_pages
#' @template verbose
#' @name feed
NULL

#' Get Feed of a User's Posts
#' 
#' This function uses the \code{user_id} to return all posts made by that user.
#' 
#' @template user_id
#' @template min_timestamp
#' @template ranked_content
#' @inheritParams feed
#' @examples \donttest{
#' bieber_user_id <- ig_get_user_id("justinbieber")
#' bieber_feed <- ig_get_user_feed(bieber_user_id)
#' }
#' @export
ig_get_user_feed <- function(user_id, max_id = NULL, min_timestamp = NULL, 
                             ranked_content = TRUE, return_df = TRUE, 
                             paginate = TRUE, max_pages = 10, verbose = FALSE) {
  check_user_id(user_id)
  this_query <- list(max_id = max_id, 
                     min_timestamp = min_timestamp,
                     rank_token = ig_rank_token(),
                     ranked_content = tolower(ranked_content))
  ig_generic_GET(relative_endpoint = sprintf("feed/user/%s", user_id), 
                 query = this_query,
                 item_accessor = function(x) x[["items"]], 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' Get Feed of Posts for a Tagged User
#' 
#' This fuction returns all of the posts that the specified user was tagged in.
#' 
#' @template user_id
#' @template ranked_content
#' @inheritParams feed
#' @examples \donttest{
#' bieber_user_id <- ig_get_user_id("justinbieber")
#' tagged_bieber_posts <- ig_get_user_tags(bieber_user_id)
#' }
#' @export
ig_get_user_tags <- function(user_id, max_id = NULL, ranked_content = TRUE, 
                             return_df = TRUE, paginate = TRUE, 
                             max_pages = 10, verbose = FALSE) {
  check_user_id(user_id)
  this_query <- list(max_id = max_id, 
                     rank_token = ig_rank_token(),
                     ranked_content = tolower(ranked_content))
  ig_generic_GET(relative_endpoint = sprintf("usertags/%s/feed", user_id),
                 query = this_query,
                 item_accessor = function(x) x[["items"]], 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}
 
#' Get Feed of a Hashtag
#' 
#' This function filters by hashtags and returns all posts that have the same 
#' hashtag string
#' 
#' @template hashtag
#' @template ranked_content
#' @inheritParams feed
#' @examples \donttest{ 
#' beliebers_tagged_posts <- ig_get_hashtag_feed("beliebers")
#' }
#' @export
ig_get_hashtag_feed <- function(hashtag, max_id = NULL, ranked_content = TRUE, 
                                return_df = TRUE, paginate = TRUE, max_pages = 10, 
                                verbose = FALSE) {
  this_query <- list(max_id = max_id, 
                     rank_token = ig_rank_token(),
                     ranked_content = tolower(ranked_content))
  ig_generic_GET(relative_endpoint = sprintf("feed/tag/%s", hashtag),
                 query = this_query,
                 item_accessor = function(x) x[["items"]], 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' Get Feed of a Location
#' 
#' This function filters by location and returns all posts that have the same location
#' 
#' @template location_id
#' @template ranked_content
#' @inheritParams feed
#' @details Note that if your location is a "group" (such as a city), the feed will 
#' include media from multiple locations within that area. But if your
#' location is a very specific place such as a specific night club, it will usually 
#' only include media from that exact location.
#' @seealso \url{https://docs.social-streams.com/article/118-find-instagram-location-id}
#' @examples \donttest{
#' # location feed for Paris, France
#' paris_location_feed <- ig_get_location_feed(6889842)
#' }
#' @export
ig_get_location_feed <- function(location_id, max_id = NULL, ranked_content = TRUE, 
                                 return_df = TRUE, paginate = TRUE, 
                                 max_pages = 10, verbose = FALSE) {
  this_query <- list(max_id = max_id, 
                     rank_token = ig_rank_token(),
                     ranked_content = tolower(ranked_content))
  ig_generic_GET(relative_endpoint = sprintf("feed/location/%s", location_id),
                 query = this_query,
                 item_accessor = function(x) x[["story"]][["items"]], 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' Get Feed of Popular Posts
#' 
#' This function returns current most popular posts on Instagram
#' 
#' @template ranked_content
#' @inheritParams feed
#' @examples \donttest{
#' most_popular_posts <- ig_get_popular_feed()
#' }
#' @export
ig_get_popular_feed <- function(max_id = NULL, ranked_content = TRUE, 
                                return_df = TRUE, paginate = TRUE, 
                                max_pages = 10, verbose = FALSE) {
  this_query <- list(max_id = max_id, 
                     rank_token = ig_rank_token(),
                     ranked_content = tolower(ranked_content))
  ig_generic_GET(relative_endpoint = "feed/popular",
                 query = this_query,
                 item_accessor = function(x) x[["items"]], 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' Get Feed of Liked or Saved Posts
#' 
#' These functions return all of the posts that you have liked or saved
#' 
#' @inheritParams feed
#' @examples \donttest{
#' my_liked_posts <- ig_get_liked_feed()
#' my_saved_posts <- ig_get_saved_feed()
#' }
#' @export
ig_get_liked_feed <- function(max_id = NULL, return_df = TRUE, paginate = TRUE, 
                              max_pages = 10, verbose = FALSE) {
  this_query <- list(max_id = max_id)
  ig_generic_GET(relative_endpoint = "feed/liked",
                 query = this_query,
                 item_accessor = function(x) x[["items"]], 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' @rdname ig_get_liked_feed
#' @export
ig_get_saved_feed <- function(max_id = NULL, return_df = TRUE, paginate = TRUE, 
                              max_pages = 10, verbose = FALSE) {
  this_query <- list(max_id = max_id)
  ig_generic_GET(relative_endpoint = "feed/saved",
                 query = this_query,
                 item_accessor = function(x) map(x[["items"]], pluck, "media"),
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' Get Follower Info
#' 
#' These function returns all of the followers or users that a specific user is following 
#' 
#' @template user_id
#' @inheritParams feed
#' @examples \donttest{
#' bieber_user_id <- ig_get_user_id("justinbieber")
#' 
#' # By default, ig_get_followers will retrieve the top 10 pages of follower data. 
#' # This is because IG users like Justin Bieber have 100M+ followers, so it could 
#' # take a long time to pull. If you would really like to get all users, then set
#' # the max_pages argument to Inf.
#' bieber_followers <- ig_get_followers(bieber_user_id)
#' bieber_following <- ig_get_following(bieber_user_id)
#' }
#' @export
ig_get_followers <- function(user_id, max_id = NULL, return_df = TRUE, 
                             paginate = TRUE, max_pages = 10, verbose = FALSE) {
  check_user_id(user_id)
  this_query <- list(max_id = max_id)
  ig_generic_GET(relative_endpoint = sprintf("friendships/%s/followers", user_id),
                 item_accessor = function(x) x[["users"]], 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' @rdname ig_get_followers
#' @export
ig_get_following <- function(user_id, max_id = NULL, return_df = TRUE, 
                             paginate = TRUE, max_pages = 10, verbose = FALSE) {
  check_user_id(user_id)
  this_query <- list(max_id = max_id)
  ig_generic_GET(relative_endpoint = sprintf("friendships/%s/following", user_id),
                 item_accessor = function(x) x[["users"]], 
                 return_df = return_df, 
                 verbose = verbose)
}


# HOLD OFF UNTIL WE FIGURE OUT A WAY TO BETTER HANDLE IF PAGINATION IS NEEDED
# #' Get a Media Id
# #' 
# #' This function accepts a Instagram user_id and the number of the post that you want
# #' and will return its \code{media_id}, which can be submitted in other functions
# #' 
# #' @template user_id
# #' @param post_index integer; an index starting at 1 to indicate the most recent post
# #' @examples \donttest{
# #' # return the media id for Jusin Bieber's 2nd to last post
# #' bieber_user_id <- ig_get_user_id("justinbieber")
# #' post2_media_id <- ig_get_media_id(bieber_user_id, post_index = 2)
# #' # use the media id to get post comments
# #' post_comments <- ig_get_media_comments(post2_media_id)
# #' }
# #' @export
# ig_get_media_id <- function(user_id, post_index = 1){
#   ig_get_user_feed(user_id)$id[post_index]
# }

# # OMIT FOR NOW, SEEMS LIKE A SELDOM USED INSTAGRAM FEATURE
# #' Get all locations that a user was tagged at
# #' 
# #' This fuction returns all of the locations that the specified user was tagged at.
# #' 
# #' @template user_id
# #' @inheritParams feed
# #' @examples \donttest{
# #' bieber_user_id <- ig_get_user_id("justinbieber")
# #' tagged_bieber_posts <- ig_get_geomedia(bieber_user_id)
# #' }
# #' @export
# ig_get_geomedia <- function(user_id, max_id = NULL, return_df = TRUE, 
#                             paginate = TRUE, max_pages = 10, verbose = FALSE) {
#   check_user_id(user_id)
#   this_query <- list(max_id = max_id)
#   ig_generic_GET(relative_endpoint = sprintf("maps/user/%s", user_id),
#                  query = this_query,
#                  item_accessor = function(x) x[["items"]], 
#                  return_df = return_df,
#                  paginate = paginate, 
#                  max_pages = max_pages,
#                  verbose = verbose)
# }
