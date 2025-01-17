{ pkgs, variables, ... }:
let
  inherit (variables) userName;

  unstable-packages = with pkgs; [
    bun
    coreutils
    curl
    du-dust
    fd
    ffmpeg
    findutils
    git
    git-crypt
    graphite-cli
    jq
    killall
    mosh
    neovim
    nodejs_20
    nodePackages.pnpm
    procs
    ripgrep
    sd
    vim
    wget
    # (pkgs.nerdfonts.override { fonts = [ "Monaspace" ]; })

    
    # language servers
    nil # nix

    # formatters and linters
    # alejandra # nix
    nixfmt-rfc-style
    deadnix # nix
    nodePackages.prettier
    shellcheck
    shfmt
    statix # nix
  ];

  stable-packages = with pkgs.stable; [
    # gh # for bootstrapping
    just

    # core languages
    # rustup

    # dependencies for lazyvim
    gcc
    cargo

    # rust stuff
    cargo-cache
    cargo-expand
  ];
in
{
  home-manager.users.${userName} = {
    home.packages = stable-packages ++ unstable-packages;
  };

  fonts.packages = [
    pkgs.nerd-fonts.monaspace
  ];
}
