
#' Run git Commands from the R Console
#'
#' For heavy R and git users, it is annoying to switch back and forth
#' between the R and git consoles. This package allows running git
#' commands directly form R, with ease.
#'
#' @docType package
#' @name gitty
NULL

git <- ""

#' @importFrom utils packageName rc.options

.onLoad <- function(libname, pkgname) {
  if (interactive()) {
    if (check_for_support()) {
      rm(list = "git", envir = asNamespace(packageName()))
      makeActiveBinding("git", gitfunction, asNamespace(packageName()))
      rc.options(custom.completer = my_completer)
    }
  }
}

check_for_support <- function() {

  if (Sys.getenv("RSTUDIO") == 1 ||
      identical(getOption("STERM"), "iESS") ||
      Sys.getenv("EMACS") == "t") {

    warning(
      "gitty does not support your platform or GUI, sorry\n",
      "complain about it here: https://github.com/gaborcsardi/gitty/issues"
    )
    FALSE

  } else {
    TRUE
  }
}
