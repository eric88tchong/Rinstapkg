
#' Search for a user's profile by username
#' 
#' This function returns the details of a user's profile based on the supplied 
#' username (omit the @@ symbol)
#' 
#' @template username
#' @template return_df
#' @template verbose
#' @export
ig_search_username <- function(username, return_df = FALSE, verbose = FALSE) {
  ig_generic_GET(relative_endpoint = sprintf("users/%s/usernameinfo/", username), 
                 item_name = "user", 
                 return_df = return_df, 
                 verbose = verbose)
}

#' ig_search_users
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_search_users <- function(){
  #Target Endpoint: users/search/
}

#' ig_search_tags
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
  ig_search_tags <- function(tag, max_id = NULL, return_df = TRUE, 
                             paginate = TRUE, max_pages = 10, verbose = FALSE){
    ig_generic_GET(relative_endpoint = "tags/search",
                   query = list(is_typeahead = "true", q = tag),
                   item_name = "results", 
                   return_df = return_df, 
                   verbose = verbose)
  #Target Endpoint: tags/search/
  }
  
  
  
  

