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

# VM Reset
alias reset-archlinux="sudo virsh snapshot-revert archlinux --snapshotname base"
alias reset-debian13="sudo virsh snapshot-revert debian13 --snapshotname base"
alias reset-win10="sudo virsh snapshot-revert win10 --snapshotname base"

# VM Power On
alias start-archlinux="sudo virsh start archlinux"
alias start-debian13="sudo virsh start debian13"
alias start-win10="sudo virsh start win10"

# Clean ACPI Shutdown (Graceful)
alias stop-archlinux="sudo virsh shutdown archlinux"
alias stop-debian13="sudo virsh shutdown debian13"
alias stop-win10="sudo virsh shutdown win10"

# Forced Stop (Instant Kill / Hard Reset power-off)
alias kill-archlinux="sudo virsh destroy archlinux"
alias kill-debian13="sudo virsh destroy debian13"
alias kill-win10="sudo virsh destroy win10"

# Quick status monitor matrix
alias vm-status="sudo virsh list --all"


# Hooks
eval "$(mise activate bash)" # Mise


# Custom Functions

