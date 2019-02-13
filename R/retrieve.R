##### THIS FILE NEEDS FUNCTIONS & DOCUMENTATION 

#' Return the user ID from a username
#' 
#' This function uses and instagram username to return the userID that you will need for other functions
#' 
#' @param username A character string 
#' @param return_df When return_df=FALSE, this function will return a list, in this case, return df will return just return the integer that is the user id. 
#' @examples
#' ig_get_user_id("r4sctest")
#' ig_get_user_id("r4scatUVA")
#' @export
ig_get_user_id <- function(username,return_df=FALSE){
  
  my_list<- ig_generic_GET(relative_endpoint=sprintf("users/%s/usernameinfo/",username), 
                 item_name = "user", 
                 return_df = return_df)
  return(my_list$pk)

}
#' Return a dateframe of the posts from a specified account
#' 
#' This function uses the user_id to return a dataframe of information from that account's feed
#' 
#' @param user_id An integer 
#' @param return_df When return_df=TRUE, this function will return the results in dataframe form, if return_df=FALSE it will return a list
#' @param verbose When verbose=FALSE, this function will run without printing the intermediary steps 
#' @param paginate When paginate=TRUE, this function allows you to return multiple page in instagram, currently each page has 18 entries
#' @param max_pages When max_pages = 10 & paginate=TRUE this function will return all the entries down to the last entry of the 10th page
#' @examples 
#' ig_get_user_feed("10719578450")
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
 
#' Return a dataframe of posts with the specified hashtag
#' 
#' This function filters by hashtags and returns all posts that have the same hashtag string
#' 
#' @param hashtag_string A string of characters: do not include the hashtag at the beginning
#' @param return_df When return_df=TRUE, this function will return the results in dataframe form, if return_df=FALSE it will return a list
#' @param verbose When verbose=FALSE, this function will run without printing the intermediary steps 
#' @param paginate When paginate=TRUE, this function allows you to return multiple page in instagram, currently each page has 18 entries
#' @param max_pages When max_pages = 10 & paginate=TRUE this function will return all the entries down to the last entry of the 10th page
#' @examples 
#' ig_get_hashtag_feed("R4SC4LIFE")
#' @export
ig_get_hashtag_feed <- function(hashtag_string,return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  
  ig_generic_GET(relative_endpoint = sprintf("feed/tag/%s",hashtag_string),
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  #Target Endpoint: feed/tag/
}
#' Return a dataframe of posts at the specified location
#' 
#' This function filters by location and returns all the posts that have the same location_string
#' @param location_string A string of characters: Syntax: unknown yet
#' @param return_df When return_df=TRUE, this function will return the results in dataframe form, if return_df=FALSE it will return a list
#' @param verbose When verbose=FALSE, this function will run without printing the intermediary steps 
#' @param paginate When paginate=TRUE, this function allows you to return multiple page in instagram, currently each page has 18 entries
#' @param max_pages When max_pages = 10 & paginate=TRUE this function will return all the entries down to the last entry of the 10th page
#' @export
ig_get_location_feed <- function(location_string,return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  ig_generic_GET(relative_endpoint = sprintf("feed/location/%s",location_string),
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  
  #Target Endpoint: feed/location/
}

#' Return dataframe with the current most popular posts on instagram
#' 
#' This function just returns current most popular posts on instagram
#' @param return_df When return_df=TRUE, this function will return the results in dataframe form, if return_df=FALSE it will return a list
#' @param verbose When verbose=FALSE, this function will run without printing the intermediary steps 
#' @param paginate When paginate=TRUE, this function allows you to return multiple page in instagram, currently each page has 24 entries
#' @param max_pages When max_pages = 10 & paginate=TRUE this function will return all the entries down to the last entry of the 10th page
#' I think this works but can only be run after a certain timeframe
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

#' Returns a dataframe with all the posts that you saved
#' 
#' This function returns the posts that you saved inside of your account
#' @param return_df When return_df=TRUE, this function will return the results in dataframe form, if return_df=FALSE it will return a list
#' @param verbose When verbose=FALSE, this function will run without printing the intermediary steps 
#' @param paginate When paginate=TRUE, this function allows you to return multiple page in instagram, currently each page has 18 entries
#' @param max_pages When max_pages = 10 & paginate=TRUE this function will return all the entries down to the last entry of the 10th page
#' @export
ig_get_saved_feed <- function(return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  ig_generic_GET(relative_endpoint = "feed/saved",
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  #Target Endpoint: feed/saved/
}

#' Returns a dataframe with information of followers of the account if it is public
#' 
#' This function needs testing
#' @param return_df When return_df=TRUE, this function will return the results in dataframe form, if return_df=FALSE it will return a list
#' @param verbose When verbose=FALSE, this function will run without printing the intermediary steps 
#' @export
ig_get_followers <- function(user_ID,return_df=TRUE, verbose=FALSE){
  ig_generic_GET(relative_endpoint = sprintf("friendships/%s/followers",user_ID),
                 item_name = "users", return_df = return_df, verbose=verbose)
  #Target Endpoint: friendships/{username_id}/followers/
}

#' Returns a dataframe with information of all the people this account follows if it is public
#' 
#' This function uses user ID to return a dataframe of all the people the account is following
#' @param return_df When return_df=TRUE, this function will return the results in dataframe form, if return_df=FALSE it will return a list
#' @param verbose When verbose=FALSE, this function will run without printing the intermediary steps 
#' @export
ig_get_followings <- function(user_ID,return_df=TRUE, verbose=FALSE){
  ig_generic_GET(relative_endpoint = sprintf("friendships/%s/following",user_ID),
                 item_name = "users", return_df = return_df, verbose=verbose)
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
#' NEEDS tEST
#' @export
ig_get_geomedia <- function(user_ID, return_df=TRUE, verbose=FALSE, paginate=TRUE, max_pages = 10){
  ig_generic_GET(relative_endpoint = sprintf("maps/user/%s",user_ID),
                 item_name = "items", paginate=paginate, max_pages=max_pages, 
                 return_df = return_df,
                 verbose=verbose)
  #Target Endpoint: maps/user/{username_id}/
}
