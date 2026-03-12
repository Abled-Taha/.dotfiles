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
  virtualisation.podman.enable = true;
  services.transmission = {
    enable = true;
    openFirewall = true; # Opens port 51413
    settings = {
      download-dir = "/home/abledtaha/Downloads"; # Ensure this directory exists
      rpc-bind-address = "127.0.0.1";
      rpc-whitelist = "127.0.0.1";
      # If using web-ui with authentication:
      # rpc-authentication-required = true;
      # rpc-username = "user";
      # rpc-password = "password";
    };
  };

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

