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
  networking.networkmanager.connectionConfig."ipv4.dhcp-client-id" = "mac";

  time.timeZone = "Asia/Karachi";

  hardware.graphics.enable32Bit = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  programs.hyprland.enable = true;
  programs.adb.enable = true;
  programs.ydotool.enable = true;

  services.displayManager.ly.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.blueman.enable = true;
  services.flatpak.enable = true;
  virtualisation.waydroid.enable = false;
  virtualisation.podman.enable = true;
  security.rtkit.enable = true;
  services.ollama.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };
  services.samba = {
    enable = false;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
      };
      # Define your share
      "publicshare" = {
        "path" = "/home/abledtaha/shared/";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };


  users.users.abledtaha = {
    isNormalUser = true;
    extraGroups = [ "wheel" "adbUsers" "input" "networkmanager" "ydotool" ]; # Enable ‘sudo’ for the user.
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
    pavucontrol
    ffmpeg-full
    pulseaudio
    usbutils
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zlib
    zstd
    stdenv.cc.cc
    curl
    openssl
    attr
    libssh
    bzip2
    libxml2
    acl
    libsodium
    util-linux
    xz
    systemd
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    config.common.default = "*";
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.11";
}

