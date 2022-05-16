.onAttach <- function(libname, pkgname) {
  shiny::addResourcePath('R',
                         system.file('www',
                                     package = 'biodiversityapp'))
}
