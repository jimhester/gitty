
make_my_error_handler <- function() {

  function() {
    git_msg_pattern <- "^Error: unexpected symbol in \"git"
    msg <- geterrmessage()
    
    ## It is a git call from the console directly, run it
    ## It is already in the history, so just call 'git' to get it and run it
    if (grepl(git_msg_pattern, msg) && length(sys.calls()) == 1) {
      git
      
    } else {
      stop(msg)
    }
  }
}
