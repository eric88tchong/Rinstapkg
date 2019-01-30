##### THIS FILE JUST NEEDS DOCUMENTATION

#' ig_my_timeline 
#' 
#' NEEDS DOCUMENTATION!!!!
#' @param max_id integer; this integer represents the last id of a post that you 
#' would want to retrieve from your timeline
#' @param 
#' @return \code{tbl_df} or \code{list}
#' @examples \dontrun{
#' my_timeline <- ig_my_timeline()
#' }
#' @export
ig_my_timeline <- function(max_id=NULL, min_timestamp=NULL, return_df=TRUE, 
                           paginate=TRUE, max_pages=10, verbose=FALSE){

  this_query <- list(max_id = max_id, min_timestamp = as_epoch(min_timestamp))
  ig_generic_GET(relative_endpoint="feed/timeline", query=this_query, 
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
}
  
#' ig_autocomplete_userlist 
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_autocomplete_userlist <- function(return_df=TRUE, verbose=FALSE){
  ig_generic_GET(relative_endpoint="friendships/autocomplete_user_list", item_name = "users", 
                 return_df = return_df, verbose = verbose)
}

#' ig_my_inbox 
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_my_inbox <- function(return_df=TRUE, verbose=FALSE){
  ig_generic_GET(relative_endpoint="direct_v2/inbox", 
                 return_df = return_df, verbose = verbose)
}

#' ig_my_recent_activity 
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_my_recent_activity <- function(return_df=TRUE, verbose=FALSE){
  ig_generic_GET(relative_endpoint="news/inbox", item_name = "old_stories", 
                 return_df = return_df, verbose = verbose)
}
