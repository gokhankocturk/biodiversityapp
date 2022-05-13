data_for_map <- function(data, keyword) {
  check_vernacular <- unique(filter_at(data,
                         vars(vernacularName, scientificName),
                         any_vars(str_detect(., regex(keyword, ignore_case = T))))$vernacularName)

  check_scientific <- unique(filter_at(data,
                                       vars(vernacularName, scientificName),
                                       any_vars(str_detect(., regex(keyword, ignore_case = T))))$scientificName)

  if(length(check_vernacular) + length(check_scientific) > 0){
    return(TRUE)
  }
  else {
    return(FALSE)
  }
}
