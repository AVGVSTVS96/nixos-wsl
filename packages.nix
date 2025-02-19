{ pkgs, variables, ... }:
let
  inherit (variables) userName;

  unstable-packages = with pkgs; [
    bun
    coreutils
    curl
    du-dust    # disk usage utility
    fd
    ffmpeg
    findutils
    git
    graphite-cli
    jq
    # mosh     # mobile shell, SSH alternative
    neovim
    nodejs_20
    pnpm
    procs      # better ps
    ripgrep
    sd         # simpler sed alternative
    vim
    wget

    
    # language servers
    nil # nix

    # formatters and linters
    nixfmt-rfc-style
    deadnix # nix
    statix # nix
    nodePackages.prettier
    shellcheck
    shfmt
  ];

  stable-packages = with pkgs.stable; [
    just

    # core languages
    # rustup

    # dependencies for lazyvim
    gcc
    cargo

    # rust stuff
    # cargo-cache
    # cargo-expand
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
