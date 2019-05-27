# Adapted from googlesheets package https://github.com/jennybc/googlesheets

# Modifications:
#  - Changed the scopes and authentication endpoints
#  - Renamed the function gs_auth to ig_auth to be consistent with package 
#    and added basic authentication handling
#  - Added basic authentication session handling functions

# Copyright (c) 2017 Jennifer Bryan, Joanna Zhao
#   
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#   
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# environment to store credentials
.state <- new.env(parent = emptyenv())

#' Log in to Instagram
#' 
#' Log in using Basic (Username-Password) or OAuth 2.0 authenticaion. OAuth does
#' not require sharing passwords, but will require authorizing \code{Rinstapkg} 
#' as a connected app to view and manage your account. You will be directed to 
#' a web browser, asked to sign in to your Instagram account, and to grant \code{Rinstapkg} 
#' permission to operate on your behalf. By default, these user credentials are 
#' cached in a file named \code{.httr-oauth-Rinstapkg} in the current working directory.
#'
#' @importFrom httr content oauth2.0_token oauth_app oauth_endpoint stop_for_status
#' @importFrom jsonlite toJSON
#' @importFrom digest digest hmac
#' @param username Instagram username, use the handle without the "@@" sign or an email
#' @param password Instagram password
#' @param token optional; an actual token object or the path to a valid token
#'   stored as an \code{.rds} file
#' @param client_id,client_secret,callback_url the "Client Id","Client Secret", 
#' and "Callback URL" when using a connected app. The \code{Rinstapkg} does not have 
#' a default App so you must specify these if using the OAuth2.0 protocol
#' @param cache logical or character; TRUE means to cache using the default cache 
#' file \code{.httr-oauth-Rinstapkg}, FALSE means don't cache. A string means use 
#' the specified path as the cache file.
#' @template verbose
#' @examples \donttest{
#' # log in using basic authentication (username-password)
#' ig_auth(username = "test@@gmail.com", 
#'         password = "test_password")
#' 
#' # log in using OAuth 2.0
#' # Via brower or refresh of .httr-oauth-Rinstapkg
#' options(Rinstapkg.client_id = "012345678901-99thisisatest99")
#' options(Rinstapkg.client_secret = "Th1s1sMyC1ientS3cr3t")
#' ig_auth()
#' 
#' # Save token and log in using it
#' saveRDS(.state$token, "token.rds")
#' ig_auth(token = "token.rds")
#' }
#' @export
ig_auth <- function(username = NULL,
                    password = NULL,
                    token = NULL,
                    client_id = getOption("Rinstapkg.client_id"),
                    client_secret = getOption("Rinstapkg.client_secret"),
                    callback_url = getOption("Rinstapkg.callback_url"),
                    cache = getOption("Rinstapkg.httr_oauth_cache"),
                    verbose = FALSE){
  
  if(!is.null(username) & !is.null(password)){
    
    # basic authentication (username-password) -------------------------------------

    # get the right csrf token 
    challenge_guid <- generate_uuid(keep_dashes = FALSE)
    challenge_url <- paste0("si/fetch_headers/?challenge_type=signup&guid=", challenge_guid)
    response <- rGET(sprintf('%s/%s', getOption("Rinstapkg.private_base_url"), challenge_url))
    this_csrftoken <- response$cookies[which(response$cookies$name == 'csrftoken'), 'value']
    
    # create guids and ids for this device 
    seed <- digest(paste0(username, password), serialize = FALSE)
    new_seed <- digest(paste0(seed, "12345"), serialize = FALSE)
    this_device_id <- paste0("android-", substr(new_seed, 1, 16))
    this_phone_id <- generate_uuid(keep_dashes = TRUE)
    session_guid <- generate_uuid(keep_dashes = TRUE)
    
    # login 
    login_data <- list('phone_id' = this_phone_id,
                       '_csrftoken' = this_csrftoken,
                       'username' = username,
                       'guid' = session_guid,
                       'device_id' = this_device_id,
                       'password' = password,
                       'login_attempt_count' = 0)
    login_response <- rPOST(sprintf('%s/%s', getOption("Rinstapkg.private_base_url"), 'accounts/login/'),
                            body = generate_signed_body(login_data))
    login_response_parsed <- content(login_response)
    if(login_response_parsed$status == "fail"){
      if(login_response_parsed$message == "challenge_required"){
       message(sprintf("%s %s %s", 
                       "Your account has been flagged to enter a challenge code.", 
                       "Go to https://instagram.com, login, and receive a code via email", 
                       "or text message to re-enable programmatic access.")) 
      }
      stop(sprintf(login_response_parsed$message))
    } else {
      stop_for_status(login_response)
    }
    
    # keep track of these for future requests
    my_username_id <- login_response_parsed$logged_in_user$pk
    rank_token <- sprintf('%s_%s', my_username_id, session_guid)
    csrf_token <- login_response$cookies[which(login_response$cookies$name == 'csrftoken'), 'value']
    
    # set the global .state variable
    .state$auth_method <- "Basic"
    .state$token = NULL
    .state$csrf_token = csrf_token
    .state$rank_token = rank_token
    .state$phone_id = this_phone_id
    .state$device_id = this_device_id
    .state$session_guid = session_guid
    .state$username_id = my_username_id
    
    # Run these so that we are not identified as bot since we mimic the typical
    # process that this device would do after logging in
    # https://github.com/eseom/pyinstagram/blob/master/pyinstagram/instagram.py#L233
    
    invisible(ig_sync_features())
    invisible(ig_my_timeline(paginate=FALSE))
    invisible(ig_my_recent_activity())
    invisible(try(ig_autocomplete_userlist(), silent = TRUE)) # can result in error code 429
    invisible(try(ig_my_inbox(), silent = TRUE)) # typically returns 404
    
  } else {
    
    # OAuth2.0 authentication
    if (is.null(token)) {
      
      stop("Not implemented yet", call. = FALSE)
      
      ig_oauth_app <- oauth_app("instagram",
                                key = client_id, 
                                secret = client_secret,
                                redirect_uri = callback_url)
      
      ig_oauth_endpoints <- oauth_endpoint(request = NULL,
                                           base_url = "https://login.instagram.com/services/oauth2",
                                           authorize = "authorize", access = "token", revoke = "revoke")
      
      ig_token <- oauth2.0_token(endpoint = ig_oauth_endpoints,
                                 app = ig_oauth_app, 
                                 cache = cache)
  
      stopifnot(is_legit_token(ig_token, verbose = TRUE))
      
      # set the global .state variable
      .state$auth_method <- "OAuth"
      .state$token <- ig_token
      .state$csrf_token = NULL
      .state$rank_token = NULL
      .state$phone_id = NULL
      .state$device_id = NULL
      .state$session_guid = NULL
      .state$username_id = NULL
      
    } else if (inherits(token, "Token2.0")) {
      
      # accept token from environment ------------------------------------------------
      stopifnot(is_legit_token(token, verbose = TRUE))
      
      # set the global .state variable
      .state$auth_method <- "OAuth"
      .state$token <- token
      .state$csrf_token = NULL
      .state$rank_token = NULL
      .state$phone_id = NULL
      .state$device_id = NULL
      .state$session_guid = NULL
      .state$username_id = NULL
      
    } else if (inherits(token, "character")) {
      
      # accept token from file -------------------------------------------------------
      ig_token <- try(suppressWarnings(readRDS(token)), silent = TRUE)
      
      if (inherits(ig_token, "try-error")) {
        spf("Cannot read token from alleged .rds file:\n%s", token)
      } else if (!is_legit_token(ig_token, verbose = TRUE)) {
        spf("File does not contain a proper token:\n%s", token)
      }
      
      # set the global .state variable
      .state$auth_method <- "OAuth"
      .state$token <- ig_token
      .state$csrf_token = NULL
      .state$rank_token = NULL
      .state$phone_id = NULL
      .state$device_id = NULL
      .state$session_guid = NULL
      .state$username_id = NULL
      
    } else {
      spf("Input provided via 'token' is neither a",
          "token,\nnor a path to an .rds file containing a token.")
    }
  }
  
  invisible(list(auth_method = .state$auth_method, 
                 token = .state$token, 
                 csrf_token = .state$csrf_token, 
                 rank_token = .state$rank_token, 
                 phone_id = .state$phone_id, 
                 device_id = .state$device_id, 
                 session_guid = .state$session_guid, 
                 username_id = .state$username_id))
}

