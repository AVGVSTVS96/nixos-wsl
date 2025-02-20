{
  variables,
  nix-index-database,
  inputs,
  config,
  osConfig,
  ...
}:
let
  inherit (variables) userName stateVersion;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  homeDirectory = osConfig.users.users.${userName}.home;
  username = userName;
in
{
  imports = [
    nix-index-database.hmModules.nix-index
    inputs.tokyonight.homeManagerModules.default
    inputs.ragenix.homeManagerModules.age
  ];
  tokyonight.enable = true;
  tokyonight.style = "night";
  home = {
    inherit
      stateVersion
      username
      homeDirectory
      ;

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
