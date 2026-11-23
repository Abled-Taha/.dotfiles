# Set environment variables securely
set -gx EDITOR vim
set -gx VISUAL vim

# Ported Environment Variables & Quick Navigation Paths
set -gx USB /mnt/usb
set -gx dotfiles "$HOME/.dotfiles"
set -gx projects "$HOME/Projects/"
set -gx notes "$HOME/Documents/obsidian"
set -gx minecraft "$HOME/.local/share/PrismLauncher/instances"

if status is-interactive
    # Initialize Starship Prompt
    starship init fish | source
end

# Disable the default greeting message
set -g fish_greeting ""

# Modern File Listing & Utilities Aliases
alias ll="eza -lah --icons --color=always --group-directories-first"
alias tree="eza --tree --icons"
alias cat="bat --style=plain"
alias preview="bat"
alias grep="grep --color=auto"
alias g="git"
alias update="yay -Syu && flatpak update"
alias cleanup="$dotfiles/scripts/monthly_cleanup.sh"

# Shell Management
alias reload="exec fish"
