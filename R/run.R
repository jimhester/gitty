
## This is called when 'git' is evaluated
## If this is the whole command line, without any comments
## after it, then we take the previous command, and if it is a git
## command, then we run it.
##
## If it has some comments, then we run the current line.

gitfunction <- function() {

  ## Do not run this from the tab-complete
  if (!is.na(find_parent(quote(custom.completer)))) return()

  hist <- get_history_tail(3)

  echo <- FALSE

  ## Just a 'git' command to re-run the previous one
  last <- tail(hist, 1)
  penultimate <- head(tail(hist, 2), 1)

  cmdline <- if (length(hist) >= 2 && grepl("^\\s*git\\s*$", last) &&
      grepl("^\\s*git\\s+#?", penultimate)) {
    echo <- TRUE
    penultimate
  } else if (length(hist) >= 1 && grepl("^\\s*git\\s+#?", last)) {
    last
  }

  if (!is.null(cmdline)) {
    cmdline <- drop_comment_char(cmdline)
    if (echo) echo_command(cmdline)
    system(cmdline)
    invisible(TRUE)

  } else {
    invisible(FALSE)
  }
}
