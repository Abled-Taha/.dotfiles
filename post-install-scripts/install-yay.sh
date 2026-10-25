#!

echo "Installing YAY"
sudo pacman -S --needed --noconfirm base-devel git
git clone https://aur.archlinux.org/yay.git ~/Downloads/yay/
cd ~/Downloads/yay/
makepkg -si
rm -rf ~/Downloads/yay/
echo "YAY Installed"
