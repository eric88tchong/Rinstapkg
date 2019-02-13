##### THIS FILE NEEDS FUNCTIONS & DOCUMENTATION 

#' ig_search_users
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_search_users <- function(){
  #Target Endpoint: users/search/
}

#' ig_search_username
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_search_username <- function(username,return_df=TRUE){
  
  ig_generic_GET(relative_endpoint=sprintf("users/%s/usernameinfo/",username), 
                           item_name = "user", 
                           return_df = return_df)
}
#' ig_search_tags
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
  ig_search_tags <- function(){
  #Target Endpoint: tags/search/
}
