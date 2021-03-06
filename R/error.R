
make_my_error_handler <- function() {

  function() {
    git_msg_pattern <- "^Error: unexpected symbol in \"git"
    msg <- geterrmessage()

    ## It is a git call from the console directly, run it
    ## It is already in the history, so just call 'git' to get it and run it
    if (grepl(git_msg_pattern, msg)) {

      num_lines <- length(strsplit(msg, "\n", fixed = TRUE)[[1]])
      erase_lines(num_lines)
      git

    } else {
      FALSE
    }
  }
}
