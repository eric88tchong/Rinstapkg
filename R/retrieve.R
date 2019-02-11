##### THIS FILE NEEDS FUNCTIONS & DOCUMENTATION 

#' ig_get_user_id
#' 
#' This function uses and instagram username to return the userID that you will need for other functions
#' 
#' @export
ig_get_user_id <- function(username,return_df=FALSE){
  
  my_list<- ig_generic_GET(relative_endpoint=sprintf("users/%s/usernameinfo/",username), 
                 item_name = "user", 
                 return_df = return_df)
  return(my_list$pk)

}
#' ig_get_user_feed
#' 
#' NEEDS DOCUMENTATION!!!!
#' THIS WORKS!!!!!!! OMFG!!!!!!!!
#' 
#' @export
ig_get_user_feed <- function(user_id, return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  
  ig_generic_GET(relative_endpoint=sprintf("feed/user/%s",user_id), 
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
}

  #Target Endpoint: feed/user/

#' ig_get_timeline_feed
#' 
#' NEEDS DOCUMENTATION!!!!
#' Ask steve why we need this....
#' @export
ig_get_timeline_feed <- function(){
  #Target Endpoint: feed/timeline/
}
 
#' ig_get_hashtag_feed
#' 
#' NEEDS DOCUMENTATION!!!!
#' THIS WORKSSSS!!!!!
#' @export
ig_get_hashtag_feed <- function(hashtag_string,return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  
  ig_generic_GET(relative_endpoint = sprintf("feed/tag/%s",hashtag_string),
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  #Target Endpoint: feed/tag/
}
#' ig_get_location_feed
#' 
#' NEEDS DOCUMENTATION!!!!
#' Not Sure of Syntax
#' @export
ig_get_location_feed <- function(location_string,return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  ig_generic_GET(relative_endpoint = sprintf("feed/location/%s",location_string),
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  
  #Target Endpoint: feed/location/
}

#' ig_get_popular_feed
#' 
#' NEEDS DOCUMENTATION!!!!
#' I think this works
#' @export
ig_get_popular_feed <- function(return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  ig_generic_GET(relative_endpoint = "feed/popular",
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  
  #Target Endpoint: feed/popular/
}

#' ig_get_liked_feed
#' 
#' NEEDS DOCUMENTATION!!!!
#' THIS WORKS!!!!!
#' @export
ig_get_liked_feed <- function(return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  ig_generic_GET(relative_endpoint = "feed/liked",
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  #Target Endpoint: feed/liked/
}

#' ig_get_saved_feed
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_get_saved_feed <- function(return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  ig_generic_GET(relative_endpoint = "feed/saved",
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  #Target Endpoint: feed/saved/
}

#' ig_get_followers
#' 
#' NEEDS DOCUMENTATION!!!!
#' THIS WORKS!!!!!!
#' @export
ig_get_followers <- function(user_ID,return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  ig_generic_GET(relative_endpoint = sprintf("friendships/%s/followers",user_ID),
                 item_name = "users", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  #Target Endpoint: friendships/{username_id}/followers/
}

#' ig_get_followings
#' 
#' NEEDS DOCUMENTATION!!!!
#' THIS WORKS!!!!
#' @export
ig_get_followings <- function(user_ID,return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  ig_generic_GET(relative_endpoint = sprintf("friendships/%s/following",user_ID),
                 item_name = "users", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  #Target Endpoint: friendships/{username_id}/following/
}

#' ig_get_user_tags
#' 
#' NEEDS DOCUMENTATION!!!!
#' NEEDS tEST
#' @export
ig_get_user_tags <- function(user_ID, return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  ig_generic_GET(relative_endpoint = sprintf("usertags/%s/feed",user_ID),
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  #Target Endpoint: usertags/{username_id}/feed/
}

#' ig_get_geomedia
#' 
#' NEEDS DOCUMENTATION!!!!
#' NEEDS TEST
#' @export
ig_get_geomedia <- function(user_ID, return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  ig_generic_GET(relative_endpoint = sprintf("maps/user/%s",user_ID),
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  #Target Endpoint: maps/user/{username_id}/
}
