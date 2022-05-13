test_that("Check data for map", {
  expect_equal(data_for_map(occurence, "Grus grus"), TRUE)          # scientific name entry
  expect_equal(data_for_map(occurence, "Hooded Crow"), TRUE)        # vernacular name entry
  expect_equal(data_for_map(occurence, "grus"), TRUE)               # some part of the name entry
  expect_equal(data_for_map(occurence, "Irrelevant Name"), FALSE)   # irrelevant name entry
})
