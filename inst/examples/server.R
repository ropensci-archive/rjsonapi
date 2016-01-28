#* @get /books
get_books <- function(){
  dat <- jsonlite::fromJSON("books.json", FALSE)
  list(meta = list(total = length(dat)), data = dat, errors = list())
}

#* @get /books/<book:int>
get_books <- function(book){
  dat <- jsonlite::fromJSON("books.json", FALSE)
  dat <- dat[vapply(dat, "[[", "", "id") == as.character(book)]
  list(meta = list(total = length(dat)), data = dat, errors = list())
}
