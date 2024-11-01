{
  description = "NixOS WSL configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    tokyonight.url = "github:mrjones2014/tokyonight.nix";

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    with inputs;
    let
      system = "x86_64-linux";
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");

      variables = {
        hostName = "nixos";
        userName = "nixos";
      };

      channels = {
        inherit nixpkgs nixpkgs-unstable;
      };

      args = {
        inherit
          variables
          secrets
          inputs
          self
          nix-index-database
          channels
          ;
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = args;

        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = args;
            };
          }
          nix-ld.nixosModules.nix-ld
          { programs.nix-ld.dev.enable = true; }
          nixos-wsl.nixosModules.wsl
          ./wsl.nix
          ./nixpkgs.nix
        ];
      };
    };
}
