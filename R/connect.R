#' Connection
#'
#' @export
#' @param url Base url, e.g., \code{http://localhost:8080}
#' @param version API version, e.g, \code{v1}
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples
#' library("httr")
#' (conn <- connect("http://localhost:8088"))
#' conn$url
#' conn$version
#' conn$content_type
#' conn$status()
#' conn$status(config = verbose())
#' conn$routes()
#' conn$routes(config = verbose())
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
#' ## errors
#' ### route doesn't exist
#' conn$route("foobar")
#'
#' ### document doesn't exist
#' conn$route("authors/56")

connect <- function(url, version, endpt, ...) {
  .jsapi_c$new(url, version, endpt, ...)
}

.jsapi_c <-
  R6::R6Class("jsonapi_connection",
    public = list(
      url = "http://localhost:8080",
      version = "v1",
      content_type = httr::content_type("application/vnd.api+json"),
      endpt = "",
      initialize = function(url, version, content_type, endpt) {
        if (!missing(url)) self$url <- url
        if (!missing(version)) self$version <- version
        if (!missing(content_type)) self$content_type <- content_type
        if (!missing(endpt)) self$endpt <- endpt
      },
      status = function(...) {
        httr::http_status(httr::HEAD(self$base_url(), self$content_type, ...))$message
      },
      routes = function(...) {
        self$fromjson(httr::content(httr::GET(self$base_url(), self$content_type, ...), "text"))
      },
      route = function(endpt, include = NULL, error_handler = self$check, ...) {
        query <- comp(list(include = include))
        tmp <- httr::GET(file.path(self$base_url(), endpt), self$content_type, query = query, ...)
        error_handler(tmp)
        self$fromjson(httr::content(tmp, "text"))
      },
      base_url = function(...) {
        file.path(self$url, self$version)
      },
      fromjson = function(...) {
        jsonlite::fromJSON(...)
      },
      check = function(x, ...) {
        if (x$status_code > 300) {
          if (grepl("application/vnd.api\\+json", x$headers$`content-type`)) {
            self$fromjson(content(x, "text"))
          } else {
            stop(content(x, "text"), call. = FALSE)
          }
        }
      }
    ),
    cloneable = FALSE
)
