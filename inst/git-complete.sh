#! /usr/bin/env bash

__print_completions() {
    printf '%s\n' "${COMPREPLY[@]}"
}

# load bash-completion functions
source {{{ bash-completion-file }}}

COMP_WORDS=({{{ words }}})
COMP_LINE='{{{ line }}}'
COMP_POINT={{{ point }}}
COMP_CWORD={{{ word }}}
_git
__print_completions
