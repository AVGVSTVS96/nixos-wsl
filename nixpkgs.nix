{ inputs, ... }:
let
  inherit (inputs) nixpkgs-stable nur;
in {
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
    ];
  };
}
