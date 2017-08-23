
#' Run git Commands from the R Console
#'
#' For heavy R and git users, it is annoying to switch back and forth
#' between the R and git consoles. This package allows running git
#' commands directly form R, with ease.
#'
#' @docType package
#' @name gitty
NULL

#' @export

git <- ""

old_opts <- NULL

#' @importFrom utils packageName rc.options

.onLoad <- function(libname, pkgname) {
  if (interactive()) {
    rm(list = "git", envir = asNamespace(packageName()))
    if (check_for_support()) {
      ## Active binding for git
      makeActiveBinding("git", gitfunction, asNamespace(packageName()))

      ## TAB completion
      completeme::register_completion(gitty = my_completer)

      ## Error handler
      old_opts <<- options(
        error = structure(make_my_error_handler(), gitty = TRUE)
      )
    }
  }
}

.onUnload <- function(libpath) {
  if (!is.null(old_opts)) {
    if (isTRUE(attr(getOption("error"), "gitty"))) {
      options(error = old_opts$error)
    }
  }
}

check_for_support <- function() {

  if (Sys.getenv("RSTUDIO") == 1 ||
      Sys.getenv("R_GUI_APP_VERSION") != "" &&
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