#' Synchronise experiments
#' 
#' This function performs a sync of the conditions of the app you are working with. 
#' The experiment conditions must need to be set prior to logging in using \link{ig_auth} by 
#' first using \code{options(Rinstapkg.experiments="...")}.
#'
#' @param features character; a long string with commas separating each of the 
#' experimental values to be set
#' @template verbose
#' @note This is mainly for backend functionality during login.
#' @export
ig_sync_features <- function(features = getOption("Rinstapkg.experiments"), 
                             verbose = FALSE){
  current_state <- Rinstapkg_state()
  this_dat <- list('_uuid' = current_state$session_guid,
                   '_uid' = current_state$username_id,
                   'id' = current_state$username_id,
                   '_csrftoken' = current_state$csrf_token,
                   'experiments' = features)
  ig_generic_POST(relative_endpoint="qe/sync/", body_as_list=this_dat, verbose=verbose)
}

#' Check that token appears to be legitimate
#'
#' @keywords internal
is_legit_token <- function(x, verbose = FALSE) {
  
  if (!inherits(x, "Token2.0")) {
    if (verbose) message("Not a Token2.0 object.")
    return(FALSE)
  }
  
  if ("invalid_client" %in% unlist(x$credentials)) {
    if (verbose) {
      message("Authorization error. Please check client_id and client_secret.")
    }
    return(FALSE)
  }
  
  if ("invalid_request" %in% unlist(x$credentials)) {
    if (verbose) message("Authorization error. No access token obtained.")
    return(FALSE)
  }
  
  TRUE
  
}

