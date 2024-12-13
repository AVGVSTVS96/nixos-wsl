{ variables, nix-index-database, inputs, config, ... }:
let
  inherit (variables) userName;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;
  inherit (builtins) pathExists;
  nvimRepo = "${homeDirectory}/neovim-config";
  nvimFallbackConfig = "${homeDirectory}/nixos-wsl/nvim";
in
{
  imports = [
    nix-index-database.hmModules.nix-index
    inputs.tokyonight.homeManagerModules.default
    inputs.ragenix.homeManagerModules.age
    ./packages.nix
    ./programs.nix
  ];
  tokyonight.enable = true;
  tokyonight.style = "night";
  home = {
    stateVersion = "22.11";
    username = "${userName}";
    homeDirectory = "/home/${userName}";

    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "/etc/profiles/per-user/${userName}/bin/fish";
    };
  };

  xdg = {
    enable = true;
    configFile = {
      # TODO: Test this
      "nvim" = {
        source = mkOutOfStoreSymlink (
          if pathExists nvimRepo
          then nvimRepo 
          else nvimFallbackConfig
        );
        recursive = true;
      };
    };
  };
}
