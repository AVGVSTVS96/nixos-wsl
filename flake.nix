{
  description = "NixOS WSL configuration";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    tokyonight.url = "github:mrjones2014/tokyonight.nix";

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    ragenix.url = "github:yaxitech/ragenix";
    ragenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    with inputs;
    let
      system = "x86_64-linux";

      variables = {
        hostName = "nixos";
        userName = "nixos";
        fullName = "Bassim Shahidy";
        email = "bassim101@gmail.com";
      };

      channels = {
        inherit nixpkgs nixpkgs-unstable;
      };

      args = {
        inherit
        variables
        system
        secrets
        inputs
        self
        nix-index-database
        channels
        ;
      };
      mkApp = scriptName: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.x86_64-linux.writeShellApplication {
          name = scriptName;
          runtimeInputs = with nixpkgs.legacyPackages.x86_64-linux; [
            coreutils
            gnugrep
          ];
          text = builtins.readFile ./apps/${scriptName};
        })}/bin/${scriptName}";
      };
    in
      {
      apps.x86_64-linux = {
        "check-keys" = mkApp "check-keys";
      };
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
              users.${variables.userName} = {
                imports = [ ./home.nix ];
              };
            };
          }
          nix-ld.nixosModules.nix-ld
          { programs.nix-ld.dev.enable = true; }
          nixos-wsl.nixosModules.wsl
          ragenix.nixosModules.default
          ./secrets.nix
          ./wsl.nix
          ./nix.nix
          ./packages.nix
          ./programs.nix
        ];
      };
    };
}
