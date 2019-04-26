##### THIS FILE NEEDS FUNCTIONS & DOCUMENTATION

#' Like a specified post
#' 
#' This function takes the \code{media_id} of a post and likes that post for you
#' 
#' @template media_id
#' 
#' @export
ig_like <- function(media_id){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "media_id" = media_id)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/like/", media_id),
                  body_as_list = my_list)
  #Target Endpoint: media/{media_id}/like/
}

#' Unlike a specified post
#' 
#' This function takes the \code{media_id} of a post and unlikes that post for you
#' 
#' @template media_id
#' 
#' @export
ig_unlike <- function(media_id){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "media_id" = media_id)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/unlike/", media_id),
                  body_as_list = my_list)
  #Target Endpoint: media/{media_id}/unlike/
}

#' Saves a specified post
#' 
#' This function takes the \code{media_id} of a post and puts that post in the Saved folder within Instagram
#' 
#' @template media_id
#' 
#' @export
ig_save <- function(media_id){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "media_id" = media_id)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/save/", media_id),
                  body_as_list = my_list)
  #Target Endpoint: media/{media_id}/save/
}

#' Unsaves a specified post
#' 
#' This function takes the \code{media_id} of a post and removes that post from the Saved folder within Instagram
#' 
#' @template media_id
#' 
#' @export
ig_unsave <- function(media_id){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "media_id" = media_id)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/unsave/", media_id),
                  body_as_list = my_list)
  #Target Endpoint: media/{media_id}/unsave/
}

#' Writes a comment on a specified post
#' 
#' This function takes the \code{media_id} of a post as well as a \code{comment_text}
#' and leaves the comment on the post
#' 
#' @template media_id
#' @param comment_text chr; the text that would be posted as a comment underneath the post
#' 
#' @export
ig_comment <- function(media_id, comment_text){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "comment_text" = comment_text)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/comment/", media_id),
                  body_as_list = my_list)
  #Target Endpoint: media/{media_id}/comment/
}    

#' Deletes a comment on a specified post
#' 
#' This function takes the \code{media_id} of a post as well as the \code{comment_id}
#' that the user wants to delete and removes that comment from the post
#' 
#' @template media_id
#' @param comment_id NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_comment_delete <- function(media_id, comment_id){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/comment/%s/delete", media_id, comment_id),
                  body_as_list = my_list)
  #Target Endpoint: media/{media_id}/comment/{comment_id}/delete/
} 

#' ig_get_media_info
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_get_media_info <- function(media_id){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "media_id" = media_id)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/info/", media_id),
                  body_as_list = my_list)
  #Target Endpoint: media/{media_id}/info/
} 

#' ig_get_media_comments NEEDS HELP
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_get_media_comments <- function(media_id, max_id = NULL, return_df = TRUE, paginate = TRUE,
                                  max_pages = 10, verbose = FALSE){
  this_query <- list(max_id = max_id)
  ig_generic_GET(relative_endpoint = sprintf("media/%s/comments/", media_id),
                query = this_query,
                item_accessor = function(x) x[["comments"]], 
                return_df = return_df, 
                paginate = paginate,
                max_pages = max_pages, 
                verbose = verbose)
  #Target Endpoint: media/{media_id}/comments/
} 

#' ig_get_media_likers
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_get_media_likers <- function(media_id, return_df = TRUE, verbose = FALSE){
  ig_generic_GET(relative_endpoint = sprintf("media/%s/likers/?", media_id),
                 item_accessor = function(x) x[["users"]], 
                 return_df = return_df, 
                 verbose = verbose)

  #Target Endpoint: media/{media_id}/likers/
} 

#' ig_edit_media
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_edit_media <- function(media_id, caption_text){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "caption_text" = caption_text)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/edit_media/", media_id),
                  body_as_list = my_list)
  #Target Endpoint: media/{media_id}/edit_media/
} 

#' ig_delete_media
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_delete_media <- function(media_id, media_type = 1){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "media_type" = media_type,
                  "media_id" = media_id)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/delete/", media_id),
                  body_as_list = my_list)
  #Target Endpoint: media/{media_id}/delete/
} 
