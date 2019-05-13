#' Like a Post
#' 
#' This function takes the \code{media_id} of a post and likes that post for you.
#' 
#' @template media_id
#' @template verbose
#' @export
ig_like <- function(media_id, verbose = FALSE){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "media_id" = media_id)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/like/", media_id),
                  body_as_list = my_list, 
                  verbose = verbose)
}

#' Unlike a Post
#' 
#' This function takes the \code{media_id} of a post and unlikes that post for you.
#' 
#' @template media_id
#' @template verbose
#' @export
ig_unlike <- function(media_id, verbose = FALSE){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "media_id" = media_id)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/unlike/", media_id),
                  body_as_list = my_list, 
                  verbose = verbose)
}

#' Save a Post
#' 
#' This function takes the \code{media_id} of a post and puts that post in the 
#' Saved folder within Instagram.
#' 
#' @template media_id
#' @template verbose
#' @export
ig_save <- function(media_id, verbose = FALSE){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "media_id" = media_id)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/save/", media_id),
                  body_as_list = my_list, 
                  verbose = verbose)
}

#' Unsave a Post
#' 
#' This function takes the \code{media_id} of a post and removes that post from 
#' the Saved folder within Instagram.
#' 
#' @template media_id
#' @template verbose
#' @export
ig_unsave <- function(media_id, verbose = FALSE){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "media_id" = media_id)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/unsave/", media_id),
                  body_as_list = my_list, 
                  verbose = verbose)
}

#' Comment on a Post
#' 
#' This function takes the \code{media_id} of a post as well as a \code{comment_text}
#' and leaves the comment on the post.
#' 
#' @template media_id
#' @param comment_text character; the text that would be posted as a comment 
#' underneath the post
#' @template verbose
#' @export
ig_comment <- function(media_id, comment_text, verbose = FALSE){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "comment_text" = comment_text)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/comment/", media_id),
                  body_as_list = my_list, 
                  verbose = verbose)
}    

#' Delete a Comment on a Post
#' 
#' This function takes the \code{media_id} of a post as well as the \code{comment_id}
#' that the user wants to delete and removes that comment from the post.
#' 
#' @template media_id
#' @template comment_id
#' @template verbose
#' @export
ig_comment_delete <- function(media_id, comment_id, verbose = FALSE){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/comment/%s/delete/", 
                                              media_id, comment_id),
                  body_as_list = my_list, 
                  verbose = verbose)
} 

#' Delete Comments on a Post in Bulk
#' 
#' This function takes the \code{media_id} of a post as well as one or more \code{comment_id}s 
#' and then deletes all of those comments
#' 
#' @template media_id
#' @template comment_id
#' @template verbose
#' @export
ig_comment_delete_bulk <- function(media_id, comment_id, verbose = FALSE){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token, 
                  comment_ids_to_delete = paste0(comment_id, collapse=","))
  ig_generic_POST(relative_endpoint = sprintf("media/%s/comment/bulk_delete/", 
                                              media_id),
                  body_as_list = my_list, 
                  verbose = verbose)
} 

#' Get Media Info
#' 
#' This function returns the details of a single post. It contains the same information 
#' about a post that is retrieved by many of the feed functions. 
#' 
#' @template media_id
#' @template verbose
#' @examples \dontrun{
#' bieber_user_id <- ig_get_user_id("justinbieber")
#' bieber_feed <- ig_get_user_feed(bieber_user_id, paginate = FALSE)
#' most_recent_post <- ig_get_media_info(media_id = bieber_feed$id[1])
#' }
#' @export
ig_get_media_info <- function(media_id, verbose = FALSE){
  ig_generic_GET(relative_endpoint = sprintf("media/%s/info/", media_id),
                 item_accessor = function(x) x[["items"]][[1]],
                 paginate = FALSE,
                 return_df = FALSE, 
                 verbose = verbose)
} 

#' Get Media Comments and Likers
#' 
#' These functions return the comments and user like data from a single post.
#' 
#' @template media_id
#' @inheritParams feed
#' @examples \dontrun{
#' bieber_user_id <- ig_get_user_id("justinbieber")
#' bieber_feed <- ig_get_user_feed(bieber_user_id, paginate = FALSE)
#' most_recent_post_comments <- ig_get_media_comments(media_id = bieber_feed$id[1])
#' }
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
} 

#' @rdname ig_get_media_comments
#' @export
ig_get_media_likers <- function(media_id, max_id = NULL, return_df = TRUE, paginate = TRUE,
                                max_pages = 10, verbose = FALSE){
  this_query <- list(max_id = max_id)
  ig_generic_GET(relative_endpoint = sprintf("media/%s/likers/", media_id),
                 query = this_query,
                 item_accessor = function(x) x[["users"]], 
                 return_df = return_df, 
                 paginate = paginate,
                 max_pages = max_pages, 
                 verbose = verbose)
} 

#' Edit a Post's Caption
#' 
#' This function can be used to edit the caption of a post that has already been made.
#' 
#' @template media_id
#' @param caption_text character; the text below a post's image or video.
#' @template verbose
#' @export
ig_edit_media_caption <- function(media_id, caption_text, verbose = FALSE){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  "caption_text" = caption_text)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/edit_media/", media_id),
                  body_as_list = my_list, 
                  verbose = verbose)
}

#' Delete a Post
#' 
#' This function can be used to delete a post.
#' 
#' @template media_id
#' @template verbose
#' @export
ig_delete_media <- function(media_id, verbose = FALSE){
  current_state <- Rinstapkg_state()
  my_list <- list("_uuid" = current_state$session_guid, 
                  "_uid" = current_state$username_id,
                  "_csrftoken" = current_state$csrf_token,
                  # TODO: CHECK IF THIS WORDS FOR VIDEO MEDIA AS WELL
                  "media_type" = media_type_enum("PHOTO"),
                  "media_id" = media_id)
  ig_generic_POST(relative_endpoint = sprintf("media/%s/delete/", media_id),
                  body_as_list = my_list, 
                  verbose = verbose)
}
