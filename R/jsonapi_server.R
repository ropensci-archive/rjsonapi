#' Start a JSONAPI server
#'
#' @export
#' @param port (integer) the port to run the server on. default: 8000
#'
#' @details Right now, this function doesn't take arbitrary input, but
#' instead serves the same content as this JSON API example
#' \url{https://github.com/endpoints/endpoints-example}. Note that not all
#' features are the same as the full \code{endpoints-example}, but most
#' should work.
#'
#' Right now, this function serves data from static, minified JSON files,
#' so there's no dynamic database underneath.
#'
#' Kill the server by CTRL+C, ESC or similar.
#'
#' @examples \dontrun{
#' if (interactive()) {
#'   # start a server in another R session
#'   jsonapi_server()
#'
#'   # Back in this session ...
#'   # Connect
#'   (conn <- jsonapi_connect("http://localhost:8000"))
#'
#'   # Get data
#'   conn$url
#'   conn$version
#'   conn$content_type
#'   conn$routes()
#'   conn$route("authors")
#'   conn$route("chapters")
#'   conn$route("authors/1")
#'   conn$route("authors/1/books")
#'   conn$route("chapters/5")
#' }
#' }
jsonapi_server <- function(port = 8000) {
  r <- plumber::plumb(system.file("examples", "server.R",
                                  package = "rjsonapi"))
  r$run(port = port)
}
