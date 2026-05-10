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


# Custom Variables
export oracle="abled.minecraftr.us"
export STORAGE="/run/media/abledtaha/Storage"
export projects="$STORAGE/Documents/Projects"
export notes="$STORAGE/Documents/Obsidian"
export bashrc="$HOME/.bashrc"
export dotfiles="$HOME/.dotfiles"
export hyprland="$dotfiles/hypr/.config/hypr/hyprland.conf"
export minecraft="$HOME/.local/share/PrismLauncher/instances"


# Aliases
alias ls='ls --color=auto -la'
alias grep='grep --color=auto'
alias reload='source ~/.bashrc'


# Hooks
eval "$(mise activate bash)" # Mise


# Custom Functions

