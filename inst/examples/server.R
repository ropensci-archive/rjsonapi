#* @get /v1/?
v1 <- function(){
  lapply(jsonlite::fromJSON("v1.json", FALSE), jsonlite::unbox)
}



#* @get /v1/authors/?
authors <- function(){
  jsonlite::fromJSON("authors.json", FALSE)
}

#* @get /v1/authors/<author:int>/?
author <- function(author){
  # jsonlite::fromJSON(sprintf("authors%s.json", author), FALSE)
  res <- jsonlite::fromJSON("authors.json", FALSE)
  list(data = res$data[vapply(res$data, "[[", "", "id") == as.character(author)])
}

#* @get /v1/authors/<author:int>/books/?
author_book <- function(author){
  jsonlite::fromJSON(sprintf("authors_%s_books.json", author), FALSE)
}



#* @get /v1/books/?
books <- function(){
  jsonlite::fromJSON("books.json", FALSE)
}

#* @get /v1/books/<book:int>?
book <- function(book){
  res <- jsonlite::fromJSON("books.json", FALSE)
  list(data = res$data[vapply(res$data, "[[", "", "id") == as.character(book)])
}



#* @get /v1/chapters/?
chapters <- function(){
  jsonlite::fromJSON("chapters.json", FALSE)
}

#* @get /v1/chapters/<chapter:int>?
chapter <- function(chapter){
  res <- jsonlite::fromJSON("chapters.json", FALSE)
  list(data = res$data[vapply(res$data, "[[", "", "id") == as.character(chapter)])
}


#* @get /v1/photos/?
photos <- function(){
  jsonlite::fromJSON("photos.json", FALSE)
}

#* @get /v1/photos/<photo:int>?
photo <- function(photo){
  res <- jsonlite::fromJSON("photos.json", FALSE)
  list(data = res$data[vapply(res$data, "[[", "", "id") == as.character(photo)])
}



#* @get /v1/series/?
series <- function(){
  jsonlite::fromJSON("series.json", FALSE)
}

#* @get /v1/series/<ser:int>?
series <- function(ser){
  res <- jsonlite::fromJSON("series.json", FALSE)
  list(data = res$data[vapply(res$data, "[[", "", "id") == as.character(ser)])
}



#* @get /v1/stores/?
stores <- function(){
  jsonlite::fromJSON("stores.json", FALSE)
}

#* @get /v1/stores/<store:int>?
store <- function(store){
  res <- jsonlite::fromJSON("stores.json", FALSE)
  list(data = res$data[vapply(res$data, "[[", "", "id") == as.character(store)])
}
