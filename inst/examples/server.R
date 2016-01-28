#* @get /books
get_books <- function(book){
  dat <- jsonlite::fromJSON("books.json", FALSE)
  if (!missing(book)) {
    dat <- dat[vapply(dat, "[[", "", "id") == as.character(book)]
  }
  list(meta = list(total = length(dat)), data = dat, errors = list())
}
