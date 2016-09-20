
can_move_cursor <- function() {
  if (!interactive()) {
    FALSE
  } else {
    cmd <- "(tput cuu1 && tput cud1) > /dev/null 2> /dev/null"
    suppressWarnings(try(system(cmd), silent = TRUE)) == 0
  }
}

terminal_width <- function() {
  as.numeric(system("tput cols", intern = TRUE))
}

cursor_up <- function(num) {
  cat("\033[", num, "A", sep = "")
}

erase_lines <- function(num) {
  if (num <= 0 || ! can_move_cursor()) return()
  tw <- terminal_width()
  spaces <- make_spaces(tw)
  cursor_up(num)
  for (i in seq_len(num)) cat("\r", spaces)
  cursor_up(num)
  cat("\r")
}

make_spaces <- function(n) {
  paste(rep(" ", n), collapse = "")
}
