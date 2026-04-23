#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Colors
C_BLUE='\[\033[01;34m\]'
C_GREEN='\[\033[01;32m\]'
C_CYAN='\[\033[01;36m\]'
C_RESET='\[\033[00m\]'

# Prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

PS1="${C_CYAN}[${C_GREEN}\u${C_CYAN}@\h] ${C_BLUE}\w${C_CYAN}\$(parse_git_branch)${C_RESET}\$> "

# Aliases
alias ls='ls --color=auto -la'
alias grep='grep --color=auto'
alias source='source ~/.bashrc'



# Custom Functions
git() {
  if [ "$1" == "s" ]; then
    command git status
  elif [ "$1" == "a" ]; then
    command git add --all
  elif [ "$1" == "c" ]; then
    local msg="${@:2}"
    command git commit -m "${msg:-Regular Commit}"
  elif [ "$1" == "p" ]; then
    command git push
  elif [ "$1" == "acp" ]; then
    git a
    git c "${@:2}"
    git p
  else
    command git "$@"
  fi
}
