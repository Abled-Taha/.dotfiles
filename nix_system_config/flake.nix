{
  description = "";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = {self, nixpkgs, home-manager, zen-browser, ...}: {
    nixosConfigurations.abled-nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit zen-browser;};
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit zen-browser;};
            users.abledtaha = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
