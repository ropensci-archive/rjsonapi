context("rjsonapi::connect functionality")

test_that("connect to a jsonapi works", {
  skip_on_cran()

  cn <- connect("https://api.labs.datacite.org")

  expect_is(cn, "jsonapi_connection")
  expect_is(cn, "R6")
  expect_equal(cn$base_url(), "https://api.labs.datacite.org")
  expect_equal(cn$endpt, "")
  expect_equal(cn$content_type$headers[[1]], "application/vnd.api+json")
})

test_that("private methods are actually private", {
  skip_on_cran()

  cn <- connect("https://api.labs.datacite.org")

  expect_null(cn$fromjson)
  expect_null(cn$check)
})

test_that("structure of output is as expected", {
  skip_on_cran()

  cn <- connect("https://api.labs.datacite.org")
  aa <- cn$route("works")

  expect_is(aa, "list")
  expect_is(aa$meta, "list")
  expect_named(aa, c('data', 'meta'))
  expect_type(aa$meta$total, "integer")
  expect_is(aa$data, "data.frame")
})

test_that("query parameters work", {
  skip_on_cran()

  cn <- connect("https://api.datacite.org")
  aa <- cn$route("works", query = list(query = "renear"))

  expect_is(aa, "list")
  expect_is(aa$meta, "list")
  expect_named(aa, c('data', 'meta'))
  expect_is(aa$meta$years, "list")
  expect_named(aa$meta$publishers, c('cdl.culis'))
  expect_is(aa$data, "data.frame")
  expect_true(any(grepl("renear", aa$data$attributes$author[[1]]$family, ignore.case = TRUE)))
})
