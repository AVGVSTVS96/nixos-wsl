{ inputs, ... }:
let
  inherit (inputs) nixpkgs-stable nur;
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
      (final: prev: {
        graphite-cli = prev.graphite-cli.overrideAttrs (oldAttrs: {
          version = "1.4.8";
          src = prev.fetchurl {
            url = "https://registry.npmjs.org/@withgraphite/graphite-cli/-/graphite-cli-1.4.8.tgz";
            hash = "sha256-PzoMDBoWAXVbK3itcpybpjZ+lWd8tS7UOFtWWMwTh5U=";
          };
        });
      })
    ];
  };
}
