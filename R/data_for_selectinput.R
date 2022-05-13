data_for_selectinput <- function(data, vernacular, scientific) {
  vernacular <- unique(filter_at(data,
                                 vars(vernacularName, scientificName),
                                 any_vars(str_detect(., regex(vernacular, ignore_case = T))))$vernacularName)

  vernacular <- vernacular[!is.na(vernacular)]

  scientific <- unique(filter_at(data,
                                 vars(vernacularName, scientificName),
                                 any_vars(str_detect(., regex(scientific, ignore_case = T))))$scientificName)

  scientific <- scientific[!is.na(scientific)]

  if((length(vernacular) + length(scientific)) == 0) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}
