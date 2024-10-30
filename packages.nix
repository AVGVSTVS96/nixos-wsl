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

    # treesitter
    tree-sitter

    # language servers
    nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
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
in
{
  home.packages = stable-packages ++ unstable-packages;
}