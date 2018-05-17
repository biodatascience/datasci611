context("Addition")

test_that("numeric addition happens", {
  expect(addition(1,5) == 6)
  expect_false(addition(1,5) == 4)
  expect_error(addition(1,'a'))
})


