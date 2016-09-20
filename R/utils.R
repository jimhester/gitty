
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
