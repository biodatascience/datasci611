context("Testing Addition and subtraction functions")

test_that("numeric addition happens", {
  expect(addition(1,5) == 6)
  expect_false(addition(1,5) == 4)
  expect_error(addition(1,'a'))
})

test_that("numeric subtraction happens", {
  expect(subtraction(5,1) == 4)
  expect_false(subtraction(1,5) == 4)
  expect_error(subtraction(1,'a'))
})

