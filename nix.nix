{ inputs, pkgs, config, variables, ... }:
let
  inherit (inputs) nixpkgs-stable nur;
  inherit (variables) userName;
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ ];
    };

    overlays = [
      nur.overlay
      (_final: prev: {
        stable = import nixpkgs-stable {
          inherit (prev) system config;
        };
      })
      # (final: prev: {
      #   graphite-cli = prev.graphite-cli.overrideAttrs (oldAttrs: {
      #     version = "1.4.8";
      #     src = prev.fetchurl {
      #       url = "https://registry.npmjs.org/@withgraphite/graphite-cli/-/graphite-cli-1.4.8.tgz";
      #       hash = "sha256-PzoMDBoWAXVbK3itcpybpjZ+lWd8tS7UOFtWWMwTh5U=";
      #     };
      #   });
      # })
    ];
  };

  nix = {
    settings = {
      trusted-users = [ userName ];
      # To be able to clone private repos on GitHub, add PAT access-tokens
      access-tokens = [
        # This is the oauth token from Github, not ssh key
        # "github.com=${config.age.secrets.github-pat.path}"
      ];

      accept-flake-config = true;
      auto-optimise-store = true;
    };

    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs.outPath}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    package = pkgs.nixVersions.latest;
    extraOptions = ''experimental-features = nix-command flakes'';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
}
