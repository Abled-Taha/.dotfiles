sudo journalctl --vacuum-time=2weeks
sudo paccache -r
yes | sudo pacman -Scc
yes | sudo pacman -Rns $(pacman -Qdtq)
flatpak uninstall --unused
rm -rf ~/.cache/
rm -rf ~/.var/app/*/cache/
rm -rf ~/.local/share/Trash/
rm -rf ~/.local/shaare/Share/Trash/
rm -rf $STORAGE/.Trash-1000/
