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
      config = "vim /home/abledtaha/.dotfiles/configuration.nix";
      home = "vim /home/abledtaha/.dotfiles/home.nix";
      flake = "vim /home/abledtaha/.dotfiles/flake.nix";
      switch = "sudo nixos-rebuild switch --flake /home/abledtaha/.dotfiles/";
      update = "nix flake update";
      scrcpy = "scrcpy --render-driver=opengl -m1024";
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
    flameshot
    ranger
    vlc
    transmission_4-gtk
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
  ];
}
