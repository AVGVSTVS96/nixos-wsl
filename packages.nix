{ pkgs, ... }:
let
  unstable-packages = with pkgs.unstable; [
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
    tmux
    vim
    wget
    (pkgs.nerdfonts.override { fonts = [ "Monaspace" ]; })

    
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

  stable-packages = with pkgs; [
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
  home.packages = stable-packages ++ unstable-packages;
}
