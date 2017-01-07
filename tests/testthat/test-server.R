context("jsonapi_server")

test_that("jsonapi_connect to a jsonapi - local", {
  expect_is(jsonapi_server, "function")
  expect_true(any(grepl("plumber", deparse(jsonapi_server))))
})
