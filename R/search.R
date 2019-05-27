#' Search by Username
#' 
#' This function accepts a username, without the "@@" symbol and finds matching 
#' user profiles. This is helpful when you do not know a user's name exactly and 
#' need to get their \code{user_id}. If you know the username exactly then you can
#' use \link{ig_get_user_profile} to pull the profile information without searching.
#' 
#' @importFrom dplyr distinct
#' @importFrom rlang .data
#' @template username
#' @inheritParams feed
#' @examples \donttest{
#' # search for usernames like Justin Bieber
#' bieber_users <- ig_search_users("justinbieb")
#' }
#' @export
ig_search_users <- function(username, max_id = NULL, return_df = TRUE, 
                            paginate = TRUE, max_pages = 10, verbose = FALSE){
  result <- ig_generic_GET(relative_endpoint = "users/search",
                           query = list(is_typeahead = "true", q = username),
                           item_accessor = function(x) x[["users"]], 
                           return_df = return_df, 
                           paginate = paginate, max_pages = max_pages,
                           verbose = verbose)
  if(nrow(result) > 0){
    result <- result %>% 
      # if the username is exact, then Instagram returns 2 records for some reason, 
      # just use distinct to keep that from happening
      distinct(.data$pk, .keep_all = TRUE)
  }
  return(result)
}

#' Search by Hashtag
#' 
#' This function accepts a hashtag, without the "#" symbol and returns the similar 
#' hashtags. You can then use \link{ig_get_hashtag_feed} to return all posts associated 
#' with that hashtag.
#' 
#' @template hashtag
#' @inheritParams feed
#' @examples \donttest{
#' # search for posts using the #belieber hashtag
#' belieber_posts <- ig_search_tags("belieber")
#' }
#' @export
ig_search_tags <- function(hashtag, max_id = NULL, return_df = TRUE, 
                           paginate = TRUE, max_pages = 10, verbose = FALSE){
  ig_generic_GET(relative_endpoint = "tags/search",
                 query = list(is_typeahead = "true", q = hashtag),
                 item_accessor = function(x) x[["results"]], 
                 return_df = return_df, 
                 paginate = paginate, max_pages = max_pages,
                 verbose = verbose)
}
