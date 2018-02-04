#' JSON API Model and Serializer
#' 
#' @export
#' @param ... named parameters
#' @param model an object of class `japi_model`
#' @param type the type
#' @param attributes attributes
#' @param has_many variables that are many
#' @param belongs_to belongs to type
#' @examples
#' mod <- japi("id", "name", "year", "actor_ids", 
#'   "owner_id", "movie_type_id")
#' mod
#' 
#' # assign values
#' mod$id = 232
#' mod$name = 'test movie'
#' mod$actor_ids = 1:3
#' mod$movie_type_id = 1
#' mod
#' 
#' # put into json api serializer
#' x <- JApiSerializer$new(
#'   model = mod,
#'   type  = "movie",
#'   attributes = c('name', 'year'),
#'   has_many = "actors",
#'   belongs_to = "movie_type"
#'  )
#' x$model
#' x$attributes
#' x$json_api_model
#' x$serialized_json()
#' x$serialized_json(pretty = TRUE)
japi_model <- function(...) {
  nms <- list(...)
  model_names <- unlist(nms)
  args <- as.list(stats::setNames(rep(NA, length(nms)), model_names))
  args$model_names <- model_names
  R6::R6Class(
    "japi_model",
    portable = FALSE,
    lock_objects = TRUE,
    public = args
  )$new()
}

#' @export
#' @rdname japi_model
japi_serializer <- R6::R6Class(
  "japi_serializer",
  public = list(
    model = NULL,
    type = NULL, 
    attributes = NULL, 
    has_many = NULL, 
    belongs_to = NULL,
    json_api_model = NULL,

    initialize = function(model, type = NULL, attributes = NULL, 
      has_many = NULL, belongs_to = NULL) {

      if (!inherits(model, "japi_model")) {
        stop("'model' must be of class 'japi_model'")
      }
      self$model <- model
      self$type <- type
      self$attributes <- attributes
      self$has_many <- has_many
      self$belongs_to <- belongs_to

      # build json api data model
      self$json_api_model <- list(
        data = list(
          id = self$model$id,
          type = self$type,
          attributes = stats::setNames(
            lapply(self$attributes, function(z) self$model[[z]]),
            self$attributes
          )
        )
      )

      if (!is.null(self$has_many)) { 
        self$json_api_model$data$relationships <- list()
        sing <- hunspell::hunspell_stem(self$has_many)[[1]]
        toget <- grep(sing, self$model$model_names, value = TRUE)
        dat <- Map(function(z) list(id = z, type = sing), self$model[[toget]])
        self$json_api_model$data$relationships <- 
          stats::setNames(list(list(data = dat)), self$has_many)
      }
    },

    serialized_json = function(...) {
      jsonlite::toJSON(self$json_api_model, ..., auto_unbox = TRUE)
    }
  )
)

# Rs <- R6::R6Class(
#   "Rs",
#   portable = FALSE,
#   lock_objects = FALSE,
#   public = list(
#     x = NULL,
#     initialize = function(...) {
#       args <- list(...)
#       self
#     },
#     getx = function() self$x,
#     setx = function(value) self$x <<- value
#   )
# )

# JsonAPIModel <- R6::R6Class(
#   "JsonAPIModel",
#   public = list(
#     x = NULL,

#     getx = function() self$x,
#     setx = function(value) self$x <<- value
#   )
# )
