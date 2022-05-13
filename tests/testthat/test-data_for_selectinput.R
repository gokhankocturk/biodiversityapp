test_that("Check missing values for selectInput object", {
  expect_equal(data_for_selectinput(occurence, vernacular = "Ringlet", scientific = "Vipera berus"), TRUE)
  expect_equal(data_for_selectinput(occurence, vernacular = "Irrelevant Name", scientific = "Vipera berus"), TRUE)
  expect_equal(data_for_selectinput(occurence, vernacular = "Ringlet", scientific = "Irrelevant Name"), TRUE)
  expect_equal(data_for_selectinput(occurence, vernacular = "Irrelevant Name", scientific = "Irrelevant Name"), FALSE)

})
