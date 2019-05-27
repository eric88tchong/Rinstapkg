# Adapted from googlesheets package https://github.com/jennybc/googlesheets

# Modifications:
#  - Modified VERB_n() with custom headers
#  - Added catch_errors() function
#  - Added generic_get() function

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

#' Generic implementation of HTTP methods with retries and authentication
#' 
#' @importFrom httr status_code config add_headers
#' @importFrom stats runif
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
VERB_n <- function(VERB, n = 5) {
  function(url, headers=character(0), ...) {
    
    current_state <- Rinstapkg_state()
    
    for (i in seq_len(n)) {
      
      if(!is.null(current_state$auth_method) && current_state$auth_method == "OAuth"){
        out <- VERB(url = url, 
                    config = config(token = current_state$token), 
                    add_headers(headers), ...) 
      } else {
        out <- VERB(url = url,
                    add_headers(headers, 
                                c('Connection' = 'close',
                                  'Accept' = '*/*',
                                  'Content-type' = 'application/x-www-form-urlencoded; charset=UTF-8',
                                  'Cookie2' = '$Version=1',
                                  'Accept-Language' = 'en-US',
                                  'User-Agent' = getOption("Rinstapkg.useragent"))), ...) 
      }
      
      status <- status_code(out)
      if (status < 500 || i == n) break
      backoff <- runif(n = 1, min = 0, max = 2 ^ i - 1)
      ## TO DO: honor a verbose argument or option
      mess <- paste("HTTP error %s on attempt %d ...\n",
                    "  backing off %0.2f seconds, retrying")
      mpf(mess, status, i, backoff)
      Sys.sleep(backoff)
    }
    out
  }
}

#' GETs with retries and authentication
#' 
#' @importFrom httr GET
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rGET <- VERB_n(GET)

#' POSTs with retries and authentication
#' 
#' @importFrom httr POST
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPOST <- VERB_n(POST)

#' PATCHs with retries and authentication
#' 
#' @importFrom httr PATCH
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPATCH <- VERB_n(PATCH)

#' PUTs with retries and authentication
#' 
#' @importFrom httr PUT
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPUT <- VERB_n(PUT)

#' DELETEs with retries and authentication
#' 
#' @importFrom httr DELETE
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rDELETE <- VERB_n(DELETE)

## good news: these are handy and call. = FALSE is built-in
##  bad news: 'fmt' must be exactly 1 string, i.e. you've got to paste, iff
##             you're counting on sprintf() substitution
cpf <- function(...) cat(paste0(sprintf(...), "\n"))
mpf <- function(...) message(sprintf(...))
wpf <- function(...) warning(sprintf(...), call. = FALSE)
spf <- function(...) stop(sprintf(...), call. = FALSE)

#' Function to catch and print HTTP errors
#'
#' @importFrom httr content http_error
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
catch_errors <- function(x) {
  if(http_error(x)) {
    response_parsed <- content(x, encoding='UTF-8')
    if(status_code(x) < 500) {
      if(!is.null(response_parsed$status) & !is.null(response_parsed$message)) {
        stop(sprintf("Status: %s\nMessage: %s", 
                     response_parsed$status, response_parsed$message), call. = FALSE)  
      }
    } else {
      stop(response_parsed, call. = FALSE) 
    }
  }
  invisible(FALSE)
}

#' A Generic GET Function
#' 
#' This is a function that can be used for most all endpoints of the API that 
#' return items that can be filtered with a query and typically need to be paginated. 
#' This reduces the amount of redundant code inside each unique function that 
#' pings the endpoints. 
#'
#' @importFrom httr parse_url build_url content
#' @importFrom dplyr bind_rows
#' @importFrom purrr pluck
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
ig_generic_GET <- function(relative_endpoint, query = NULL, item_accessor = NULL, 
                           return_df = TRUE, paginate = FALSE, page_index = 1, 
                           max_pages = 10, verbose = FALSE) {
  
  endpoint_url <- parse_url(sprintf('%s/%s', 
                                    getOption("Rinstapkg.private_base_url"), 
                                    relative_endpoint))
  endpoint_url$query <- query
  httr_url <- build_url(endpoint_url)
  
  if(verbose){
    if(paginate) {
      if(page_index == 1) message(httr_url)
      message(sprintf("Pulling Results Page: %s", page_index))      
    } else {
      message(httr_url)  
    }
  }
  
  resp <- rGET(httr_url)
  catch_errors(resp) # how should we handle 404 errors?
  resp_parsed <- content(resp, as = "parsed")
  
  target_data <- if(is.null(item_accessor)) resp_parsed else pluck(resp_parsed, item_accessor)
  # drop any elements that are in the following list of ignored elements
  ignore_idx <- sapply(sapply(target_data, names), FUN=function(x){any(x %in% c("end_of_feed_demarcator", 
                                                                                "suggestions"))})    
  target_data <- target_data[!ignore_idx]
  result <- if(return_df) items_to_tidy_df(target_data) else target_data
  
  # check whether it has another page of records and continue to pull if so
  more_records <- any(unlist(resp_parsed[c('has_more', 'more_available', 
                                           'big_list', 'has_more_comments')]))
  if(!is.null(more_records)){
    if(more_records & paginate & page_index <= max_pages){
      query$max_id <- resp_parsed$next_max_id
      next_result <- ig_generic_GET(relative_endpoint = relative_endpoint, 
                                    query = query,
                                    item_accessor = item_accessor, 
                                    return_df = return_df, 
                                    paginate = paginate,
                                    page_index = page_index + 1, 
                                    max_pages = max_pages,
                                    verbose = verbose)
      result <- if(return_df) bind_rows(result, next_result) else c(result, next_result)
    }
  }
  
  return(result)
}

#' A Generic POST Function
#' 
#' This is a function that can be used for most all endpoints of the API that 
#' accept a signed body of JSON data for a POST. This reduces the amount of redundant 
#' code inside each unique function that pings the endpoints. 
#'
#' @importFrom httr parse_url build_url content
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
ig_generic_POST <- function(relative_endpoint, body_as_list, 
                            return_df = FALSE, verbose = FALSE) {
  
  endpoint_url <- parse_url(sprintf('%s/%s', 
                                    getOption("Rinstapkg.private_base_url"), 
                                    relative_endpoint))
  httr_url <- build_url(endpoint_url)
  if(verbose) httr_url
  
  resp <- rPOST(httr_url, body = generate_signed_body(body_as_list))
  catch_errors(resp)
  resp_parsed <- content(resp, "parsed")
  
  result <- if(return_df) items_to_tidy_df(resp_parsed) else resp_parsed
  return(result)
}
