#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

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
