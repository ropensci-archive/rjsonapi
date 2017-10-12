context("jsonapi_connect")

cn <- jsonapi_connect(url = "http://localhost:8088")

test_that("jsonapi_connect to a jsonapi - local", {
  skip_on_cran()
  expect_is(cn, "jsonapi_connection")
  expect_is(cn, "R6")
  expect_equal(cn$base_url(), "http://localhost:8088")
  expect_null(cn$endpt)
  expect_equal(cn$content_type, "application/vnd.api+json")
  expect_equal(cn$version, "v1")
})

test_that("private methods are actually private", {
  skip_on_cran()
  expect_null(cn$fromjson)
  expect_null(cn$check)
})

test_that("status method is as expected", {
  skip_on_cran()
  skip_on_travis()
  if (identical(Sys.getenv("TRAVIS"), "true")) {
    expect_equal(cn$status(), "OK (200)")
  }
})

test_that("routes method is as expected", {
  skip_on_cran()
  skip_on_travis()
  if (identical(Sys.getenv("TRAVIS"), "true")) {
    aa <- cn$routes()

    expect_is(aa, "list")
    expect_named(aa, c('authors','books','chapters','photos','series','stores'))
    expect_equal(length(aa), 6)
    expect_equal(length(aa$authors), 1)
  }
})

test_that("route method is as expected", {
  skip_on_cran()
  skip_on_travis()
  if (identical(Sys.getenv("TRAVIS"), "true")) {
    expect_error(cn$route(), "\"endpt\" is missing")

    aa <- cn$route("authors")

    expect_is(aa, "list")
    expect_named(aa, 'data')
    expect_equal(length(aa), 1)
    expect_equal(NROW(aa$data), 2)
    expect_named(aa$data, c('id','type','attributes','relationships','links'))
  }
})

test_that("include parameter works", {
  skip_on_cran()
  skip_on_travis()
  if (identical(Sys.getenv("TRAVIS"), "true")) {
    aa <- cn$route("authors/1")
    bb <- cn$route("authors/1", include = "books")

    expect_is(aa, "list")
    expect_is(bb, "list")

    expect_named(aa, "data")
    expect_named(bb, c("data", "included"))

    expect_is(bb$included, "data.frame")
  }
})
