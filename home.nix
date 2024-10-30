{
  # TODO: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  pkgs,
  lib,
  username,
  nix-index-database,
  inputs,
  config,
  ...
}: {
  imports = [
    nix-index-database.hmModules.nix-index
    inputs.tokyonight.homeManagerModules.default
    ./packages.nix
    ./programs.nix
  ];
  tokyonight.enable = true;
  tokyonight.style = "night";
  home.stateVersion = "22.11";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "nvim";
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/fish";
  };

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "/tmp/configuration/nvim";
    recursive = true;
  };
}
