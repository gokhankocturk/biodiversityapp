data_raw_check <- function(data, longitude, latitude, city, count) {
  lon <- is.na(data[longitude])
  sum_lon <- sum(lon)

  lat <- is.na(data[latitude])
  sum_lat <- sum(lat)

  town <- is.na(data[city])
  sum_town <- sum(town)

  total <- is.na(data[count])
  sum_total <- sum(total)
  return(sum_lon + sum_lat + sum_town + sum_total)
}
