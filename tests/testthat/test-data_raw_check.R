test_that("Raw data check", {

  # Here we check specific columns we need for the APP.
  # For mapping : Longitude and Latitude columns should not have any missing values
  # For infoBox : Every observation should belong to a city in Poland
  # For infoBox : Every observation should have at least 1 individual counted
  expect_equal(data_raw_check(occurence, "LON", "LAT", "town","individualCount"), 0)
})
