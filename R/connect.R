#' Connection
#'
#' @importFrom httr GET HEAD http_status content content_type verbose
#' @importFrom jsonlite fromJSON
#' @importFrom R6 R6Class
#' @export
#' @param url Base url, e.g., \code{http://localhost:8080}
#' @param version API version, e.g, \code{v1}
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples
#' library("httr")
#' conn <- connect()
#' conn
#' conn$url
#' conn$version
#' conn$content_type
#' conn$status()
#' conn$status(config = verbose())
#' conn$routes()
#' conn$routes(config = verbose())

connect <- function(url, version, ...) {
  .jsonapi_connect$new(url, version, ...)
}

.jsonapi_connect <-
  R6::R6Class("jsonapi_connection",
    public = list(
      url = "http://localhost:8080",
      version = "v1",
      content_type = httr::content_type("application/vnd.api+json"),
      initialize = function(url, version, content_type) {
        if (!missing(url)) self$url <- url
        if (!missing(version)) self$version <- version
        if (!missing(content_type)) self$content_type <- content_type
      },
      status = function(...) {
        httr::http_status(httr::HEAD(self$base_url(), self$content_type, ...))$message
      },
      routes = function(...) {
        self$fromjson(httr::content(httr::GET(self$base_url(), self$content_type, ...), "text"))
      },
      base_url = function(...) {
        paste0(self$url, self$version)
      },
      fromjson = function(...) {
        jsonlite::fromJSON(...)
      }
    ),
    cloneable = FALSE
)

# conn <- connect$new()
# conn
# conn$url
# conn$version
# conn$content_type
# conn$status()
# conn$status(config = verbose())
# conn$routes()
# conn$routes(config = verbose())