#' Check that an Authorized Instagram Session Exists
#'
#' Before the user makes any calls requiring an authorized session, check if an 
#' OAuth token or session is not already available, call \code{\link{ig_auth}} to 
#' by default initiate the OAuth 2.0 workflow that will load a token from cache or 
#' launch browser flow. Return the bare token. Use
#' \code{access_token()} to reveal the actual access token, suitable for use
#' with \code{curl}.
#'
#' @template verbose
#' @return a \code{Token2.0} object (an S3 class provided by \code{httr}) or a 
#' a character string of the sessionId element of the current authorized 
#' API session
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
ig_auth_check <- function(verbose = FALSE) {
  if (!token_available(verbose) & !csrf_token_available(verbose)) {
    # not auth'ed at all before a call that requires auth, so
    # start up the OAuth 2.0 workflow that should work seamlessly
    # if a cached file exists
    ig_auth(verbose = verbose)
    res <- .state$token
  } else if(token_available(verbose)) {
    issued_timestamp <- as.numeric(substr(.state$token$credentials$issued_at, 1, 10))
    nows_timestamp <- as.numeric(Sys.time())
    time_diff_in_sec <- nows_timestamp - issued_timestamp
    if(time_diff_in_sec > 3600){
      # the token is probably expired even though we have it so refresh
      # TODO: must be better way to validate the token.
      ig_auth_refresh(verbose = verbose)
    }
    res <- .state$token
  } else if(csrf_token_available(verbose)) {
    res <- .state$csrf_token
  } else {
    # somehow we've got a token and session id, just return the token
    res <- .state$token
  }
  invisible(res)
}

