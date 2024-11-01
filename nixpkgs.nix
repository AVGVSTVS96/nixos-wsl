{ inputs, ... }:
let
  inherit (inputs) nixpkgs-unstable nur;
in {
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ ];
    };

    overlays = [
      nur.overlay
      (_final: prev: {
        unstable = import nixpkgs-unstable {
          inherit (prev) system;
          config = prev.config;
        };
      })
    ];
  };
}
