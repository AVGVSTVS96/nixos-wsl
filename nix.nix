{
  inputs,
  pkgs,
  variables,
  ...
}:
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
      (final: prev: {
        bun = prev.bun.overrideAttrs (oldAttrs: {
          version = "1.2.0";
          src = prev.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v1.2.0/bun-linux-x64.zip";
            sha256 = "sha256-B0fpcBILE6HaU0G3UaXwrxd4vYr9cLXEWPr/+VzppFM=";
          };
        });
      })
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
