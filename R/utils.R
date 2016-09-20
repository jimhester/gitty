
get_history_tail <- function(n) {
  savehistory(tmp <- tempfile())
  on.exit(unlink(tmp))
  tail(readLines(tmp), n)
}

drop_comment_char <- function(x) {
  sub("^(\\s*git\\s+)#?", "\\1", x)
}

echo_command <- function(x) {
  ## Current prompt, can be multiple lines, take the last
  pr <- tail(strsplit(getOption("prompt"), "\n")[[1]], 1)
  cat(pr, x, "\n", sep = "")
}

find_parent <- function(name, pkg = NULL) {
  if (!is.null(pkg)) name <- call("::", pkg, name)
  calls <- sys.calls()
  for (i in seq_along(calls)) {
    if (identical(calls[[i]][[1]], name)) return(i)
  }
  NA_integer_
}
