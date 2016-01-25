#' Connection
#'
#' @keywords internal
#' @param url Base url, e.g., \code{http://localhost:8080}
#' @param version API version, e.g, \code{v1}
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples
#' library("httr")
#' (conn <- connect("http://localhost:8088"))
#' conn$route(endpt = "authors")
# js_get <- function(endpt, ...) {
#   .jsapi_c$route(endpt, ...)
# }

