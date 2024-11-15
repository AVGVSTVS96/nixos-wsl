{
  # secrets,
  variables,
  nix-index-database,
  inputs,
  config,
  ...
}:
let
  inherit (variables) userName;
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
        source = config.lib.file.mkOutOfStoreSymlink "/tmp/configuration/nvim";
        recursive = true;
      };
    };
  };
}
