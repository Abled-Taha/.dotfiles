# Set environment variables securely
set -gx EDITOR vim
set -gx VISUAL vim

# Ported Environment Variables & Quick Navigation Paths
set -gx oracle "abled.minecraftr.us"
set -gx STORAGE /mnt/Storage
set -gx USB /mnt/usb
set -gx dotfiles "$HOME/.dotfiles"
set -gx projectsstorage "$STORAGE/Documents/Projects"
set -gx projects "$HOME/Projects/"
set -gx network "$STORAGE/Network"
set -gx notes "$STORAGE/Documents/Obsidian"
set -gx fish "$dotfiles/fish/.config/fish/config.fish"
set -gx mango "$dotfiles/mango/.config/mango/config.conf"
set -gx hyprland "$dotfiles/hypr/.config/hypr/hyprland.lua"
set -gx minecraft "$HOME/.local/share/PrismLauncher/instances"

# Add custom local binaries safely to PATH without breaking Fish lists
fish_add_path /home/abledtaha/.local/bin

if status is-interactive
    # Initialize Mise Environment Manager (Always activate LAST after PATH setups)
    if type -q mise
        mise activate fish | source
    end

    # Initialize Starship Prompt
    starship init fish | source
end

# Disable the default greeting message
set -g fish_greeting ""

# Modern File Listing & Utilities Aliases
alias ls="eza --icons --color=always --group-directories-first"
alias ll="eza -lah --icons --color=always --group-directories-first"
alias la="eza -a --icons"
alias tree="eza --tree --icons"
alias cat="bat --style=plain"
alias preview="bat"
alias grep="grep --color=auto"
alias cls="clear"
alias g="git"
alias z="zeditor"
alias update="yay -Syu && flatpak update"

# Shell Management
alias reload="exec fish"

# VM Management (Libvirt / Virsh)
## Status Check
alias vm-status="sudo virsh list --all"

## VM Reset
alias reset-archlinux="sudo virsh snapshot-revert archlinux --snapshotname base"
alias reset-debian13="sudo virsh snapshot-revert debian13 --snapshotname base"
alias reset-win10="sudo virsh snapshot-revert win10 --snapshotname base"
alias reset-nixos="sudo virsh snapshot-revert nixos --snapshotname base"

## VM Power On
alias start-archlinux="sudo virsh start archlinux"
alias start-debian13="sudo virsh start debian13"
alias start-win10="sudo virsh start win10"
alias start-nixos="sudo virsh start nixos"

## Clean ACPI Shutdown (Graceful)
alias stop-archlinux="sudo virsh shutdown archlinux"
alias stop-debian13="sudo virsh shutdown debian13"
alias stop-win10="sudo virsh shutdown win10"
alias stop-nixos="sudo virsh shutdown nixos"

## Forced Stop (Instant Kill / Hard Reset power-off)
alias kill-archlinux="sudo virsh destroy archlinux"
alias kill-debian13="sudo virsh destroy debian13"
alias kill-win10="sudo virsh destroy win10"
alias kill-nixos="sudo virsh destroy nixos"

## Custom Functions #needs to be updated to match from ironbook
function get-codebase --description 'Generate a single text file of the current codebase structure and contents'
    bash -c '(echo "=== DIRECTORY TREE ===" && tree -a -I "codebase.txt" && echo -e "\n=== FILE CONTENTS ===" && find . -type f -not -name "codebase.txt" | while read -r file; do echo -e "\n==> $file <=="; cat "$file"; done) > codebase.txt'
    echo "✔ Codebase successfully dumped to codebase.txt"
end