#' Refresh an existing Authorized Instagram Token
#'
#' Force the current OAuth to refresh. This is only needed for times when you 
#' load the token from outside the current working directory, it is expired, and 
#' you're running in non-interactive mode.
#'
#' @template verbose
#' @return a \code{Token2.0} object (an S3 class provided by \code{httr})
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
ig_auth_refresh <- function(verbose = FALSE) {
  if(token_available(verbose)){
    .state$token <- .state$token$refresh()
  } else {
    message("No token found. ig_auth_refresh() only refreshes OAuth tokens")
  }
  invisible(.state$token)
}

#' Check csrf_token availability
#'
#' Check if a csrf_token is available in \code{\link{Rinstapkg}}'s internal
#' \code{.state} environment.
#'
#' @return logical
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
csrf_token_available <- function(verbose = TRUE) {
  if (is.null(.state$csrf_token)) {
    if (verbose) {
      message("The csrf_token is NULL in Rinstapkg's internal .state environment. ", 
              "This can occur if the user is authorized using OAuth 2.0, which doesn't ", 
              "require a csrf_token, or the user is not yet performed any authorization ", 
              "routine.\n",
              "When/if needed, 'Rinstapkg' will initiate authentication ",
              "and authorization.\nOr run ig_auth() to trigger this explicitly.")
    }
    return(FALSE)
  }
  TRUE
}

#' Check rank_token availability
#'
#' Check if a rank_token is available in \code{\link{Rinstapkg}}'s internal
#' \code{.state} environment.
#'
#' @return logical
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rank_token_available <- function(verbose = TRUE) {
  if (is.null(.state$rank_token)) {
    if (verbose) {
      message("The rank_token is NULL in Rinstapkg's internal .state environment. ", 
              "This can occur if the user is authorized using OAuth 2.0, which doesn't ", 
              "require a rank_token, or the user is not yet performed any authorization ", 
              "routine.\n",
              "When/if needed, 'Rinstapkg' will initiate authentication ",
              "and authorization.\nOr run ig_auth() to trigger this explicitly.")
    }
    return(FALSE)
  }
  TRUE
}

#' Check token availability
#'
#' Check if a token is available in \code{\link{Rinstapkg}}'s internal
#' \code{.state} environment.
#'
#' @return logical
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
token_available <- function(verbose = TRUE) {
  if (is.null(.state$token)) {
    if (verbose) {
      if (file.exists(".httr-oauth-Rinstapkg")) {
        message("A '.httr-oauth-Rinstapkg' file exists in current working ",
                "directory.\nWhen/if needed, the credentials cached in ",
                "'.httr-oauth-Rinstapkg' will be used for this session.\nOr run ig_auth() ",
                "for explicit authentication and authorization.")
      } else {
        message("No '.httr-oauth-Rinstapkg' file exists in current working directory.\n",
                "When/if needed, Rinstapkg will initiate authentication ",
                "and authorization.\nOr run ig_auth() to trigger this explicitly.")
      }
    }
    return(FALSE)
  }
  TRUE
}

#' Return access_token attribute of OAuth 2.0 Token
#'
#' @template verbose
#' @return character; a string of the access_token element of the current token in 
#' force; otherwise NULL
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
ig_access_token <- function(verbose = FALSE) {
  if (!token_available(verbose = verbose)) return(NULL)
  .state$token$credentials$access_token
}

#' Return csrf_token resulting from Basic auth routine
#'
#' @template verbose
#' @return character; a string of the csrf_token element of the current authorized 
#' API session; otherwise NULL
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
ig_csrf_token <- function(verbose = TRUE) {
  if (!csrf_token_available(verbose = verbose)) return(NULL)
  .state$csrf_token
}

#' Return rank_token resulting from Basic auth routine
#'
#' @template verbose
#' @return character; a string of the rank_token element of the current authorized 
#' API session; otherwise NULL
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
ig_rank_token <- function(verbose = TRUE) {
  if (!rank_token_available(verbose = verbose)) return(NULL)
  .state$rank_token
}
