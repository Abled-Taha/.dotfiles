{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda/";
  networking.hostName = "abled-nix";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = "loose";

  time.timeZone = "Asia/Karachi";

  hardware.graphics.enable32Bit = true;

  programs.hyprland.enable = true;
  programs.adb.enable = true;
  services.displayManager.ly.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;
  virtualisation.waydroid.enable = true;

  users.users.abledtaha = {
    isNormalUser = true;
    extraGroups = [ "wheel" "adbUsers" "input" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    kitty
    rofi
    chromium
    wl-clipboard
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.11";
}

