
my_completer <- function(e) {
  buffer <- e$linebuffer
  if (grepl("^git ", buffer)) {
    return(tryCatch(
      git_completer(e),
      error = function(e) NULL
    ))
  }
}

#' This is called when a "git " command line is being TAB-completed
#'
#' Current contents of the rcompgen environment:
#' * `attached_packages` this is always empty for me
#' * `comps` the completions should be put in here
#' * `end` position after the word being completed, 0-indexed
#' * `fguess` special function we are inside of, e.g. `library`
#'      it does not happen for use here.
#' * `fileName` `TRUE`/`FALSE`, whether we are completing a filename should
#'      be put in here.
#' * `help_topics` empty for our purposes
#' * `isFirstArg` whether we are completing the first argument. Might not
#'      be relevant for us.
#' * `linebuffer` The complete line buffer
#' * `options` `rc.options()`
#' * `settings` `rc.settings()`
#' * `start` start position of the word being completed, 0-indexed
#' * `token`
#'
#' @param env `rcompgen` environment
#' @return The potentially modified `rcompgen` environment.
#'
#' @keywords internal

git_completer <- function(env) {
  line <- env$linebuffer

  cline <- drop_comment_char(line)
  position <- env$end + 1L - (nchar(cline) - nchar(line))
  comps <- git_bash_completer(cline, position)
  if (length(comps) > 1) comps else warn_for_no_hash(line, comps)

  comps
}

warn_for_no_hash <- function(line, comps) {
  ## Turn this off, it is annoying...
  ## if (grepl("^\\s*git\\s+($|[^#])", line)) {
  ##   comps <- paste0(comps, "#!")
  ## }
  comps
}

#' @importFrom whisker whisker.render
#' @importFrom utils packageName

git_bash_completer <- function(line, position) {

  ## Get the template script
  sh_file <- system.file(package = packageName(), "git-complete.sh")
  template <- readLines(sh_file)

  ## Set its parameters
  comp_file <- system.file(package = packageName(), "git-completion.bash")
  comp_file <- normalizePath(comp_file)

  ## scan() is better than strsplit, because it considers quotes
  word_index <- length(scan(text = line, what = "", quiet = TRUE)) - 1L

  ## If we are at the end after a space, then one more word
  if (position > nchar(line) && grepl("\\s$", line)) {
    word_index <- word_index + 1L
  }

  data <- list(
    `bash-completion-file` = shQuote(comp_file),
    `line` = line,
    `words` = line,
    `point` = position,
    `word` = word_index
  )

  ## Create and run it
  sh <- whisker.render(template, data)
  writeLines(sh, tmp <- tempfile(fileext = ".bat"))
  on.exit(unlink(tmp), add = TRUE)
  Sys.chmod(tmp, "700")

  out <- safe_system(tmp)
  strsplit(out$stdout, "\n")[[1]]
}
