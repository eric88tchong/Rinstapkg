#' Return the user ID from a username
#' 
#' This function accepts a Instagram username and returns their \code{user_id}, which is 
#' needed for other functions
#' 
#' @template username
#' @examples \dontrun{
#' ig_get_user_id("r4scatUVA")
#' }
#' @export
ig_get_user_id <- function(username) {
  as.double(ig_search_username(username)$pk)
}

#' Return the media ID from a user_id and post index
#' 
#' This function accepts a Instagram user_id and the number of the post that you want
#' and will return its MediaID, which is needed for other functions
#' 
#' @template username
#' @examples \dontrun{
#' 
#' }
#' @export
ig_get_media_id <- function(user_id, post_index){
  ig_get_user_feed(user_id)$id[post_index]
}

#' Return data from a feed-like Instagram endpoint
#'
#' @template return_df
#' @template paginate 
#' @template max_pages 
#' @template verbose
#' @name feed
NULL

#' Get a user's timeline feed
#' 
#' This function uses the \code{user_id} to return data that would appear in a 
#' user's timeline feed.
#' 
#' @section Feeds:
#' @template user_id
#' @template max_id
#' @template min_timestamp
#' @template ranked_content
#' @inheritParams feed
#' @examples \dontrun{
#' ig_get_user_feed(10719578450)
#' }
#' @export
ig_get_user_feed <- function(user_id, max_id = NULL, min_timestamp = NULL, 
                             ranked_content = TRUE, return_df = TRUE, 
                             paginate = TRUE, max_pages = 10, verbose = FALSE) {
  this_query <- list(max_id = max_id, 
                     min_timestamp = min_timestamp,
                     rank_token = ig_rank_token(),
                     ranked_content = tolower(ranked_content))
  ig_generic_GET(relative_endpoint = sprintf("feed/user/%s", user_id), 
                 query = this_query,
                 item_name = "items", 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}
 
#' Get the feed for a hashtag
#' 
#' This function filters by hashtags and returns all posts that have the same 
#' hashtag string
#' 
#' @section Feeds:
#' @template hashtag
#' @template max_id
#' @template ranked_content
#' @inheritParams feed
#' @examples \dontrun{ 
#' ig_get_hashtag_feed("R4SC4LIFE")
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
                 item_name = "items", 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' Get the feed for a location
#' 
#' This function filters by location and returns all posts that have the same location
#' 
#' @section Feeds:
#' @template location_id
#' @template max_id
#' @template ranked_content
#' @inheritParams feed
#' @details Note that if your location is a "group" (such as a city), the feed will 
#' include media from multiple locations within that area. But if your
#' location is a very specific place such as a specific night club, it will usually 
#' only include media from that exact location.
#' @seealso \url{https://docs.social-streams.com/article/118-find-instagram-location-id}
#' @examples \dontrun{
#' # location feed for the city of The Juice Laundry
#' ig_get_location_feed(1472678466133411)
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
                 item_name = "items", 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' Get the feed of most popular current posts on Instagram
#' 
#' This function returns current most popular posts on Instagram
#' 
#' @section Feeds:
#' @template max_id
#' @template ranked_content
#' @inheritParams feed
#' @examples \dontrun{
#' ig_get_popular_feed()
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
                 item_name = "items", 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' Get feed of your liked media
#' 
#' This function returns all of the posts that you have liked
#' 
#' @section Feeds:
#' @template max_id
#' @inheritParams feed
#' @examples \dontrun{
#' ig_get_liked_feed()
#' }
#' @export
ig_get_liked_feed <- function(max_id = NULL, return_df = TRUE, paginate = TRUE, 
                              max_pages = 10, verbose = FALSE) {
  this_query <- list(max_id = max_id)
  ig_generic_GET(relative_endpoint = "feed/liked",
                 query = this_query,
                 item_name = "items", 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' Get feed of your saved media
#' 
#' This function returns all of the posts that you have saved
#' 
#' @section Feeds:
#' @template max_id
#' @inheritParams feed
#' @examples \dontrun{
#' ig_get_saved_feed()
#' }
#' @export
ig_get_saved_feed <- function(max_id = NULL, return_df = TRUE, paginate = TRUE, 
                              max_pages = 10, verbose = FALSE) {
  this_query <- list(max_id = max_id)
  ig_generic_GET(relative_endpoint = "feed/saved",
                 query = this_query,
                 item_name = "items", 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' Get all posts that a user was tagged in
#' 
#' This fuction returns all of the posts that the specified user was tagged in.
#' 
#' @section Feeds:
#' @template user_id
#' @template max_id
#' @template ranked_content
#' @inheritParams feed
#' @examples \dontrun{
#' this_user_id <- ig_get_user_id("r4scatUVA")
#' ig_get_user_tags(this_user_id)
#' }
#' @export
ig_get_user_tags <- function(user_id, max_id = NULL, ranked_content = TRUE, 
                             return_df = TRUE, paginate = TRUE, 
                             max_pages = 10, verbose = FALSE) {
  this_query <- list(max_id = max_id, 
                     rank_token = ig_rank_token(),
                     ranked_content = tolower(ranked_content))
  ig_generic_GET(relative_endpoint = sprintf("usertags/%s/feed", user_id),
                 query = this_query,
                 item_name = "items",
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' Get all locations that a user was tagged at
#' 
#' This fuction returns all of the locations that the specified user was tagged at.
#' 
#' @section Feeds:
#' @template user_id
#' @template max_id
#' @inheritParams feed
#' @examples \dontrun{
#' this_user_id <- ig_get_user_id("r4scatUVA")
#' ig_get_geomedia(this_user_id)
#' }
#' @export
ig_get_geomedia <- function(user_id, max_id = NULL, return_df = TRUE, 
                            paginate = TRUE, max_pages = 10, verbose = FALSE) {
  this_query <- list(max_id = max_id)
  ig_generic_GET(relative_endpoint = sprintf("maps/user/%s", user_id),
                 query = this_query,
                 item_name = "items",
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages,
                 verbose = verbose)
}

#' Get all followers of user
#' 
#' This fuction returns all of the users that follow the specified user.
#' 
#' @template user_id
#' @template max_id
#' @inheritParams feed
#' @examples \dontrun{
#' this_user_id <- ig_get_user_id("r4scatUVA")
#' ig_get_followers(this_user_id)
#' }
#' @export
ig_get_followers <- function(user_id, max_id = NULL, return_df = TRUE, 
                             paginate = TRUE, max_pages = 10, verbose = FALSE) {
  this_query <- list(max_id = max_id)
  ig_generic_GET(relative_endpoint = sprintf("friendships/%s/followers", user_id),
                 item_name = "users", 
                 return_df = return_df, 
                 verbose = verbose)
}

#' Get all users that a user follows
#' 
#' This fuction returns all of the users that the specified user follows
#' 
#' @template user_id
#' @template max_id
#' @inheritParams feed
#' @examples \dontrun{
#' this_user_id <- ig_get_user_id("r4scatUVA")
#' ig_get_following(this_user_id)
#' }
#' @export
ig_get_following <- function(user_id, max_id = NULL, return_df = TRUE, 
                             paginate = TRUE, max_pages = 10, verbose = FALSE) {
  this_query <- list(max_id = max_id)
  ig_generic_GET(relative_endpoint = sprintf("friendships/%s/following", user_id),
                 item_name = "users", 
                 return_df = return_df, 
                 verbose = verbose)
}
