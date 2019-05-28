#' Return the package's .state environment variable
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
Rinstapkg_state <- function(){
  .state
}

#' Validate a User Id
#' 
#' This function checks whether a supplied user_id fits the pattern of one, mostly 
#' to alert users when supplying a username instead of an id.
#' 
#' @template user_id
#' @examples
#' # check with a real user id
#' bieber_user_id <- 6860189 # returned using ig_get_user_id("justinbieber")
#' check_user_id(bieber_user_id)
#' 
#' # this will return a warning that we need a User Id, not a Username
#' #check_user_id("justinbieber")
#' @export
check_user_id <- function(user_id){
  if(!is.numeric(user_id)){
    valid_string <- grepl("^[0-9]+$", as.character(user_id))
    if(!valid_string){
      warning(sprintf("Invalid User Id - Check that this is not a Username: %s", user_id), 
              call. = FALSE)
    }
  }
  return(invisible(user_id))
}

#' Lookup Media Type Enum
#' 
#' This function returns the integer value of a specified type of media
#' 
#' @template media_type
#' @examples
#' # photo media are mapped to 1
#' media_type_enum("PHOTO")
#' 
#' # an unknown media type returns NULL
#' media_type_enum("FAKE_MEDIA_TYPE")
#' @export
media_type_enum <- function(media_type = c("PHOTO", "VIDEO", "ALBUM")){
  switch(media_type, PHOTO = 1, VIDEO = 2, ALBUM = 8, NULL)
}

#' Convert a value to Epoch Time
#' 
#' This function takes an input and converts it to the Unix epoch which is the 
#' number of seconds that have elapsed since January 1, 1970 at Midnight UTC.
#' 
#' @importFrom lubridate as_datetime
#' @param x object to be coerced
#' @export
as_epoch <- function(x){
  UseMethod("as_epoch")
}
#' @export
as_epoch.Date <- function(x){
  as.integer(as_datetime(x))
}
#' @export
as_epoch.POSIXct <- function(x){
  as.integer(as_datetime(x))
}
#' @export
as_epoch.POSIXlt <- function(x){
  as.integer(as.POSIXct(as_datetime(x)))
}
#' @export
as_epoch.character <- function(x){
  as.integer(as_datetime(x))
}
#' @export
as_epoch.numeric <- function(x){
  as.integer(x)
}
#' @export
as_epoch.integer <- function(x){
  x
}
#' @export
as_epoch.NULL <- function(x){
  NULL
}


#' Generate a Unique Id
#' 
#' This function generates universally unique ids with or without dashes
#'
#' @importFrom uuid UUIDgenerate
#' @param keep_dashes logical; an indicator of whether to keep the symbol "-" in 
#' the generated Id
#' @return character
#' @examples
#' id_w_dashes <- generate_uuid()
#' id_wo_dashes <- generate_uuid(keep_dashes=FALSE)
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
generate_uuid <- function(keep_dashes=TRUE){
  this_guid <- UUIDgenerate()
  if(!keep_dashes){
    this_guid <- gsub('-', '', this_guid)
  }
  return(this_guid)
}

#' Generate a Signed Body
#' 
#' This function generates signed json body when sending information to the API
#'
#' @importFrom digest digest hmac
#' @param list_data \code{list}; a list of data to be converted to JSON
#' @return character
#' @examples
#' login_data <- list('phone_id' = "012345678901-99thisisatest99",
#'                    '_csrftoken' = "012345678901-99thisisatest99",
#'                    'username' = "testuser",
#'                    'guid' = "012345678901-99thisisatest99",
#'                    'device_id' = "012345678901-99thisisatest99",
#'                    'password' = "testpassword",
#'                    'login_attempt_count' = 0)
#' signed_body <- generate_signed_body(login_data)
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
generate_signed_body <- function(list_data){
  data_as_json <- toJSON(list_data, auto_unbox=TRUE)
  body <- sprintf('ig_sig_key_version=%s&signed_body=%s.%s',
                  getOption("Rinstapkg.ig_sig_key_version"),
                  hmac(key = digest(getOption("Rinstapkg.ig_sig_key"), serialize = FALSE),
                       object = digest(data_as_json, serialize = FALSE),
                       algo = "sha256"),
                  data_as_json)
  return(body)
}

#' Convert JSON List of Items to as Data Frame
#' 
#' This function takes a list of items, potentially deeply nested, and returns 
#' a \code{tbl_df} with one row per item
#'
#' @importFrom purrr modify_if compact map map_df
#' @importFrom dplyr as_tibble
#' @param x \code{list}; a list object where each element is an item
#' @return \code{tbl_df}
#' @examples
#' list_dat <- list(list("name"="Item 1", 
#'                       "letters"=list("cap_letter"="A", 
#'                                      "lower_letter"="a")), 
#'                  list("name"="Item 2", 
#'                       "letters"=list("cap_letter"="B", 
#'                                      "lower_letter"="b"))) 
#' tidy_df_list <- items_to_tidy_df(list_dat)
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
items_to_tidy_df <- function(l){
  l %>%
    map(compact) %>%
    map_df(~as_tibble(modify_if(., ~(length(.x) > 1 | is.list(.x)), list)))
}

#' Determine the host operating system
#' 
#' This function determines whether the system running the R code
#' is Windows, Mac, or Linux
#'
#' @return A character string
#' @examples
#' my_os <- get_os()
#' @seealso \url{http://conjugateprior.org/2015/06/identifying-the-os-from-r}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin'){
      os <- "osx"
    }
  } else {
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os)){
      os <- "osx"
    }
    if (grepl("linux-gnu", R.version$os)){
      os <- "linux"
    }
  }
  unname(tolower(os))
}

#' Validate the input for an operation
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
ig_input_data_validation <- function(input_data, operation=''){
  stop("Not implemented yet", call. = FALSE)
}
