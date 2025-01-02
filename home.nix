{ variables, nix-index-database, inputs, config, ... }:
let
  inherit (variables) userName;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;
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
      "nvim" = {
        # This needs to be an absolute path for mkOutOfStoreSymlink
        source = mkOutOfStoreSymlink "${homeDirectory}/neovim-config";
        recursive = true;
      };
    };
  };
}
