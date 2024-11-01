{
  # secrets,
  variables,
  nix-index-database,
  inputs,
  config,
  ...
}:
let
  username = variables.userName;
in
{
  imports = [
    nix-index-database.hmModules.nix-index
    inputs.tokyonight.homeManagerModules.default
    ./packages.nix
    ./programs.nix
  ];
  tokyonight.enable = true;
  tokyonight.style = "night";
  home = {
    stateVersion = "22.11";
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "/etc/profiles/per-user/${username}/bin/fish";
    };
  };
  xdg.enable = true;
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "/tmp/configuration/nvim";
      recursive = true;
    };
  };
}
