##### THIS FILE NEEDS FUNCTIONS & DOCUMENTATION

#' ig_like 
#' 
#' NEEDS DOCUMENTATION!!!!
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

#' ig_unlike 
#' 
#' NEEDS DOCUMENTATION!!!!
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

#' ig_save 
#' 
#' NEEDS DOCUMENTATION!!!!
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

#' ig_unsave 
#' 
#' NEEDS DOCUMENTATION!!!!
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

#' ig_comment
#' 
#' NEEDS DOCUMENTATION!!!!
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

#' ig_comment_delete
#' 
#' NEEDS DOCUMENTATION!!!!
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
ig_get_media_comments <- function(media_id, max_id){
  ig_generic_GET(relative_endpoint = sprintf("media/%s/comments/", media_id),
                  query = list(max_id = "", q = max_id))
  #Target Endpoint: media/{media_id}/comments/
} 

#' ig_get_media_likers
#' 
#' NEEDS DOCUMENTATION!!!!
#' 
#' @export
ig_get_media_likers <- function(media_id, return_df = TRUE, verbose = FALSE){
  ig_generic_GET(relative_endpoint = sprintf("media/%s/likers/?", media_id),
                 item_name = "users", 
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
