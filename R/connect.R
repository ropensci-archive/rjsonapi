#' Connection
#'
#' @export
#' @param url (character)Base url, e.g., \code{http://localhost:8080}
#' @param version (character) API version, e.g, \code{v1}
#' @param content_type (character) the content type to set in all request
#' headers. Default: application/vnd.api+json
#' @param ... Curl options passed on to \code{\link[crul]{HttpClient}}
#' @details
#' \strong{Methods}
#'   \describe{
#'     \item{\code{status(...)}}{
#'       Check server status with a HEAD request
#'
#'       \itemize{
#'        \item ... - curl options
#'       }
#'     }
#'     \item{\code{routes(...)}}{
#'       Get routes the server supports
#'
#'       \itemize{
#'        \item ... - curl options
#'       }
#'     }
#'     \item{\code{route(endpt, query, include, error_handler, ...)}}{
#'       Fetch a route, optional query parameters
#'
#'       \itemize{
#'        \item endpt - The endpoint to request data from. required.
#'        \item query - a set of query parameters. combined with include
#'        parameter
#'        \item include - A comma-separated list of relationship paths.
#'       combined with query parameter
#'        \item error_handler - A function for error handling
#'        \item ... - curl options
#'       }
#'     }
#'   }
#' @format NULL
#' @usage NULL
#' @examples \dontrun{
#' library("crul")
#' (conn <- connect("http://localhost:8088"))
#' conn$url
#' conn$version
#' conn$content_type
#' conn$status()
#' conn$routes()
#' conn$routes(verbose = TRUE)
#'
#' # get data from speicific routes
#' conn$route("authors")
#' conn$route("chapters")
#' conn$route("authors/1")
#' conn$route("authors/1/books")
#' conn$route("chapters/5")
#' conn$route("chapters/5/book")
#' conn$route("chapters/5/relationships/book")
#'
#' ## include
#' conn$route("authors/1", include = "books")
#' conn$route("authors/1", include = "photos")
#' conn$route("authors/1", include = "photos.title")
#'
#' ## set curl options on connect() call
#' xx <- connect("http://localhost:8088", verbose = TRUE)
#' xx$opts
#' xx$status()
#'
#' ## errors
#' ### route doesn't exist
#' # conn$route("foobar")
#'
#' ### document doesn't exist
#' # conn$route("authors/56")
#' }
connect <- function(url, version, content_type, headers, ...) {
  .jsapi_c$new(url, version, content_type, headers, ...)
}

.jsapi_c <-
  R6::R6Class("jsonapi_connection",
    public = list(
      url = "http://localhost:8088",
      version = "v1",
      content_type = "application/vnd.api+json",
      opts = NULL,
      headers = NULL,
      cli = NULL,

      initialize = function(url, version, content_type, headers = list(),
                            ...) {

        if (!missing(url)) self$url <- url
        self$cli <- crul:::HttpClient$new(
          url = self$url,
          opts = list(...),
          headers = headers
        )
        self$opts <- self$cli$opts
        if (!missing(version)) self$version <- version
        if (!missing(content_type)) self$content_type <- content_type
        self$cli$headers <- c(
          self$cli$headers,
          list(`Content-Type` = self$content_type)
        )
      },

      status = function(...) {
        stat <- self$cli$head(self$version, ...)$status_http()
        sprintf("%s (%s)", stat$message, stat$status_code)
      },

      routes = function(...) {
        private$fromjson(
          self$cli$get(self$version, ...)$parse(encoding = "UTF-8"),
          "text", encoding = "UTF-8")
      },

      route = function(endpt, query = NULL, include = NULL,
                       error_handler = private$check, ...) {
        query <- comp(c(query, list(include = include)))
        tmp <- self$cli$get(file.path(self$version, endpt), query = query, ...)
        error_handler(tmp)
        private$fromjson(tmp$parse(encoding = "UTF-8"))
      },

      base_url = function() self$url
    ),

    private = list(
      fromjson = function(...) jsonlite::fromJSON(...),

      check = function(x, ...) {
        if (x$status_code > 300) {
          if (grepl("application/vnd.api\\+json", x$response_headers$`content-type`)) {
            self$fromjson(x$parse(encoding = "UTF-8"))
          } else {
            stop(x$parse(encoding = "UTF-8"), call. = FALSE)
          }
        }
      }
    ),

    cloneable = FALSE
)
