rjsonapi
========



[![Build Status](https://travis-ci.org/ropensci/rjsonapi.svg?branch=master)](https://travis-ci.org/ropensci/rjsonapi)
[![codecov.io](https://codecov.io/github/ropensci/rjsonapi/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rjsonapi?branch=master)
[![cran version](http://www.r-pkg.org/badges/version/rjsonapi)](https://cran.r-project.org/package=rjsonapi)

An R client for consuming APIs that follow the [JSONAPI spec][spec]. This library
does not do server side JSONAPI things.

* rjsonapi home: <http://jsonapi.org/>
* rjsonapi spec: <http://jsonapi.org/format/>

## Setup a JSONAPI

* `git clone git@github.com:endpoints/endpoints-example.git` (or via `hub`: `hub clone endpoints/endpoints-example`)
* `cd endpoints-example`
* `npm install`
* `PORT=8088 npm start` (start with port 8088 instead of 8080, can use a different port) - OR, `npm install forever`, then `PORT=8088 forever start -c "npm start" '.'`

Which starts a server. Then point your browser to e.g.:

* http://localhost:8088/v1
* http://localhost:8088/v1/authors
* http://localhost:8088/v1/authors/1

## Install rjsonapi R client

Stabler version


```r
install.packages("rjsonapi")
```

Dev version


```r
devtools::install_github("ropensci/rjsonapi")
```


```r
library("rjsonapi")
```

## Connect


```r
(conn <- jsonapi_connect("http://localhost:8088", "v1"))
#> <jsonapi_connection>
#>   Public:
#>     base_url: function () 
#>     cli: HttpClient, R6
#>     content_type: application/vnd.api+json
#>     headers: NULL
#>     initialize: function (url, version, content_type, headers = list(), ...) 
#>     opts: list
#>     route: function (endpt, query = NULL, include = NULL, error_handler = private$check, 
#>     routes: function (...) 
#>     status: function (...) 
#>     url: http://localhost:8088
#>     version: v1
#>   Private:
#>     check: function (x, ...) 
#>     fromjson: function (...)
```

## Get API info

Get version


```r
conn$version
#> [1] "v1"
```

Get base URL


```r
conn$base_url()
#> [1] "http://localhost:8088"
```

Get server status


```r
conn$status()
#> [1] "OK (200)"
```

Get routes (not available in a standard JSONAPI i think)


```r
conn$routes()
#> $authors
#> [1] "/v1/authors?include={books,books.chapters,photos}&filter[{id,name,alive,dead,date_of_birth,date_of_death,born_before,born_after}]"
#> 
#> $books
#> [1] "/v1/books?include={chapters,firstChapter,series,author,stores,photos}&filter[{author_id,series_id,date_published,published_before,published_after,title}]"
#> 
#> $chapters
#> [1] "/v1/chapters?include={book}&filter[{book_id,title,ordering}]"
#> 
#> $photos
#> [1] "/v1/photos?include={imageable}"
#> 
#> $series
#> [1] "/v1/series?include={books,photos}&filter[{title}]"
#> 
#> $stores
#> [1] "/v1/stores?include={books,books.author}"
```

## Call a route

books route


```r
conn$route("authors")
#> $data
#>   id    type  attributes.name attributes.date_of_birth
#> 1  1 authors J. R. R. Tolkien               1892-01-03
#> 2  2 authors    J. K. Rowling               1965-07-31
#>   attributes.date_of_death attributes.created_at attributes.updated_at
#> 1               1973-09-02   2017-08-24 22:44:53   2017-08-24 22:44:53
#> 2                     <NA>   2017-08-24 22:44:53   2017-08-24 22:44:53
#>      relationships.books.links.self relationships.books.links.related
#> 1 /v1/authors/1/relationships/books               /v1/authors/1/books
#> 2 /v1/authors/2/relationships/books               /v1/authors/2/books
#>      relationships.photos.links.self relationships.photos.links.related
#> 1 /v1/authors/1/relationships/photos               /v1/authors/1/photos
#> 2 /v1/authors/2/relationships/photos               /v1/authors/2/photos
#>            self
#> 1 /v1/authors/1
#> 2 /v1/authors/2
```

## Get a single document

First authors document


```r
conn$route("authors/1")
#> $data
#> $data$id
#> [1] "1"
#> 
#> $data$type
#> [1] "authors"
#> 
#> $data$attributes
#> $data$attributes$name
#> [1] "J. R. R. Tolkien"
#> 
#> $data$attributes$date_of_birth
#> [1] "1892-01-03"
#> 
#> $data$attributes$date_of_death
#> [1] "1973-09-02"
#> 
#> $data$attributes$created_at
#> [1] "2017-08-24 22:44:53"
#> 
#> $data$attributes$updated_at
#> [1] "2017-08-24 22:44:53"
#> 
#> 
#> $data$relationships
#> $data$relationships$books
#> $data$relationships$books$links
#> $data$relationships$books$links$self
#> [1] "/v1/authors/1/relationships/books"
#> 
#> $data$relationships$books$links$related
#> [1] "/v1/authors/1/books"
#> 
#> 
#> 
#> $data$relationships$photos
#> $data$relationships$photos$links
#> $data$relationships$photos$links$self
#> [1] "/v1/authors/1/relationships/photos"
#> 
#> $data$relationships$photos$links$related
#> [1] "/v1/authors/1/photos"
#> 
#> 
#> 
#> 
#> $data$links
#> $data$links$self
#> [1] "/v1/authors/1"
```

Sub-part under that document: `books`


```r
conn$route("authors/1/books")
#> $data
#>   id  type attributes.date_published           attributes.title
#> 1  1 books                1954-07-29 The Fellowship of the Ring
#> 2  2 books                1954-11-11             The Two Towers
#> 3  3 books                1955-10-20         Return of the King
#> 4 11 books                1937-09-21                 The Hobbit
#>   attributes.created_at attributes.updated_at
#> 1   2017-08-24 22:44:53   2017-08-24 22:44:53
#> 2   2017-08-24 22:44:53   2017-08-24 22:44:53
#> 3   2017-08-24 22:44:53   2017-08-24 22:44:53
#> 4   2017-08-24 22:44:53   2017-08-24 22:44:53
#>       relationships.chapters.links.self
#> 1  /v1/authors/1/relationships/chapters
#> 2  /v1/authors/2/relationships/chapters
#> 3  /v1/authors/3/relationships/chapters
#> 4 /v1/authors/11/relationships/chapters
#>   relationships.chapters.links.related
#> 1               /v1/authors/1/chapters
#> 2               /v1/authors/2/chapters
#> 3               /v1/authors/3/chapters
#> 4              /v1/authors/11/chapters
#>       relationships.firstChapter.links.self
#> 1  /v1/authors/1/relationships/firstChapter
#> 2  /v1/authors/2/relationships/firstChapter
#> 3  /v1/authors/3/relationships/firstChapter
#> 4 /v1/authors/11/relationships/firstChapter
#>   relationships.firstChapter.links.related
#> 1               /v1/authors/1/firstChapter
#> 2               /v1/authors/2/firstChapter
#> 3               /v1/authors/3/firstChapter
#> 4              /v1/authors/11/firstChapter
#>       relationships.series.links.self relationships.series.links.related
#> 1  /v1/authors/1/relationships/series               /v1/authors/1/series
#> 2  /v1/authors/2/relationships/series               /v1/authors/2/series
#> 3  /v1/authors/3/relationships/series               /v1/authors/3/series
#> 4 /v1/authors/11/relationships/series              /v1/authors/11/series
#>   relationships.series.data.id relationships.series.data.type
#> 1                            1                         series
#> 2                            1                         series
#> 3                            1                         series
#> 4                         <NA>                           <NA>
#>       relationships.author.links.self relationships.author.links.related
#> 1  /v1/authors/1/relationships/author               /v1/authors/1/author
#> 2  /v1/authors/2/relationships/author               /v1/authors/2/author
#> 3  /v1/authors/3/relationships/author               /v1/authors/3/author
#> 4 /v1/authors/11/relationships/author              /v1/authors/11/author
#>   relationships.author.data.id relationships.author.data.type
#> 1                            1                        authors
#> 2                            1                        authors
#> 3                            1                        authors
#> 4                            1                        authors
#>       relationships.stores.links.self relationships.stores.links.related
#> 1  /v1/authors/1/relationships/stores               /v1/authors/1/stores
#> 2  /v1/authors/2/relationships/stores               /v1/authors/2/stores
#> 3  /v1/authors/3/relationships/stores               /v1/authors/3/stores
#> 4 /v1/authors/11/relationships/stores              /v1/authors/11/stores
#>       relationships.photos.links.self relationships.photos.links.related
#> 1  /v1/authors/1/relationships/photos               /v1/authors/1/photos
#> 2  /v1/authors/2/relationships/photos               /v1/authors/2/photos
#> 3  /v1/authors/3/relationships/photos               /v1/authors/3/photos
#> 4 /v1/authors/11/relationships/photos              /v1/authors/11/photos
#>             self
#> 1  /v1/authors/1
#> 2  /v1/authors/2
#> 3  /v1/authors/3
#> 4 /v1/authors/11
```

A different sub-part under that document: `photos`


```r
conn$route("authors/1/photos")
#> $data
#>   id   type attributes.imageable_id attributes.imageable_type
#> 1  1 photos                       1                   authors
#> 2  2 photos                       1                   authors
#>                      attributes.title
#> 1                    J. R. R. Tolkein
#> 2 Family Postcard of J. R. R. Tolkein
#>                                                                         attributes.uri
#> 1                  http://upload.wikimedia.org/wikipedia/commons/b/b4/Tolkien_1916.jpg
#> 2 http://upload.wikimedia.org/wikipedia/commons/5/5b/Mabel_Suffield_Christmas_Card.jpg
#>   attributes.created_at attributes.updated_at
#> 1   2017-08-24 22:44:52   2017-08-24 22:44:52
#> 2   2017-08-24 22:44:52   2017-08-24 22:44:52
#>      relationships.imageable.links.self
#> 1 /v1/authors/1/relationships/imageable
#> 2 /v1/authors/2/relationships/imageable
#>   relationships.imageable.links.related          self
#> 1               /v1/authors/1/imageable /v1/authors/1
#> 2               /v1/authors/2/imageable /v1/authors/2
```

## Experimental - startup a server from R

In one R session:


```r
jsonapi_server()
#> Starting server to listen on port 8000
```

Then in another R session:

Connect to the server:


```r
(conn <- jsonapi_connect("http://localhost:8000"))
```

Get routes


```r
conn$routes()
```

Get chapters


```r
conn$route("chapters")
```

Note: This server stuff is still in infancy. Working on getting a more complete set
of routes and data.

Right now, `jsonapi_server()` only loads data that comes with this package - in the
future it will support your own data.

[spec]: http://jsonapi.org/format/

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rjsonapi/issues).
* License: MIT
* Get citation information for `rjsonapi` in R doing `citation(package = 'rjsonapi')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
