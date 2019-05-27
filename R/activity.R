#' Get the authenticated user's timeline feed
#' 
#' This function returns data that would appear in the authenticated user's 
#' timeline feed.
#' 
#' @template max_id
#' @template min_timestamp
#' @template ranked_content
#' @inheritParams feed
#' @return \code{tbl_df} or \code{list}
#' @examples \donttest{
#' my_timeline <- ig_my_timeline()
#' }
#' @export
ig_my_timeline <- function(max_id = NULL, min_timestamp = NULL, ranked_content = TRUE, 
                           return_df = TRUE, paginate = TRUE, max_pages = 10, 
                           verbose = FALSE) {
  this_query <- list(max_id = max_id, 
                     min_timestamp = as_epoch(min_timestamp), 
                     rank_token = ig_rank_token(),
                     ranked_content = tolower(ranked_content))
  ig_generic_GET(relative_endpoint = "feed/timeline",
                 query = this_query, 
                 item_accessor = function(x) x[["items"]], 
                 return_df = return_df,
                 paginate = paginate, 
                 max_pages = max_pages, 
                 verbose = verbose)
}
  
#' Get bootstrap user data (autocompletion user list)
#' 
#' This function returns a list of users for you guessed by Instagram.
#' 
#' @template return_df
#' @template verbose
#' @details WARNING: This is a special, very heavily throttled API endpoint. Instagram 
#' REQUIRES that you wait several minutes between calls to it
#' @keywords internal
#' @examples \donttest{
#' my_autocompleted_userlist <- ig_autocomplete_userlist()
#' }
#' @export
ig_autocomplete_userlist <- function(return_df = TRUE, verbose = FALSE) {
  ig_generic_GET(relative_endpoint = "friendships/autocomplete_user_list", 
                 item_accessor = function(x) x[["users"]], 
                 return_df = return_df, 
                 verbose = verbose)
}

#' Get direct inbox messages for your account
#' 
#' This function returns direct messages for your account.
#' 
#' @template return_df
#' @template verbose
#' @examples \donttest{
#' my_inbox <- ig_my_inbox()
#' }
#' @export
ig_my_inbox <- function(return_df = TRUE, verbose = FALSE) {
  ig_generic_GET(relative_endpoint = "direct_v2/inbox", 
                 return_df = return_df, 
                 verbose = verbose)
}

#' Get news feed of recent activities by you
#' 
#' This function returns notifications regarding the actions you have recently took, 
#' such as what posts you've liked or when you've started following other people.
#' 
#' @template return_df
#' @template verbose
#' @examples \donttest{
#' my_recent_activity <- ig_my_recent_activity()
#' }
#' @export
ig_my_recent_activity <- function(return_df = TRUE, verbose = FALSE) {
  ig_generic_GET(relative_endpoint = "news/inbox", 
                 item_accessor = function(x) x[["old_stories"]], 
                 return_df = return_df, 
                 verbose = verbose)
}

#' Get news feed of recent activities for accounts you follow
#' 
#' This function returns notifications regarding the people you follow, such as 
#' what posts they've liked or that they've started following other people.
#' 
#' @template return_df
#' @template verbose
#' @examples \donttest{
#' my_following_recent_activity <- ig_following_recent_activity()
#' }
#' @export
ig_following_recent_activity <- function(return_df = TRUE, verbose = FALSE) {
  ig_generic_GET(relative_endpoint = "news", 
                 item_accessor = function(x) x[["stories"]], 
                 return_df = return_df, 
                 verbose = verbose)
}
