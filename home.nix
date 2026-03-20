{config, pkgs, zen-browser, ...}:
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    hypr = "hypr";
    rofi = "rofi";
    kitty = "kitty";
  };
in
{
  home.username = "abledtaha";
  home.homeDirectory = "/home/abledtaha";
  home.stateVersion = "25.11";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nixos, btw";
      ll = "ls -la";
      config = "vim /home/abledtaha/.dotfiles/configuration.nix";
      home = "vim /home/abledtaha/.dotfiles/home.nix";
      flake = "vim /home/abledtaha/.dotfiles/flake.nix";
      switch = "sudo nixos-rebuild switch --flake /home/abledtaha/.dotfiles/";
      update = "nix flake update";
      scrcpy = "scrcpy --render-driver=opengl -m1024";
      dualaudio = "pactl load-module module-combine-sink sink_name=combined slaves=alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo,alsa_output.pci-0000_00_1b.0.analog-stereo";
    };
  };
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Abled-Taha";
        email = "abledtaha@gmail.com";
      };
      init.defaultBranch = "main";
      alias = {
        s = "status";
        l = "log --oneline";
      };
      credential.helper = "cache";
    };
    ignores = [
      ".swp"
      "*.log"
    ];
  };
  programs.gh = {
    enable = true;
    # settings = {
    #   aliases = {
    #     co = "pr checkout";
    #   };
    # };
    # extensions = [ pkgs.gh-s ]; # example extension
  };
  services.ssh-agent.enable = true;
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        useGrimAdapter = true;
        disabledGrimWarning = true;
      };
    };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
  }) configs;

  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24; # Adjust size as needed
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    # Fixes Flameshot and other Qt apps on Wayland
    QT_QPA_PLATFORM = "wayland;xcb";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "video/mp4" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "video/quicktime" = [ "vlc.desktop" ];
      "video/x-flv" = [ "vlc.desktop" ];
      "video/x-msvideo" = [ "vlc.desktop" ];
      "audio/mpeg" = [ "vlc.desktop" ];
      "audio/x-wav" = [ "vlc.desktop" ];
      "audio/flac" = [ "vlc.desktop" ];
      "audio/x-matroska" = [ "vlc.desktop" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    zen-browser.packages."${system}".default
    android-tools
    scrcpy
    kdePackages.dolphin
    gedit
    btop
    ranger
    vlc
    qbittorrent
    tor-browser
    vscode
    protonvpn-gui
    wireguard-tools
    lutris
    wineWowPackages.stable
    winetricks
    adwaita-icon-theme
    protonup-qt
    lmstudio
    remmina
    distrobox
    obsidian
    steam-run
    steam
    gimp
    prismlauncher
  ];
}
